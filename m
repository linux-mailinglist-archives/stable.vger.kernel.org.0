Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6A45521751
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242526AbiEJNYJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242707AbiEJNUl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:20:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8332E2B94ED;
        Tue, 10 May 2022 06:13:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8318E615DD;
        Tue, 10 May 2022 13:13:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EA7CC385A6;
        Tue, 10 May 2022 13:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188418;
        bh=M8IicdsUnZg8vfnppCcQYQR4NgT/lEnuhCttCqnkMSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AoeAX0PVYBWrPwqpmS/iNSm8mB/huDkdHUFWkW1B9ClizDEIVKrvN2JkV6dcr7hAR
         CoKuBWjfkSDuBL0gTJW1p71xApN+yGbjQ/HG+s1bTMM6zgnreCx+FvX/Dsrjcyn+XA
         zD3wQI0JV6ERc2NudgqDcg3aMDrhQt0nrJ0Cv27c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiazi Li <lijiazi@xiaomi.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 4.9 65/66] dm: fix mempool NULL pointer race when completing IO
Date:   Tue, 10 May 2022 15:07:55 +0200
Message-Id: <20220510130731.673926877@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130729.762341544@linuxfoundation.org>
References: <20220510130729.762341544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiazi Li <jqqlijiazi@gmail.com>

commit d208b89401e073de986dc891037c5a668f5d5d95 upstream.

dm_io_dec_pending() calls end_io_acct() first and will then dec md
in-flight pending count. But if a task is swapping DM table at same
time this can result in a crash due to mempool->elements being NULL:

task1                             task2
do_resume
 ->do_suspend
  ->dm_wait_for_completion
                                  bio_endio
				   ->clone_endio
				    ->dm_io_dec_pending
				     ->end_io_acct
				      ->wakeup task1
 ->dm_swap_table
  ->__bind
   ->__bind_mempools
    ->bioset_exit
     ->mempool_exit
                                     ->free_io

[ 67.330330] Unable to handle kernel NULL pointer dereference at
virtual address 0000000000000000
......
[ 67.330494] pstate: 80400085 (Nzcv daIf +PAN -UAO)
[ 67.330510] pc : mempool_free+0x70/0xa0
[ 67.330515] lr : mempool_free+0x4c/0xa0
[ 67.330520] sp : ffffff8008013b20
[ 67.330524] x29: ffffff8008013b20 x28: 0000000000000004
[ 67.330530] x27: ffffffa8c2ff40a0 x26: 00000000ffff1cc8
[ 67.330535] x25: 0000000000000000 x24: ffffffdada34c800
[ 67.330541] x23: 0000000000000000 x22: ffffffdada34c800
[ 67.330547] x21: 00000000ffff1cc8 x20: ffffffd9a1304d80
[ 67.330552] x19: ffffffdada34c970 x18: 000000b312625d9c
[ 67.330558] x17: 00000000002dcfbf x16: 00000000000006dd
[ 67.330563] x15: 000000000093b41e x14: 0000000000000010
[ 67.330569] x13: 0000000000007f7a x12: 0000000034155555
[ 67.330574] x11: 0000000000000001 x10: 0000000000000001
[ 67.330579] x9 : 0000000000000000 x8 : 0000000000000000
[ 67.330585] x7 : 0000000000000000 x6 : ffffff80148b5c1a
[ 67.330590] x5 : ffffff8008013ae0 x4 : 0000000000000001
[ 67.330596] x3 : ffffff80080139c8 x2 : ffffff801083bab8
[ 67.330601] x1 : 0000000000000000 x0 : ffffffdada34c970
[ 67.330609] Call trace:
[ 67.330616] mempool_free+0x70/0xa0
[ 67.330627] bio_put+0xf8/0x110
[ 67.330638] dec_pending+0x13c/0x230
[ 67.330644] clone_endio+0x90/0x180
[ 67.330649] bio_endio+0x198/0x1b8
[ 67.330655] dec_pending+0x190/0x230
[ 67.330660] clone_endio+0x90/0x180
[ 67.330665] bio_endio+0x198/0x1b8
[ 67.330673] blk_update_request+0x214/0x428
[ 67.330683] scsi_end_request+0x2c/0x300
[ 67.330688] scsi_io_completion+0xa0/0x710
[ 67.330695] scsi_finish_command+0xd8/0x110
[ 67.330700] scsi_softirq_done+0x114/0x148
[ 67.330708] blk_done_softirq+0x74/0xd0
[ 67.330716] __do_softirq+0x18c/0x374
[ 67.330724] irq_exit+0xb4/0xb8
[ 67.330732] __handle_domain_irq+0x84/0xc0
[ 67.330737] gic_handle_irq+0x148/0x1b0
[ 67.330744] el1_irq+0xe8/0x190
[ 67.330753] lpm_cpuidle_enter+0x4f8/0x538
[ 67.330759] cpuidle_enter_state+0x1fc/0x398
[ 67.330764] cpuidle_enter+0x18/0x20
[ 67.330772] do_idle+0x1b4/0x290
[ 67.330778] cpu_startup_entry+0x20/0x28
[ 67.330786] secondary_start_kernel+0x160/0x170

Fix this by:
1) Establishing pointers to 'struct dm_io' members in
dm_io_dec_pending() so that they may be passed into end_io_acct()
_after_ free_io() is called.
2) Moving end_io_acct() after free_io().

Cc: stable@vger.kernel.org
Signed-off-by: Jiazi Li <lijiazi@xiaomi.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -524,20 +524,19 @@ static void start_io_acct(struct dm_io *
 				    false, 0, &io->stats_aux);
 }
 
-static void end_io_acct(struct dm_io *io)
+static void end_io_acct(struct mapped_device *md, struct bio *bio,
+			unsigned long start_time, struct dm_stats_aux *stats_aux)
 {
-	struct mapped_device *md = io->md;
-	struct bio *bio = io->bio;
-	unsigned long duration = jiffies - io->start_time;
+	unsigned long duration = jiffies - start_time;
 	int pending;
 	int rw = bio_data_dir(bio);
 
-	generic_end_io_acct(rw, &dm_disk(md)->part0, io->start_time);
+	generic_end_io_acct(rw, &dm_disk(md)->part0, start_time);
 
 	if (unlikely(dm_stats_used(&md->stats)))
 		dm_stats_account_io(&md->stats, bio_data_dir(bio),
 				    bio->bi_iter.bi_sector, bio_sectors(bio),
-				    true, duration, &io->stats_aux);
+				    true, duration, stats_aux);
 
 	/*
 	 * After this is decremented the bio must not be touched if it is
@@ -768,6 +767,8 @@ static void dec_pending(struct dm_io *io
 	int io_error;
 	struct bio *bio;
 	struct mapped_device *md = io->md;
+	unsigned long start_time = 0;
+	struct dm_stats_aux stats_aux;
 
 	/* Push-back supersedes any I/O errors */
 	if (unlikely(error)) {
@@ -793,8 +794,10 @@ static void dec_pending(struct dm_io *io
 
 		io_error = io->error;
 		bio = io->bio;
-		end_io_acct(io);
+		start_time = io->start_time;
+		stats_aux = io->stats_aux;
 		free_io(md, io);
+		end_io_acct(md, bio, start_time, &stats_aux);
 
 		if (io_error == DM_ENDIO_REQUEUE)
 			return;


