Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D48E50501A
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238355AbiDRMV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238329AbiDRMVJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:21:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 236301AF10;
        Mon, 18 Apr 2022 05:17:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BBCB5B80ED7;
        Mon, 18 Apr 2022 12:17:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 164BDC385A1;
        Mon, 18 Apr 2022 12:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284232;
        bh=PGMSCHIq8Ea2LVix5FCymQtAbWUPzEE/jy1wS8r+Rxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HDhdSyCKxYGOhYP0JaJIZ4K/9Y2EXrEt2C7WJfLSIMOtC7PucXHsMTTRzi10LCVz+
         OwuWdpUr1nqE8TWOJ5Xv1mHbE5Cn3L30y0Akk26/x6GMvJhukNO0kkCj3pn/8NTz9Z
         5dMRYqSRGLtaV4HcWJz8YYgknfHWMJWiNqAxA5Hg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.17 016/219] btrfs: return allocated block group from do_chunk_alloc()
Date:   Mon, 18 Apr 2022 14:09:45 +0200
Message-Id: <20220418121204.075353134@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
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

commit 820c363bd526ec8e133e4b84e6ad1fda12023b4b upstream.

Return the allocated block group from do_chunk_alloc(). This is a
preparation patch for the next patch.

CC: stable@vger.kernel.org # 5.16+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Tested-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-group.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -3427,7 +3427,7 @@ int btrfs_force_chunk_alloc(struct btrfs
 	return btrfs_chunk_alloc(trans, alloc_flags, CHUNK_ALLOC_FORCE);
 }
 
-static int do_chunk_alloc(struct btrfs_trans_handle *trans, u64 flags)
+static struct btrfs_block_group *do_chunk_alloc(struct btrfs_trans_handle *trans, u64 flags)
 {
 	struct btrfs_block_group *bg;
 	int ret;
@@ -3514,7 +3514,11 @@ static int do_chunk_alloc(struct btrfs_t
 out:
 	btrfs_trans_release_chunk_metadata(trans);
 
-	return ret;
+	if (ret)
+		return ERR_PTR(ret);
+
+	btrfs_get_block_group(bg);
+	return bg;
 }
 
 /*
@@ -3629,6 +3633,7 @@ int btrfs_chunk_alloc(struct btrfs_trans
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_space_info *space_info;
+	struct btrfs_block_group *ret_bg;
 	bool wait_for_alloc = false;
 	bool should_alloc = false;
 	int ret = 0;
@@ -3722,9 +3727,14 @@ int btrfs_chunk_alloc(struct btrfs_trans
 			force_metadata_allocation(fs_info);
 	}
 
-	ret = do_chunk_alloc(trans, flags);
+	ret_bg = do_chunk_alloc(trans, flags);
 	trans->allocating_chunk = false;
 
+	if (IS_ERR(ret_bg))
+		ret = PTR_ERR(ret_bg);
+	else
+		btrfs_put_block_group(ret_bg);
+
 	spin_lock(&space_info->lock);
 	if (ret < 0) {
 		if (ret == -ENOSPC)


