Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02BBF50DF99
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 13:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbiDYMCJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 08:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240703AbiDYMCH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 08:02:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7EA3B1CE
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 04:58:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96C9F612E4
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 11:58:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A721CC385A7;
        Mon, 25 Apr 2022 11:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650887931;
        bh=jZyerhuHFb4CwWebi8461xaFzRxEHJNZxb+6fPfgRkE=;
        h=Subject:To:Cc:From:Date:From;
        b=blAikw5jecVaQbBmcLlyIlQmomvI+pqznStZk5J8By98Ls1hQ/zpxV6U08R4F6P9B
         N/KsuxZRgQsci0zU4m/uzPuquBaqrHDCnGRLUbdDzqaHG6t2gr0/wAioZUAUI/tnsd
         V5A9n1l7VYCc652IinmO5k/bkyGksQ/gEvtQwbvo=
Subject: FAILED: patch "[PATCH] ext4: update the cached overhead value in the superblock" failed to apply to 5.10-stable tree
To:     tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 Apr 2022 13:58:48 +0200
Message-ID: <165088792812255@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From eb7054212eac8b451d727bf079eae3db8c88f9d3 Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Thu, 14 Apr 2022 22:39:00 -0400
Subject: [PATCH] ext4: update the cached overhead value in the superblock

If we (re-)calculate the file system overhead amount and it's
different from the on-disk s_overhead_clusters value, update the
on-disk version since this can take potentially quite a while on
bigalloc file systems.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 48dc2c3247ad..a743b1e3b89e 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3068,6 +3068,7 @@ int ext4_fileattr_set(struct user_namespace *mnt_userns,
 		      struct dentry *dentry, struct fileattr *fa);
 int ext4_fileattr_get(struct dentry *dentry, struct fileattr *fa);
 extern void ext4_reset_inode_seed(struct inode *inode);
+int ext4_update_overhead(struct super_block *sb);
 
 /* migrate.c */
 extern int ext4_ext_migrate(struct inode *);
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 992229ca2d83..ba44fa1be70a 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1652,3 +1652,19 @@ long ext4_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	return ext4_ioctl(file, cmd, (unsigned long) compat_ptr(arg));
 }
 #endif
+
+static void set_overhead(struct ext4_super_block *es, const void *arg)
+{
+	es->s_overhead_clusters = cpu_to_le32(*((unsigned long *) arg));
+}
+
+int ext4_update_overhead(struct super_block *sb)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+
+	if (sb_rdonly(sb) || sbi->s_overhead == 0 ||
+	    sbi->s_overhead == le32_to_cpu(sbi->s_es->s_overhead_clusters))
+		return 0;
+
+	return ext4_update_superblocks_fn(sb, set_overhead, &sbi->s_overhead);
+}
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d08820fdfdee..1847b46af808 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5618,6 +5618,8 @@ static int ext4_fill_super(struct super_block *sb, struct fs_context *fc)
 		ext4_msg(sb, KERN_INFO, "mounted filesystem with%s. "
 			 "Quota mode: %s.", descr, ext4_quota_mode(sb));
 
+	/* Update the s_overhead_clusters if necessary */
+	ext4_update_overhead(sb);
 	return 0;
 
 free_sbi:

