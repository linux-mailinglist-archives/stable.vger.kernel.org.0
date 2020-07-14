Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67A5721FA4E
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 20:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729917AbgGNSv0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:51:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:47824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730401AbgGNSvX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:51:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E080207F5;
        Tue, 14 Jul 2020 18:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752683;
        bh=dShFMiilCJWGcWTyh18//MxFOxtwTYwGKLalvCV8Wo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Puv9nMp/4ssXRDA7Z+xzfwwCPTN/mEyLVFSbsuALjfRzFa/vt9oq4LL07IHF7ZZC1
         AAc7NXAPwYt3UbmWdBll/83IJ6S3h4EpFXGVpcaugcJDUKKJvOA1QYCG+MGJM91XND
         SKep1V3S3jMbKTuP4kXbVDWrLUbq92NUJnycMVO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Kaike Wan <kaike.wan@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.4 070/109] IB/hfi1: Do not destroy hfi1_wq when the device is shut down
Date:   Tue, 14 Jul 2020 20:44:13 +0200
Message-Id: <20200714184108.890144912@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184105.507384017@linuxfoundation.org>
References: <20200714184105.507384017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kaike Wan <kaike.wan@intel.com>

commit 28b70cd9236563e1a88a6094673fef3c08db0d51 upstream.

The workqueue hfi1_wq is destroyed in function shutdown_device(), which is
called by either shutdown_one() or remove_one(). The function
shutdown_one() is called when the kernel is rebooted while remove_one() is
called when the hfi1 driver is unloaded. When the kernel is rebooted,
hfi1_wq is destroyed while all qps are still active, leading to a kernel
crash:

  BUG: unable to handle kernel NULL pointer dereference at 0000000000000102
  IP: [<ffffffff94cb7b02>] __queue_work+0x32/0x3e0
  PGD 0
  Oops: 0000 [#1] SMP
  Modules linked in: dm_round_robin nvme_rdma(OE) nvme_fabrics(OE) nvme_core(OE) ib_isert iscsi_target_mod target_core_mod ib_ucm mlx4_ib iTCO_wdt iTCO_vendor_support mxm_wmi sb_edac intel_powerclamp coretemp intel_rapl iosf_mbi kvm rpcrdma sunrpc irqbypass crc32_pclmul ghash_clmulni_intel rdma_ucm aesni_intel ib_uverbs lrw gf128mul opa_vnic glue_helper ablk_helper ib_iser cryptd ib_umad rdma_cm iw_cm ses enclosure libiscsi scsi_transport_sas pcspkr joydev ib_ipoib(OE) scsi_transport_iscsi ib_cm sg ipmi_ssif mei_me lpc_ich i2c_i801 mei ioatdma ipmi_si dm_multipath ipmi_devintf ipmi_msghandler wmi acpi_pad acpi_power_meter hangcheck_timer ip_tables ext4 mbcache jbd2 mlx4_en sd_mod crc_t10dif crct10dif_generic mgag200 drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm hfi1(OE)
  crct10dif_pclmul crct10dif_common crc32c_intel drm ahci mlx4_core libahci rdmavt(OE) igb megaraid_sas ib_core libata drm_panel_orientation_quirks ptp pps_core devlink dca i2c_algo_bit dm_mirror dm_region_hash dm_log dm_mod
  CPU: 19 PID: 0 Comm: swapper/19 Kdump: loaded Tainted: G OE ------------ 3.10.0-957.el7.x86_64 #1
  Hardware name: Phegda X2226A/S2600CW, BIOS SE5C610.86B.01.01.0024.021320181901 02/13/2018
  task: ffff8a799ba0d140 ti: ffff8a799bad8000 task.ti: ffff8a799bad8000
  RIP: 0010:[<ffffffff94cb7b02>] [<ffffffff94cb7b02>] __queue_work+0x32/0x3e0
  RSP: 0018:ffff8a90dde43d80 EFLAGS: 00010046
  RAX: 0000000000000082 RBX: 0000000000000086 RCX: 0000000000000000
  RDX: ffff8a90b924fcb8 RSI: 0000000000000000 RDI: 000000000000001b
  RBP: ffff8a90dde43db8 R08: ffff8a799ba0d6d8 R09: ffff8a90dde53900
  R10: 0000000000000002 R11: ffff8a90dde43de8 R12: ffff8a90b924fcb8
  R13: 000000000000001b R14: 0000000000000000 R15: ffff8a90d2890000
  FS: 0000000000000000(0000) GS:ffff8a90dde40000(0000) knlGS:0000000000000000
  CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000102 CR3: 0000001a70410000 CR4: 00000000001607e0
  Call Trace:
  [<ffffffff94cb8105>] queue_work_on+0x45/0x50
  [<ffffffffc03f781e>] _hfi1_schedule_send+0x6e/0xc0 [hfi1]
  [<ffffffffc03f78a2>] hfi1_schedule_send+0x32/0x70 [hfi1]
  [<ffffffffc02cf2d9>] rvt_rc_timeout+0xe9/0x130 [rdmavt]
  [<ffffffff94ce563a>] ? trigger_load_balance+0x6a/0x280
  [<ffffffffc02cf1f0>] ? rvt_free_qpn+0x40/0x40 [rdmavt]
  [<ffffffff94ca7f58>] call_timer_fn+0x38/0x110
  [<ffffffffc02cf1f0>] ? rvt_free_qpn+0x40/0x40 [rdmavt]
  [<ffffffff94caa3bd>] run_timer_softirq+0x24d/0x300
  [<ffffffff94ca0f05>] __do_softirq+0xf5/0x280
  [<ffffffff9537832c>] call_softirq+0x1c/0x30
  [<ffffffff94c2e675>] do_softirq+0x65/0xa0
  [<ffffffff94ca1285>] irq_exit+0x105/0x110
  [<ffffffff953796c8>] smp_apic_timer_interrupt+0x48/0x60
  [<ffffffff95375df2>] apic_timer_interrupt+0x162/0x170
  <EOI>
  [<ffffffff951adfb7>] ? cpuidle_enter_state+0x57/0xd0
  [<ffffffff951ae10e>] cpuidle_idle_call+0xde/0x230
  [<ffffffff94c366de>] arch_cpu_idle+0xe/0xc0
  [<ffffffff94cfc3ba>] cpu_startup_entry+0x14a/0x1e0
  [<ffffffff94c57db7>] start_secondary+0x1f7/0x270
  [<ffffffff94c000d5>] start_cpu+0x5/0x14

The solution is to destroy the workqueue only when the hfi1 driver is
unloaded, not when the device is shut down. In addition, when the device
is shut down, no more work should be scheduled on the workqueues and the
workqueues are flushed.

Fixes: 8d3e71136a08 ("IB/{hfi1, qib}: Add handling of kernel restart")
Link: https://lore.kernel.org/r/20200623204047.107638.77646.stgit@awfm-01.aw.intel.com
Cc: <stable@vger.kernel.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/hfi1/init.c     |   27 +++++++++++++++++++++++----
 drivers/infiniband/hw/hfi1/qp.c       |    5 ++++-
 drivers/infiniband/hw/hfi1/tid_rdma.c |    5 ++++-
 3 files changed, 31 insertions(+), 6 deletions(-)

--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -845,6 +845,25 @@ wq_error:
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
@@ -1118,11 +1137,10 @@ static void shutdown_device(struct hfi1_
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
@@ -1814,6 +1832,7 @@ static void remove_one(struct pci_dev *p
 	 * clear dma engines, etc.
 	 */
 	shutdown_device(dd);
+	destroy_workqueues(dd);
 
 	stop_timers(dd);
 
--- a/drivers/infiniband/hw/hfi1/qp.c
+++ b/drivers/infiniband/hw/hfi1/qp.c
@@ -381,7 +381,10 @@ bool _hfi1_schedule_send(struct rvt_qp *
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
--- a/drivers/infiniband/hw/hfi1/tid_rdma.c
+++ b/drivers/infiniband/hw/hfi1/tid_rdma.c
@@ -5406,7 +5406,10 @@ static bool _hfi1_schedule_tid_send(stru
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


