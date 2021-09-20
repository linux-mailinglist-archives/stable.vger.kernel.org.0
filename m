Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6098411F42
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348444AbhITRjw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:39:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:42360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348712AbhITRha (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:37:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CABB61381;
        Mon, 20 Sep 2021 17:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157615;
        bh=GQ9lV9zBSX7ryX4LY8y0KL8mtGf2KgywVURBNcGLNkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jE63iUahRbbU19FaF35MCjSTkddgg0grvM4r/DAzlnYCMFJyFx5x0NEwly0AdNiif
         LyQ3Bt/YYcy84AaWon3PSB/mMdtdB2hNGXYwsjVHtKFWWj3rRp/CiM3Et3eaPZZlKj
         TSAMNaQNbugD2Clq+2TozMEV+NSlKn7QJ/WoKdOc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+7fbfe5fed73ebb675748@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 040/293] udf: Check LVID earlier
Date:   Mon, 20 Sep 2021 18:40:02 +0200
Message-Id: <20210920163934.647035360@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index c7f6243f318b..9c71246e6d60 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -112,16 +112,10 @@ struct logicalVolIntegrityDescImpUse *udf_sb_lvidiu(struct super_block *sb)
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
@@ -1529,6 +1523,7 @@ static void udf_load_logicalvolint(struct super_block *sb, struct kernel_extent_
 	struct udf_sb_info *sbi = UDF_SB(sb);
 	struct logicalVolIntegrityDesc *lvid;
 	int indirections = 0;
+	u32 parts, impuselen;
 
 	while (++indirections <= UDF_MAX_LVID_NESTING) {
 		final_bh = NULL;
@@ -1555,15 +1550,27 @@ static void udf_load_logicalvolint(struct super_block *sb, struct kernel_extent_
 
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



