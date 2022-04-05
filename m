Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43A694F3371
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347528AbiDEJ1R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243308AbiDEIuV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:50:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F06BE097;
        Tue,  5 Apr 2022 01:38:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F1B6B6152C;
        Tue,  5 Apr 2022 08:38:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA6DC385A1;
        Tue,  5 Apr 2022 08:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147889;
        bh=2FjM/lj0fcJq0jHwEH+Am/vpGg0MEDZx4Nc772tYTu4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lcvv2F42S2+azgDa0ub0hoiHjEraduQROI9mrjnUpYrgeovrdMZ7JUd5gp5+OhVo7
         +KMvAqqZJh/Q6Zk2QldTS9RfteRnjTeZdHQP7jxU7LkH97BSHRKGoUf1bloUTpZNtR
         X/wjxXhjDvW1IHyhJScViPo3l5pvMMZi1ZRkDP4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.16 0120/1017] dm: interlock pending dm_io and dm_wait_for_bios_completion
Date:   Tue,  5 Apr 2022 09:17:13 +0200
Message-Id: <20220405070357.759928595@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Snitzer <snitzer@redhat.com>

commit 9f6dc633761006f974701d4c88da71ab68670749 upstream.

Commit d208b89401e0 ("dm: fix mempool NULL pointer race when
completing IO") didn't go far enough.

When bio_end_io_acct ends the count of in-flight I/Os may reach zero
and the DM device may be suspended. There is a possibility that the
suspend races with dm_stats_account_io.

Fix this by adding percpu "pending_io" counters to track outstanding
dm_io. Move kicking of suspend queue to dm_io_dec_pending(). Also,
rename md_in_flight_bios() to dm_in_flight_bios() and update it to
iterate all pending_io counters.

Fixes: d208b89401e0 ("dm: fix mempool NULL pointer race when completing IO")
Cc: stable@vger.kernel.org
Co-developed-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-core.h |    2 ++
 drivers/md/dm.c      |   35 +++++++++++++++++++++++------------
 2 files changed, 25 insertions(+), 12 deletions(-)

--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -65,6 +65,8 @@ struct mapped_device {
 	struct gendisk *disk;
 	struct dax_device *dax_dev;
 
+	unsigned long __percpu *pending_io;
+
 	/*
 	 * A list of ios that arrived while we were suspended.
 	 */
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -507,10 +507,6 @@ static void end_io_acct(struct mapped_de
 		dm_stats_account_io(&md->stats, bio_data_dir(bio),
 				    bio->bi_iter.bi_sector, bio_sectors(bio),
 				    true, duration, stats_aux);
-
-	/* nudge anyone waiting on suspend queue */
-	if (unlikely(wq_has_sleeper(&md->wait)))
-		wake_up(&md->wait);
 }
 
 static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
@@ -531,6 +527,7 @@ static struct dm_io *alloc_io(struct map
 	io->magic = DM_IO_MAGIC;
 	io->status = 0;
 	atomic_set(&io->io_count, 1);
+	this_cpu_inc(*md->pending_io);
 	io->orig_bio = bio;
 	io->md = md;
 	spin_lock_init(&io->endio_lock);
@@ -828,6 +825,12 @@ void dm_io_dec_pending(struct dm_io *io,
 		stats_aux = io->stats_aux;
 		free_io(md, io);
 		end_io_acct(md, bio, start_time, &stats_aux);
+		smp_wmb();
+		this_cpu_dec(*md->pending_io);
+
+		/* nudge anyone waiting on suspend queue */
+		if (unlikely(wq_has_sleeper(&md->wait)))
+			wake_up(&md->wait);
 
 		if (io_error == BLK_STS_DM_REQUEUE)
 			return;
@@ -1689,6 +1692,11 @@ static void cleanup_mapped_device(struct
 		blk_cleanup_disk(md->disk);
 	}
 
+	if (md->pending_io) {
+		free_percpu(md->pending_io);
+		md->pending_io = NULL;
+	}
+
 	cleanup_srcu_struct(&md->io_barrier);
 
 	mutex_destroy(&md->suspend_lock);
@@ -1786,6 +1794,10 @@ static struct mapped_device *alloc_dev(i
 	if (!md->wq)
 		goto bad;
 
+	md->pending_io = alloc_percpu(unsigned long);
+	if (!md->pending_io)
+		goto bad;
+
 	dm_stats_init(&md->stats);
 
 	/* Populate the mapping, nobody knows we exist yet */
@@ -2193,16 +2205,13 @@ void dm_put(struct mapped_device *md)
 }
 EXPORT_SYMBOL_GPL(dm_put);
 
-static bool md_in_flight_bios(struct mapped_device *md)
+static bool dm_in_flight_bios(struct mapped_device *md)
 {
 	int cpu;
-	struct block_device *part = dm_disk(md)->part0;
-	long sum = 0;
+	unsigned long sum = 0;
 
-	for_each_possible_cpu(cpu) {
-		sum += part_stat_local_read_cpu(part, in_flight[0], cpu);
-		sum += part_stat_local_read_cpu(part, in_flight[1], cpu);
-	}
+	for_each_possible_cpu(cpu)
+		sum += *per_cpu_ptr(md->pending_io, cpu);
 
 	return sum != 0;
 }
@@ -2215,7 +2224,7 @@ static int dm_wait_for_bios_completion(s
 	while (true) {
 		prepare_to_wait(&md->wait, &wait, task_state);
 
-		if (!md_in_flight_bios(md))
+		if (!dm_in_flight_bios(md))
 			break;
 
 		if (signal_pending_state(task_state, current)) {
@@ -2227,6 +2236,8 @@ static int dm_wait_for_bios_completion(s
 	}
 	finish_wait(&md->wait, &wait);
 
+	smp_rmb();
+
 	return r;
 }
 


