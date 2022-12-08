Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5054464709F
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 14:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbiLHNQF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 08:16:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbiLHNQC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 08:16:02 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C98D592FE2;
        Thu,  8 Dec 2022 05:16:00 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 6007C20904;
        Thu,  8 Dec 2022 13:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1670505359; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iPFMHOnurXJKsZDknaM1534eKF2Z3PShZjb8nsALLlE=;
        b=wxfRE0N/hEpV6HWaO8g7QmhroGa+SECZjcYFm/KHZoTnb6jRp3odfPmRb5LptdTqkvB3yU
        2Ku9jWSfqnnmBs3wbcx5gI93B28R7IUAc9QW/r/43FN1QSgv/T3/Szsm+vcnk4+bLp8T0a
        KOwmas3Wk2Q9eWw+vzVLIRD6h1gTIm8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1670505359;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iPFMHOnurXJKsZDknaM1534eKF2Z3PShZjb8nsALLlE=;
        b=QRuYkg+JpvF4rRjcJEgHRA5HKeLkBm1xaWwXEMNP0kD+2regTLR0gpxwZk/6lFymrFrEIY
        HUWaoxv9gnwMMtBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5317F138E1;
        Thu,  8 Dec 2022 13:15:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id fzFEFI/jkWNdTQAAMHmgww
        (envelope-from <jack@suse.cz>); Thu, 08 Dec 2022 13:15:59 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id CBE03A072B; Thu,  8 Dec 2022 14:15:58 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     <linux-fsdevel@vger.kernel.org>
Cc:     Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Subject: [PATCH 4/4] udf: Fix extending file within last block
Date:   Thu,  8 Dec 2022 14:15:51 +0100
Message-Id: <20221208131558.27298-4-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20221208131111.29134-1-jack@suse.cz>
References: <20221208131111.29134-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3464; i=jack@suse.cz; h=from:subject; bh=AU/lHCrgIprNH5pPhEr/sAK5FDWApMHlmRpcV7/DMQI=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBjkeOGWVCHlJTO4D2yEnxlCjopqEclk7RUAt4GTQtn 6wO6b4CJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCY5HjhgAKCRCcnaoHP2RA2ZqyB/ 0eMAPLpWGFVbVWp8I4izW3eLdPwZdNuOhBJkIBHBpDZKOM+BrGpKl1BdVQ9tt7eeiNA0dOtzSvWuwr p8CPWmX/q4J6d+WlhFZfINN71guSMW6vlDoeS6gQ98HeT2AQWBkieUwkJZpK1fAKkO9tehYhcgyJ5l 4lQ7Ehk0xAjtHl2SN8LfFc+91kChDFuED9jh5wRsUcaB9Rqkoah2+WtBKZW21xRR4XxpNEnd5pZQ+E a/GMFj9BLMczHt1Y49gv4p4UJ6XYqMJEn+tkW4jY1JngOShdHDCIT721/4yMMmyniGM8NUvXgHLz4a 7kb//3uKvHyBbS5t6yD+D0p/5w31uA
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

When extending file within last block it can happen that the extent is
already rounded to the blocksize and thus contains the offset we want to
grow up to. In such case we would mistakenly expand the last extent and
make it one block longer than it should be, exposing unallocated block
in a file and causing data corruption. Fix the problem by properly
detecting this case and bailing out.

CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/inode.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index d09ca6db14a0..1e5d37f6c689 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -500,13 +500,17 @@ static int udf_do_extend_file(struct inode *inode,
 static void udf_do_extend_final_block(struct inode *inode,
 				      struct extent_position *last_pos,
 				      struct kernel_long_ad *last_ext,
-				      uint32_t final_block_len)
+				      uint32_t new_elen)
 {
-	struct super_block *sb = inode->i_sb;
 	uint32_t added_bytes;
 
-	added_bytes = final_block_len -
-		      (last_ext->extLength & (sb->s_blocksize - 1));
+	/*
+	 * Extent already large enough? It may be already rounded up to block
+	 * size...
+	 */
+	if (new_elen <= (last_ext->extLength & UDF_EXTENT_LENGTH_MASK))
+		return;
+	added_bytes = (last_ext->extLength & UDF_EXTENT_LENGTH_MASK) - new_elen;
 	last_ext->extLength += added_bytes;
 	UDF_I(inode)->i_lenExtents += added_bytes;
 
@@ -523,12 +527,12 @@ static int udf_extend_file(struct inode *inode, loff_t newsize)
 	int8_t etype;
 	struct super_block *sb = inode->i_sb;
 	sector_t first_block = newsize >> sb->s_blocksize_bits, offset;
-	unsigned long partial_final_block;
+	loff_t new_elen;
 	int adsize;
 	struct udf_inode_info *iinfo = UDF_I(inode);
 	struct kernel_long_ad extent;
 	int err = 0;
-	int within_final_block;
+	bool within_last_ext;
 
 	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
 		adsize = sizeof(struct short_ad);
@@ -544,9 +548,9 @@ static int udf_extend_file(struct inode *inode, loff_t newsize)
 	udf_discard_prealloc(inode);
 
 	etype = inode_bmap(inode, first_block, &epos, &eloc, &elen, &offset);
-	within_final_block = (etype != -1);
+	within_last_ext = (etype != -1);
 	/* We don't expect extents past EOF... */
-	WARN_ON_ONCE(etype != -1 &&
+	WARN_ON_ONCE(within_last_ext &&
 		     elen > ((loff_t)offset + 1) << inode->i_blkbits);
 
 	if ((!epos.bh && epos.offset == udf_file_entry_alloc_offset(inode)) ||
@@ -563,19 +567,17 @@ static int udf_extend_file(struct inode *inode, loff_t newsize)
 		extent.extLength |= etype << 30;
 	}
 
-	partial_final_block = newsize & (sb->s_blocksize - 1);
+	new_elen = ((loff_t)offset << inode->i_blkbits) |
+					(newsize & (sb->s_blocksize - 1));
 
 	/* File has extent covering the new size (could happen when extending
 	 * inside a block)?
 	 */
-	if (within_final_block) {
+	if (within_last_ext) {
 		/* Extending file within the last file block */
-		udf_do_extend_final_block(inode, &epos, &extent,
-					  partial_final_block);
+		udf_do_extend_final_block(inode, &epos, &extent, new_elen);
 	} else {
-		loff_t add = ((loff_t)offset << sb->s_blocksize_bits) |
-			     partial_final_block;
-		err = udf_do_extend_file(inode, &epos, &extent, add);
+		err = udf_do_extend_file(inode, &epos, &extent, new_elen);
 	}
 
 	if (err < 0)
-- 
2.35.3

