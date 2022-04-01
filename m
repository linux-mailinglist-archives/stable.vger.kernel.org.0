Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9594EF156
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 16:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347531AbiDAOis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347661AbiDAOfn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:35:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED53E1EF5CC;
        Fri,  1 Apr 2022 07:33:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 393D7B824D5;
        Fri,  1 Apr 2022 14:33:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E8B1C36AF2;
        Fri,  1 Apr 2022 14:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823592;
        bh=imqWvnXAnpoDT58SFHM9+eZjse8am0m8K6Zovi79gBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WHTaOcxAEFbpRVgU2SXMhvnqRcApfCo92zrANGA/h0uzW+oS4Ck2zdtEH/dqUEhtG
         2KqC2RFIQQfkJ8Bzk6ZhOJyO0QI35Vz9sSXyndBbVQ9nPgpbAE3M1X6SNA/1jdm6dq
         T3AEpEovdxHP4m5D1DWUv5IcDXo2JZ2Jt0Qd0QKR/SWKaN1/gxWSIv/CnBi2ruYVp4
         G8rKcn4c9CNM0jGW5840LC1p518r3VRYNuhwsm0wQDmUd7j/N1LcYhdKs7OKzariyp
         cyBREPC2a7JrX5+/cC6brLC+NjU73OvPgApXelIDBA1tYjquJtX7ueZSV5ggtj0zEj
         4RUCRpw4Lk/qA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Douglas Gilbert <dgilbert@interlog.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 006/109] scsi: scsi_debug: Address races following module load
Date:   Fri,  1 Apr 2022 10:31:13 -0400
Message-Id: <20220401143256.1950537-6-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143256.1950537-1-sashal@kernel.org>
References: <20220401143256.1950537-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Douglas Gilbert <dgilbert@interlog.com>

[ Upstream commit 2aad3cd8537033cd34f70294a23f54623ffe9c1b ]

When scsi_debug is loaded as a module with many (simulated) hosts, targets,
and devices (LUs), modprobe can take a long time to return.  Only a small
amount of this time is spent in the scsi_debug_init(); the rest is other
parts of the kernel reacting to to the appearance of new storage
devices. As soon as scsi_debug_init() has completed the user space may call
'rmmod scsi_debug' and this was found to cause race problems as outlined
here:

    https://bugzilla.kernel.org/show_bug.cgi?id=212337

To reliably generate this race a sysfs parameter called rm_all_hosts was
added and the code was strengthened in this area. The main change was to
make the count of scsi_debug hosts present an atomic.  Then it was found
that the handling of the existing add_host parameter needed the same
strengthening. Further: 'echo -9999 >
/sys/bus/pseudo/drivers/scsi_debug/add_host has the same effect as
rm_all_hosts so rm_all_hosts was not needed.

To inhibit a race between two invocations of writes to add_host, a mutex
was added. Also address a possible race when rmmod is called but LUs are
still being added.

The logic to remove (all) hosts is rather crude: it works backwards down a
linked lists of hosts. Any pending requests are terminated with
DID_NO_CONNECT as are any new requests. In the case where not all hosts are
being removed, the ones that remain may have lost requests as just
outlined. The lowest numbered host (id) hosts will remain.

Cc: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20220109012853.301953-2-dgilbert@interlog.com
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 197 ++++++++++++++++++++++++++++----------
 1 file changed, 146 insertions(+), 51 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 2104973a35cd..24f3905f054f 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -33,6 +33,7 @@
 #include <linux/blkdev.h>
 #include <linux/crc-t10dif.h>
 #include <linux/spinlock.h>
+#include <linux/mutex.h>
 #include <linux/interrupt.h>
 #include <linux/atomic.h>
 #include <linux/hrtimer.h>
@@ -730,7 +731,9 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEM_P1 + 1] = {
 	    {0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
 };
 
-static int sdebug_num_hosts;
+static atomic_t sdebug_num_hosts;
+static DEFINE_MUTEX(add_host_mutex);
+
 static int sdebug_add_host = DEF_NUM_HOST;  /* in sysfs this is relative */
 static int sdebug_ato = DEF_ATO;
 static int sdebug_cdb_len = DEF_CDB_LEN;
@@ -777,6 +780,7 @@ static int sdebug_uuid_ctl = DEF_UUID_CTL;
 static bool sdebug_random = DEF_RANDOM;
 static bool sdebug_per_host_store = DEF_PER_HOST_STORE;
 static bool sdebug_removable = DEF_REMOVABLE;
+static bool sdebug_deflect_incoming;
 static bool sdebug_clustering;
 static bool sdebug_host_lock = DEF_HOST_LOCK;
 static bool sdebug_strict = DEF_STRICT;
@@ -5026,6 +5030,10 @@ static int scsi_debug_slave_configure(struct scsi_device *sdp)
 		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
 	if (sdp->host->max_cmd_len != SDEBUG_MAX_CMD_LEN)
 		sdp->host->max_cmd_len = SDEBUG_MAX_CMD_LEN;
+	if (smp_load_acquire(&sdebug_deflect_incoming)) {
+		pr_info("Exit early due to deflect_incoming\n");
+		return 1;
+	}
 	if (devip == NULL) {
 		devip = find_build_dev_info(sdp);
 		if (devip == NULL)
@@ -5111,7 +5119,7 @@ static bool stop_queued_cmnd(struct scsi_cmnd *cmnd)
 }
 
 /* Deletes (stops) timers or work queues of all queued commands */
-static void stop_all_queued(void)
+static void stop_all_queued(bool done_with_no_conn)
 {
 	unsigned long iflags;
 	int j, k;
@@ -5120,13 +5128,15 @@ static void stop_all_queued(void)
 	struct sdebug_queued_cmd *sqcp;
 	struct sdebug_dev_info *devip;
 	struct sdebug_defer *sd_dp;
+	struct scsi_cmnd *scp;
 
 	for (j = 0, sqp = sdebug_q_arr; j < submit_queues; ++j, ++sqp) {
 		spin_lock_irqsave(&sqp->qc_lock, iflags);
 		for (k = 0; k < SDEBUG_CANQUEUE; ++k) {
 			if (test_bit(k, sqp->in_use_bm)) {
 				sqcp = &sqp->qc_arr[k];
-				if (sqcp->a_cmnd == NULL)
+				scp = sqcp->a_cmnd;
+				if (!scp)
 					continue;
 				devip = (struct sdebug_dev_info *)
 					sqcp->a_cmnd->device->hostdata;
@@ -5141,6 +5151,10 @@ static void stop_all_queued(void)
 					l_defer_t = SDEB_DEFER_NONE;
 				spin_unlock_irqrestore(&sqp->qc_lock, iflags);
 				stop_qc_helper(sd_dp, l_defer_t);
+				if (done_with_no_conn && l_defer_t != SDEB_DEFER_NONE) {
+					scp->result = DID_NO_CONNECT << 16;
+					scsi_done(scp);
+				}
 				clear_bit(k, sqp->in_use_bm);
 				spin_lock_irqsave(&sqp->qc_lock, iflags);
 			}
@@ -5283,7 +5297,7 @@ static int scsi_debug_host_reset(struct scsi_cmnd *SCpnt)
 		}
 	}
 	spin_unlock(&sdebug_host_list_lock);
-	stop_all_queued();
+	stop_all_queued(false);
 	if (SDEBUG_OPT_RESET_NOISE & sdebug_opts)
 		sdev_printk(KERN_INFO, SCpnt->device,
 			    "%s: %d device(s) found\n", __func__, k);
@@ -5343,13 +5357,50 @@ static void sdebug_build_parts(unsigned char *ramp, unsigned long store_size)
 	}
 }
 
-static void block_unblock_all_queues(bool block)
+static void sdeb_block_all_queues(void)
+{
+	int j;
+	struct sdebug_queue *sqp;
+
+	for (j = 0, sqp = sdebug_q_arr; j < submit_queues; ++j, ++sqp)
+		atomic_set(&sqp->blocked, (int)true);
+}
+
+static void sdeb_unblock_all_queues(void)
 {
 	int j;
 	struct sdebug_queue *sqp;
 
 	for (j = 0, sqp = sdebug_q_arr; j < submit_queues; ++j, ++sqp)
-		atomic_set(&sqp->blocked, (int)block);
+		atomic_set(&sqp->blocked, (int)false);
+}
+
+static void
+sdeb_add_n_hosts(int num_hosts)
+{
+	if (num_hosts < 1)
+		return;
+	do {
+		bool found;
+		unsigned long idx;
+		struct sdeb_store_info *sip;
+		bool want_phs = (sdebug_fake_rw == 0) && sdebug_per_host_store;
+
+		found = false;
+		if (want_phs) {
+			xa_for_each_marked(per_store_ap, idx, sip, SDEB_XA_NOT_IN_USE) {
+				sdeb_most_recent_idx = (int)idx;
+				found = true;
+				break;
+			}
+			if (found)	/* re-use case */
+				sdebug_add_host_helper((int)idx);
+			else
+				sdebug_do_add_host(true	/* make new store */);
+		} else {
+			sdebug_do_add_host(false);
+		}
+	} while (--num_hosts);
 }
 
 /* Adjust (by rounding down) the sdebug_cmnd_count so abs(every_nth)-1
@@ -5362,10 +5413,10 @@ static void tweak_cmnd_count(void)
 	modulo = abs(sdebug_every_nth);
 	if (modulo < 2)
 		return;
-	block_unblock_all_queues(true);
+	sdeb_block_all_queues();
 	count = atomic_read(&sdebug_cmnd_count);
 	atomic_set(&sdebug_cmnd_count, (count / modulo) * modulo);
-	block_unblock_all_queues(false);
+	sdeb_unblock_all_queues();
 }
 
 static void clear_queue_stats(void)
@@ -5383,6 +5434,15 @@ static bool inject_on_this_cmd(void)
 	return (atomic_read(&sdebug_cmnd_count) % abs(sdebug_every_nth)) == 0;
 }
 
+static int process_deflect_incoming(struct scsi_cmnd *scp)
+{
+	u8 opcode = scp->cmnd[0];
+
+	if (opcode == SYNCHRONIZE_CACHE || opcode == SYNCHRONIZE_CACHE_16)
+		return 0;
+	return DID_NO_CONNECT << 16;
+}
+
 #define INCLUSIVE_TIMING_MAX_NS 1000000		/* 1 millisecond */
 
 /* Complete the processing of the thread that queued a SCSI command to this
@@ -5392,8 +5452,7 @@ static bool inject_on_this_cmd(void)
  */
 static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 			 int scsi_result,
-			 int (*pfp)(struct scsi_cmnd *,
-				    struct sdebug_dev_info *),
+			 int (*pfp)(struct scsi_cmnd *, struct sdebug_dev_info *),
 			 int delta_jiff, int ndelay)
 {
 	bool new_sd_dp;
@@ -5414,13 +5473,27 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 	}
 	sdp = cmnd->device;
 
-	if (delta_jiff == 0)
+	if (delta_jiff == 0) {
+		sqp = get_queue(cmnd);
+		if (atomic_read(&sqp->blocked)) {
+			if (smp_load_acquire(&sdebug_deflect_incoming))
+				return process_deflect_incoming(cmnd);
+			else
+				return SCSI_MLQUEUE_HOST_BUSY;
+		}
 		goto respond_in_thread;
+	}
 
 	sqp = get_queue(cmnd);
 	spin_lock_irqsave(&sqp->qc_lock, iflags);
 	if (unlikely(atomic_read(&sqp->blocked))) {
 		spin_unlock_irqrestore(&sqp->qc_lock, iflags);
+		if (smp_load_acquire(&sdebug_deflect_incoming)) {
+			scsi_result = process_deflect_incoming(cmnd);
+			goto respond_in_thread;
+		}
+		if (sdebug_verbose)
+			pr_info("blocked --> SCSI_MLQUEUE_HOST_BUSY\n");
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 	num_in_q = atomic_read(&devip->num_in_q);
@@ -5616,8 +5689,12 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 respond_in_thread:	/* call back to mid-layer using invocation thread */
 	cmnd->result = pfp != NULL ? pfp(cmnd, devip) : 0;
 	cmnd->result &= ~SDEG_RES_IMMED_MASK;
-	if (cmnd->result == 0 && scsi_result != 0)
+	if (cmnd->result == 0 && scsi_result != 0) {
 		cmnd->result = scsi_result;
+		if (sdebug_verbose)
+			pr_info("respond_in_thread: tag=0x%x, scp->result=0x%x\n",
+				blk_mq_unique_tag(scsi_cmd_to_rq(cmnd)), scsi_result);
+	}
 	scsi_done(cmnd);
 	return 0;
 }
@@ -5900,7 +5977,7 @@ static ssize_t delay_store(struct device_driver *ddp, const char *buf,
 			int j, k;
 			struct sdebug_queue *sqp;
 
-			block_unblock_all_queues(true);
+			sdeb_block_all_queues();
 			for (j = 0, sqp = sdebug_q_arr; j < submit_queues;
 			     ++j, ++sqp) {
 				k = find_first_bit(sqp->in_use_bm,
@@ -5914,7 +5991,7 @@ static ssize_t delay_store(struct device_driver *ddp, const char *buf,
 				sdebug_jdelay = jdelay;
 				sdebug_ndelay = 0;
 			}
-			block_unblock_all_queues(false);
+			sdeb_unblock_all_queues();
 		}
 		return res;
 	}
@@ -5940,7 +6017,7 @@ static ssize_t ndelay_store(struct device_driver *ddp, const char *buf,
 			int j, k;
 			struct sdebug_queue *sqp;
 
-			block_unblock_all_queues(true);
+			sdeb_block_all_queues();
 			for (j = 0, sqp = sdebug_q_arr; j < submit_queues;
 			     ++j, ++sqp) {
 				k = find_first_bit(sqp->in_use_bm,
@@ -5955,7 +6032,7 @@ static ssize_t ndelay_store(struct device_driver *ddp, const char *buf,
 				sdebug_jdelay = ndelay  ? JDELAY_OVERRIDDEN
 							: DEF_JDELAY;
 			}
-			block_unblock_all_queues(false);
+			sdeb_unblock_all_queues();
 		}
 		return res;
 	}
@@ -6269,7 +6346,7 @@ static ssize_t max_queue_store(struct device_driver *ddp, const char *buf,
 	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n > 0) &&
 	    (n <= SDEBUG_CANQUEUE) &&
 	    (sdebug_host_max_queue == 0)) {
-		block_unblock_all_queues(true);
+		sdeb_block_all_queues();
 		k = 0;
 		for (j = 0, sqp = sdebug_q_arr; j < submit_queues;
 		     ++j, ++sqp) {
@@ -6284,7 +6361,7 @@ static ssize_t max_queue_store(struct device_driver *ddp, const char *buf,
 			atomic_set(&retired_max_queue, k + 1);
 		else
 			atomic_set(&retired_max_queue, 0);
-		block_unblock_all_queues(false);
+		sdeb_unblock_all_queues();
 		return count;
 	}
 	return -EINVAL;
@@ -6356,43 +6433,48 @@ static DRIVER_ATTR_RW(virtual_gb);
 static ssize_t add_host_show(struct device_driver *ddp, char *buf)
 {
 	/* absolute number of hosts currently active is what is shown */
-	return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_num_hosts);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", atomic_read(&sdebug_num_hosts));
 }
 
+/*
+ * Accept positive and negative values. Hex values (only positive) may be prefixed by '0x'.
+ * To remove all hosts use a large negative number (e.g. -9999). The value 0 does nothing.
+ * Returns -EBUSY if another add_host sysfs invocation is active.
+ */
 static ssize_t add_host_store(struct device_driver *ddp, const char *buf,
 			      size_t count)
 {
-	bool found;
-	unsigned long idx;
-	struct sdeb_store_info *sip;
-	bool want_phs = (sdebug_fake_rw == 0) && sdebug_per_host_store;
 	int delta_hosts;
 
-	if (sscanf(buf, "%d", &delta_hosts) != 1)
+	if (count == 0 || kstrtoint(buf, 0, &delta_hosts))
 		return -EINVAL;
+	if (sdebug_verbose)
+		pr_info("prior num_hosts=%d, num_to_add=%d\n",
+			atomic_read(&sdebug_num_hosts), delta_hosts);
+	if (delta_hosts == 0)
+		return count;
+	if (mutex_trylock(&add_host_mutex) == 0)
+		return -EBUSY;
 	if (delta_hosts > 0) {
-		do {
-			found = false;
-			if (want_phs) {
-				xa_for_each_marked(per_store_ap, idx, sip,
-						   SDEB_XA_NOT_IN_USE) {
-					sdeb_most_recent_idx = (int)idx;
-					found = true;
-					break;
-				}
-				if (found)	/* re-use case */
-					sdebug_add_host_helper((int)idx);
-				else
-					sdebug_do_add_host(true);
-			} else {
-				sdebug_do_add_host(false);
-			}
-		} while (--delta_hosts);
+		sdeb_add_n_hosts(delta_hosts);
 	} else if (delta_hosts < 0) {
+		smp_store_release(&sdebug_deflect_incoming, true);
+		sdeb_block_all_queues();
+		if (delta_hosts >= atomic_read(&sdebug_num_hosts))
+			stop_all_queued(true);
 		do {
+			if (atomic_read(&sdebug_num_hosts) < 1) {
+				free_all_queued();
+				break;
+			}
 			sdebug_do_remove_host(false);
 		} while (++delta_hosts);
+		sdeb_unblock_all_queues();
+		smp_store_release(&sdebug_deflect_incoming, false);
 	}
+	mutex_unlock(&add_host_mutex);
+	if (sdebug_verbose)
+		pr_info("post num_hosts=%d\n", atomic_read(&sdebug_num_hosts));
 	return count;
 }
 static DRIVER_ATTR_RW(add_host);
@@ -6902,6 +6984,10 @@ static int __init scsi_debug_init(void)
 	sdebug_add_host = 0;
 
 	for (k = 0; k < hosts_to_add; k++) {
+		if (smp_load_acquire(&sdebug_deflect_incoming)) {
+			pr_info("exit early as sdebug_deflect_incoming is set\n");
+			return 0;
+		}
 		if (want_store && k == 0) {
 			ret = sdebug_add_host_helper(idx);
 			if (ret < 0) {
@@ -6919,8 +7005,12 @@ static int __init scsi_debug_init(void)
 		}
 	}
 	if (sdebug_verbose)
-		pr_info("built %d host(s)\n", sdebug_num_hosts);
+		pr_info("built %d host(s)\n", atomic_read(&sdebug_num_hosts));
 
+	/*
+	 * Even though all the hosts have been established, due to async device (LU) scanning
+	 * by the scsi mid-level, there may still be devices (LUs) being set up.
+	 */
 	return 0;
 
 bus_unreg:
@@ -6936,12 +7026,17 @@ static int __init scsi_debug_init(void)
 
 static void __exit scsi_debug_exit(void)
 {
-	int k = sdebug_num_hosts;
+	int k;
 
-	stop_all_queued();
-	for (; k; k--)
+	/* Possible race with LUs still being set up; stop them asap */
+	sdeb_block_all_queues();
+	smp_store_release(&sdebug_deflect_incoming, true);
+	stop_all_queued(false);
+	for (k = 0; atomic_read(&sdebug_num_hosts) > 0; k++)
 		sdebug_do_remove_host(true);
 	free_all_queued();
+	if (sdebug_verbose)
+		pr_info("removed %d hosts\n", k);
 	driver_unregister(&sdebug_driverfs_driver);
 	bus_unregister(&pseudo_lld_bus);
 	root_device_unregister(pseudo_primary);
@@ -7111,13 +7206,13 @@ static int sdebug_add_host_helper(int per_host_idx)
 	sdbg_host->dev.bus = &pseudo_lld_bus;
 	sdbg_host->dev.parent = pseudo_primary;
 	sdbg_host->dev.release = &sdebug_release_adapter;
-	dev_set_name(&sdbg_host->dev, "adapter%d", sdebug_num_hosts);
+	dev_set_name(&sdbg_host->dev, "adapter%d", atomic_read(&sdebug_num_hosts));
 
 	error = device_register(&sdbg_host->dev);
 	if (error)
 		goto clean;
 
-	++sdebug_num_hosts;
+	atomic_inc(&sdebug_num_hosts);
 	return 0;
 
 clean:
@@ -7181,7 +7276,7 @@ static void sdebug_do_remove_host(bool the_end)
 		return;
 
 	device_unregister(&sdbg_host->dev);
-	--sdebug_num_hosts;
+	atomic_dec(&sdebug_num_hosts);
 }
 
 static int sdebug_change_qdepth(struct scsi_device *sdev, int qdepth)
@@ -7189,10 +7284,10 @@ static int sdebug_change_qdepth(struct scsi_device *sdev, int qdepth)
 	int num_in_q = 0;
 	struct sdebug_dev_info *devip;
 
-	block_unblock_all_queues(true);
+	sdeb_block_all_queues();
 	devip = (struct sdebug_dev_info *)sdev->hostdata;
 	if (NULL == devip) {
-		block_unblock_all_queues(false);
+		sdeb_unblock_all_queues();
 		return	-ENODEV;
 	}
 	num_in_q = atomic_read(&devip->num_in_q);
@@ -7211,7 +7306,7 @@ static int sdebug_change_qdepth(struct scsi_device *sdev, int qdepth)
 		sdev_printk(KERN_INFO, sdev, "%s: qdepth=%d, num_in_q=%d\n",
 			    __func__, qdepth, num_in_q);
 	}
-	block_unblock_all_queues(false);
+	sdeb_unblock_all_queues();
 	return sdev->queue_depth;
 }
 
-- 
2.34.1

