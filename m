Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5A558DEC0
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343842AbiHISXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347327AbiHISWU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:22:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9198631DC4;
        Tue,  9 Aug 2022 11:08:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D852B8199A;
        Tue,  9 Aug 2022 18:07:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAE7AC43470;
        Tue,  9 Aug 2022 18:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660068443;
        bh=ywVLN2ma4MVkAmTR58UKcULnKrwma1toTjcHNXw3Wbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OId86UbL5sY1lR91qK20OFi+3IZ+VZ8TzILrQ9/OWGlIJAg9M+BBV9hREpvMw9/Zl
         NFCTJceaImhC7xl7i4/qYblNQEcCKTmvbhTDEjkoZD+2bPZCjWdcVIz8ZJ6Nu1mTHr
         IREZYooR9o3Ipi1ovjWBFalhTgg1TSZfuo0mpKhY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.18 21/35] btrfs: zoned: fix critical section of relocation inode writeback
Date:   Tue,  9 Aug 2022 20:00:50 +0200
Message-Id: <20220809175515.832622102@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809175515.046484486@linuxfoundation.org>
References: <20220809175515.046484486@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naohiro Aota <naohiro.aota@wdc.com>

commit 19ab78ca86981e0e1e73036fb73a508731a7c078 upstream.

We use btrfs_zoned_data_reloc_{lock,unlock} to allow only one process to
write out to the relocation inode. That critical section must include all
the IO submission for the inode. However, flush_write_bio() in
extent_writepages() is out of the critical section, causing an IO
submission outside of the lock. This leads to an out of the order IO
submission and fail the relocation process.

Fix it by extending the critical section.

Fixes: 35156d852762 ("btrfs: zoned: only allow one process to add pages to a relocation inode")
CC: stable@vger.kernel.org # 5.16+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_io.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5214,13 +5214,14 @@ int extent_writepages(struct address_spa
 	 */
 	btrfs_zoned_data_reloc_lock(BTRFS_I(inode));
 	ret = extent_write_cache_pages(mapping, wbc, &epd);
-	btrfs_zoned_data_reloc_unlock(BTRFS_I(inode));
 	ASSERT(ret <= 0);
 	if (ret < 0) {
+		btrfs_zoned_data_reloc_unlock(BTRFS_I(inode));
 		end_write_bio(&epd, ret);
 		return ret;
 	}
 	ret = flush_write_bio(&epd);
+	btrfs_zoned_data_reloc_unlock(BTRFS_I(inode));
 	return ret;
 }
 


