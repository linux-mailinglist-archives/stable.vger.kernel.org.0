Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCFEC4D5441
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 23:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344284AbiCJWLo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 17:11:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240840AbiCJWLo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 17:11:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F1F1959E8;
        Thu, 10 Mar 2022 14:10:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC847B828AE;
        Thu, 10 Mar 2022 22:10:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 928EBC340E9;
        Thu, 10 Mar 2022 22:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646950239;
        bh=ciE3UiXOo8qUTGPSsYq8F51hde1jSkJhyknZojqG7HY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=iW8LoZv2jkoI6/s4RU7OqRDlWr/X1Kf1G6LRnMFbkqM/4V79sSKrORFmgiB4/YTWh
         7jVz0fxWx/9qQgNZ0/7N26ApTEus7Pu1fwwi2lh4U5bcf/EOBGebp/gWsSo9PITr/B
         45i5LB8hMRgiXn20i/4sy1miO/fA/rM+6ktWQ87fHb00Fp9psxn2F9aSwPiTxNgU5p
         55QWwOX8VJejgV+mQoN5rcXAaMLmliEisLRu1Bdjun3Y8IsNk0gvQKxuAMG7bfI+0A
         6aLCiD8iBGZfmKWN1wxiJS3PY8ciIyJJXD5ovP/BoKxJFFghx0w300oLUV+gtF28qe
         i8C++WBeHABUw==
Received: by mail-yb1-f181.google.com with SMTP id g1so13680028ybe.4;
        Thu, 10 Mar 2022 14:10:39 -0800 (PST)
X-Gm-Message-State: AOAM532w8uAQvaWly1hAQQEnI6FkllypbiX6yZV14HZ3mGYuLZkXRKqi
        U01rvjaNt1jyheAib8YemnOEpnxV7tumw0CKPqw=
X-Google-Smtp-Source: ABdhPJwpvxpy0c9Yo21E4M2ZcsteYPHZBpbfcLZhyrm/KA5yOBkJDyFiagUv5wbNWoIzD8dljXpQcEZ8j23JdqeU0Pw=
X-Received: by 2002:a25:8b81:0:b0:629:17d5:68c1 with SMTP id
 j1-20020a258b81000000b0062917d568c1mr5607679ybl.449.1646950238655; Thu, 10
 Mar 2022 14:10:38 -0800 (PST)
MIME-Version: 1.0
References: <20220309064209.4169303-1-song@kernel.org> <YimfLJoWLKnnhLfR@infradead.org>
 <CAPhsuW4DJbvH5QZ5YMC4Ms4bd66UOFsLL=-yK8tQKrwreCfKDQ@mail.gmail.com>
In-Reply-To: <CAPhsuW4DJbvH5QZ5YMC4Ms4bd66UOFsLL=-yK8tQKrwreCfKDQ@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 10 Mar 2022 14:10:27 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7AHuxOpiH_nsqg4dkb3pwOTy8f2sHsDrtAF73+BLZF5A@mail.gmail.com>
Message-ID: <CAPhsuW7AHuxOpiH_nsqg4dkb3pwOTy8f2sHsDrtAF73+BLZF5A@mail.gmail.com>
Subject: Re: [PATCH] block: check more requests for multiple_queues in blk_attempt_plug_merge
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-block@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org,
        Larkin Lowrey <llowrey@nuclearwinter.com>,
        Wilson Jonathan <i400sjon@gmail.com>,
        Roger Heflin <rogerheflin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 9, 2022 at 11:23 PM Song Liu <song@kernel.org> wrote:
>
> On Wed, Mar 9, 2022 at 10:48 PM Christoph Hellwig <hch@infradead.org> wrote:
> >
> > On Tue, Mar 08, 2022 at 10:42:09PM -0800, Song Liu wrote:
> > > RAID arrays check/repair operations benefit a lot from merging requests.
> > > If we only check the previous entry for merge attempt, many merge will be
> > > missed. As a result, significant regression is observed for RAID check
> > > and repair.
> > >
> > > Fix this by checking more than just the previous entry when
> > > plug->multiple_queues == true.
> >
> > But this also means really significant CPU overhead for all other
> > workloads.
>
> Would the following check help with these workloads?
>
>  if (!plug->multiple_queues)
>               break;
>
> >
> > >
> > > This improves the check/repair speed of a 20-HDD raid6 from 19 MB/s to
> > > 103 MB/s.
> >
> > What driver uses multiple queues for HDDs?
> >
> > Can you explain the workload submitted by a md a bit better?  I wonder
> > if we can easily do the right thing straight in the md driver.
>
> It is the md sync_thread doing check and repair. Basically, the md
> thread reads all
> the disks and computes parity from data.
>
> Maybe we should add a new flag to struct blk_plug for this special case?

I meant something like:

diff --git c/block/blk-core.c w/block/blk-core.c
index 1039515c99d6..4fb09243e908 100644
--- c/block/blk-core.c
+++ w/block/blk-core.c
@@ -1303,6 +1303,12 @@ void blk_finish_plug(struct blk_plug *plug)
 }
 EXPORT_SYMBOL(blk_finish_plug);

+void blk_plug_merge_aggressively(struct blk_plug *plug)
+{
+    plug->aggresive_merge = true;
+}
+EXPORT_SYMBOL(blk_plug_merge_aggressively);
+
 void blk_io_schedule(void)
 {
     /* Prevent hang_check timer from firing at us during very long I/O */
diff --git c/block/blk-merge.c w/block/blk-merge.c
index 4de34a332c9f..8b673288bc5f 100644
--- c/block/blk-merge.c
+++ w/block/blk-merge.c
@@ -1089,12 +1089,14 @@ bool blk_attempt_plug_merge(struct
request_queue *q, struct bio *bio,
     if (!plug || rq_list_empty(plug->mq_list))
         return false;

-    /* check the previously added entry for a quick merge attempt */
-    rq = rq_list_peek(&plug->mq_list);
-    if (rq->q == q) {
-        if (blk_attempt_bio_merge(q, rq, bio, nr_segs, false) ==
-                BIO_MERGE_OK)
-            return true;
+    rq_list_for_each(&plug->mq_list, rq) {
+        if (rq->q == q) {
+            if (blk_attempt_bio_merge(q, rq, bio, nr_segs, false) ==
+                BIO_MERGE_OK)
+                return true;
+        }
+        if (!plug->aggresive_merge)
+            break;
     }
     return false;
 }
diff --git c/drivers/md/md.c w/drivers/md/md.c
index 4d38bd7dadd6..6be56632a412 100644
--- c/drivers/md/md.c
+++ w/drivers/md/md.c
@@ -8901,6 +8901,7 @@ void md_do_sync(struct md_thread *thread)
     update_time = jiffies;

     blk_start_plug(&plug);
+    blk_plug_merge_aggressively(&plug);
     while (j < max_sectors) {
         sector_t sectors;

diff --git c/drivers/md/raid1.c w/drivers/md/raid1.c
index e2d8acb1e988..501d15532170 100644
--- c/drivers/md/raid1.c
+++ w/drivers/md/raid1.c
@@ -838,6 +838,7 @@ static void flush_pending_writes(struct r1conf *conf)
          */
         __set_current_state(TASK_RUNNING);
         blk_start_plug(&plug);
+        blk_plug_merge_aggressively(&plug);
         flush_bio_list(conf, bio);
         blk_finish_plug(&plug);
     } else
@@ -2591,6 +2592,7 @@ static void raid1d(struct md_thread *thread)
     }

     blk_start_plug(&plug);
+    blk_plug_merge_aggressively(&plug);
     for (;;) {

         flush_pending_writes(conf);
diff --git c/drivers/md/raid10.c w/drivers/md/raid10.c
index 2b969f70a31f..0a594613a075 100644
--- c/drivers/md/raid10.c
+++ w/drivers/md/raid10.c
@@ -876,6 +876,7 @@ static void flush_pending_writes(struct r10conf *conf)
         __set_current_state(TASK_RUNNING);

         blk_start_plug(&plug);
+        blk_plug_merge_aggressively(&plug);
         /* flush any pending bitmap writes to disk
          * before proceeding w/ I/O */
         md_bitmap_unplug(conf->mddev->bitmap);
@@ -3088,6 +3089,7 @@ static void raid10d(struct md_thread *thread)
     }

     blk_start_plug(&plug);
+    blk_plug_merge_aggressively(&plug);
     for (;;) {

         flush_pending_writes(conf);
diff --git c/drivers/md/raid5.c w/drivers/md/raid5.c
index ffe720c73b0a..a96884ca5f08 100644
--- c/drivers/md/raid5.c
+++ w/drivers/md/raid5.c
@@ -6447,6 +6447,7 @@ static void raid5_do_work(struct work_struct *work)
     pr_debug("+++ raid5worker active\n");

     blk_start_plug(&plug);
+    blk_plug_merge_aggressively(&plug);
     handled = 0;
     spin_lock_irq(&conf->device_lock);
     while (1) {
@@ -6497,6 +6498,7 @@ static void raid5d(struct md_thread *thread)
     md_check_recovery(mddev);

     blk_start_plug(&plug);
+    blk_plug_merge_aggressively(&plug);
     handled = 0;
     spin_lock_irq(&conf->device_lock);
     while (1) {
diff --git c/include/linux/blkdev.h w/include/linux/blkdev.h
index 16b47035e4b0..45b0da416302 100644
--- c/include/linux/blkdev.h
+++ w/include/linux/blkdev.h
@@ -775,6 +775,7 @@ struct blk_plug {
     bool multiple_queues;
     bool has_elevator;
     bool nowait;
+    bool aggresive_merge;

     struct list_head cb_list; /* md requires an unplug callback */
 };
@@ -791,6 +792,7 @@ extern struct blk_plug_cb
*blk_check_plugged(blk_plug_cb_fn unplug,
 extern void blk_start_plug(struct blk_plug *);
 extern void blk_start_plug_nr_ios(struct blk_plug *, unsigned short);
 extern void blk_finish_plug(struct blk_plug *);
+void blk_plug_merge_aggressively(struct blk_plug *plug);

 void blk_flush_plug(struct blk_plug *plug, bool from_schedule);
