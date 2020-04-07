Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB2531A030F
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 02:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbgDGAGF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Apr 2020 20:06:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:36714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727994AbgDGACV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Apr 2020 20:02:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C89F32078A;
        Tue,  7 Apr 2020 00:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586217740;
        bh=zb7CPgpDosGnXvuzcznJMfLK+4GbFLZXEzAV3QlAoH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J5QrcfRKR1SPbWs/i21DIig0zuj2GA8znuKFIgGkK8BQ2iSUoY5JJxSyHTGSPqBhK
         CtVd1yGL/QKduvKW9RKBn2fHV6Pp06oIvOwcJKC0veGVJXkRNTihg+BqgD5Ow1dklm
         fmRRcIiahLxqRuy+VNpa8jTtSZcs3qfaPKHbjSwY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Kaike Wan <kaike.wan@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 23/32] IB/hfi1: Ensure pq is not left on waitlist
Date:   Mon,  6 Apr 2020 20:01:41 -0400
Message-Id: <20200407000151.16768-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200407000151.16768-1-sashal@kernel.org>
References: <20200407000151.16768-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

[ Upstream commit 9a293d1e21a6461a11b4217b155bf445e57f4131 ]

The following warning can occur when a pq is left on the dmawait list and
the pq is then freed:

  WARNING: CPU: 47 PID: 3546 at lib/list_debug.c:29 __list_add+0x65/0xc0
  list_add corruption. next->prev should be prev (ffff939228da1880), but was ffff939cabb52230. (next=ffff939cabb52230).
  Modules linked in: mmfs26(OE) mmfslinux(OE) tracedev(OE) 8021q garp mrp ib_isert iscsi_target_mod target_core_mod crc_t10dif crct10dif_generic opa_vnic rpcrdma ib_iser libiscsi scsi_transport_iscsi ib_ipoib(OE) bridge stp llc iTCO_wdt iTCO_vendor_support intel_powerclamp coretemp intel_rapl iosf_mbi kvm_intel kvm irqbypass crct10dif_pclmul crct10dif_common crc32_pclmul ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper ablk_helper cryptd ast ttm drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm pcspkr joydev drm_panel_orientation_quirks i2c_i801 mei_me lpc_ich mei wmi ipmi_si ipmi_devintf ipmi_msghandler nfit libnvdimm acpi_power_meter acpi_pad hfi1(OE) rdmavt(OE) rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_core binfmt_misc numatools(OE) xpmem(OE) ip_tables
  nfsv3 nfs_acl nfs lockd grace sunrpc fscache igb ahci libahci i2c_algo_bit dca libata ptp pps_core crc32c_intel [last unloaded: i2c_algo_bit]
  CPU: 47 PID: 3546 Comm: wrf.exe Kdump: loaded Tainted: G W OE ------------ 3.10.0-957.41.1.el7.x86_64 #1
  Hardware name: HPE.COM HPE SGI 8600-XA730i Gen10/X11DPT-SB-SG007, BIOS SBED1229 01/22/2019
  Call Trace:
  [<ffffffff91f65ac0>] dump_stack+0x19/0x1b
  [<ffffffff91898b78>] __warn+0xd8/0x100
  [<ffffffff91898bff>] warn_slowpath_fmt+0x5f/0x80
  [<ffffffff91a1dabe>] ? ___slab_alloc+0x24e/0x4f0
  [<ffffffff91b97025>] __list_add+0x65/0xc0
  [<ffffffffc03926a5>] defer_packet_queue+0x145/0x1a0 [hfi1]
  [<ffffffffc0372987>] sdma_check_progress+0x67/0xa0 [hfi1]
  [<ffffffffc03779d2>] sdma_send_txlist+0x432/0x550 [hfi1]
  [<ffffffff91a20009>] ? kmem_cache_alloc+0x179/0x1f0
  [<ffffffffc0392973>] ? user_sdma_send_pkts+0xc3/0x1990 [hfi1]
  [<ffffffffc0393e3a>] user_sdma_send_pkts+0x158a/0x1990 [hfi1]
  [<ffffffff918ab65e>] ? try_to_del_timer_sync+0x5e/0x90
  [<ffffffff91a3fe1a>] ? __check_object_size+0x1ca/0x250
  [<ffffffffc0395546>] hfi1_user_sdma_process_request+0xd66/0x1280 [hfi1]
  [<ffffffffc034e0da>] hfi1_aio_write+0xca/0x120 [hfi1]
  [<ffffffff91a4245b>] do_sync_readv_writev+0x7b/0xd0
  [<ffffffff91a4409e>] do_readv_writev+0xce/0x260
  [<ffffffff918df69f>] ? pick_next_task_fair+0x5f/0x1b0
  [<ffffffff918db535>] ? sched_clock_cpu+0x85/0xc0
  [<ffffffff91f6b16a>] ? __schedule+0x13a/0x860
  [<ffffffff91a442c5>] vfs_writev+0x35/0x60
  [<ffffffff91a4447f>] SyS_writev+0x7f/0x110
  [<ffffffff91f78ddb>] system_call_fastpath+0x22/0x27

The issue happens when wait_event_interruptible_timeout() returns a value
<= 0.

In that case, the pq is left on the list. The code continues sending
packets and potentially can complete the current request with the pq still
on the dmawait list provided no descriptor shortage is seen.

If the pq is torn down in that state, the sdma interrupt handler could
find the now freed pq on the list with list corruption or memory
corruption resulting.

Fix by adding a flush routine to ensure that the pq is never on a list
after processing a request.

A follow-up patch series will address issues with seqlock surfaced in:
https://lore.kernel.org/r/20200320003129.GP20941@ziepe.ca

The seqlock use for sdma will then be converted to a spin lock since the
list_empty() doesn't need the protection afforded by the sequence lock
currently in use.

Fixes: a0d406934a46 ("staging/rdma/hfi1: Add page lock limit check for SDMA requests")
Link: https://lore.kernel.org/r/20200320200200.23203.37777.stgit@awfm-01.aw.intel.com
Reviewed-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/user_sdma.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index c2f0d9ba93de1..13e4203497b33 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -141,6 +141,7 @@ static int defer_packet_queue(
 	 */
 	xchg(&pq->state, SDMA_PKT_Q_DEFERRED);
 	if (list_empty(&pq->busy.list)) {
+		pq->busy.lock = &sde->waitlock;
 		iowait_get_priority(&pq->busy);
 		iowait_queue(pkts_sent, &pq->busy, &sde->dmawait);
 	}
@@ -155,6 +156,7 @@ static void activate_packet_queue(struct iowait *wait, int reason)
 {
 	struct hfi1_user_sdma_pkt_q *pq =
 		container_of(wait, struct hfi1_user_sdma_pkt_q, busy);
+	pq->busy.lock = NULL;
 	xchg(&pq->state, SDMA_PKT_Q_ACTIVE);
 	wake_up(&wait->wait_dma);
 };
@@ -256,6 +258,21 @@ int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt,
 	return ret;
 }
 
+static void flush_pq_iowait(struct hfi1_user_sdma_pkt_q *pq)
+{
+	unsigned long flags;
+	seqlock_t *lock = pq->busy.lock;
+
+	if (!lock)
+		return;
+	write_seqlock_irqsave(lock, flags);
+	if (!list_empty(&pq->busy.list)) {
+		list_del_init(&pq->busy.list);
+		pq->busy.lock = NULL;
+	}
+	write_sequnlock_irqrestore(lock, flags);
+}
+
 int hfi1_user_sdma_free_queues(struct hfi1_filedata *fd,
 			       struct hfi1_ctxtdata *uctxt)
 {
@@ -281,6 +298,7 @@ int hfi1_user_sdma_free_queues(struct hfi1_filedata *fd,
 		kfree(pq->reqs);
 		kfree(pq->req_in_use);
 		kmem_cache_destroy(pq->txreq_cache);
+		flush_pq_iowait(pq);
 		kfree(pq);
 	} else {
 		spin_unlock(&fd->pq_rcu_lock);
@@ -587,11 +605,12 @@ int hfi1_user_sdma_process_request(struct hfi1_filedata *fd,
 		if (ret < 0) {
 			if (ret != -EBUSY)
 				goto free_req;
-			wait_event_interruptible_timeout(
+			if (wait_event_interruptible_timeout(
 				pq->busy.wait_dma,
-				(pq->state == SDMA_PKT_Q_ACTIVE),
+				pq->state == SDMA_PKT_Q_ACTIVE,
 				msecs_to_jiffies(
-					SDMA_IOWAIT_TIMEOUT));
+					SDMA_IOWAIT_TIMEOUT)) <= 0)
+				flush_pq_iowait(pq);
 		}
 	}
 	*count += idx;
-- 
2.20.1

