Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93A4C206042
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403856AbgFWUk6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:40:58 -0400
Received: from mga05.intel.com ([192.55.52.43]:48931 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392286AbgFWUku (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:40:50 -0400
IronPort-SDR: uiJAvkptwytyjB/tHTwenDZYqSTScJuiVzWBxORZDWs889GhFLdl8IZMeEHh5oW2Ej1Lsus4c5
 +9Ewdl0BIxZQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9661"; a="228910642"
X-IronPort-AV: E=Sophos;i="5.75,272,1589266800"; 
   d="scan'208";a="228910642"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2020 13:40:50 -0700
IronPort-SDR: +wkx2SskWNjo8V+Z8bl3PJt3Bs7P/857WW3VmrCcobxQjomRVX7zs/f0E2PYs/A2t6U4PsGqfy
 QyPzp1gD/0Tg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,272,1589266800"; 
   d="scan'208";a="287819228"
Received: from sedona.ch.intel.com ([10.2.136.157])
  by orsmga007.jf.intel.com with ESMTP; 23 Jun 2020 13:40:49 -0700
Received: from awfm-01.aw.intel.com (awfm-01.aw.intel.com [10.228.212.213])
        by sedona.ch.intel.com (8.14.3/8.14.3/Standard MailSET/Hub) with ESMTP id 05NKemQQ057568;
        Tue, 23 Jun 2020 13:40:49 -0700
Received: from awfm-01.aw.intel.com (localhost [127.0.0.1])
        by awfm-01.aw.intel.com (8.14.7/8.14.7) with ESMTP id 05NKelp5107976;
        Tue, 23 Jun 2020 16:40:47 -0400
Subject: [PATCH for-rc v2 1/2] IB/hfi1: Do not destroy hfi1_wq when the
 device is shut down
From:   Dennis Dalessandro <dennis.dalessandro@intel.com>
To:     jgg@ziepe.ca, dledford@redhat.com
Cc:     linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>
Date:   Tue, 23 Jun 2020 16:40:47 -0400
Message-ID: <20200623204047.107638.77646.stgit@awfm-01.aw.intel.com>
In-Reply-To: <20200623203524.107638.62465.stgit@awfm-01.aw.intel.com>
References: <20200623203524.107638.62465.stgit@awfm-01.aw.intel.com>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kaike Wan <kaike.wan@intel.com>

The workqueue hfi1_wq is destroyed in function shutdown_device(), which
is called by either shutdown_one() or remove_one(). The function
shutdown_one() is called when the kernel is rebooted while remove_one()
is called when the hfi1 driver is unloaded. When the kernel is rebooted,
hfi1_wq is destroyed while all qps are still active, leading to a
kernel crash:

[ 198.891986] BUG: unable to handle kernel NULL pointer dereference at 0000000000000102
[ 198.892072] IP: [<ffffffff94cb7b02>] __queue_work+0x32/0x3e0
[ 198.892130] PGD 0
[ 198.892156] Oops: 0000 [#1] SMP
[ 198.892193] Modules linked in: dm_round_robin nvme_rdma(OE) nvme_fabrics(OE) nvme_core(OE) ib_isert iscsi_target_mod target_core_mod ib_ucm mlx4_ib iTCO_wdt iTCO_vendor_support mxm_wmi sb_edac intel_powerclamp coretemp intel_rapl iosf_mbi kvm rpcrdma sunrpc irqbypass crc32_pclmul ghash_clmulni_intel rdma_ucm aesni_intel ib_uverbs lrw gf128mul opa_vnic glue_helper ablk_helper ib_iser cryptd ib_umad rdma_cm iw_cm ses enclosure libiscsi scsi_transport_sas pcspkr joydev ib_ipoib(OE) scsi_transport_iscsi ib_cm sg ipmi_ssif mei_me lpc_ich i2c_i801 mei ioatdma ipmi_si dm_multipath ipmi_devintf ipmi_msghandler wmi acpi_pad acpi_power_meter hangcheck_timer ip_tables ext4 mbcache jbd2 mlx4_en sd_mod crc_t10dif crct10dif_generic mgag200 drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm hfi1(OE)
[ 198.892997] crct10dif_pclmul crct10dif_common crc32c_intel drm ahci mlx4_core libahci rdmavt(OE) igb megaraid_sas ib_core libata drm_panel_orientation_quirks ptp pps_core devlink dca i2c_algo_bit dm_mirror dm_region_hash dm_log dm_mod
[ 198.893233] CPU: 19 PID: 0 Comm: swapper/19 Kdump: loaded Tainted: G OE ------------ 3.10.0-957.el7.x86_64 #1
[ 198.893317] Hardware name: Phegda X2226A/S2600CW, BIOS SE5C610.86B.01.01.0024.021320181901 02/13/2018
[ 198.893388] task: ffff8a799ba0d140 ti: ffff8a799bad8000 task.ti: ffff8a799bad8000
[ 198.893447] RIP: 0010:[<ffffffff94cb7b02>] [<ffffffff94cb7b02>] __queue_work+0x32/0x3e0
[ 198.893518] RSP: 0018:ffff8a90dde43d80 EFLAGS: 00010046
[ 198.893561] RAX: 0000000000000082 RBX: 0000000000000086 RCX: 0000000000000000
[ 198.893617] RDX: ffff8a90b924fcb8 RSI: 0000000000000000 RDI: 000000000000001b
[ 198.893674] RBP: ffff8a90dde43db8 R08: ffff8a799ba0d6d8 R09: ffff8a90dde53900
[ 198.893730] R10: 0000000000000002 R11: ffff8a90dde43de8 R12: ffff8a90b924fcb8
[ 198.893786] R13: 000000000000001b R14: 0000000000000000 R15: ffff8a90d2890000
[ 198.893843] FS: 0000000000000000(0000) GS:ffff8a90dde40000(0000) knlGS:0000000000000000
[ 198.893905] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 198.893953] CR2: 0000000000000102 CR3: 0000001a70410000 CR4: 00000000001607e0
[ 198.894009] Call Trace:
[ 198.894058] [<ffffffff94cb8105>] queue_work_on+0x45/0x50
[ 198.894161] [<ffffffffc03f781e>] _hfi1_schedule_send+0x6e/0xc0 [hfi1]
[ 198.894244] [<ffffffffc03f78a2>] hfi1_schedule_send+0x32/0x70 [hfi1]
[ 198.894311] [<ffffffffc02cf2d9>] rvt_rc_timeout+0xe9/0x130 [rdmavt]
[ 198.894366] [<ffffffff94ce563a>] ? trigger_load_balance+0x6a/0x280
[ 198.894426] [<ffffffffc02cf1f0>] ? rvt_free_qpn+0x40/0x40 [rdmavt]
[ 198.894482] [<ffffffff94ca7f58>] call_timer_fn+0x38/0x110
[ 198.894537] [<ffffffffc02cf1f0>] ? rvt_free_qpn+0x40/0x40 [rdmavt]
[ 198.894589] [<ffffffff94caa3bd>] run_timer_softirq+0x24d/0x300
[ 198.894641] [<ffffffff94ca0f05>] __do_softirq+0xf5/0x280
[ 198.894689] [<ffffffff9537832c>] call_softirq+0x1c/0x30
[ 198.894736] [<ffffffff94c2e675>] do_softirq+0x65/0xa0
[ 198.894780] [<ffffffff94ca1285>] irq_exit+0x105/0x110
[ 198.894826] [<ffffffff953796c8>] smp_apic_timer_interrupt+0x48/0x60
[ 198.894881] [<ffffffff95375df2>] apic_timer_interrupt+0x162/0x170
[ 198.894930] <EOI>
[ 198.894955] [<ffffffff951adfb7>] ? cpuidle_enter_state+0x57/0xd0
[ 198.895012] [<ffffffff951ae10e>] cpuidle_idle_call+0xde/0x230
[ 198.895063] [<ffffffff94c366de>] arch_cpu_idle+0xe/0xc0
[ 198.896984] [<ffffffff94cfc3ba>] cpu_startup_entry+0x14a/0x1e0
[ 198.898879] [<ffffffff94c57db7>] start_secondary+0x1f7/0x270
[ 198.900750] [<ffffffff94c000d5>] start_cpu+0x5/0x14

The solution is to destroy the workqueue only when the hfi1 driver is
unloaded, not when the device is shut down. In addition, when the
device is shut down, no more work should be scheduled on the
workqueues and the workqueues are flushed.

Fixes: 8d3e71136a08 ("IB/{hfi1, qib}: Add handling of kernel restart")
Cc: <stable@vger.kernel.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>

---
Changes since v1:
  - Flush the workqueues when the device is shut down;
  - Stop queuing more work on hfi1_wq when the device is shut down.
---
 drivers/infiniband/hw/hfi1/init.c     |   27 +++++++++++++++++++++++----
 drivers/infiniband/hw/hfi1/qp.c       |    5 ++++-
 drivers/infiniband/hw/hfi1/tid_rdma.c |    5 ++++-
 3 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 5eed436..16d6788 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -831,6 +831,25 @@ static int create_workqueues(struct hfi1_devdata *dd)
 }
 
 /**
+ * destroy_workqueues - destroy per port workqueues
+ * @dd: the hfi1_ib device
+ */
+static void destroy_workqueues(struct hfi1_devdata *dd)
+{
+	int pidx;
+	struct hfi1_pportdata *ppd;
+
+	for (pidx = 0; pidx < dd->num_pports; ++pidx) {
+		ppd = dd->pport + pidx;
+
+		if (ppd->hfi1_wq) {
+			destroy_workqueue(ppd->hfi1_wq);
+			ppd->hfi1_wq = NULL;
+		}
+	}
+}
+
+/**
  * enable_general_intr() - Enable the IRQs that will be handled by the
  * general interrupt handler.
  * @dd: valid devdata
@@ -1104,11 +1123,10 @@ static void shutdown_device(struct hfi1_devdata *dd)
 		 */
 		hfi1_quiet_serdes(ppd);
 
-		if (ppd->hfi1_wq) {
-			destroy_workqueue(ppd->hfi1_wq);
-			ppd->hfi1_wq = NULL;
-		}
+		if (ppd->hfi1_wq)
+			flush_workqueue(ppd->hfi1_wq);
 		if (ppd->link_wq) {
+			flush_workqueue(ppd->link_wq);
 			destroy_workqueue(ppd->link_wq);
 			ppd->link_wq = NULL;
 		}
@@ -1756,6 +1774,7 @@ static void remove_one(struct pci_dev *pdev)
 	 * clear dma engines, etc.
 	 */
 	shutdown_device(dd);
+	destroy_workqueues(dd);
 
 	stop_timers(dd);
 
diff --git a/drivers/infiniband/hw/hfi1/qp.c b/drivers/infiniband/hw/hfi1/qp.c
index 0c2ae9f..283d4c5 100644
--- a/drivers/infiniband/hw/hfi1/qp.c
+++ b/drivers/infiniband/hw/hfi1/qp.c
@@ -367,7 +367,10 @@ bool _hfi1_schedule_send(struct rvt_qp *qp)
 	struct hfi1_ibport *ibp =
 		to_iport(qp->ibqp.device, qp->port_num);
 	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
-	struct hfi1_devdata *dd = dd_from_ibdev(qp->ibqp.device);
+	struct hfi1_devdata *dd = ppd->dd;
+
+	if (dd->flags & HFI1_SHUTDOWN)
+		return true;
 
 	return iowait_schedule(&priv->s_iowait, ppd->hfi1_wq,
 			       priv->s_sde ?
diff --git a/drivers/infiniband/hw/hfi1/tid_rdma.c b/drivers/infiniband/hw/hfi1/tid_rdma.c
index 243b4ba..facff13 100644
--- a/drivers/infiniband/hw/hfi1/tid_rdma.c
+++ b/drivers/infiniband/hw/hfi1/tid_rdma.c
@@ -5406,7 +5406,10 @@ static bool _hfi1_schedule_tid_send(struct rvt_qp *qp)
 	struct hfi1_ibport *ibp =
 		to_iport(qp->ibqp.device, qp->port_num);
 	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
-	struct hfi1_devdata *dd = dd_from_ibdev(qp->ibqp.device);
+	struct hfi1_devdata *dd = ppd->dd;
+
+	if ((dd->flags & HFI1_SHUTDOWN))
+		return true;
 
 	return iowait_tid_schedule(&priv->s_iowait, ppd->hfi1_wq,
 				   priv->s_sde ?

