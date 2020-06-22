Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28E60203E6A
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 19:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730118AbgFVRvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 13:51:06 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:55517 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730099AbgFVRvG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 13:51:06 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 8405A11FC;
        Mon, 22 Jun 2020 13:51:05 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 22 Jun 2020 13:51:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=S0tm8c
        tq2kdWIk0zY5WaDylbtPYxgoADz+yDthd9nD0=; b=gqryWox22tbJyVK/R2cN1u
        YekvrwTI5pzQy/sdauRig77y0wADvSB4v70fKufvFPitOrr4tlTWt1U8FUrgspYw
        jjDBfKR/4Vg89p5h6EZfXU6IV3k0Akj4Rt0V7lG3A/nKEsXIrZr4vOntq1tXLotG
        1KS5Snec0KYkR1HQ/jHx9GjfkvMTzmQrwzjCaaek/+im52MfSqFOJNN735BxoT/B
        RlrFSU3is2JeHQobU6cdOOwNSqEI616qQHEDaW6k1xBZaX5IlZ0TPG49XtUWb4aM
        jyCBlwbtbkf8GLXEPEDfkufbT9cl793VoEW28g94rS50DwoyNLGzOOInMAjH/SEQ
        ==
X-ME-Sender: <xms:ie_wXg04vhVWDKNwI9XnL-KW0xpfzmkKFAWDqj1bNbu70FUBmcoIKg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekvddguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhs
    thgvrhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:ie_wXrGnS2J0jRkmd1tjWEC9V3L-P6hOywnTYb9NeVJX5doZGUlZJw>
    <xmx:ie_wXo7Ea9_0IgHFAxstTSsaOIft7Txr6CXmzJHdD7zNUEHcVz-v8A>
    <xmx:ie_wXp2wRY_rR62h6zzlYzcSns0JVHK6RoVMwe0VbARyThH3HrD6mw>
    <xmx:ie_wXnS3hqssWRRvuRjzcqZ-dbtkSliRz9u29Z8YLnDWAbhRFnSKFeWptqw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id BEFD030673B7;
        Mon, 22 Jun 2020 13:51:04 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ext4: avoid race conditions when remounting with options that" failed to apply to 4.19-stable tree
To:     tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Jun 2020 19:50:57 +0200
Message-ID: <159284825795161@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 829b37b8cddb1db75c1b7905505b90e593b15db1 Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Wed, 10 Jun 2020 11:16:37 -0400
Subject: [PATCH] ext4: avoid race conditions when remounting with options that
 change dax

Trying to change dax mount options when remounting could allow mount
options to be enabled for a small amount of time, and then the mount
option change would be reverted.

In the case of "mount -o remount,dax", this can cause a race where
files would temporarily treated as DAX --- and then not.

Cc: stable@kernel.org
Reported-by: syzbot+bca9799bf129256190da@syzkaller.appspotmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index a22d67c5bc00..edf06c1bee9d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2104,16 +2104,40 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 		switch (token) {
 		case Opt_dax:
 		case Opt_dax_always:
+			if (is_remount &&
+			    (!(sbi->s_mount_opt & EXT4_MOUNT_DAX_ALWAYS) ||
+			     (sbi->s_mount_opt2 & EXT4_MOUNT2_DAX_NEVER))) {
+			fail_dax_change_remount:
+				ext4_msg(sb, KERN_ERR, "can't change "
+					 "dax mount option while remounting");
+				return -1;
+			}
+			if (is_remount &&
+			    (test_opt(sb, DATA_FLAGS) ==
+			     EXT4_MOUNT_JOURNAL_DATA)) {
+				    ext4_msg(sb, KERN_ERR, "can't mount with "
+					     "both data=journal and dax");
+				    return -1;
+			}
 			ext4_msg(sb, KERN_WARNING,
 				"DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
 			sbi->s_mount_opt |= EXT4_MOUNT_DAX_ALWAYS;
 			sbi->s_mount_opt2 &= ~EXT4_MOUNT2_DAX_NEVER;
 			break;
 		case Opt_dax_never:
+			if (is_remount &&
+			    (!(sbi->s_mount_opt2 & EXT4_MOUNT2_DAX_NEVER) ||
+			     (sbi->s_mount_opt & EXT4_MOUNT_DAX_ALWAYS)))
+				goto fail_dax_change_remount;
 			sbi->s_mount_opt2 |= EXT4_MOUNT2_DAX_NEVER;
 			sbi->s_mount_opt &= ~EXT4_MOUNT_DAX_ALWAYS;
 			break;
 		case Opt_dax_inode:
+			if (is_remount &&
+			    ((sbi->s_mount_opt & EXT4_MOUNT_DAX_ALWAYS) ||
+			     (sbi->s_mount_opt2 & EXT4_MOUNT2_DAX_NEVER) ||
+			     !(sbi->s_mount_opt2 & EXT4_MOUNT2_DAX_INODE)))
+				goto fail_dax_change_remount;
 			sbi->s_mount_opt &= ~EXT4_MOUNT_DAX_ALWAYS;
 			sbi->s_mount_opt2 &= ~EXT4_MOUNT2_DAX_NEVER;
 			/* Strictly for printing options */
@@ -5454,12 +5478,6 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 			err = -EINVAL;
 			goto restore_opts;
 		}
-		if (test_opt(sb, DAX_ALWAYS)) {
-			ext4_msg(sb, KERN_ERR, "can't mount with "
-				 "both data=journal and dax");
-			err = -EINVAL;
-			goto restore_opts;
-		}
 	} else if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_ORDERED_DATA) {
 		if (test_opt(sb, JOURNAL_ASYNC_COMMIT)) {
 			ext4_msg(sb, KERN_ERR, "can't mount with "
@@ -5475,18 +5493,6 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 		goto restore_opts;
 	}
 
-	if ((sbi->s_mount_opt ^ old_opts.s_mount_opt) & EXT4_MOUNT_DAX_ALWAYS ||
-	    (sbi->s_mount_opt2 ^ old_opts.s_mount_opt2) & EXT4_MOUNT2_DAX_NEVER ||
-	    (sbi->s_mount_opt2 ^ old_opts.s_mount_opt2) & EXT4_MOUNT2_DAX_INODE) {
-		ext4_msg(sb, KERN_WARNING, "warning: refusing change of "
-			"dax mount option with busy inodes while remounting");
-		sbi->s_mount_opt &= ~EXT4_MOUNT_DAX_ALWAYS;
-		sbi->s_mount_opt |= old_opts.s_mount_opt & EXT4_MOUNT_DAX_ALWAYS;
-		sbi->s_mount_opt2 &= ~(EXT4_MOUNT2_DAX_NEVER | EXT4_MOUNT2_DAX_INODE);
-		sbi->s_mount_opt2 |= old_opts.s_mount_opt2 &
-				     (EXT4_MOUNT2_DAX_NEVER | EXT4_MOUNT2_DAX_INODE);
-	}
-
 	if (sbi->s_mount_flags & EXT4_MF_FS_ABORTED)
 		ext4_abort(sb, EXT4_ERR_ESHUTDOWN, "Abort forced by user");
 

