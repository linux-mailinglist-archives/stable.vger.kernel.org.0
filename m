Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A120964709D
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 14:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbiLHNQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 08:16:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiLHNQC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 08:16:02 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C992692FEA;
        Thu,  8 Dec 2022 05:16:00 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 561C6208DE;
        Thu,  8 Dec 2022 13:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1670505359; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5mtrRWkeif0u1cMY0mFFaMoCXncrrP1/K5/WlVw5nJc=;
        b=zKeJkJcAcZAPzjMoS8S/cEJq0OXJYI+hbvuP4d3qCuaJQEHMGUGGr6VkqlH7A6Oqp1MXXl
        QTLIXIm1nH6YsU+LaLXp/TUU45mW4sMIcIdTHEyI9S0HYQVAB0vZLrHEgL/4wauQY1Eea2
        T8I8raL6WWPcqNI7sbhPSJ/tfoyDDCk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1670505359;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5mtrRWkeif0u1cMY0mFFaMoCXncrrP1/K5/WlVw5nJc=;
        b=p6iCyLXitJuOpwxR8fYLN8QtbYL8Qo/YLIRPD9MLviMsw+5DbI73mkOUB5/0GUkaetV/wB
        nhDWSrW2qjRusYAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4B00D138E2;
        Thu,  8 Dec 2022 13:15:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Vn3nEY/jkWNaTQAAMHmgww
        (envelope-from <jack@suse.cz>); Thu, 08 Dec 2022 13:15:59 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id C615CA0729; Thu,  8 Dec 2022 14:15:58 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     <linux-fsdevel@vger.kernel.org>
Cc:     Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Subject: [PATCH 3/4] udf: Discard preallocation before extending file with a hole
Date:   Thu,  8 Dec 2022 14:15:50 +0100
Message-Id: <20221208131558.27298-3-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20221208131111.29134-1-jack@suse.cz>
References: <20221208131111.29134-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4355; i=jack@suse.cz; h=from:subject; bh=XAAAnca7wXicVWpc8NCWeUwmmzDiNPQvC3+MibdJerY=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBjkeOFMDbnmQtXLFKTdPFDIaSATWVdkrWAN6/9py+Q UXV/PAyJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCY5HjhQAKCRCcnaoHP2RA2XjpB/ 4v8wb5NYhXGff7TSbIyxFf2Xev4ETSh3u+fScRLvfiSyIa2gYdZPAW4wdyhrjCNHVeZ0axGyWplP50 ef7p1mdKeWVVXqu28OMfxlbDpi2IVgYuSGpglqsSCNscVfo94QjfaRySEUZNe7Ri7l+tYk48pl+b36 BJRt5q1Ku7UpSAczo1tYwZD7WVsIfaQS3WBWLdbAvt0bbJ+MoU5OMZyZvbdRyxooBU2aUdx6XrJz5G arJYxO2Ha4RrNVtqqBCd5hOd1IapjSGULV5GYy20jJWzV7oQJBb/znWaASUUSi6KNnjVY71WD0VrL+ H6Cj+ymwS1NS/izHZpLoK/IvZYYm79
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When extending file with a hole, we tried to preserve existing
preallocation for the file. However that is not very useful and
complicates code because the previous extent may need to be rounded to
block boundary as well (which we forgot to do thus causing data
corruption for sequence like:

xfs_io -f -c "pwrite 0x75e63 11008" -c "truncate 0x7b24b" \
  -c "truncate 0xabaa3" -c "pwrite 0xac70b 22954" \
  -c "pwrite 0x93a43 11358" -c "pwrite 0xb8e65 52211" file

with 512-byte block size. Just discard preallocation before extending
file to simplify things and also fix this data corruption.

CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/inode.c | 46 ++++++++++++++++++----------------------------
 1 file changed, 18 insertions(+), 28 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 6db2ef047f1c..d09ca6db14a0 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -349,6 +349,12 @@ static int udf_get_block(struct inode *inode, sector_t block,
 		iinfo->i_next_alloc_goal++;
 	}
 
+	/*
+	 * Block beyond EOF and prealloc extents? Just discard preallocation
+	 * as it is not useful and complicates things.
+	 */
+	if (((loff_t)block) << inode->i_blkbits > iinfo->i_lenExtents)
+		udf_discard_prealloc(inode);
 	udf_clear_extent_cache(inode);
 	phys = inode_getblk(inode, block, &err, &new);
 	if (!phys)
@@ -398,8 +404,6 @@ static int udf_do_extend_file(struct inode *inode,
 	uint32_t add;
 	int count = 0, fake = !(last_ext->extLength & UDF_EXTENT_LENGTH_MASK);
 	struct super_block *sb = inode->i_sb;
-	struct kernel_lb_addr prealloc_loc = {};
-	uint32_t prealloc_len = 0;
 	struct udf_inode_info *iinfo;
 	int err;
 
@@ -420,19 +424,6 @@ static int udf_do_extend_file(struct inode *inode,
 			~(sb->s_blocksize - 1);
 	}
 
-	/* Last extent are just preallocated blocks? */
-	if ((last_ext->extLength & UDF_EXTENT_FLAG_MASK) ==
-						EXT_NOT_RECORDED_ALLOCATED) {
-		/* Save the extent so that we can reattach it to the end */
-		prealloc_loc = last_ext->extLocation;
-		prealloc_len = last_ext->extLength;
-		/* Mark the extent as a hole */
-		last_ext->extLength = EXT_NOT_RECORDED_NOT_ALLOCATED |
-			(last_ext->extLength & UDF_EXTENT_LENGTH_MASK);
-		last_ext->extLocation.logicalBlockNum = 0;
-		last_ext->extLocation.partitionReferenceNum = 0;
-	}
-
 	/* Can we merge with the previous extent? */
 	if ((last_ext->extLength & UDF_EXTENT_FLAG_MASK) ==
 					EXT_NOT_RECORDED_NOT_ALLOCATED) {
@@ -460,7 +451,7 @@ static int udf_do_extend_file(struct inode *inode,
 		 * more extents, we may need to enter possible following
 		 * empty indirect extent.
 		 */
-		if (new_block_bytes || prealloc_len)
+		if (new_block_bytes)
 			udf_next_aext(inode, last_pos, &tmploc, &tmplen, 0);
 	}
 
@@ -494,17 +485,6 @@ static int udf_do_extend_file(struct inode *inode,
 	}
 
 out:
-	/* Do we have some preallocated blocks saved? */
-	if (prealloc_len) {
-		err = udf_add_aext(inode, last_pos, &prealloc_loc,
-				   prealloc_len, 1);
-		if (err)
-			return err;
-		last_ext->extLocation = prealloc_loc;
-		last_ext->extLength = prealloc_len;
-		count++;
-	}
-
 	/* last_pos should point to the last written extent... */
 	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
 		last_pos->offset -= sizeof(struct short_ad);
@@ -557,8 +537,17 @@ static int udf_extend_file(struct inode *inode, loff_t newsize)
 	else
 		BUG();
 
+	/*
+	 * When creating hole in file, just don't bother with preserving
+	 * preallocation. It likely won't be very useful anyway.
+	 */
+	udf_discard_prealloc(inode);
+
 	etype = inode_bmap(inode, first_block, &epos, &eloc, &elen, &offset);
 	within_final_block = (etype != -1);
+	/* We don't expect extents past EOF... */
+	WARN_ON_ONCE(etype != -1 &&
+		     elen > ((loff_t)offset + 1) << inode->i_blkbits);
 
 	if ((!epos.bh && epos.offset == udf_file_entry_alloc_offset(inode)) ||
 	    (epos.bh && epos.offset == sizeof(struct allocExtDesc))) {
@@ -687,10 +676,11 @@ static sector_t inode_getblk(struct inode *inode, sector_t block,
 		goto out_free;
 	}
 
-	/* Are we beyond EOF? */
+	/* Are we beyond EOF and preallocated extent? */
 	if (etype == -1) {
 		int ret;
 		loff_t hole_len;
+
 		isBeyondEOF = true;
 		if (count) {
 			if (c)
-- 
2.35.3

