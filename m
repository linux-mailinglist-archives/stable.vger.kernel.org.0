Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF0E548F97
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237632AbiFMKtv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348199AbiFMKtM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:49:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B51F2DD4D;
        Mon, 13 Jun 2022 03:26:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3BD660AEB;
        Mon, 13 Jun 2022 10:26:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97F6C34114;
        Mon, 13 Jun 2022 10:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116009;
        bh=4SgZ93K4izLIRG+/5o4JaxKKXjWiS68cLfgaBrU9xEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cM8fzjNeg27GD+9SPZHKHMKoQRQ+quKIbaw9jJHOOxhkrbUGkYfZExV0askdhCoax
         GY9pG5JdRfz9PjiYLwJNGugPS5eay9aoL/WeCCutd6F3EGuZoeH51lRBBcYaS1sMol
         pemFcAO2y9BG4owKejz8RVrnbIAZht0BXtFk1HNs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.14 107/218] ext4: verify dir block before splitting it
Date:   Mon, 13 Jun 2022 12:09:25 +0200
Message-Id: <20220613094923.804849291@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094908.257446132@linuxfoundation.org>
References: <20220613094908.257446132@linuxfoundation.org>
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

commit 46c116b920ebec58031f0a78c5ea9599b0d2a371 upstream.

Before splitting a directory block verify its directory entries are sane
so that the splitting code does not access memory it should not.

Cc: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220518093332.13986-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/namei.c |   32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -271,9 +271,9 @@ static struct dx_frame *dx_probe(struct
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
 static struct ext4_dir_entry_2 *dx_move_dirents(char *from, char *to,
 		struct dx_map_entry *offsets, int count, unsigned blocksize);
@@ -1202,15 +1202,23 @@ static inline int search_dirblock(struct
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
 			ext4fs_dirhash(de->name, de->name_len, &h);
 			map_tail--;
@@ -1220,8 +1228,7 @@ static int dx_make_map(struct inode *dir
 			count++;
 			cond_resched();
 		}
-		/* XXX: do we need to check rec_len == 0 case? -Chris */
-		de = ext4_next_entry(de, blocksize);
+		de = ext4_next_entry(de, dir->i_sb->s_blocksize);
 	}
 	return count;
 }
@@ -1737,8 +1744,11 @@ static struct ext4_dir_entry_2 *do_split
 
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


