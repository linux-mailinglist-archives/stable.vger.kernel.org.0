Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAE5C1631B9
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728230AbgBRUCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 15:02:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:42614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728914AbgBRUCV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 15:02:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C843424125;
        Tue, 18 Feb 2020 20:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582056141;
        bh=mDbcaI0GS6+deQxhKF0GGzKKQveWFWhYfGzi7xXXqQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lLonYZE80CH6h0bkLX+UAVE3BR9qn+XlXQBKdH1QoVSl0bU3XH3y750OB3c+41WUz
         PnmUmYR9AJFCJsS08GDy5ZFFfhT3lh8WfNtxaUqwoIVDaEV4Rxfkjhvge5O+rvmDxR
         Tu1tHfosDswrhEOqeiYIpAjdfMPSPfR3ut9SWdZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Kaike Wan <kaike.wan@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.5 51/80] IB/rdmavt: Reset all QPs when the device is shut down
Date:   Tue, 18 Feb 2020 20:55:12 +0100
Message-Id: <20200218190437.097828202@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190432.043414522@linuxfoundation.org>
References: <20200218190432.043414522@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kaike Wan <kaike.wan@intel.com>

commit f92e48718889b3d49cee41853402aa88cac84a6b upstream.

When the hfi1 device is shut down during a system reboot, it is possible
that some QPs might have not not freed by ULPs. More requests could be
post sent and a lingering timer could be triggered to schedule more packet
sends, leading to a crash:

  BUG: unable to handle kernel NULL pointer dereference at 0000000000000102
  IP: [ffffffff810a65f2] __queue_work+0x32/0x3c0
  PGD 0
  Oops: 0000 1 SMP
  Modules linked in: nvmet_rdma(OE) nvmet(OE) nvme(OE) dm_round_robin nvme_rdma(OE) nvme_fabrics(OE) nvme_core(OE) pal_raw(POE) pal_pmt(POE) pal_cache(POE) pal_pile(POE) pal(POE) pal_compatible(OE) rpcrdma sunrpc ib_isert iscsi_target_mod target_core_mod ib_iser libiscsi scsi_transport_iscsi ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm mlx4_ib sb_edac edac_core intel_powerclamp coretemp intel_rapl iosf_mbi kvm irqbypass crc32_pclmul ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper ablk_helper cryptd iTCO_wdt iTCO_vendor_support mxm_wmi ipmi_ssif pcspkr ses enclosure joydev scsi_transport_sas i2c_i801 sg mei_me lpc_ich mei ioatdma shpchp ipmi_si ipmi_devintf ipmi_msghandler wmi acpi_power_meter acpi_pad dm_multipath hangcheck_timer ip_tables ext4 mbcache jbd2 mlx4_en
  sd_mod crc_t10dif crct10dif_generic mgag200 drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm mlx4_core crct10dif_pclmul crct10dif_common hfi1(OE) igb crc32c_intel rdmavt(OE) ahci ib_core libahci libata ptp megaraid_sas pps_core dca i2c_algo_bit i2c_core devlink dm_mirror dm_region_hash dm_log dm_mod
  CPU: 23 PID: 0 Comm: swapper/23 Tainted: P OE ------------ 3.10.0-693.el7.x86_64 #1
  Hardware name: Intel Corporation S2600CWR/S2600CWR, BIOS SE5C610.86B.01.01.0028.121720182203 12/17/2018
  task: ffff8808f4ec4f10 ti: ffff8808f4ed8000 task.ti: ffff8808f4ed8000
  RIP: 0010:[ffffffff810a65f2] [ffffffff810a65f2] __queue_work+0x32/0x3c0
  RSP: 0018:ffff88105df43d48 EFLAGS: 00010046
  RAX: 0000000000000086 RBX: 0000000000000086 RCX: 0000000000000000
  RDX: ffff880f74e758b0 RSI: 0000000000000000 RDI: 000000000000001f
  RBP: ffff88105df43d80 R08: ffff8808f3c583c8 R09: ffff8808f3c58000
  R10: 0000000000000002 R11: ffff88105df43da8 R12: ffff880f74e758b0
  R13: 000000000000001f R14: 0000000000000000 R15: ffff88105a300000
  FS: 0000000000000000(0000) GS:ffff88105df40000(0000) knlGS:0000000000000000
  CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000102 CR3: 00000000019f2000 CR4: 00000000001407e0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
  Stack:
  ffff88105b6dd708 0000001f00000286 0000000000000086 ffff88105a300000
  ffff880f74e75800 0000000000000000 ffff88105a300000 ffff88105df43d98
  ffffffff810a6b85 ffff88105a301e80 ffff88105df43dc8 ffffffffc0224cde
  Call Trace:
  IRQ

  [ffffffff810a6b85] queue_work_on+0x45/0x50
  [ffffffffc0224cde] _hfi1_schedule_send+0x6e/0xc0 [hfi1]
  [ffffffffc0170570] ? get_map_page+0x60/0x60 [rdmavt]
  [ffffffffc0224d62] hfi1_schedule_send+0x32/0x70 [hfi1]
  [ffffffffc0170644] rvt_rc_timeout+0xd4/0x120 [rdmavt]
  [ffffffffc0170570] ? get_map_page+0x60/0x60 [rdmavt]
  [ffffffff81097316] call_timer_fn+0x36/0x110
  [ffffffffc0170570] ? get_map_page+0x60/0x60 [rdmavt]
  [ffffffff8109982d] run_timer_softirq+0x22d/0x310
  [ffffffff81090b3f] __do_softirq+0xef/0x280
  [ffffffff816b6a5c] call_softirq+0x1c/0x30
  [ffffffff8102d3c5] do_softirq+0x65/0xa0
  [ffffffff81090ec5] irq_exit+0x105/0x110
  [ffffffff816b76c2] smp_apic_timer_interrupt+0x42/0x50
  [ffffffff816b5c1d] apic_timer_interrupt+0x6d/0x80
  EOI

  [ffffffff81527a02] ? cpuidle_enter_state+0x52/0xc0
  [ffffffff81527b48] cpuidle_idle_call+0xd8/0x210
  [ffffffff81034fee] arch_cpu_idle+0xe/0x30
  [ffffffff810e7bca] cpu_startup_entry+0x14a/0x1c0
  [ffffffff81051af6] start_secondary+0x1b6/0x230
  Code: 89 e5 41 57 41 56 49 89 f6 41 55 41 89 fd 41 54 49 89 d4 53 48 83 ec 10 89 7d d4 9c 58 0f 1f 44 00 00 f6 c4 02 0f 85 be 02 00 00 41 f6 86 02 01 00 00 01 0f 85 58 02 00 00 49 c7 c7 28 19 01 00
  RIP [ffffffff810a65f2] __queue_work+0x32/0x3c0
  RSP ffff88105df43d48
  CR2: 0000000000000102

The solution is to reset the QPs before the device resources are freed.
This reset will change the QP state to prevent post sends and delete
timers to prevent callbacks.

Fixes: 0acb0cc7ecc1 ("IB/rdmavt: Initialize and teardown of qpn table")
Link: https://lore.kernel.org/r/20200210131040.87408.38161.stgit@awfm-01.aw.intel.com
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/sw/rdmavt/qp.c |   84 +++++++++++++++++++++++---------------
 1 file changed, 51 insertions(+), 33 deletions(-)

--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -61,6 +61,8 @@
 #define RVT_RWQ_COUNT_THRESHOLD 16
 
 static void rvt_rc_timeout(struct timer_list *t);
+static void rvt_reset_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp,
+			 enum ib_qp_type type);
 
 /*
  * Convert the AETH RNR timeout code into the number of microseconds.
@@ -452,40 +454,41 @@ no_qp_table:
 }
 
 /**
- * free_all_qps - check for QPs still in use
+ * rvt_free_qp_cb - callback function to reset a qp
+ * @qp: the qp to reset
+ * @v: a 64-bit value
+ *
+ * This function resets the qp and removes it from the
+ * qp hash table.
+ */
+static void rvt_free_qp_cb(struct rvt_qp *qp, u64 v)
+{
+	unsigned int *qp_inuse = (unsigned int *)v;
+	struct rvt_dev_info *rdi = ib_to_rvt(qp->ibqp.device);
+
+	/* Reset the qp and remove it from the qp hash list */
+	rvt_reset_qp(rdi, qp, qp->ibqp.qp_type);
+
+	/* Increment the qp_inuse count */
+	(*qp_inuse)++;
+}
+
+/**
+ * rvt_free_all_qps - check for QPs still in use
  * @rdi: rvt device info structure
  *
  * There should not be any QPs still in use.
  * Free memory for table.
+ * Return the number of QPs still in use.
  */
 static unsigned rvt_free_all_qps(struct rvt_dev_info *rdi)
 {
-	unsigned long flags;
-	struct rvt_qp *qp;
-	unsigned n, qp_inuse = 0;
-	spinlock_t *ql; /* work around too long line below */
-
-	if (rdi->driver_f.free_all_qps)
-		qp_inuse = rdi->driver_f.free_all_qps(rdi);
+	unsigned int qp_inuse = 0;
 
 	qp_inuse += rvt_mcast_tree_empty(rdi);
 
-	if (!rdi->qp_dev)
-		return qp_inuse;
+	rvt_qp_iter(rdi, (u64)&qp_inuse, rvt_free_qp_cb);
 
-	ql = &rdi->qp_dev->qpt_lock;
-	spin_lock_irqsave(ql, flags);
-	for (n = 0; n < rdi->qp_dev->qp_table_size; n++) {
-		qp = rcu_dereference_protected(rdi->qp_dev->qp_table[n],
-					       lockdep_is_held(ql));
-		RCU_INIT_POINTER(rdi->qp_dev->qp_table[n], NULL);
-
-		for (; qp; qp = rcu_dereference_protected(qp->next,
-							  lockdep_is_held(ql)))
-			qp_inuse++;
-	}
-	spin_unlock_irqrestore(ql, flags);
-	synchronize_rcu();
 	return qp_inuse;
 }
 
@@ -902,14 +905,14 @@ static void rvt_init_qp(struct rvt_dev_i
 }
 
 /**
- * rvt_reset_qp - initialize the QP state to the reset state
+ * _rvt_reset_qp - initialize the QP state to the reset state
  * @qp: the QP to reset
  * @type: the QP type
  *
  * r_lock, s_hlock, and s_lock are required to be held by the caller
  */
-static void rvt_reset_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp,
-			 enum ib_qp_type type)
+static void _rvt_reset_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp,
+			  enum ib_qp_type type)
 	__must_hold(&qp->s_lock)
 	__must_hold(&qp->s_hlock)
 	__must_hold(&qp->r_lock)
@@ -955,6 +958,27 @@ static void rvt_reset_qp(struct rvt_dev_
 	lockdep_assert_held(&qp->s_lock);
 }
 
+/**
+ * rvt_reset_qp - initialize the QP state to the reset state
+ * @rdi: the device info
+ * @qp: the QP to reset
+ * @type: the QP type
+ *
+ * This is the wrapper function to acquire the r_lock, s_hlock, and s_lock
+ * before calling _rvt_reset_qp().
+ */
+static void rvt_reset_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp,
+			 enum ib_qp_type type)
+{
+	spin_lock_irq(&qp->r_lock);
+	spin_lock(&qp->s_hlock);
+	spin_lock(&qp->s_lock);
+	_rvt_reset_qp(rdi, qp, type);
+	spin_unlock(&qp->s_lock);
+	spin_unlock(&qp->s_hlock);
+	spin_unlock_irq(&qp->r_lock);
+}
+
 /** rvt_free_qpn - Free a qpn from the bit map
  * @qpt: QP table
  * @qpn: queue pair number to free
@@ -1546,7 +1570,7 @@ int rvt_modify_qp(struct ib_qp *ibqp, st
 	switch (new_state) {
 	case IB_QPS_RESET:
 		if (qp->state != IB_QPS_RESET)
-			rvt_reset_qp(rdi, qp, ibqp->qp_type);
+			_rvt_reset_qp(rdi, qp, ibqp->qp_type);
 		break;
 
 	case IB_QPS_RTR:
@@ -1695,13 +1719,7 @@ int rvt_destroy_qp(struct ib_qp *ibqp, s
 	struct rvt_qp *qp = ibqp_to_rvtqp(ibqp);
 	struct rvt_dev_info *rdi = ib_to_rvt(ibqp->device);
 
-	spin_lock_irq(&qp->r_lock);
-	spin_lock(&qp->s_hlock);
-	spin_lock(&qp->s_lock);
 	rvt_reset_qp(rdi, qp, ibqp->qp_type);
-	spin_unlock(&qp->s_lock);
-	spin_unlock(&qp->s_hlock);
-	spin_unlock_irq(&qp->r_lock);
 
 	wait_event(qp->wait, !atomic_read(&qp->refcount));
 	/* qpn is now available for use again */


