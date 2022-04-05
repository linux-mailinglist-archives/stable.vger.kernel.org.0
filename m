Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 510764F255C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbiDEHt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233629AbiDEHsP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:48:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C930CBB;
        Tue,  5 Apr 2022 00:46:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64DDD615E7;
        Tue,  5 Apr 2022 07:46:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71FF7C340EE;
        Tue,  5 Apr 2022 07:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144776;
        bh=kCiBLdnFzD0QRDANYJYIktkcCTP1oE4zBfsCsX8qP78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XreuLiQ4KkaYNUP0IKig6vs7M0c2IVnY6XxZAoJAXrL/fUSB6aQ6IPg+eZ17GEGUh
         GJ/mrNgYUi2OYD3OEGV8sVv7QE9jnHCdFqlCy8aHMmDm1qK+erTSSUTcME+eocBkLe
         efYfCSyzxdDMwZKmR0Zrbagq5QqQZSCRGgSwNYXA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.17 0140/1126] btrfs: zoned: put block group after final usage
Date:   Tue,  5 Apr 2022 09:14:47 +0200
Message-Id: <20220405070411.688381132@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Borisov <nborisov@suse.com>

commit d3e29967079c522ce1c5cab0e9fab2c280b977eb upstream.

It's counter-intuitive (and wrong) to put the block group _before_ the
final usage in submit_eb_page. Fix it by re-ordering the call to
btrfs_put_block_group after its final reference. Also fix a minor typo
in 'implies'

Fixes: be1a1d7a5d24 ("btrfs: zoned: finish fully written block group")
CC: stable@vger.kernel.org # 5.16+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_io.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4780,11 +4780,12 @@ static int submit_eb_page(struct page *p
 		return ret;
 	}
 	if (cache) {
-		/* Impiles write in zoned mode */
-		btrfs_put_block_group(cache);
-		/* Mark the last eb in a block group */
+		/*
+		 * Implies write in zoned mode. Mark the last eb in a block group.
+		 */
 		if (cache->seq_zone && eb->start + eb->len == cache->zone_capacity)
 			set_bit(EXTENT_BUFFER_ZONE_FINISH, &eb->bflags);
+		btrfs_put_block_group(cache);
 	}
 	ret = write_one_eb(eb, wbc, epd);
 	free_extent_buffer(eb);


