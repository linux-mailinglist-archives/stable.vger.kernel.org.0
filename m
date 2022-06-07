Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3506F541788
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357470AbiFGVDo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379395AbiFGVCZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:02:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EFAAAF1F5;
        Tue,  7 Jun 2022 11:48:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F1386157E;
        Tue,  7 Jun 2022 18:48:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C257C385A2;
        Tue,  7 Jun 2022 18:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627680;
        bh=xf9XcbXTutHEaP8Ja6L4CnA04pALN4aTf1DHiUc7ZXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tazklCE7QNm9pWR7g1EDFOr6t5sp06H4DpPEIJIiINbT9BiicWyKSnmQVBnDuLD3z
         P6LWWpmd5axd5zQHU0zlWKmbTybgdxJr19fLSOYyq9NTlXXBW6ZoQQIamLMjbREtb+
         aDhy42rTmEEPZE43JGI2b9amWUm4ygaH52dgqJgQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.18 053/879] btrfs: zoned: fix comparison of alloc_offset vs meta_write_pointer
Date:   Tue,  7 Jun 2022 18:52:51 +0200
Message-Id: <20220607165004.227971390@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naohiro Aota <naohiro.aota@wdc.com>

commit aa9ffadfcae33e611d8c2d476bcc2aa0d273b587 upstream.

The block_group->alloc_offset is an offset from the start of the block
group. OTOH, the ->meta_write_pointer is an address in the logical
space. So, we should compare the alloc_offset shifted with the
block_group->start.

Fixes: afba2bc036b0 ("btrfs: zoned: implement active zone tracking")
CC: stable@vger.kernel.org # 5.16+
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/zoned.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1896,7 +1896,7 @@ int btrfs_zone_finish(struct btrfs_block
 	/* Check if we have unwritten allocated space */
 	if ((block_group->flags &
 	     (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM)) &&
-	    block_group->alloc_offset > block_group->meta_write_pointer) {
+	    block_group->start + block_group->alloc_offset > block_group->meta_write_pointer) {
 		spin_unlock(&block_group->lock);
 		return -EAGAIN;
 	}


