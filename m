Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23DBB50DB30
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 10:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236072AbiDYIcC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 04:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236081AbiDYIb6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 04:31:58 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D204BC09
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 01:28:42 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id j17-20020a62b611000000b004fa6338bd77so9959602pff.10
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 01:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=L/g0bvSDwPnuo+OUPLoiHehwSXqnnWuBcck3d5mIN9M=;
        b=cnmFwoBhFMB/Pj/JIIygENpMidH6zwJmMLX6saPKUkj4UfmSBcYcURpXfcx4gh0inc
         sGZPs+knBgI3q2bvF9mEN7Vx9W+f2j3iDa3DZAM6Zzizi5icpiqjcEcOTTAjvStdreo0
         Jvx2MZr9ym5NsVoKonEl5qY48yp2+2b17c0l1ZNl+AAsS0AnmHtyCZiJA9WGThlJPYQf
         4QK34skauRX2AWq4V2e8JZXvXSjj4PqEerFmLDNl+JB6+QXJQO/0BtAVW5HEmFTMtbp4
         Fr+1/ojsE4w0nSa04jFOz8XLzyukFF4neklb0jEnDN2qURW+S9hsqE2uoUtyZfjlruAh
         SmKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=L/g0bvSDwPnuo+OUPLoiHehwSXqnnWuBcck3d5mIN9M=;
        b=wuaNx5XUy+wQrHlpx1p3svFrWNB4JFgOi1XiRtNDDZOxGlzYXx4cFYN81x+BP2iZ0P
         fVX43BwoJiYDI9ZWPFFvgeEdCQcFMLukWWIWS0fgfcoTXUMRVBKirskoNo3TnT1Ul6T1
         JcWlVc2//Cos4S/9sMzc2CKVH9u8qGku2z00mXR043q4twMf8rbL61mO1vbkkGBltElV
         iL1k2CnQvDgl49FP5e2U6iwXbWQXcrEKHijtifSa7KieBT5nQt7GQCrTGpjamqlKm2KS
         Y3HNywn4h/+b7My7BdPG6qd+c+nsSGQWuqecr2F2etliM0ary+yPu//DoOm5SJMx4JwI
         fZWw==
X-Gm-Message-State: AOAM530JHmip8XjsS4PX9rjnzo+TnOwAaStI+CMOlTLiFBjnmiHXMv4f
        xoPRE/QbUsevq0lDd/vjqWywHMaw3TciCwl3f9BM5aJrGorLBgzjoYJRVfiS1kNJw0fc7+Sj541
        PITF771LLYzVLyDhc8MUG9qFqTADCXKEi7VEF8J9JRWj94swAmqNotP20jRHQOTNjc7Y=
X-Google-Smtp-Source: ABdhPJyKgd+B7+akN68eNfEFu0f3pvv3Z+LsqgdmFH8KOvoxR3ca0S+m9ezFTKUSUtq6v9lB4HUsrAun1Ogpng==
X-Received: from akailash.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1e6])
 (user=akailash job=sendgmr) by 2002:a17:90a:9105:b0:1d2:9e98:7e1e with SMTP
 id k5-20020a17090a910500b001d29e987e1emr1365096pjo.0.1650875321248; Mon, 25
 Apr 2022 01:28:41 -0700 (PDT)
Date:   Mon, 25 Apr 2022 08:28:12 +0000
Message-Id: <20220425082812.780445-1-akailash@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH] dm: fix mempool NULL pointer race when completing IO
From:   Akilesh Kailash <akailash@google.com>
To:     stable@vger.kernel.org
Cc:     Jiazi Li <lijiazi@xiaomi.com>, kernel-team@android.com,
        akailash@google.com, Jiazi Li <jqqlijiazi@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiazi Li <jqqlijiazi@gmail.com>

commit d208b89401e073de986dc891037c5a668f5d5d95 upstream.

This is a backport of the upstream patch to 5.10.y stable branch.

This backport resolves a minor merge-conflict on 5.10.y stable branch.

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

Link: https://lore.kernel.org/dm-devel/1632916768-22379-1-git-send-email-lijiazi@xiaomi.com/T/#u
Cc: stable@vger.kernel.org
Signed-off-by: Jiazi Li <lijiazi@xiaomi.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Akilesh Kailash <akailash@google.com>
---
 drivers/md/dm.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 2836d44094ab..b3d8d9e0e6f6 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -607,18 +607,17 @@ static void start_io_acct(struct dm_io *io)
 				    false, 0, &io->stats_aux);
 }
 
-static void end_io_acct(struct dm_io *io)
+static void end_io_acct(struct mapped_device *md, struct bio *bio,
+			unsigned long start_time, struct dm_stats_aux *stats_aux)
 {
-	struct mapped_device *md = io->md;
-	struct bio *bio = io->orig_bio;
-	unsigned long duration = jiffies - io->start_time;
+	unsigned long duration = jiffies - start_time;
 
-	bio_end_io_acct(bio, io->start_time);
+	bio_end_io_acct(bio, start_time);
 
 	if (unlikely(dm_stats_used(&md->stats)))
 		dm_stats_account_io(&md->stats, bio_data_dir(bio),
 				    bio->bi_iter.bi_sector, bio_sectors(bio),
-				    true, duration, &io->stats_aux);
+				    true, duration, stats_aux);
 
 	/* nudge anyone waiting on suspend queue */
 	if (unlikely(wq_has_sleeper(&md->wait)))
@@ -903,6 +902,8 @@ static void dec_pending(struct dm_io *io, blk_status_t error)
 	blk_status_t io_error;
 	struct bio *bio;
 	struct mapped_device *md = io->md;
+	unsigned long start_time = 0;
+	struct dm_stats_aux stats_aux;
 
 	/* Push-back supersedes any I/O errors */
 	if (unlikely(error)) {
@@ -929,8 +930,10 @@ static void dec_pending(struct dm_io *io, blk_status_t error)
 
 		io_error = io->status;
 		bio = io->orig_bio;
-		end_io_acct(io);
+		start_time = io->start_time;
+		stats_aux = io->stats_aux;
 		free_io(md, io);
+		end_io_acct(md, bio, start_time, &stats_aux);
 
 		if (io_error == BLK_STS_DM_REQUEUE)
 			return;
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

