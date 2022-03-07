Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAF7C4CF934
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232783AbiCGKEG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:04:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240512AbiCGKBE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:01:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA1120F58;
        Mon,  7 Mar 2022 01:49:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF1EB60010;
        Mon,  7 Mar 2022 09:49:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2EC6C340F5;
        Mon,  7 Mar 2022 09:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646589;
        bh=PxzTc57IQdrmDgTvi0EtjhOekh9QUtO7TK6zL07Nh+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LxxINoID4ZZwd/gIkzldZpiioQdA+ZoU+Nvpp19MZjiAD3Q6mzoYWmJBFsDD3L+y2
         ykxAzEjU8eCOj2cj1I2C3RSAd5SjT2A3tatjEZnr6HgrtT4YtnCr5KeyVFER+Vgy30
         zjVixJ5h4ssw8nknLrZVgpoHfaMaO+IPdXpWJtnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Vu-Brugier <christophe.vu-brugier@seagate.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 030/186] exfat: reuse exfat_inode_info variable instead of calling EXFAT_I()
Date:   Mon,  7 Mar 2022 10:17:48 +0100
Message-Id: <20220307091654.936386507@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Vu-Brugier <christophe.vu-brugier@seagate.com>

[ Upstream commit 7dee6f57d7f22a89dd214518c778aec448270d4c ]

Also add a local "struct exfat_inode_info *ei" variable to
exfat_truncate() to simplify the code.

Signed-off-by: Christophe Vu-Brugier <christophe.vu-brugier@seagate.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/file.c  | 14 +++++++-------
 fs/exfat/inode.c |  9 ++++-----
 fs/exfat/namei.c |  6 +++---
 fs/exfat/super.c |  6 +++---
 4 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/fs/exfat/file.c b/fs/exfat/file.c
index 6af0191b648f1..848166d6d5e9d 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -110,8 +110,7 @@ int __exfat_truncate(struct inode *inode, loff_t new_size)
 	exfat_set_volume_dirty(sb);
 
 	num_clusters_new = EXFAT_B_TO_CLU_ROUND_UP(i_size_read(inode), sbi);
-	num_clusters_phys =
-		EXFAT_B_TO_CLU_ROUND_UP(EXFAT_I(inode)->i_size_ondisk, sbi);
+	num_clusters_phys = EXFAT_B_TO_CLU_ROUND_UP(ei->i_size_ondisk, sbi);
 
 	exfat_chain_set(&clu, ei->start_clu, num_clusters_phys, ei->flags);
 
@@ -228,12 +227,13 @@ void exfat_truncate(struct inode *inode, loff_t size)
 {
 	struct super_block *sb = inode->i_sb;
 	struct exfat_sb_info *sbi = EXFAT_SB(sb);
+	struct exfat_inode_info *ei = EXFAT_I(inode);
 	unsigned int blocksize = i_blocksize(inode);
 	loff_t aligned_size;
 	int err;
 
 	mutex_lock(&sbi->s_lock);
-	if (EXFAT_I(inode)->start_clu == 0) {
+	if (ei->start_clu == 0) {
 		/*
 		 * Empty start_clu != ~0 (not allocated)
 		 */
@@ -260,11 +260,11 @@ void exfat_truncate(struct inode *inode, loff_t size)
 		aligned_size++;
 	}
 
-	if (EXFAT_I(inode)->i_size_ondisk > i_size_read(inode))
-		EXFAT_I(inode)->i_size_ondisk = aligned_size;
+	if (ei->i_size_ondisk > i_size_read(inode))
+		ei->i_size_ondisk = aligned_size;
 
-	if (EXFAT_I(inode)->i_size_aligned > i_size_read(inode))
-		EXFAT_I(inode)->i_size_aligned = aligned_size;
+	if (ei->i_size_aligned > i_size_read(inode))
+		ei->i_size_aligned = aligned_size;
 	mutex_unlock(&sbi->s_lock);
 }
 
diff --git a/fs/exfat/inode.c b/fs/exfat/inode.c
index 1c7aa1ea4724c..aca2e64d045b6 100644
--- a/fs/exfat/inode.c
+++ b/fs/exfat/inode.c
@@ -114,10 +114,9 @@ static int exfat_map_cluster(struct inode *inode, unsigned int clu_offset,
 	unsigned int local_clu_offset = clu_offset;
 	unsigned int num_to_be_allocated = 0, num_clusters = 0;
 
-	if (EXFAT_I(inode)->i_size_ondisk > 0)
+	if (ei->i_size_ondisk > 0)
 		num_clusters =
-			EXFAT_B_TO_CLU_ROUND_UP(EXFAT_I(inode)->i_size_ondisk,
-			sbi);
+			EXFAT_B_TO_CLU_ROUND_UP(ei->i_size_ondisk, sbi);
 
 	if (clu_offset >= num_clusters)
 		num_to_be_allocated = clu_offset - num_clusters + 1;
@@ -416,10 +415,10 @@ static int exfat_write_end(struct file *file, struct address_space *mapping,
 
 	err = generic_write_end(file, mapping, pos, len, copied, pagep, fsdata);
 
-	if (EXFAT_I(inode)->i_size_aligned < i_size_read(inode)) {
+	if (ei->i_size_aligned < i_size_read(inode)) {
 		exfat_fs_error(inode->i_sb,
 			"invalid size(size(%llu) > aligned(%llu)\n",
-			i_size_read(inode), EXFAT_I(inode)->i_size_aligned);
+			i_size_read(inode), ei->i_size_aligned);
 		return -EIO;
 	}
 
diff --git a/fs/exfat/namei.c b/fs/exfat/namei.c
index 24b41103d1cc0..9d8ada781250b 100644
--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -395,9 +395,9 @@ static int exfat_find_empty_entry(struct inode *inode,
 
 		/* directory inode should be updated in here */
 		i_size_write(inode, size);
-		EXFAT_I(inode)->i_size_ondisk += sbi->cluster_size;
-		EXFAT_I(inode)->i_size_aligned += sbi->cluster_size;
-		EXFAT_I(inode)->flags = p_dir->flags;
+		ei->i_size_ondisk += sbi->cluster_size;
+		ei->i_size_aligned += sbi->cluster_size;
+		ei->flags = p_dir->flags;
 		inode->i_blocks += 1 << sbi->sect_per_clus_bits;
 	}
 
diff --git a/fs/exfat/super.c b/fs/exfat/super.c
index 5539ffc20d164..1a2115d73a48a 100644
--- a/fs/exfat/super.c
+++ b/fs/exfat/super.c
@@ -366,9 +366,9 @@ static int exfat_read_root(struct inode *inode)
 
 	inode->i_blocks = ((i_size_read(inode) + (sbi->cluster_size - 1))
 			& ~(sbi->cluster_size - 1)) >> inode->i_blkbits;
-	EXFAT_I(inode)->i_pos = ((loff_t)sbi->root_dir << 32) | 0xffffffff;
-	EXFAT_I(inode)->i_size_aligned = i_size_read(inode);
-	EXFAT_I(inode)->i_size_ondisk = i_size_read(inode);
+	ei->i_pos = ((loff_t)sbi->root_dir << 32) | 0xffffffff;
+	ei->i_size_aligned = i_size_read(inode);
+	ei->i_size_ondisk = i_size_read(inode);
 
 	exfat_save_attr(inode, ATTR_SUBDIR);
 	inode->i_mtime = inode->i_atime = inode->i_ctime = ei->i_crtime =
-- 
2.34.1



