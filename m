Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80BAA1B67F5
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728836AbgDWXKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:10:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50292 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728588AbgDWXGw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:52 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkve-0004rl-1a; Fri, 24 Apr 2020 00:06:46 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkva-00E70M-13; Fri, 24 Apr 2020 00:06:42 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jens Axboe" <axboe@fb.com>, "Davidlohr Bueso" <dave@stgolabs.ne>,
        "Davidlohr Bueso" <dbueso@suse.de>
Date:   Fri, 24 Apr 2020 00:07:18 +0100
Message-ID: <lsq.1587683028.407504257@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 211/245] blktrace: re-write setting q->blk_trace
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Davidlohr Bueso <dave@stgolabs.ne>

commit cdea01b2bf98affb7e9c44530108a4a28535eee8 upstream.

This is really about simplifying the double xchg patterns into
a single cmpxchg, with the same logic. Other than the immediate
cleanup, there are some subtleties this change deals with:

(i) While the load of the old bt is fully ordered wrt everything,
ie:

        old_bt = xchg(&q->blk_trace, bt);             [barrier]
        if (old_bt)
	     (void) xchg(&q->blk_trace, old_bt);    [barrier]

blk_trace could still be changed between the xchg and the old_bt
load. Note that this description is merely theoretical and afaict
very small, but doing everything in a single context with cmpxchg
closes this potential race.

(ii) Ordering guarantees are obviously kept with cmpxchg.

(iii) Gets rid of the hacky-by-nature (void)xchg pattern.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
eviewed-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/trace/blktrace.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -448,7 +448,7 @@ int do_blk_trace_setup(struct request_qu
 		       struct block_device *bdev,
 		       struct blk_user_trace_setup *buts)
 {
-	struct blk_trace *old_bt, *bt = NULL;
+	struct blk_trace *bt = NULL;
 	struct dentry *dir = NULL;
 	int ret, i;
 
@@ -532,11 +532,8 @@ int do_blk_trace_setup(struct request_qu
 	bt->trace_state = Blktrace_setup;
 
 	ret = -EBUSY;
-	old_bt = xchg(&q->blk_trace, bt);
-	if (old_bt) {
-		(void) xchg(&q->blk_trace, old_bt);
+	if (cmpxchg(&q->blk_trace, NULL, bt))
 		goto err;
-	}
 
 	if (atomic_inc_return(&blk_probes_ref) == 1)
 		blk_register_tracepoints();
@@ -1550,7 +1547,7 @@ static int blk_trace_remove_queue(struct
 static int blk_trace_setup_queue(struct request_queue *q,
 				 struct block_device *bdev)
 {
-	struct blk_trace *old_bt, *bt = NULL;
+	struct blk_trace *bt = NULL;
 	int ret = -ENOMEM;
 
 	bt = kzalloc(sizeof(*bt), GFP_KERNEL);
@@ -1566,12 +1563,9 @@ static int blk_trace_setup_queue(struct
 
 	blk_trace_setup_lba(bt, bdev);
 
-	old_bt = xchg(&q->blk_trace, bt);
-	if (old_bt != NULL) {
-		(void)xchg(&q->blk_trace, old_bt);
-		ret = -EBUSY;
+	ret = -EBUSY;
+	if (cmpxchg(&q->blk_trace, NULL, bt))
 		goto free_bt;
-	}
 
 	if (atomic_inc_return(&blk_probes_ref) == 1)
 		blk_register_tracepoints();

