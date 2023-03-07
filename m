Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D45166AEB71
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232050AbjCGRoa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:44:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232052AbjCGRoP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:44:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8113E95E02
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:39:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F24086150C
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:39:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A41C433D2;
        Tue,  7 Mar 2023 17:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210749;
        bh=pYmPZuIatWJIy9TjbQpRfMHAueHd4doPOek4LgFFMPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K3UQRsZ7dNAfpJPCwSFlwG6uYsUOVHm/ZREhpacQQUipSgO8CYC8TnBd61RG7evED
         AE+mJwxmdho05K4MAKxjYHtS2mqRonJMxJ9oJgzrxsn8RXjETvnK+m0QGo4zlhDvFr
         qqX7XqiTgpe+LdZh8HKqsoXI8OW2/H7yp4VKiSjE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jann Horn <jannh@google.com>,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0624/1001] fs: Use CHECK_DATA_CORRUPTION() when kernel bugs are detected
Date:   Tue,  7 Mar 2023 17:56:36 +0100
Message-Id: <20230307170048.642209949@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

[ Upstream commit 47d586913f2abec4d240bae33417f537fda987ec ]

Currently, filp_close() and generic_shutdown_super() use printk() to log
messages when bugs are detected. This is problematic because infrastructure
like syzkaller has no idea that this message indicates a bug.
In addition, some people explicitly want their kernels to BUG() when kernel
data corruption has been detected (CONFIG_BUG_ON_DATA_CORRUPTION).
And finally, when generic_shutdown_super() detects remaining inodes on a
system without CONFIG_BUG_ON_DATA_CORRUPTION, it would be nice if later
accesses to a busy inode would at least crash somewhat cleanly rather than
walking through freed memory.

To address all three, use CHECK_DATA_CORRUPTION() when kernel bugs are
detected.

Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/open.c              |  5 +++--
 fs/super.c             | 21 +++++++++++++++++----
 include/linux/poison.h |  3 +++
 3 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 82c1a28b33089..ceb88ac0ca3b2 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -1411,8 +1411,9 @@ int filp_close(struct file *filp, fl_owner_t id)
 {
 	int retval = 0;
 
-	if (!file_count(filp)) {
-		printk(KERN_ERR "VFS: Close: file count is 0\n");
+	if (CHECK_DATA_CORRUPTION(file_count(filp) == 0,
+			"VFS: Close: file count is 0 (f_op=%ps)",
+			filp->f_op)) {
 		return 0;
 	}
 
diff --git a/fs/super.c b/fs/super.c
index 12c08cb20405d..cf737ec2bd05c 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -491,10 +491,23 @@ void generic_shutdown_super(struct super_block *sb)
 		if (sop->put_super)
 			sop->put_super(sb);
 
-		if (!list_empty(&sb->s_inodes)) {
-			printk("VFS: Busy inodes after unmount of %s. "
-			   "Self-destruct in 5 seconds.  Have a nice day...\n",
-			   sb->s_id);
+		if (CHECK_DATA_CORRUPTION(!list_empty(&sb->s_inodes),
+				"VFS: Busy inodes after unmount of %s (%s)",
+				sb->s_id, sb->s_type->name)) {
+			/*
+			 * Adding a proper bailout path here would be hard, but
+			 * we can at least make it more likely that a later
+			 * iput_final() or such crashes cleanly.
+			 */
+			struct inode *inode;
+
+			spin_lock(&sb->s_inode_list_lock);
+			list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
+				inode->i_op = VFS_PTR_POISON;
+				inode->i_sb = VFS_PTR_POISON;
+				inode->i_mapping = VFS_PTR_POISON;
+			}
+			spin_unlock(&sb->s_inode_list_lock);
 		}
 	}
 	spin_lock(&sb_lock);
diff --git a/include/linux/poison.h b/include/linux/poison.h
index 2d3249eb0e62d..0e8a1f2ceb2f1 100644
--- a/include/linux/poison.h
+++ b/include/linux/poison.h
@@ -84,4 +84,7 @@
 /********** kernel/bpf/ **********/
 #define BPF_PTR_POISON ((void *)(0xeB9FUL + POISON_POINTER_DELTA))
 
+/********** VFS **********/
+#define VFS_PTR_POISON ((void *)(0xF5 + POISON_POINTER_DELTA))
+
 #endif
-- 
2.39.2



