Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 339C325949B
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731182AbgIAPl0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:41:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:53158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731419AbgIAPlP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:41:15 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 833C320767;
        Tue,  1 Sep 2020 15:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974875;
        bh=bcv8a7aUYMp16+rL7DKkOjjRhxFK6QVJCj1xeSXR4ts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GSqjBjZkukGrkmK0iZhcZhK8a8EXyO5ElezGlnqSsFDFjEcqdg+Jrspp92+YYoryn
         KBFS9vgA62Nu+09oqsW6+VgiJXjbqxPtWDcfxeaVq0JeVDlic7n6cDNNtv+gXADhzP
         2Xtm6SfUQubkA8OMQqMDrBwrSyZKoEvkkRQL1bvM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 116/255] ext4: correctly restore system zone info when remount fails
Date:   Tue,  1 Sep 2020 17:09:32 +0200
Message-Id: <20200901151006.287088129@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit 0f5bde1db174f6c471f0bd27198575719dabe3e5 ]

When remounting filesystem fails late during remount handling and
block_validity mount option is also changed during the remount, we fail
to restore system zone information to a state matching the mount option.
This is mostly harmless, just the block validity checking will not match
the situation described by the mount option. Make sure these two are always
consistent.

Reported-by: Lukas Czerner <lczerner@redhat.com>
Reviewed-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20200728130437.7804-7-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/block_validity.c |  8 --------
 fs/ext4/super.c          | 29 +++++++++++++++++++++--------
 2 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/fs/ext4/block_validity.c b/fs/ext4/block_validity.c
index e830a9d4e10d3..11aa37693e436 100644
--- a/fs/ext4/block_validity.c
+++ b/fs/ext4/block_validity.c
@@ -254,14 +254,6 @@ int ext4_setup_system_zone(struct super_block *sb)
 	int flex_size = ext4_flex_bg_size(sbi);
 	int ret;
 
-	if (!test_opt(sb, BLOCK_VALIDITY)) {
-		if (sbi->system_blks)
-			ext4_release_system_zone(sb);
-		return 0;
-	}
-	if (sbi->system_blks)
-		return 0;
-
 	system_blks = kzalloc(sizeof(*system_blks), GFP_KERNEL);
 	if (!system_blks)
 		return -ENOMEM;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 54d1c09329e55..4c8253188d8df 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4698,11 +4698,13 @@ no_journal:
 
 	ext4_set_resv_clusters(sb);
 
-	err = ext4_setup_system_zone(sb);
-	if (err) {
-		ext4_msg(sb, KERN_ERR, "failed to initialize system "
-			 "zone (%d)", err);
-		goto failed_mount4a;
+	if (test_opt(sb, BLOCK_VALIDITY)) {
+		err = ext4_setup_system_zone(sb);
+		if (err) {
+			ext4_msg(sb, KERN_ERR, "failed to initialize system "
+				 "zone (%d)", err);
+			goto failed_mount4a;
+		}
 	}
 
 	ext4_ext_init(sb);
@@ -5716,9 +5718,16 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 		ext4_register_li_request(sb, first_not_zeroed);
 	}
 
-	err = ext4_setup_system_zone(sb);
-	if (err)
-		goto restore_opts;
+	/*
+	 * Handle creation of system zone data early because it can fail.
+	 * Releasing of existing data is done when we are sure remount will
+	 * succeed.
+	 */
+	if (test_opt(sb, BLOCK_VALIDITY) && !sbi->system_blks) {
+		err = ext4_setup_system_zone(sb);
+		if (err)
+			goto restore_opts;
+	}
 
 	if (sbi->s_journal == NULL && !(old_sb_flags & SB_RDONLY)) {
 		err = ext4_commit_super(sb, 1);
@@ -5740,6 +5749,8 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 		}
 	}
 #endif
+	if (!test_opt(sb, BLOCK_VALIDITY) && sbi->system_blks)
+		ext4_release_system_zone(sb);
 
 	/*
 	 * Some options can be enabled by ext4 and/or by VFS mount flag
@@ -5761,6 +5772,8 @@ restore_opts:
 	sbi->s_commit_interval = old_opts.s_commit_interval;
 	sbi->s_min_batch_time = old_opts.s_min_batch_time;
 	sbi->s_max_batch_time = old_opts.s_max_batch_time;
+	if (!test_opt(sb, BLOCK_VALIDITY) && sbi->system_blks)
+		ext4_release_system_zone(sb);
 #ifdef CONFIG_QUOTA
 	sbi->s_jquota_fmt = old_opts.s_jquota_fmt;
 	for (i = 0; i < EXT4_MAXQUOTAS; i++) {
-- 
2.25.1



