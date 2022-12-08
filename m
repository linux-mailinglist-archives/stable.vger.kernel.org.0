Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5293E64709C
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 14:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbiLHNQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 08:16:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbiLHNQB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 08:16:01 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C977992A3B;
        Thu,  8 Dec 2022 05:16:00 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 4F2CC208C8;
        Thu,  8 Dec 2022 13:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1670505359; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3LMNHaFogcKAiq3PV7qT2chrlGfUwbcE2YSyFrK3yQA=;
        b=bY1VEDghte1H1uQAr45NWvGB44/YXT79dXIBZ1HbAGEfqHgmjBQKB+n0ucPp/C9hyEoGcM
        wMOit7cXlJg8TjMmbXbPrOrVdmcWKWcpKHDnFmSURPiMIg7hGb2JVLPWUuZ7I0cQEpXn83
        dfqv3IT8Z2f/GFLxL2BuZKji509ksAA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1670505359;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3LMNHaFogcKAiq3PV7qT2chrlGfUwbcE2YSyFrK3yQA=;
        b=wY56DyIanqXBRI12P2gwcCx0s3cjMJDDtX49QSF2MB7nKco5EAA2Z65XeRQw/68vn5sjaH
        NRfmfJFhp7AVFvDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 428A6138E1;
        Thu,  8 Dec 2022 13:15:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id D2Q6EI/jkWNSTQAAMHmgww
        (envelope-from <jack@suse.cz>); Thu, 08 Dec 2022 13:15:59 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id B9C25A0723; Thu,  8 Dec 2022 14:15:58 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     <linux-fsdevel@vger.kernel.org>
Cc:     Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Subject: [PATCH 1/4] udf: Fix preallocation discarding at indirect extent boundary
Date:   Thu,  8 Dec 2022 14:15:48 +0100
Message-Id: <20221208131558.27298-1-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20221208131111.29134-1-jack@suse.cz>
References: <20221208131111.29134-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2941; i=jack@suse.cz; h=from:subject; bh=C9GMRZKW48EwB2J6ZdnueBYWIFNB9lXLbG85zpb9yiI=; b=owGbwMvMwME4Z+4qdvsUh5uMp9WSGJInPm6OXOi1eWnu/AP2Qe/Uvsgqz2SJdHJRCl3LZaH2QaTn 0oPDnYzGLAyMHAyyYoosqyMval+bZ9S1NVRDBmYQKxPIFAYuTgGYyIWrHAwHfpVNTNn5jUP2RPaJLe UvC5nuZFTt+/Ihdh/TKcuNbje928rd+aOtHTOO7ejMPhsYxByc7naTtWPSpvMOl2brdssIVmz+dq/r Q8D6vMW5VUcmLF0RKn9F0vp5wS8PoYMtm/+o+F2Il5PqZVq5kpMnQDhcNL2czzRObOJXu57tjV+U/R 8lnD6w5rWJMzP3m3X7CpRX/WiU7d2f6X3ZVUy9MbunQylKJY2zOnvepjm2Pdy60+tlfFec987RmVKc dne/wlEe5didITNEmQ78M+MzKrSd4n/ux9lFAVGTG5id2C1Dnv22XeqWOP0AV290QLV5ilSeUf9nw5 ZrjlvZvb167HYn1LSnuPpOWpwBAA==
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When preallocation extent is the first one in the extent block, the
code would corrupt extent tree header instead. Fix the problem and use
udf_delete_aext() for deleting extent to avoid some code duplication.

CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/truncate.c | 45 +++++++++++++--------------------------------
 1 file changed, 13 insertions(+), 32 deletions(-)

diff --git a/fs/udf/truncate.c b/fs/udf/truncate.c
index 532cda99644e..a9790fb32f5f 100644
--- a/fs/udf/truncate.c
+++ b/fs/udf/truncate.c
@@ -120,60 +120,41 @@ void udf_truncate_tail_extent(struct inode *inode)
 
 void udf_discard_prealloc(struct inode *inode)
 {
-	struct extent_position epos = { NULL, 0, {0, 0} };
+	struct extent_position epos = {};
+	struct extent_position prev_epos = {};
 	struct kernel_lb_addr eloc;
 	uint32_t elen;
 	uint64_t lbcount = 0;
 	int8_t etype = -1, netype;
-	int adsize;
 	struct udf_inode_info *iinfo = UDF_I(inode);
 
 	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB ||
 	    inode->i_size == iinfo->i_lenExtents)
 		return;
 
-	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
-		adsize = sizeof(struct short_ad);
-	else if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_LONG)
-		adsize = sizeof(struct long_ad);
-	else
-		adsize = 0;
-
 	epos.block = iinfo->i_location;
 
 	/* Find the last extent in the file */
-	while ((netype = udf_next_aext(inode, &epos, &eloc, &elen, 1)) != -1) {
-		etype = netype;
+	while ((netype = udf_next_aext(inode, &epos, &eloc, &elen, 0)) != -1) {
+		brelse(prev_epos.bh);
+		prev_epos = epos;
+		if (prev_epos.bh)
+			get_bh(prev_epos.bh);
+
+		etype = udf_next_aext(inode, &epos, &eloc, &elen, 1);
 		lbcount += elen;
 	}
 	if (etype == (EXT_NOT_RECORDED_ALLOCATED >> 30)) {
-		epos.offset -= adsize;
 		lbcount -= elen;
-		extent_trunc(inode, &epos, &eloc, etype, elen, 0);
-		if (!epos.bh) {
-			iinfo->i_lenAlloc =
-				epos.offset -
-				udf_file_entry_alloc_offset(inode);
-			mark_inode_dirty(inode);
-		} else {
-			struct allocExtDesc *aed =
-				(struct allocExtDesc *)(epos.bh->b_data);
-			aed->lengthAllocDescs =
-				cpu_to_le32(epos.offset -
-					    sizeof(struct allocExtDesc));
-			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) ||
-			    UDF_SB(inode->i_sb)->s_udfrev >= 0x0201)
-				udf_update_tag(epos.bh->b_data, epos.offset);
-			else
-				udf_update_tag(epos.bh->b_data,
-					       sizeof(struct allocExtDesc));
-			mark_buffer_dirty_inode(epos.bh, inode);
-		}
+		udf_delete_aext(inode, prev_epos);
+		udf_free_blocks(inode->i_sb, inode, &eloc, 0,
+				DIV_ROUND_UP(elen, 1 << inode->i_blkbits));
 	}
 	/* This inode entry is in-memory only and thus we don't have to mark
 	 * the inode dirty */
 	iinfo->i_lenExtents = lbcount;
 	brelse(epos.bh);
+	brelse(prev_epos.bh);
 }
 
 static void udf_update_alloc_ext_desc(struct inode *inode,
-- 
2.35.3

