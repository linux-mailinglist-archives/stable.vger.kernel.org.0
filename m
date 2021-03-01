Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64D19328C1A
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240284AbhCASpe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:45:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:51508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240503AbhCASjS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:39:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 480B165126;
        Mon,  1 Mar 2021 17:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618189;
        bh=hOFdupMaChb4+KhGP7ACzSJ//GTerf0Gu7R0L79F1jw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ikzx6Dh0xbB+d2D/11FR8820D8mgtY52vwXwWUdL2+qhKA/Xv/WIM3dn9SyuLvLkj
         5fQbXDfmfupNoXV82K3YigSQ4tShXJtu9+RALuWFQziVZUmZ4WXnhY+eaBBDSpLgX1
         bJoDKKiaUM6yyJmKPmvcrNoxLT1CfgEFQt2YKRtw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikos Tsironis <ntsironis@arrikto.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.4 339/340] dm era: Update in-core bitset after committing the metadata
Date:   Mon,  1 Mar 2021 17:14:43 +0100
Message-Id: <20210301161104.978937521@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikos Tsironis <ntsironis@arrikto.com>

commit 2099b145d77c1d53f5711f029c37cc537897cee6 upstream.

In case of a system crash, dm-era might fail to mark blocks as written
in its metadata, although the corresponding writes to these blocks were
passed down to the origin device and completed successfully.

Consider the following sequence of events:

1. We write to a block that has not been yet written in the current era
2. era_map() checks the in-core bitmap for the current era and sees
   that the block is not marked as written.
3. The write is deferred for submission after the metadata have been
   updated and committed.
4. The worker thread processes the deferred write
   (process_deferred_bios()) and marks the block as written in the
   in-core bitmap, **before** committing the metadata.
5. The worker thread starts committing the metadata.
6. We do more writes that map to the same block as the write of step (1)
7. era_map() checks the in-core bitmap and sees that the block is marked
   as written, **although the metadata have not been committed yet**.
8. These writes are passed down to the origin device immediately and the
   device reports them as completed.
9. The system crashes, e.g., power failure, before the commit from step
   (5) finishes.

When the system recovers and we query the dm-era target for the list of
written blocks it doesn't report the aforementioned block as written,
although the writes of step (6) completed successfully.

The issue is that era_map() decides whether to defer or not a write
based on non committed information. The root cause of the bug is that we
update the in-core bitmap, **before** committing the metadata.

Fix this by updating the in-core bitmap **after** successfully
committing the metadata.

Fixes: eec40579d84873 ("dm: add era target")
Cc: stable@vger.kernel.org # v3.15+
Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-era-target.c |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -135,7 +135,7 @@ static int writeset_test_and_set(struct
 {
 	int r;
 
-	if (!test_and_set_bit(block, ws->bits)) {
+	if (!test_bit(block, ws->bits)) {
 		r = dm_bitset_set_bit(info, ws->md.root, block, &ws->md.root);
 		if (r) {
 			/* FIXME: fail mode */
@@ -1241,8 +1241,10 @@ static void process_deferred_bios(struct
 	int r;
 	struct bio_list deferred_bios, marked_bios;
 	struct bio *bio;
+	struct blk_plug plug;
 	bool commit_needed = false;
 	bool failed = false;
+	struct writeset *ws = era->md->current_writeset;
 
 	bio_list_init(&deferred_bios);
 	bio_list_init(&marked_bios);
@@ -1252,9 +1254,11 @@ static void process_deferred_bios(struct
 	bio_list_init(&era->deferred_bios);
 	spin_unlock(&era->deferred_lock);
 
+	if (bio_list_empty(&deferred_bios))
+		return;
+
 	while ((bio = bio_list_pop(&deferred_bios))) {
-		r = writeset_test_and_set(&era->md->bitset_info,
-					  era->md->current_writeset,
+		r = writeset_test_and_set(&era->md->bitset_info, ws,
 					  get_block(era, bio));
 		if (r < 0) {
 			/*
@@ -1262,7 +1266,6 @@ static void process_deferred_bios(struct
 			 * FIXME: finish.
 			 */
 			failed = true;
-
 		} else if (r == 0)
 			commit_needed = true;
 
@@ -1278,9 +1281,19 @@ static void process_deferred_bios(struct
 	if (failed)
 		while ((bio = bio_list_pop(&marked_bios)))
 			bio_io_error(bio);
-	else
-		while ((bio = bio_list_pop(&marked_bios)))
+	else {
+		blk_start_plug(&plug);
+		while ((bio = bio_list_pop(&marked_bios))) {
+			/*
+			 * Only update the in-core writeset if the on-disk one
+			 * was updated too.
+			 */
+			if (commit_needed)
+				set_bit(get_block(era, bio), ws->bits);
 			generic_make_request(bio);
+		}
+		blk_finish_plug(&plug);
+	}
 }
 
 static void process_rpc_calls(struct era *era)


