Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFBE63DBF4
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 18:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbiK3RaG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 12:30:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiK3RaE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 12:30:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3AB123E99
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 09:30:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E814B81C4B
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 17:30:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2A2DC433D6;
        Wed, 30 Nov 2022 17:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669829401;
        bh=8sx+9mqAWanWsQuJ4l9eRWe/up45WbfObe/X2rtM8h8=;
        h=Subject:To:Cc:From:Date:From;
        b=IA/TVg74m51uhT5JvTgTLgKG+YauM20a+fbSvQTxOKaSq93plcUhdUeIQf8b3aMmv
         TgRpLjETHIc2N4opdQp9w0kGZlW1WtaPgIcpZAMl1VgCMy+69VQrm8t4mRJd7Z4p6k
         MDGNDuu3XhDCpTUS7MUn4N9azuRsGck6h40Y/Dn0=
Subject: FAILED: patch "[PATCH] btrfs: free btrfs_path before copying inodes to userspace" failed to apply to 4.19-stable tree
To:     anand.jain@oracle.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 30 Nov 2022 18:29:46 +0100
Message-ID: <1669829386167187@kroah.com>
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


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

418ffb9e3cf6 ("btrfs: free btrfs_path before copying inodes to userspace")
e3059ec06b9f ("btrfs: sink iterator parameter to btrfs_ioctl_logical_to_ino")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 418ffb9e3cf6c4e2574d3a732b724916684bd133 Mon Sep 17 00:00:00 2001
From: Anand Jain <anand.jain@oracle.com>
Date: Thu, 10 Nov 2022 11:36:28 +0530
Subject: [PATCH] btrfs: free btrfs_path before copying inodes to userspace

btrfs_ioctl_logical_to_ino() frees the search path after the userspace
copy from the temp buffer @inodes. Which potentially can lead to a lock
splat.

Fix this by freeing the path before we copy @inodes to userspace.

CC: stable@vger.kernel.org # 4.19+
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 89b8d14cb68c..b595f2c6dfc9 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4282,21 +4282,20 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
 		size = min_t(u32, loi->size, SZ_16M);
 	}
 
-	path = btrfs_alloc_path();
-	if (!path) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
 	inodes = init_data_container(size);
 	if (IS_ERR(inodes)) {
 		ret = PTR_ERR(inodes);
-		inodes = NULL;
-		goto out;
+		goto out_loi;
 	}
 
+	path = btrfs_alloc_path();
+	if (!path) {
+		ret = -ENOMEM;
+		goto out;
+	}
 	ret = iterate_inodes_from_logical(loi->logical, fs_info, path,
 					  inodes, ignore_offset);
+	btrfs_free_path(path);
 	if (ret == -EINVAL)
 		ret = -ENOENT;
 	if (ret < 0)
@@ -4308,7 +4307,6 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
 		ret = -EFAULT;
 
 out:
-	btrfs_free_path(path);
 	kvfree(inodes);
 out_loi:
 	kfree(loi);

