Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E33E3540F06
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353124AbiFGS7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353234AbiFGS6l (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:58:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55C3F14CDCF;
        Tue,  7 Jun 2022 11:04:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 112FDB82349;
        Tue,  7 Jun 2022 18:04:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 775E7C385A5;
        Tue,  7 Jun 2022 18:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625049;
        bh=wVbbGLDEgiHbwO+8ceB4LaEgkGTDRdVe8SWyZV+ln8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pKM2GHnSh+7IQJGArrkd9ho01eHdNFOk+fnlgRhJpSxOTojHe22jUtM6I9vaRsOyo
         /oWvdhTE8A2+BhhtHEEctEAhSCymB3ZasA7UgcwPkL/R2SU8/KNPjESDkqqrf8Mn8C
         Bw28Q6XeUxSXza/oeqxvo9H3om/BBghMgjeVrqlU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 548/667] ext4: avoid cycles in directory h-tree
Date:   Tue,  7 Jun 2022 19:03:33 +0200
Message-Id: <20220607164951.136344500@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 3ba733f879c2a88910744647e41edeefbc0d92b2 upstream.

A maliciously corrupted filesystem can contain cycles in the h-tree
stored inside a directory. That can easily lead to the kernel corrupting
tree nodes that were already verified under its hands while doing a node
split and consequently accessing unallocated memory. Fix the problem by
verifying traversed block numbers are unique.

Cc: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220518093332.13986-2-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/namei.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

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
@@ -854,6 +856,8 @@ dx_probe(struct ext4_filename *fname, st
 	}
 
 	dxtrace(printk("Look up %x", hash));
+	level = 0;
+	blocks[0] = 0;
 	while (1) {
 		count = dx_get_count(entries);
 		if (!count || count > dx_get_limit(entries)) {
@@ -882,15 +886,27 @@ dx_probe(struct ext4_filename *fname, st
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


