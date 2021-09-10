Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1111640638D
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241714AbhIJAp1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:45:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:47140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233767AbhIJAVP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:21:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 684E76023D;
        Fri, 10 Sep 2021 00:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233205;
        bh=AhZQpIEa2jAd8ASkdv9iUd0SEoYpt0OKm5VlG+UM4gs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=smQbgqnoWcObglB0guh8EtsgUUN64O6tCIQLQK2QVQNcPYE2XaBiL4oj+MAXANR1p
         SnYpASkixkH4z1qBGl+cpbMX0a6HnTXXu82DtHFMGe6vbC+oNdV2TiGspQK5TZOfzE
         ss5/6PD2twoRPsp7IrfbP8YcMaQtm3ldnlAGO51GmQXxN6UxNZmoOKyBC5EDaw1Tpy
         3NH2kHTrCgxjzjyNR8H4jBqW6O7p1+f9kUeX8YsWac9fhL2hDdOc0KmB2aj5p3IF2u
         HngEeUID0GCQPtbGSK1vzZus4EHpb5cEqojgb7KcgXNy2S/3Q/miUgN6WVIyWLhQsw
         EnXn7OCtC/F6w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>, linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 74/88] ext4: Make sure quota files are not grabbed accidentally
Date:   Thu,  9 Sep 2021 20:18:06 -0400
Message-Id: <20210910001820.174272-74-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001820.174272-1-sashal@kernel.org>
References: <20210910001820.174272-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit bd2c38cf1726ea913024393a0d11f2e2a3f4c180 ]

If ext4 filesystem is corrupted so that quota files are linked from
directory hirerarchy, bad things can happen. E.g. quota files can get
corrupted or deleted. Make sure we are not grabbing quota file inodes
when we expect normal inodes.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Link: https://lore.kernel.org/r/20210812133122.26360-1-jack@suse.cz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 211acfba3af7..4e150fbf5c6b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4603,6 +4603,7 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 	struct ext4_iloc iloc;
 	struct ext4_inode *raw_inode;
 	struct ext4_inode_info *ei;
+	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
 	struct inode *inode;
 	journal_t *journal = EXT4_SB(sb)->s_journal;
 	long ret;
@@ -4613,9 +4614,12 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 	projid_t i_projid;
 
 	if ((!(flags & EXT4_IGET_SPECIAL) &&
-	     (ino < EXT4_FIRST_INO(sb) && ino != EXT4_ROOT_INO)) ||
+	     ((ino < EXT4_FIRST_INO(sb) && ino != EXT4_ROOT_INO) ||
+	      ino == le32_to_cpu(es->s_usr_quota_inum) ||
+	      ino == le32_to_cpu(es->s_grp_quota_inum) ||
+	      ino == le32_to_cpu(es->s_prj_quota_inum))) ||
 	    (ino < EXT4_ROOT_INO) ||
-	    (ino > le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count))) {
+	    (ino > le32_to_cpu(es->s_inodes_count))) {
 		if (flags & EXT4_IGET_HANDLE)
 			return ERR_PTR(-ESTALE);
 		__ext4_error(sb, function, line, false, EFSCORRUPTED, 0,
-- 
2.30.2

