Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63973401286
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238730AbhIFBV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:21:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:37702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238721AbhIFBVM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:21:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4867661027;
        Mon,  6 Sep 2021 01:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891208;
        bh=fTBl37/vcA+zy1sA3MVNfCds40e/iH4HGRE70K5FlEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tbcd+NArIwdeXJrdI+i5n7BtMLkCMIkAUNR2eDPH1MJN+1CRFsB1jDpg/82Rs2Cnz
         mDQgN4NemAk8QyGix/6GJrpG9P2/YD7mPS9EtwCPJnMoFrhUacoB/raXip0BNyca/C
         0KwvqH859Z5HiQCKh1kXUyVpjqFKXTS50K5TUw/OWg3eXLpwp4cuU9TPC4LZUDSQN5
         Ed6/tTRnutPe+xiph5bXQ6hdsxeyfkjzSZtBWr5M4xU7jpQfbWBKMtMEZOqrDT6SBN
         Kx6XRTgfRCHSr8aAlfbg+x3+/pAJkqX77knS++Fs3ume26A/DA28Tscp9zQPtbDhmb
         WEdE5ZCGGv8+g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Kara <jack@suse.cz>,
        syzbot+7fbfe5fed73ebb675748@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.14 14/47] udf: Check LVID earlier
Date:   Sun,  5 Sep 2021 21:19:18 -0400
Message-Id: <20210906011951.928679-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906011951.928679-1-sashal@kernel.org>
References: <20210906011951.928679-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit 781d2a9a2fc7d0be53a072794dc03ef6de770f3d ]

We were checking validity of LVID entries only when getting
implementation use information from LVID in udf_sb_lvidiu(). However if
the LVID is suitably corrupted, it can cause problems also to code such
as udf_count_free() which doesn't use udf_sb_lvidiu(). So check validity
of LVID already when loading it from the disk and just disable LVID
altogether when it is not valid.

Reported-by: syzbot+7fbfe5fed73ebb675748@syzkaller.appspotmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/super.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 2f83c1204e20..1eeb75a1efd2 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -108,16 +108,10 @@ struct logicalVolIntegrityDescImpUse *udf_sb_lvidiu(struct super_block *sb)
 		return NULL;
 	lvid = (struct logicalVolIntegrityDesc *)UDF_SB(sb)->s_lvid_bh->b_data;
 	partnum = le32_to_cpu(lvid->numOfPartitions);
-	if ((sb->s_blocksize - sizeof(struct logicalVolIntegrityDescImpUse) -
-	     offsetof(struct logicalVolIntegrityDesc, impUse)) /
-	     (2 * sizeof(uint32_t)) < partnum) {
-		udf_err(sb, "Logical volume integrity descriptor corrupted "
-			"(numOfPartitions = %u)!\n", partnum);
-		return NULL;
-	}
 	/* The offset is to skip freeSpaceTable and sizeTable arrays */
 	offset = partnum * 2 * sizeof(uint32_t);
-	return (struct logicalVolIntegrityDescImpUse *)&(lvid->impUse[offset]);
+	return (struct logicalVolIntegrityDescImpUse *)
+					(((uint8_t *)(lvid + 1)) + offset);
 }
 
 /* UDF filesystem type */
@@ -1542,6 +1536,7 @@ static void udf_load_logicalvolint(struct super_block *sb, struct kernel_extent_
 	struct udf_sb_info *sbi = UDF_SB(sb);
 	struct logicalVolIntegrityDesc *lvid;
 	int indirections = 0;
+	u32 parts, impuselen;
 
 	while (++indirections <= UDF_MAX_LVID_NESTING) {
 		final_bh = NULL;
@@ -1568,15 +1563,27 @@ static void udf_load_logicalvolint(struct super_block *sb, struct kernel_extent_
 
 		lvid = (struct logicalVolIntegrityDesc *)final_bh->b_data;
 		if (lvid->nextIntegrityExt.extLength == 0)
-			return;
+			goto check;
 
 		loc = leea_to_cpu(lvid->nextIntegrityExt);
 	}
 
 	udf_warn(sb, "Too many LVID indirections (max %u), ignoring.\n",
 		UDF_MAX_LVID_NESTING);
+out_err:
 	brelse(sbi->s_lvid_bh);
 	sbi->s_lvid_bh = NULL;
+	return;
+check:
+	parts = le32_to_cpu(lvid->numOfPartitions);
+	impuselen = le32_to_cpu(lvid->lengthOfImpUse);
+	if (parts >= sb->s_blocksize || impuselen >= sb->s_blocksize ||
+	    sizeof(struct logicalVolIntegrityDesc) + impuselen +
+	    2 * parts * sizeof(u32) > sb->s_blocksize) {
+		udf_warn(sb, "Corrupted LVID (parts=%u, impuselen=%u), "
+			 "ignoring.\n", parts, impuselen);
+		goto out_err;
+	}
 }
 
 /*
-- 
2.30.2

