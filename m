Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D76E1DB6A4
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 16:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbgETO0T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 10:26:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33004 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727007AbgETOW1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 10:22:27 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbw-00035x-7p; Wed, 20 May 2020 15:22:20 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbv-007DRc-FQ; Wed, 20 May 2020 15:22:19 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Joe Thornber" <ejt@redhat.com>,
        "Mike Snitzer" <snitzer@redhat.com>,
        "Eric Wheeler" <dm-devel@lists.ewheeler.net>
Date:   Wed, 20 May 2020 15:14:15 +0100
Message-ID: <lsq.1589984008.706059311@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 47/99] dm space map common: fix to ensure new block
 isn't already in use
In-Reply-To: <lsq.1589984008.673931885@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.84-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Thornber <ejt@redhat.com>

commit 4feaef830de7ffdd8352e1fe14ad3bf13c9688f8 upstream.

The space-maps track the reference counts for disk blocks allocated by
both the thin-provisioning and cache targets.  There are variants for
tracking metadata blocks and data blocks.

Transactionality is implemented by never touching blocks from the
previous transaction, so we can rollback in the event of a crash.

When allocating a new block we need to ensure the block is free (has
reference count of 0) in both the current and previous transaction.
Prior to this fix we were doing this by searching for a free block in
the previous transaction, and relying on a 'begin' counter to track
where the last allocation in the current transaction was.  This
'begin' field was not being updated in all code paths (eg, increment
of a data block reference count due to breaking sharing of a neighbour
block in the same btree leaf).

This fix keeps the 'begin' field, but now it's just a hint to speed up
the search.  Instead the current transaction is searched for a free
block, and then the old transaction is double checked to ensure it's
free.  Much simpler.

This fixes reports of sm_disk_new_block()'s BUG_ON() triggering when
DM thin-provisioning's snapshots are heavily used.

Reported-by: Eric Wheeler <dm-devel@lists.ewheeler.net>
Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 .../md/persistent-data/dm-space-map-common.c  | 27 +++++++++++++++++++
 .../md/persistent-data/dm-space-map-common.h  |  2 ++
 .../md/persistent-data/dm-space-map-disk.c    |  6 +++--
 .../persistent-data/dm-space-map-metadata.c   |  5 +++-
 4 files changed, 37 insertions(+), 3 deletions(-)

--- a/drivers/md/persistent-data/dm-space-map-common.c
+++ b/drivers/md/persistent-data/dm-space-map-common.c
@@ -384,6 +384,33 @@ int sm_ll_find_free_block(struct ll_disk
 	return -ENOSPC;
 }
 
+int sm_ll_find_common_free_block(struct ll_disk *old_ll, struct ll_disk *new_ll,
+	                         dm_block_t begin, dm_block_t end, dm_block_t *b)
+{
+	int r;
+	uint32_t count;
+
+	do {
+		r = sm_ll_find_free_block(new_ll, begin, new_ll->nr_blocks, b);
+		if (r)
+			break;
+
+		/* double check this block wasn't used in the old transaction */
+		if (*b >= old_ll->nr_blocks)
+			count = 0;
+		else {
+			r = sm_ll_lookup(old_ll, *b, &count);
+			if (r)
+				break;
+
+			if (count)
+				begin = *b + 1;
+		}
+	} while (count);
+
+	return r;
+}
+
 static int sm_ll_mutate(struct ll_disk *ll, dm_block_t b,
 			int (*mutator)(void *context, uint32_t old, uint32_t *new),
 			void *context, enum allocation_event *ev)
--- a/drivers/md/persistent-data/dm-space-map-common.h
+++ b/drivers/md/persistent-data/dm-space-map-common.h
@@ -109,6 +109,8 @@ int sm_ll_lookup_bitmap(struct ll_disk *
 int sm_ll_lookup(struct ll_disk *ll, dm_block_t b, uint32_t *result);
 int sm_ll_find_free_block(struct ll_disk *ll, dm_block_t begin,
 			  dm_block_t end, dm_block_t *result);
+int sm_ll_find_common_free_block(struct ll_disk *old_ll, struct ll_disk *new_ll,
+	                         dm_block_t begin, dm_block_t end, dm_block_t *result);
 int sm_ll_insert(struct ll_disk *ll, dm_block_t b, uint32_t ref_count, enum allocation_event *ev);
 int sm_ll_inc(struct ll_disk *ll, dm_block_t b, enum allocation_event *ev);
 int sm_ll_dec(struct ll_disk *ll, dm_block_t b, enum allocation_event *ev);
--- a/drivers/md/persistent-data/dm-space-map-disk.c
+++ b/drivers/md/persistent-data/dm-space-map-disk.c
@@ -165,8 +165,10 @@ static int sm_disk_new_block(struct dm_s
 	enum allocation_event ev;
 	struct sm_disk *smd = container_of(sm, struct sm_disk, sm);
 
-	/* FIXME: we should loop round a couple of times */
-	r = sm_ll_find_free_block(&smd->old_ll, smd->begin, smd->old_ll.nr_blocks, b);
+	/*
+	 * Any block we allocate has to be free in both the old and current ll.
+	 */
+	r = sm_ll_find_common_free_block(&smd->old_ll, &smd->ll, smd->begin, smd->ll.nr_blocks, b);
 	if (r)
 		return r;
 
--- a/drivers/md/persistent-data/dm-space-map-metadata.c
+++ b/drivers/md/persistent-data/dm-space-map-metadata.c
@@ -447,7 +447,10 @@ static int sm_metadata_new_block_(struct
 	enum allocation_event ev;
 	struct sm_metadata *smm = container_of(sm, struct sm_metadata, sm);
 
-	r = sm_ll_find_free_block(&smm->old_ll, smm->begin, smm->old_ll.nr_blocks, b);
+	/*
+	 * Any block we allocate has to be free in both the old and current ll.
+	 */
+	r = sm_ll_find_common_free_block(&smm->old_ll, &smm->ll, smm->begin, smm->ll.nr_blocks, b);
 	if (r)
 		return r;
 

