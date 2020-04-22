Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCC41B4054
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731694AbgDVKpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:45:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:54724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729933AbgDVKSP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:18:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DC092070B;
        Wed, 22 Apr 2020 10:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550695;
        bh=5SeT3hiRI9bcQ3mKwLYKdi/OeOWo9IX8PWvS3M83jsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mFiufMcJf3SDP2Cb8+YrLHKoAJMaAXj8DNlv65cPi7bfmKmOTn56CP5ks1awpmvxg
         2FEtZA6kJPzs4jfCB3kgnh9be9Yn7IKLe3NF1QLE3kHQkgfS0lktjnNTZ+qX1M+bca
         5s6hTunfnw8kO3nWIKmekoWX7mLHkEoIjGinKNIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 055/118] f2fs: fix to show norecovery mount option
Date:   Wed, 22 Apr 2020 11:56:56 +0200
Message-Id: <20200422095041.064784796@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095031.522502705@linuxfoundation.org>
References: <20200422095031.522502705@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit a9117eca1de6b738e713d2142126db2cfbf6fb36 ]

Previously, 'norecovery' mount option will be shown as
'disable_roll_forward', fix to show original option name correctly.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/f2fs.h  | 1 +
 fs/f2fs/super.c | 7 +++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 1a8b68ceaa62f..3edde3d6d089d 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -100,6 +100,7 @@ extern const char *f2fs_fault_name[FAULT_MAX];
 #define F2FS_MOUNT_INLINE_XATTR_SIZE	0x00800000
 #define F2FS_MOUNT_RESERVE_ROOT		0x01000000
 #define F2FS_MOUNT_DISABLE_CHECKPOINT	0x02000000
+#define F2FS_MOUNT_NORECOVERY		0x04000000
 
 #define F2FS_OPTION(sbi)	((sbi)->mount_opt)
 #define clear_opt(sbi, option)	(F2FS_OPTION(sbi).opt &= ~F2FS_MOUNT_##option)
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 28441f4971b8d..94caf26901e0b 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -439,7 +439,7 @@ static int parse_options(struct super_block *sb, char *options)
 			break;
 		case Opt_norecovery:
 			/* this option mounts f2fs with ro */
-			set_opt(sbi, DISABLE_ROLL_FORWARD);
+			set_opt(sbi, NORECOVERY);
 			if (!f2fs_readonly(sb))
 				return -EINVAL;
 			break;
@@ -1348,6 +1348,8 @@ static int f2fs_show_options(struct seq_file *seq, struct dentry *root)
 	}
 	if (test_opt(sbi, DISABLE_ROLL_FORWARD))
 		seq_puts(seq, ",disable_roll_forward");
+	if (test_opt(sbi, NORECOVERY))
+		seq_puts(seq, ",norecovery");
 	if (test_opt(sbi, DISCARD))
 		seq_puts(seq, ",discard");
 	else
@@ -3488,7 +3490,8 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 		goto reset_checkpoint;
 
 	/* recover fsynced data */
-	if (!test_opt(sbi, DISABLE_ROLL_FORWARD)) {
+	if (!test_opt(sbi, DISABLE_ROLL_FORWARD) &&
+			!test_opt(sbi, NORECOVERY)) {
 		/*
 		 * mount should be failed, when device has readonly mode, and
 		 * previous checkpoint was not done by clean system shutdown.
-- 
2.20.1



