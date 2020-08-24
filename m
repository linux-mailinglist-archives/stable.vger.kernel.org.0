Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2392502AF
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 18:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbgHXQfY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 12:35:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:39336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728145AbgHXQfU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 12:35:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 003BA22BF5;
        Mon, 24 Aug 2020 16:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598286918;
        bh=YXFQNHr9lZq6hjs8+szpgPfzsKLLsPavwLXSALMFg+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LBLrpjxeqXlMyhC1soMYXMJlKm+WjsSByzIEC5dbIH+6G9Ep9ycCM9DMu7/2AdP4Q
         rfF6/UlyNLPnb9LE/7crFwulJ77YhRTnAcL+KdutygpLjeMwX6WojwMeWNVMCULF5G
         j9bvBm62A/3jEPJ3xgZnBplzxWJHm6SaRbi+E9B8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Kara <jack@suse.cz>, Lukas Czerner <lczerner@redhat.com>,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 11/63] ext4: correctly restore system zone info when remount fails
Date:   Mon, 24 Aug 2020 12:34:11 -0400
Message-Id: <20200824163504.605538-11-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200824163504.605538-1-sashal@kernel.org>
References: <20200824163504.605538-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 16e9b2fda03ae..30ff442453ff0 100644
--- a/fs/ext4/block_validity.c
+++ b/fs/ext4/block_validity.c
@@ -262,14 +262,6 @@ int ext4_setup_system_zone(struct super_block *sb)
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
@@ -4698,11 +4698,13 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 
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
@@ -5761,6 +5772,8 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
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

