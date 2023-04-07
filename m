Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91C026DA8B3
	for <lists+stable@lfdr.de>; Fri,  7 Apr 2023 08:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbjDGGFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Apr 2023 02:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232953AbjDGGF3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Apr 2023 02:05:29 -0400
X-Greylist: delayed 60 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 06 Apr 2023 23:05:28 PDT
Received: from bigo.sg (mail.bigo.sg [202.168.101.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 248E361BE
        for <stable@vger.kernel.org>; Thu,  6 Apr 2023 23:05:27 -0700 (PDT)
Received: from localhost.localdomain (unknown [169.136.75.194])
        by sg-mail1 (Coremail) with SMTP id U2SSCgAnYDthsi9k7Dq_AA--.39940S2;
        Fri, 07 Apr 2023 14:04:24 +0800 (CST)
From:   linminggui <linminggui1@bigo.sg>
To:     stable@vger.kernel.org
Cc:     shli@kernel.org, linminggui <linminggui1@bigo.sg>
Subject: [PATCH] md/raid10: fix deadlock when handle read error and running data-check at same time
Date:   Fri,  7 Apr 2023 14:04:11 +0800
Message-Id: <1680847451-71593-1-git-send-email-linminggui1@bigo.sg>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: U2SSCgAnYDthsi9k7Dq_AA--.39940S2
X-Coremail-Antispam: 1UD129KBjvJXoWxWr1xWFWDXF17JFW3ZF1rtFb_yoWrWrWkp3
        y3t3ZxJrWUAwn0vws8JFWUCFyFy34ktay3JrWxKw1xXFnF9rZ3AFy7GFyrWryDuFZ5ua47
        Xrn8Cw4DGr10yaDanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUgv1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l8cAvFVAK
        0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4
        x0Y4vE2Ix0cI8IcVCY1x0267AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28E
        F7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F4
        0EFcxC0VAKzVAqx4xG6I80ewAv7VCjz48v1sIEY20_Gr4UJr1UMcvjeVCFs4IE7xkEbVWU
        JVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc2xSY4AK6xAfMx
        AIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY20_Gr4UJr1UMxC20s026xCaFVCjc4AY
        6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17
        CEb7AF67AKxVWUXVWUAwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF
        0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIx
        AIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIev
        Ja73UjIFyTuYvjfUxzuWDUUUU
X-CM-SenderInfo: 5olqzx5qjj3x2r6exwnrovw/
X-Spam-Status: No, score=-0.0 required=5.0 tests=SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

when running data-check and ecounter a normal IO errror, raid10d handle
the error, one resync IO added into conf->retry_list waiting for
raid10d to handle it, so barrier will not drop to zero and the normal
IO(read error) will stuck in wait_barrier in raid10_read_request.
after this, resyc thread will stuck in raise_barrier, other process
will stuck in wait_barrier. Ignore barrier for read error retry in
raid10_read_request to avoid deadlock. for kernel linux-4.19.y

processA      md0_raid10          md0_resync               processB
-------------------------------------------------------------------------
        |         |                     |                      |
read io error     |                     |                      |
        |   handle_read_error     raise_barrier                |
        |         |               (nr_pending=1,barrier=1)     |
                  |                     |                 wait_barrier
                  |                     |       (nr_waiting=1,barrier=1)
           allow_barrier                |                      |
          (nr_pending=0)                |                      |
                  |                     |                      
                  |                conf->retry_list
                  |                     |
                  |                     |
            wait_barrier
          (nr_waiting=2,barrier=1)

[ 1452.065519] INFO: task md0_raid10:381 blocked for more than 120 seconds.
[ 1452.065852]       Tainted: G           OE K   4.19.280 #2
[ 1452.066018] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1452.066189] md0_raid10      D    0   381      2 0x80000000
[ 1452.066191] Call Trace:
[ 1452.066197]  __schedule+0x3f8/0x8b0
[ 1452.066199]  schedule+0x36/0x80
[ 1452.066201]  wait_barrier+0x150/0x1b0
[ 1452.066203]  ? wait_woken+0x80/0x80
[ 1452.066205]  raid10_read_request+0xa8/0x510
[ 1452.066206]  handle_read_error+0xa9/0x220
[ 1452.066207]  ? pick_next_task_fair+0x15d/0x610
[ 1452.066208]  raid10d+0xa01/0x1510
[ 1452.066210]  ? schedule+0x36/0x80
[ 1452.066211]  md_thread+0x133/0x180
[ 1452.066212]  ? md_thread+0x133/0x180
[ 1452.066213]  ? wait_woken+0x80/0x80
[ 1452.066214]  kthread+0x105/0x140

Signed-off-by: linminggui <linminggui1@bigo.sg>
---
 drivers/md/raid10.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 9f9cd2f..9f00400 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1137,6 +1137,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	int slot = r10_bio->read_slot;
 	struct md_rdev *err_rdev = NULL;
 	gfp_t gfp = GFP_NOIO;
+	bool error_retry = false;
 
 	if (slot >= 0 && r10_bio->devs[slot].rdev) {
 		/*
@@ -1153,6 +1154,9 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 		 */
 		gfp = GFP_NOIO | __GFP_HIGH;
 
+		error_retry = true;
+		atomic_inc(&conf->nr_pending);
+
 		rcu_read_lock();
 		disk = r10_bio->devs[slot].devnum;
 		err_rdev = rcu_dereference(conf->mirrors[disk].rdev);
@@ -1169,8 +1173,10 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	 * Register the new request and wait if the reconstruction
 	 * thread has put up a bar for new requests.
 	 * Continue immediately if no resync is active currently.
+	 * Ignore barrier if this is an error retry.
 	 */
-	wait_barrier(conf);
+	if (!error_retry)
+		wait_barrier(conf);
 
 	sectors = r10_bio->sectors;
 	while (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
@@ -1181,12 +1187,14 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 		 * pass
 		 */
 		raid10_log(conf->mddev, "wait reshape");
-		allow_barrier(conf);
+		if (!error_retry)
+			allow_barrier(conf);
 		wait_event(conf->wait_barrier,
 			   conf->reshape_progress <= bio->bi_iter.bi_sector ||
 			   conf->reshape_progress >= bio->bi_iter.bi_sector +
 			   sectors);
-		wait_barrier(conf);
+		if (!error_retry)
+			wait_barrier(conf);
 	}
 
 	rdev = read_balance(conf, r10_bio, &max_sectors);
@@ -1208,9 +1216,11 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 		struct bio *split = bio_split(bio, max_sectors,
 					      gfp, &conf->bio_split);
 		bio_chain(split, bio);
-		allow_barrier(conf);
+		if (!error_retry)
+			allow_barrier(conf);
 		generic_make_request(bio);
-		wait_barrier(conf);
+		if (!error_retry)
+			wait_barrier(conf);
 		bio = split;
 		r10_bio->master_bio = bio;
 		r10_bio->sectors = max_sectors;
-- 
2.7.4

