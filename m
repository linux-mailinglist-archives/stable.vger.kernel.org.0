Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDB3165D31D
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 13:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbjADMxI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 07:53:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232648AbjADMwj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 07:52:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB451E3C5
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 04:52:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C24B261616
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 12:52:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D63ACC433EF;
        Wed,  4 Jan 2023 12:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672836755;
        bh=gpbyrbsAPx7gh05nGMsQk54Dk7gEq5nBOoiLd8fCKLo=;
        h=Subject:To:Cc:From:Date:From;
        b=NVS0sbRWBoCeslYuE+7uGL8Lhr22NikUF3BNNxu9M7yIJ8bmn5jntItSMW9lIJ4EA
         foQrxzI6kwET91FfFywOqpUhLVLeQvcEWMLz/R1FvkGLmD1QJgSs0T6Z7y279oXOvx
         fmbOKoQNj17BIZj6PW4VjL5YLGb3Z698NX7sXyFc=
Subject: FAILED: patch "[PATCH] btrfs: replace strncpy() with strscpy()" failed to apply to 5.15-stable tree
To:     artem.chernyshev@red-soft.ru, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 13:52:27 +0100
Message-ID: <16728367471883@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

63d5429f68a3 ("btrfs: replace strncpy() with strscpy()")
cb3e217bdb39 ("btrfs: use btrfs_dev_name() helper to handle missing devices better")
947a629988f1 ("btrfs: move tree block parentness check into validate_extent_buffer()")
789d6a3a876e ("btrfs: concentrate all tree block parentness check parameters into one structure")
ab2072b2921e ("btrfs: change how submit bio callback is passed to btrfs_wq_submit_bio")
7920b773bd8a ("btrfs: drop parameter compression_type from btrfs_submit_dio_repair_bio")
19af6a7d345a ("btrfs: change how repair action is passed to btrfs_repair_one_sector")
a2c8d27e5ee8 ("btrfs: use a structure to pass arguments to backref walking functions")
6ce6ba534418 ("btrfs: use a single argument for extent offset in backref walking functions")
22a3c0ac8ed0 ("btrfs: send: avoid unnecessary backref lookups when finding clone source")
2885fd632050 ("btrfs: move inode prototypes to btrfs_inode.h")
b31bed170d52 ("btrfs: move btrfs_chunk_item_size out of ctree.h")
911bd75aca73 ("btrfs: remove unused function prototypes")
a56159d4080b ("btrfs: move btrfs_fs_info declarations into fs.h")
6db75318823a ("btrfs: use struct fscrypt_str instead of struct qstr")
ab3c5c18e8fa ("btrfs: setup qstr from dentrys using fscrypt helper")
e43eec81c516 ("btrfs: use struct qstr instead of name and namelen pairs")
e9c83077d2be ("btrfs: remove temporary btrfs_map_token declaration in ctree.h")
ad1ac5012c2b ("btrfs: move btrfs_map_token to accessors")
d83eb482b727 ("btrfs: move the compat/incompat flag masks to fs.h")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 63d5429f68a3d4c4aa27e65a05196c17f86c41d6 Mon Sep 17 00:00:00 2001
From: Artem Chernyshev <artem.chernyshev@red-soft.ru>
Date: Sat, 19 Nov 2022 11:13:29 +0300
Subject: [PATCH] btrfs: replace strncpy() with strscpy()

Using strncpy() on NUL-terminated strings are deprecated.  To avoid
possible forming of non-terminated string strscpy() should be used.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

CC: stable@vger.kernel.org # 4.9+
Signed-off-by: Artem Chernyshev <artem.chernyshev@red-soft.ru>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index bed74a3ff574..4fd6b61b06a4 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2859,13 +2859,10 @@ static long btrfs_ioctl_dev_info(struct btrfs_fs_info *fs_info,
 	di_args->bytes_used = btrfs_device_get_bytes_used(dev);
 	di_args->total_bytes = btrfs_device_get_total_bytes(dev);
 	memcpy(di_args->uuid, dev->uuid, sizeof(di_args->uuid));
-	if (dev->name) {
-		strncpy(di_args->path, btrfs_dev_name(dev),
-				sizeof(di_args->path) - 1);
-		di_args->path[sizeof(di_args->path) - 1] = 0;
-	} else {
+	if (dev->name)
+		strscpy(di_args->path, btrfs_dev_name(dev), sizeof(di_args->path));
+	else
 		di_args->path[0] = '\0';
-	}
 
 out:
 	rcu_read_unlock();
diff --git a/fs/btrfs/rcu-string.h b/fs/btrfs/rcu-string.h
index 5c1a617eb25d..5c2b66d155ef 100644
--- a/fs/btrfs/rcu-string.h
+++ b/fs/btrfs/rcu-string.h
@@ -18,7 +18,11 @@ static inline struct rcu_string *rcu_string_strdup(const char *src, gfp_t mask)
 					 (len * sizeof(char)), mask);
 	if (!ret)
 		return ret;
-	strncpy(ret->str, src, len);
+	/* Warn if the source got unexpectedly truncated. */
+	if (WARN_ON(strscpy(ret->str, src, len) < 0)) {
+		kfree(ret);
+		return NULL;
+	}
 	return ret;
 }
 

