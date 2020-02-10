Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07627157A1C
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729092AbgBJNUY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:20:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:59710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727911AbgBJMhk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:37:40 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48FA22051A;
        Mon, 10 Feb 2020 12:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338259;
        bh=/i6l/U5Vb1wmXbSl/H8EJrzujIaF09aGsl8Hfcv7yBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tXZ/9vpvoNtLBQobgmLOzQlieQiGYpu9OfaXMy5NSSimS/U9a0MmqDhzQzwqs6kOP
         aA5Hm5r4LpNAgzF4adiSCtyN3a7pLlITFYT6c35ryqA87ZCN+XIcvZriY1FqlUL28f
         u/wivJCQH/wo8IVoADifHsLn0hL6r9LcXVv/G5pU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Wheeler <dm-devel@lists.ewheeler.net>,
        Joe Thornber <ejt@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.4 128/309] dm space map common: fix to ensure new block isnt already in use
Date:   Mon, 10 Feb 2020 04:31:24 -0800
Message-Id: <20200210122418.694760922@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: stable@vger.kernel.org
Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/persistent-data/dm-space-map-common.c   |   27 +++++++++++++++++++++
 drivers/md/persistent-data/dm-space-map-common.h   |    2 +
 drivers/md/persistent-data/dm-space-map-disk.c     |    6 +++-
 drivers/md/persistent-data/dm-space-map-metadata.c |    5 +++
 4 files changed, 37 insertions(+), 3 deletions(-)

--- a/drivers/md/persistent-data/dm-space-map-common.c
+++ b/drivers/md/persistent-data/dm-space-map-common.c
@@ -380,6 +380,33 @@ int sm_ll_find_free_block(struct ll_disk
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
@@ -167,8 +167,10 @@ static int sm_disk_new_block(struct dm_s
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
@@ -448,7 +448,10 @@ static int sm_metadata_new_block_(struct
 	enum allocation_event ev;
 	struct sm_metadata *smm = container_of(sm, struct sm_metadata, sm);
 
-	r = sm_ll_find_free_block(&smm->old_ll, smm->begin, smm->old_ll.nr_blocks, b);
+	/*
+	 * Any block we allocate has to be free in both the old and current ll.
+	 */
+	r = sm_ll_find_common_free_block(&smm->old_ll, &smm->ll, smm->begin, smm->ll.nr_blocks, b);
 	if (r)
 		return r;
 


