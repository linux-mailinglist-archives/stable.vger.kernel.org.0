Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49EA72598D4
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730718AbgIAPbj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:31:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:34700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730700AbgIAPbf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:31:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BBB321582;
        Tue,  1 Sep 2020 15:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974294;
        bh=Sh1s/7J5WqrXnrxlBMPb30P44eFZLVwU/Nn+LUPRg88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iMXSaILuKAxil6rUph5UriI7JUTEvTU3WCg1Sl/ymOmPNm88JfLvCxkaoF/e/nR73
         qlIYuAAs1trF65Iv1k0dxF8+mgTepURzWP970QfBMuoW3Uw5b3mt07N/qkTlFE4Qka
         4Mm2+5t0fhjSEln7Fji2q8/YwNkr2DjmA+UHv11Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 120/214] ext4: correctly restore system zone info when remount fails
Date:   Tue,  1 Sep 2020 17:10:00 +0200
Message-Id: <20200901150958.736981727@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
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
index ceb54ccc937e9..97c56d061e615 100644
--- a/fs/ext4/block_validity.c
+++ b/fs/ext4/block_validity.c
@@ -250,14 +250,6 @@ int ext4_setup_system_zone(struct super_block *sb)
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
index e8923013accc0..184f2d737efc9 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4563,11 +4563,13 @@ no_journal:
 
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
@@ -5563,9 +5565,16 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
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
@@ -5587,6 +5596,8 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 		}
 	}
 #endif
+	if (!test_opt(sb, BLOCK_VALIDITY) && sbi->system_blks)
+		ext4_release_system_zone(sb);
 
 	/*
 	 * Some options can be enabled by ext4 and/or by VFS mount flag
@@ -5608,6 +5619,8 @@ restore_opts:
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



