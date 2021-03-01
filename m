Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 610033285F5
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236742AbhCARBx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:01:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:53996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234732AbhCAQzU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:55:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABF9664FCF;
        Mon,  1 Mar 2021 16:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616522;
        bh=r41VT8VW3u+zA5it1s/10s5a1IlobnY55dX6CLh4pZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dwe8xAVurwzgXnlEtOfbdxdEMUIGskj+lLjXROjEpb6TuUT7yfFzYXxT065Ub41cf
         ZXkYIru5llq9U3wo8T1LTkcSQ8LUfsb2jaQANyfO9BTDFCQ6cICopCsPYJNJ6x/RnS
         L8TpfvCtFct6f9vWXB+BL7WLI9QnsVcoJrb4/4Xc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikos Tsironis <ntsironis@arrikto.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.14 164/176] dm era: Recover committed writeset after crash
Date:   Mon,  1 Mar 2021 17:13:57 +0100
Message-Id: <20210301161029.177627653@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
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
@@ -578,6 +578,7 @@ static int open_metadata(struct era_meta
 	md->nr_blocks = le32_to_cpu(disk->nr_blocks);
 	md->current_era = le32_to_cpu(disk->current_era);
 
+	ws_unpack(&disk->current_writeset, &md->current_writeset->md);
 	md->writeset_tree_root = le64_to_cpu(disk->writeset_tree_root);
 	md->era_array_root = le64_to_cpu(disk->era_array_root);
 	md->metadata_snap = le64_to_cpu(disk->metadata_snap);
@@ -869,7 +870,6 @@ static int metadata_era_archive(struct e
 	}
 
 	ws_pack(&md->current_writeset->md, &value);
-	md->current_writeset->md.root = INVALID_WRITESET_ROOT;
 
 	keys[0] = md->current_era;
 	__dm_bless_for_disk(&value);
@@ -881,6 +881,7 @@ static int metadata_era_archive(struct e
 		return r;
 	}
 
+	md->current_writeset->md.root = INVALID_WRITESET_ROOT;
 	md->archived_writesets = true;
 
 	return 0;
@@ -897,7 +898,7 @@ static int metadata_new_era(struct era_m
 	int r;
 	struct writeset *new_writeset = next_writeset(md);
 
-	r = writeset_init(&md->bitset_info, new_writeset);
+	r = writeset_init(&md->bitset_info, new_writeset, md->nr_blocks);
 	if (r) {
 		DMERR("%s: writeset_init failed", __func__);
 		return r;
@@ -950,7 +951,7 @@ static int metadata_commit(struct era_me
 	int r;
 	struct dm_block *sblock;
 
-	if (md->current_writeset->md.root != SUPERBLOCK_LOCATION) {
+	if (md->current_writeset->md.root != INVALID_WRITESET_ROOT) {
 		r = dm_bitset_flush(&md->bitset_info, md->current_writeset->md.root,
 				    &md->current_writeset->md.root);
 		if (r) {
@@ -1580,7 +1581,7 @@ static int era_preresume(struct dm_targe
 
 	start_worker(era);
 
-	r = in_worker0(era, metadata_new_era);
+	r = in_worker0(era, metadata_era_rollover);
 	if (r) {
 		DMERR("%s: metadata_era_rollover failed", __func__);
 		return r;


