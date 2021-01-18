Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5998E2FA9E5
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 20:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437134AbhARTQH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 14:16:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:34046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390462AbhARLi0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:38:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEDAF22573;
        Mon, 18 Jan 2021 11:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969866;
        bh=w/z7BlrgUBh21OrJ8cF5EMc2bPJT3ChthwQzP6FhDdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RY4oSCFt/y59GvBdIt5jNqUrTZafFgNlZZrcoXRnD/nuRO1eUcqGQE9Ynj/yy1OAj
         jCO81U7B0UPLAgnTRALupOJYo9oEjtNlU+GJo1IwJ38h4oHXoP30GHBoq3l9Lfjypu
         qNPqxpu5F1AKbeM+0YcA/tZvETEtfZd8gYEL9C6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Akilesh Kailash <akailash@google.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.4 15/76] dm snapshot: flush merged data before committing metadata
Date:   Mon, 18 Jan 2021 12:34:15 +0100
Message-Id: <20210118113341.719915534@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113340.984217512@linuxfoundation.org>
References: <20210118113340.984217512@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Akilesh Kailash <akailash@google.com>

commit fcc42338375a1e67b8568dbb558f8b784d0f3b01 upstream.

If the origin device has a volatile write-back cache and the following
events occur:

1: After finishing merge operation of one set of exceptions,
   merge_callback() is invoked.
2: Update the metadata in COW device tracking the merge completion.
   This update to COW device is flushed cleanly.
3: System crashes and the origin device's cache where the recent
   merge was completed has not been flushed.

During the next cycle when we read the metadata from the COW device,
we will skip reading those metadata whose merge was completed in
step (1). This will lead to data loss/corruption.

To address this, flush the origin device post merge IO before
updating the metadata.

Cc: stable@vger.kernel.org
Signed-off-by: Akilesh Kailash <akailash@google.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-snap.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -141,6 +141,11 @@ struct dm_snapshot {
 	 * for them to be committed.
 	 */
 	struct bio_list bios_queued_during_merge;
+
+	/*
+	 * Flush data after merge.
+	 */
+	struct bio flush_bio;
 };
 
 /*
@@ -1121,6 +1126,17 @@ shut:
 
 static void error_bios(struct bio *bio);
 
+static int flush_data(struct dm_snapshot *s)
+{
+	struct bio *flush_bio = &s->flush_bio;
+
+	bio_reset(flush_bio);
+	bio_set_dev(flush_bio, s->origin->bdev);
+	flush_bio->bi_opf = REQ_OP_WRITE | REQ_PREFLUSH;
+
+	return submit_bio_wait(flush_bio);
+}
+
 static void merge_callback(int read_err, unsigned long write_err, void *context)
 {
 	struct dm_snapshot *s = context;
@@ -1134,6 +1150,11 @@ static void merge_callback(int read_err,
 		goto shut;
 	}
 
+	if (flush_data(s) < 0) {
+		DMERR("Flush after merge failed: shutting down merge");
+		goto shut;
+	}
+
 	if (s->store->type->commit_merge(s->store,
 					 s->num_merging_chunks) < 0) {
 		DMERR("Write error in exception store: shutting down merge");
@@ -1318,6 +1339,7 @@ static int snapshot_ctr(struct dm_target
 	s->first_merging_chunk = 0;
 	s->num_merging_chunks = 0;
 	bio_list_init(&s->bios_queued_during_merge);
+	bio_init(&s->flush_bio, NULL, 0);
 
 	/* Allocate hash table for COW data */
 	if (init_hash_tables(s)) {
@@ -1504,6 +1526,8 @@ static void snapshot_dtr(struct dm_targe
 
 	dm_exception_store_destroy(s->store);
 
+	bio_uninit(&s->flush_bio);
+
 	dm_put_device(ti, s->cow);
 
 	dm_put_device(ti, s->origin);


