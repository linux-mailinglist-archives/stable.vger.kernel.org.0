Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9811550F75F
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346335AbiDZJNF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346496AbiDZJLT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:11:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8504E17FBFA;
        Tue, 26 Apr 2022 01:49:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D4BD6142A;
        Tue, 26 Apr 2022 08:49:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F0D6C385A4;
        Tue, 26 Apr 2022 08:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962986;
        bh=SKZ70ocCGQMjXnK+lWqgjKDRpLy/0CK15+nNC8oyUdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xVJyyPeD9cGAMRX/YURx3Y5/+BqH3t5FZW/jYtFHPMdoVWStKM/70LQLfoHxtjjmS
         PYpGlW/0zO5aE6ic/5oG51Bvb5PHWiQfly79EwIEE0LnyBIkGO7KquFIwBxG8Kh8N3
         ISFZcHdmiKvZ6AYNsRxV0OrdmU8jmQcflxkQKjJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        stable@kernel.org
Subject: [PATCH 5.17 141/146] ext4: update the cached overhead value in the superblock
Date:   Tue, 26 Apr 2022 10:22:16 +0200
Message-Id: <20220426081754.022193929@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

commit eb7054212eac8b451d727bf079eae3db8c88f9d3 upstream.

If we (re-)calculate the file system overhead amount and it's
different from the on-disk s_overhead_clusters value, update the
on-disk version since this can take potentially quite a while on
bigalloc file systems.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ext4.h  |    1 +
 fs/ext4/ioctl.c |   16 ++++++++++++++++
 fs/ext4/super.c |    2 ++
 3 files changed, 19 insertions(+)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3066,6 +3066,7 @@ int ext4_fileattr_set(struct user_namesp
 		      struct dentry *dentry, struct fileattr *fa);
 int ext4_fileattr_get(struct dentry *dentry, struct fileattr *fa);
 extern void ext4_reset_inode_seed(struct inode *inode);
+int ext4_update_overhead(struct super_block *sb);
 
 /* migrate.c */
 extern int ext4_ext_migrate(struct inode *);
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1652,3 +1652,19 @@ long ext4_compat_ioctl(struct file *file
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
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5597,6 +5597,8 @@ static int ext4_fill_super(struct super_
 		ext4_msg(sb, KERN_INFO, "mounted filesystem with%s. "
 			 "Quota mode: %s.", descr, ext4_quota_mode(sb));
 
+	/* Update the s_overhead_clusters if necessary */
+	ext4_update_overhead(sb);
 	return 0;
 
 free_sbi:


