Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F292E3284B5
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234670AbhCAQlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:41:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:36940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234167AbhCAQe1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:34:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61B3964F6C;
        Mon,  1 Mar 2021 16:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615959;
        bh=+FxhaaNU7d+1OrETs7FgQAmetnmdCIFE3BfEseO/Zjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ai5CxzbzeSiIsFr4GRRYvCMIdnBr82wQUPLwhzjuKtmdp6ltDIZarr6TiCAuohTOp
         KXBLsINi+C04wGWx2iGRdjKnU0MJatoBC1szhmT1eggIZKeTB+ryf/8fpecYUCf1xb
         vBIL/QtH6fciiKoeojTmFsELfomOVZ5e10/pelkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikos Tsironis <ntsironis@arrikto.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.9 120/134] dm era: Recover committed writeset after crash
Date:   Mon,  1 Mar 2021 17:13:41 +0100
Message-Id: <20210301161019.489613810@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
References: <20210301161013.585393984@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikos Tsironis <ntsironis@arrikto.com>

commit de89afc1e40fdfa5f8b666e5d07c43d21a1d3be0 upstream.

Following a system crash, dm-era fails to recover the committed writeset
for the current era, leading to lost writes. That is, we lose the
information about what blocks were written during the affected era.

dm-era assumes that the writeset of the current era is archived when the
device is suspended. So, when resuming the device, it just moves on to
the next era, ignoring the committed writeset.

This assumption holds when the device is properly shut down. But, when
the system crashes, the code that suspends the target never runs, so the
writeset for the current era is not archived.

There are three issues that cause the committed writeset to get lost:

1. dm-era doesn't load the committed writeset when opening the metadata
2. The code that resizes the metadata wipes the information about the
   committed writeset (assuming it was loaded at step 1)
3. era_preresume() starts a new era, without taking into account that
   the current era might not have been archived, due to a system crash.

To fix this:

1. Load the committed writeset when opening the metadata
2. Fix the code that resizes the metadata to make sure it doesn't wipe
   the loaded writeset
3. Fix era_preresume() to check for a loaded writeset and archive it,
   before starting a new era.

Fixes: eec40579d84873 ("dm: add era target")
Cc: stable@vger.kernel.org # v3.15+
Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-era-target.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -70,8 +70,6 @@ static size_t bitset_size(unsigned nr_bi
  */
 static int writeset_alloc(struct writeset *ws, dm_block_t nr_blocks)
 {
-	ws->md.nr_bits = nr_blocks;
-	ws->md.root = INVALID_WRITESET_ROOT;
 	ws->bits = vzalloc(bitset_size(nr_blocks));
 	if (!ws->bits) {
 		DMERR("%s: couldn't allocate in memory bitset", __func__);
@@ -84,12 +82,14 @@ static int writeset_alloc(struct writese
 /*
  * Wipes the in-core bitset, and creates a new on disk bitset.
  */
-static int writeset_init(struct dm_disk_bitset *info, struct writeset *ws)
+static int writeset_init(struct dm_disk_bitset *info, struct writeset *ws,
+			 dm_block_t nr_blocks)
 {
 	int r;
 
-	memset(ws->bits, 0, bitset_size(ws->md.nr_bits));
+	memset(ws->bits, 0, bitset_size(nr_blocks));
 
+	ws->md.nr_bits = nr_blocks;
 	r = setup_on_disk_bitset(info, ws->md.nr_bits, &ws->md.root);
 	if (r) {
 		DMERR("%s: setup_on_disk_bitset failed", __func__);
@@ -579,6 +579,7 @@ static int open_metadata(struct era_meta
 	md->nr_blocks = le32_to_cpu(disk->nr_blocks);
 	md->current_era = le32_to_cpu(disk->current_era);
 
+	ws_unpack(&disk->current_writeset, &md->current_writeset->md);
 	md->writeset_tree_root = le64_to_cpu(disk->writeset_tree_root);
 	md->era_array_root = le64_to_cpu(disk->era_array_root);
 	md->metadata_snap = le64_to_cpu(disk->metadata_snap);
@@ -871,7 +872,6 @@ static int metadata_era_archive(struct e
 	}
 
 	ws_pack(&md->current_writeset->md, &value);
-	md->current_writeset->md.root = INVALID_WRITESET_ROOT;
 
 	keys[0] = md->current_era;
 	__dm_bless_for_disk(&value);
@@ -883,6 +883,7 @@ static int metadata_era_archive(struct e
 		return r;
 	}
 
+	md->current_writeset->md.root = INVALID_WRITESET_ROOT;
 	md->archived_writesets = true;
 
 	return 0;
@@ -899,7 +900,7 @@ static int metadata_new_era(struct era_m
 	int r;
 	struct writeset *new_writeset = next_writeset(md);
 
-	r = writeset_init(&md->bitset_info, new_writeset);
+	r = writeset_init(&md->bitset_info, new_writeset, md->nr_blocks);
 	if (r) {
 		DMERR("%s: writeset_init failed", __func__);
 		return r;
@@ -952,7 +953,7 @@ static int metadata_commit(struct era_me
 	int r;
 	struct dm_block *sblock;
 
-	if (md->current_writeset->md.root != SUPERBLOCK_LOCATION) {
+	if (md->current_writeset->md.root != INVALID_WRITESET_ROOT) {
 		r = dm_bitset_flush(&md->bitset_info, md->current_writeset->md.root,
 				    &md->current_writeset->md.root);
 		if (r) {
@@ -1582,7 +1583,7 @@ static int era_preresume(struct dm_targe
 
 	start_worker(era);
 
-	r = in_worker0(era, metadata_new_era);
+	r = in_worker0(era, metadata_era_rollover);
 	if (r) {
 		DMERR("%s: metadata_era_rollover failed", __func__);
 		return r;


