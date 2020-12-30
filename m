Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B33E62E7951
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 14:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727242AbgL3NE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 08:04:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:53386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727215AbgL3NE4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 08:04:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BE862247F;
        Wed, 30 Dec 2020 13:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609333430;
        bh=PsMdaPCEfclDW+2glU7Iio8JmZBxzfIsyOPnJie5Hs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sqSFIA6bvtyugO5JM5IM+9Vk3IaBcz7HZZhdKMesc/8SyXUJ34VoSlFFU1lmcjPWJ
         NJxTc/ozgu+8DAUo27Ejq/NH87O/Pit+PdlV68Dvk6l+TwdU6J5sYH9k9TXI50DU2e
         0kE/C0aVgDzpNpPwPakN/BG2EcvZe0yrl/lZjDKutuSUry5VZvNFBpXTAiMAS3RrRl
         Ng0pwbgremMuoDaUWAp93YrxL+H0qhTl+0FZY+KjuOQERYY0gltMKpNQPwle0ahOTI
         nF0nBNZPVvI4xSwNHQnr+9ALTaYX1rKmKy558wLLu2nbxnTUwFMZBeal/c/TwaORr0
         L0ExRV5nBm1XA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Theodore Ts'o <tytso@mit.edu>,
        syzbot+345b75652b1d24227443@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>, linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 27/31] ext4: check for invalid block size early when mounting a file system
Date:   Wed, 30 Dec 2020 08:03:09 -0500
Message-Id: <20201230130314.3636961-27-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201230130314.3636961-1-sashal@kernel.org>
References: <20201230130314.3636961-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

[ Upstream commit c9200760da8a728eb9767ca41a956764b28c1310 ]

Check for valid block size directly by validating s_log_block_size; we
were doing this in two places.  First, by calculating blocksize via
BLOCK_SIZE << s_log_block_size, and then checking that the blocksize
was valid.  And then secondly, by checking s_log_block_size directly.

The first check is not reliable, and can trigger an UBSAN warning if
s_log_block_size on a maliciously corrupted superblock is greater than
22.  This is harmless, since the second test will correctly reject the
maliciously fuzzed file system, but to make syzbot shut up, and
because the two checks are duplicative in any case, delete the
blocksize check, and move the s_log_block_size earlier in
ext4_fill_super().

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reported-by: syzbot+345b75652b1d24227443@syzkaller.appspotmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 40 ++++++++++++++++------------------------
 1 file changed, 16 insertions(+), 24 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 94472044f4c1d..950872c9c6891 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4188,18 +4188,25 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	 */
 	sbi->s_li_wait_mult = EXT4_DEF_LI_WAIT_MULT;
 
-	blocksize = BLOCK_SIZE << le32_to_cpu(es->s_log_block_size);
-
-	if (blocksize == PAGE_SIZE)
-		set_opt(sb, DIOREAD_NOLOCK);
-
-	if (blocksize < EXT4_MIN_BLOCK_SIZE ||
-	    blocksize > EXT4_MAX_BLOCK_SIZE) {
+	if (le32_to_cpu(es->s_log_block_size) >
+	    (EXT4_MAX_BLOCK_LOG_SIZE - EXT4_MIN_BLOCK_LOG_SIZE)) {
 		ext4_msg(sb, KERN_ERR,
-		       "Unsupported filesystem blocksize %d (%d log_block_size)",
-			 blocksize, le32_to_cpu(es->s_log_block_size));
+			 "Invalid log block size: %u",
+			 le32_to_cpu(es->s_log_block_size));
 		goto failed_mount;
 	}
+	if (le32_to_cpu(es->s_log_cluster_size) >
+	    (EXT4_MAX_CLUSTER_LOG_SIZE - EXT4_MIN_BLOCK_LOG_SIZE)) {
+		ext4_msg(sb, KERN_ERR,
+			 "Invalid log cluster size: %u",
+			 le32_to_cpu(es->s_log_cluster_size));
+		goto failed_mount;
+	}
+
+	blocksize = EXT4_MIN_BLOCK_SIZE << le32_to_cpu(es->s_log_block_size);
+
+	if (blocksize == PAGE_SIZE)
+		set_opt(sb, DIOREAD_NOLOCK);
 
 	if (le32_to_cpu(es->s_rev_level) == EXT4_GOOD_OLD_REV) {
 		sbi->s_inode_size = EXT4_GOOD_OLD_INODE_SIZE;
@@ -4418,21 +4425,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	if (!ext4_feature_set_ok(sb, (sb_rdonly(sb))))
 		goto failed_mount;
 
-	if (le32_to_cpu(es->s_log_block_size) >
-	    (EXT4_MAX_BLOCK_LOG_SIZE - EXT4_MIN_BLOCK_LOG_SIZE)) {
-		ext4_msg(sb, KERN_ERR,
-			 "Invalid log block size: %u",
-			 le32_to_cpu(es->s_log_block_size));
-		goto failed_mount;
-	}
-	if (le32_to_cpu(es->s_log_cluster_size) >
-	    (EXT4_MAX_CLUSTER_LOG_SIZE - EXT4_MIN_BLOCK_LOG_SIZE)) {
-		ext4_msg(sb, KERN_ERR,
-			 "Invalid log cluster size: %u",
-			 le32_to_cpu(es->s_log_cluster_size));
-		goto failed_mount;
-	}
-
 	if (le16_to_cpu(sbi->s_es->s_reserved_gdt_blocks) > (blocksize / 4)) {
 		ext4_msg(sb, KERN_ERR,
 			 "Number of reserved GDT blocks insanely large: %d",
-- 
2.27.0

