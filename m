Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C513E52B751
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 12:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234267AbiERJdw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 05:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234258AbiERJds (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 05:33:48 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CFE18148A;
        Wed, 18 May 2022 02:33:47 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 0CA6921BC1;
        Wed, 18 May 2022 09:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1652866426; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/L0znopHwfmojijoGxp80PUysPc0KZjVhPWv9K9iKKc=;
        b=ya0p4a1TQpZSZLU8H5BSW72d9sRWQTAUmQf7yYhL6Wk3eRvWeusGCPB9imafd6FbXQbrID
        7RJZE03XSPxWrHs31gq0voSEiwTBRJmM09Nu4/RYQpfZxq/FPriNqpa1iU1uJ7sNKHM0IG
        aD36xCfbZ1UbWV8wbNxy3zNqLhjMlnk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1652866426;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/L0znopHwfmojijoGxp80PUysPc0KZjVhPWv9K9iKKc=;
        b=oXOhrp2nCkFS1GK89k8wKdHNEh2OEPNXnQZgHln3Fhdh8XLU25wVFaB1e/LgeHQ7dJn7D9
        cS3lv9n9AAwPDxBQ==
Received: from quack3.suse.cz (unknown [10.163.43.118])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 004BA2C3F9;
        Wed, 18 May 2022 09:33:45 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id BA32CA0631; Wed, 18 May 2022 11:33:45 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 2/2] ext4: Avoid cycles in directory h-tree
Date:   Wed, 18 May 2022 11:33:29 +0200
Message-Id: <20220518093332.13986-2-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220518093143.20955-1-jack@suse.cz>
References: <20220518093143.20955-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2401; h=from:subject; bh=dBH5chpRq4a7X82rh9vecUP2NZshXLFCLU0Z5g/1vY4=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBihL1oUkOiJou12zmhv4kTHJLDBVtz7H5e/gRK73iP NS1OjAOJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYoS9aAAKCRCcnaoHP2RA2YrnB/ 46AichLvfC87qDWYvusaQoVoK24F6eVZV4zU8AnmswDLjAR+y69nyVkvbnEhDrkeEvrMdaeSM5ebGR iPHrRxLXFXuCwD+VuRQi6TsUBSAmBVYGAPPEY5pFuLYBuXu9YmDdfObBQ/qWaSEu9hrSQy+pvzE/l6 C5F3v4VvoLmEMTQJN5SvwGWvmX9pMK8f2LSMkVaE/5IBylYF/UdE0lMEVyAlM7+LPZ2eVIm2X9YLHK Ve4Fmawd7QFJJoTjuwY0FR5VMo3+m50bbZJn11uU2k4bbcrdh72zqYEkgsNMz+M1NOt+XI5tMPDKz5 6cdEn8dDuxhBr4KjrfB63GA6REP8XE
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

A maliciously corrupted filesystem can contain cycles in the h-tree
stored inside a directory. That can easily lead to the kernel corrupting
tree nodes that were already verified under its hands while doing a node
split and consequently accessing unallocated memory. Fix the problem by
verifying traversed block numbers are unique.

CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/namei.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 2a55f23e4524..2ca99f1569c0 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -777,12 +777,14 @@ static struct dx_frame *
 dx_probe(struct ext4_filename *fname, struct inode *dir,
 	 struct dx_hash_info *hinfo, struct dx_frame *frame_in)
 {
-	unsigned count, indirect;
+	unsigned count, indirect, level, i;
 	struct dx_entry *at, *entries, *p, *q, *m;
 	struct dx_root *root;
 	struct dx_frame *frame = frame_in;
 	struct dx_frame *ret_err = ERR_PTR(ERR_BAD_DX_DIR);
 	u32 hash;
+	ext4_lblk_t block;
+	ext4_lblk_t blocks[EXT4_HTREE_LEVEL];
 
 	memset(frame_in, 0, EXT4_HTREE_LEVEL * sizeof(frame_in[0]));
 	frame->bh = ext4_read_dirblock(dir, 0, INDEX);
@@ -854,6 +856,8 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 	}
 
 	dxtrace(printk("Look up %x", hash));
+	level = 0;
+	blocks[0] = 0;
 	while (1) {
 		count = dx_get_count(entries);
 		if (!count || count > dx_get_limit(entries)) {
@@ -882,15 +886,27 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 			       dx_get_block(at)));
 		frame->entries = entries;
 		frame->at = at;
-		if (!indirect--)
+
+		block = dx_get_block(at);
+		for (i = 0; i <= level; i++) {
+			if (blocks[i] == block) {
+				ext4_warning_inode(dir,
+					"dx entry: tree cycle block %u points back to block %u",
+					blocks[level], block);
+				goto fail;
+			}
+		}
+		if (++level > indirect)
 			return frame;
+		blocks[level] = block;
 		frame++;
-		frame->bh = ext4_read_dirblock(dir, dx_get_block(at), INDEX);
+		frame->bh = ext4_read_dirblock(dir, block, INDEX);
 		if (IS_ERR(frame->bh)) {
 			ret_err = (struct dx_frame *) frame->bh;
 			frame->bh = NULL;
 			goto fail;
 		}
+
 		entries = ((struct dx_node *) frame->bh->b_data)->entries;
 
 		if (dx_get_limit(entries) != dx_node_limit(dir)) {
-- 
2.35.3

