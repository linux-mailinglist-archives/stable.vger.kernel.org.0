Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B96A205E24
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389921AbgFWUUW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:20:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:37626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389628AbgFWUUV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:20:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 769D12070E;
        Tue, 23 Jun 2020 20:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943621;
        bh=4PHlZQzPiW4+kAZ98aUi0K6CCahnUn0WTBTQeaOC5tE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YdCKRHGTcwjeWNN7475CWF4pGLnXtfC2d0id9vCLhvf+ZOjuF1d7SlyqOeqKQYjHp
         d1Vg0meJ/qjG0hpmbKpVrlsX5rVYiNd2JDPpTtaXOGT716D2MI9SbOlHwyAc8pL8+9
         aom8vnNS4sUTbtlH1z0lIAQcJaZUXcLgBT01QUMA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        syzbot+bca9799bf129256190da@syzkaller.appspotmail.com,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 436/477] ext4: avoid race conditions when remounting with options that change dax
Date:   Tue, 23 Jun 2020 21:57:13 +0200
Message-Id: <20200623195428.139593024@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

[ Upstream commit 829b37b8cddb1db75c1b7905505b90e593b15db1 ]

Trying to change dax mount options when remounting could allow mount
options to be enabled for a small amount of time, and then the mount
option change would be reverted.

In the case of "mount -o remount,dax", this can cause a race where
files would temporarily treated as DAX --- and then not.

Cc: stable@kernel.org
Reported-by: syzbot+bca9799bf129256190da@syzkaller.appspotmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d23afd6c909de..7318ca71b69eb 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2080,6 +2080,16 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 #endif
 	} else if (token == Opt_dax) {
 #ifdef CONFIG_FS_DAX
+		if (is_remount && test_opt(sb, DAX)) {
+			ext4_msg(sb, KERN_ERR, "can't mount with "
+				"both data=journal and dax");
+			return -1;
+		}
+		if (is_remount && !(sbi->s_mount_opt & EXT4_MOUNT_DAX)) {
+			ext4_msg(sb, KERN_ERR, "can't change "
+					"dax mount option while remounting");
+			return -1;
+		}
 		ext4_msg(sb, KERN_WARNING,
 		"DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
 		sbi->s_mount_opt |= m->mount_opt;
@@ -5407,12 +5417,6 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 			err = -EINVAL;
 			goto restore_opts;
 		}
-		if (test_opt(sb, DAX)) {
-			ext4_msg(sb, KERN_ERR, "can't mount with "
-				 "both data=journal and dax");
-			err = -EINVAL;
-			goto restore_opts;
-		}
 	} else if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_ORDERED_DATA) {
 		if (test_opt(sb, JOURNAL_ASYNC_COMMIT)) {
 			ext4_msg(sb, KERN_ERR, "can't mount with "
@@ -5428,12 +5432,6 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 		goto restore_opts;
 	}
 
-	if ((sbi->s_mount_opt ^ old_opts.s_mount_opt) & EXT4_MOUNT_DAX) {
-		ext4_msg(sb, KERN_WARNING, "warning: refusing change of "
-			"dax flag with busy inodes while remounting");
-		sbi->s_mount_opt ^= EXT4_MOUNT_DAX;
-	}
-
 	if (sbi->s_mount_flags & EXT4_MF_FS_ABORTED)
 		ext4_abort(sb, EXT4_ERR_ESHUTDOWN, "Abort forced by user");
 
-- 
2.25.1



