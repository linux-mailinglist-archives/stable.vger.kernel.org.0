Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00FB952B6D8
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 12:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234258AbiERJdx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 05:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234304AbiERJds (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 05:33:48 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4018680233;
        Wed, 18 May 2022 02:33:47 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 025E121BB7;
        Wed, 18 May 2022 09:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1652866426; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3V/Fw0XIDP2Rv6CbzJuJNleSyzeKVKTInpxmMcFySbw=;
        b=I+/YokzR7/f08oQFi+SZDbr0YJIolpRkVnvgu+3c8tGDRRFcxWVGm0t6Y25jDaG2eqgMxt
        gpBFa1qY5aKPH9XBhqhppT26azIPh0ElosPs95D2zbxFPNCrwf5Z/T7324XTm7GuQTct3k
        8nerwanti+lxv5705VXWO7v7B2S0sjE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1652866426;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3V/Fw0XIDP2Rv6CbzJuJNleSyzeKVKTInpxmMcFySbw=;
        b=gs/BDlWBAUeDbCYFTkcVOk9/doaU3VXytM2i/VjJ8nEpRSZ9EvLwh46wbPkPQ9j4ICrO5g
        obbhEDT8Epl1sZCA==
Received: from quack3.suse.cz (unknown [10.163.43.118])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id E94D82C3F8;
        Wed, 18 May 2022 09:33:45 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id B3608A062F; Wed, 18 May 2022 11:33:45 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] ext4: Verify dir block before splitting it
Date:   Wed, 18 May 2022 11:33:28 +0200
Message-Id: <20220518093332.13986-1-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220518093143.20955-1-jack@suse.cz>
References: <20220518093143.20955-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3146; h=from:subject; bh=3ndvlAC5Jc7/SNT5XRRUEXEdsoXQ35rlHPNtW9BTj9Q=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBihL1nAwjOpiXqd0daEn9juHSHrlMSvdNr0VWXrzFA 60qdcJKJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYoS9ZwAKCRCcnaoHP2RA2eg4CA CWvYCNLY3hz8r8EG+CksEcn1AYoFJjuywG5xBTlaJIZWTZjjcKfFoyBs3kAcXAxABAnKF+oR9BRGkb hvrfA0nNm6aCSPuzDMJ3exqD0uROIAtDC53Advfd4vT/tAPOlnZvq52MrE2FQ61o54ucVksqjwniCs 7UzBNFAusp1bSBA90ayD3LNXunf4AkeH+oPjISXR+ovJXYMsbX4wz2eslqzkcPWRbJDHVmZcwqeVM2 +cJPHsykU0ETN3VlKMWtuOS1ZcM+/rQ3agHnCuwBP7LCRlPPovULCG83ArB6aabLG6TkRn1+rlVQ7B P5xx4HiLGNetZz9yqy5y34I4Jr17T4
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Before splitting a directory block verify its directory entries are sane
so that the splitting code does not access memory it should not.

CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/namei.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 767b4bfe39c3..2a55f23e4524 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -277,9 +277,9 @@ static struct dx_frame *dx_probe(struct ext4_filename *fname,
 				 struct dx_hash_info *hinfo,
 				 struct dx_frame *frame);
 static void dx_release(struct dx_frame *frames);
-static int dx_make_map(struct inode *dir, struct ext4_dir_entry_2 *de,
-		       unsigned blocksize, struct dx_hash_info *hinfo,
-		       struct dx_map_entry map[]);
+static int dx_make_map(struct inode *dir, struct buffer_head *bh,
+		       struct dx_hash_info *hinfo,
+		       struct dx_map_entry *map_tail);
 static void dx_sort_map(struct dx_map_entry *map, unsigned count);
 static struct ext4_dir_entry_2 *dx_move_dirents(struct inode *dir, char *from,
 					char *to, struct dx_map_entry *offsets,
@@ -1249,15 +1249,23 @@ static inline int search_dirblock(struct buffer_head *bh,
  * Create map of hash values, offsets, and sizes, stored at end of block.
  * Returns number of entries mapped.
  */
-static int dx_make_map(struct inode *dir, struct ext4_dir_entry_2 *de,
-		       unsigned blocksize, struct dx_hash_info *hinfo,
+static int dx_make_map(struct inode *dir, struct buffer_head *bh,
+		       struct dx_hash_info *hinfo,
 		       struct dx_map_entry *map_tail)
 {
 	int count = 0;
-	char *base = (char *) de;
+	struct ext4_dir_entry_2 *de = (struct ext4_dir_entry_2 *)bh->b_data;
+	unsigned int buflen = bh->b_size;
+	char *base = bh->b_data;
 	struct dx_hash_info h = *hinfo;
 
-	while ((char *) de < base + blocksize) {
+	if (ext4_has_metadata_csum(dir->i_sb))
+		buflen -= sizeof(struct ext4_dir_entry_tail);
+
+	while ((char *) de < base + buflen) {
+		if (ext4_check_dir_entry(dir, NULL, de, bh, base, buflen,
+					 ((char *)de) - base))
+			return -EFSCORRUPTED;
 		if (de->name_len && de->inode) {
 			if (ext4_hash_in_dirent(dir))
 				h.hash = EXT4_DIRENT_HASH(de);
@@ -1270,8 +1278,7 @@ static int dx_make_map(struct inode *dir, struct ext4_dir_entry_2 *de,
 			count++;
 			cond_resched();
 		}
-		/* XXX: do we need to check rec_len == 0 case? -Chris */
-		de = ext4_next_entry(de, blocksize);
+		de = ext4_next_entry(de, dir->i_sb->s_blocksize);
 	}
 	return count;
 }
@@ -1943,8 +1950,11 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 
 	/* create map in the end of data2 block */
 	map = (struct dx_map_entry *) (data2 + blocksize);
-	count = dx_make_map(dir, (struct ext4_dir_entry_2 *) data1,
-			     blocksize, hinfo, map);
+	count = dx_make_map(dir, *bh, hinfo, map);
+	if (count < 0) {
+		err = count;
+		goto journal_error;
+	}
 	map -= count;
 	dx_sort_map(map, count);
 	/* Ensure that neither split block is over half full */
-- 
2.35.3

