Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD23127156
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 00:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbfLSXTZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 18:19:25 -0500
Received: from mga17.intel.com ([192.55.52.151]:29904 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726818AbfLSXTZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 18:19:25 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Dec 2019 15:19:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,333,1571727600"; 
   d="scan'208";a="241326119"
Received: from sedona.ch.intel.com ([10.2.136.157])
  by fmsmga004.fm.intel.com with ESMTP; 19 Dec 2019 15:19:24 -0800
Received: from awfm-01.aw.intel.com (awfm-01.aw.intel.com [10.228.212.213])
        by sedona.ch.intel.com (8.14.3/8.14.3/Standard MailSET/Hub) with ESMTP id xBJNJMHV016425;
        Thu, 19 Dec 2019 16:19:23 -0700
Received: from awfm-01.aw.intel.com (localhost [127.0.0.1])
        by awfm-01.aw.intel.com (8.14.7/8.14.7) with ESMTP id xBJNJKOg051093;
        Thu, 19 Dec 2019 18:19:20 -0500
Subject: [PATCH for-rc] IB/hfi1: Adjust flow PSN with the correct resync_psn
From:   Dennis Dalessandro <dennis.dalessandro@intel.com>
To:     jgg@ziepe.ca, dledford@redhat.com
Cc:     linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>
Date:   Thu, 19 Dec 2019 18:19:20 -0500
Message-ID: <20191219231920.51069.37147.stgit@awfm-01.aw.intel.com>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kaike Wan <kaike.wan@intel.com>

When a TID RDMA ACK to RESYNC request is received, the flow PSNs for
pending TID RDMA WRITE segments will be adjusted with the next flow
generation number, based on the resync_psn value extracted from the
flow PSN of the TID RDMA ACK packet. The resync_psn value indicates
the last flow PSN for which a TID RDMA WRITE DATA packet has been
received by the responder and the requester should resend TID RDMA
WRITE DATA packets, starting from the next flow PSN. However, if
resync_psn points to the last flow PSN for a segment and the next
segment flow PSN starts with a new generation number, use of the
old resync_psn to adjust the flow PSN for the next segment will
lead to miscalculation, resulting in WARN_ON and sge rewinding
errors:
[2419460.492485] WARNING: CPU: 4 PID: 146961 at /nfs/site/home/phcvs2/gitrepo/ifs-all/components/Drivers/tmp/rpmbuild/BUILD/ifs-kernel-updates-3.10.0_957.el7.x86_64/hfi1/tid_rdma.c:4764 hfi1_rc_rcv_tid_rdma_ack+0x8f6/0xa90 [hfi1]
[2419460.514565] Modules linked in: ib_ipoib(OE) hfi1(OE) rdmavt(OE) rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfsv3 nfs_acl nfs lockd grace fscache iTCO_wdt iTCO_vendor_support skx_edac intel_powerclamp coretemp intel_rapl iosf_mbi kvm irqbypass crc32_pclmul ghash_clmulni_intel ib_isert iscsi_target_mod target_core_mod aesni_intel lrw gf128mul glue_helper ablk_helper cryptd rpcrdma sunrpc opa_vnic ast ttm ib_iser libiscsi drm_kms_helper scsi_transport_iscsi ipmi_ssif syscopyarea sysfillrect sysimgblt fb_sys_fops drm joydev ipmi_si pcspkr sg drm_panel_orientation_quirks ipmi_devintf lpc_ich i2c_i801 ipmi_msghandler wmi rdma_ucm ib_ucm ib_uverbs acpi_cpufreq acpi_power_meter ib_umad rdma_cm ib_cm iw_cm ip_tables ext4 mbcache jbd2 sd_mod crc_t10dif crct10dif_generic crct10dif_pclmul i2c_algo_bit crct10dif_common
[2419460.594432]  crc32c_intel e1000e ib_core ahci libahci ptp libata pps_core nfit libnvdimm [last unloaded: rdmavt]
[2419460.605645] CPU: 4 PID: 146961 Comm: kworker/4:0H Kdump: loaded Tainted: G        W  OE  ------------   3.10.0-957.el7.x86_64 #1
[2419460.619424] Hardware name: Intel Corporation S2600WFT/S2600WFT, BIOS SE5C620.86B.0X.02.0117.040420182310 04/04/2018
[2419460.631062] Workqueue: hfi0_0 _hfi1_do_tid_send [hfi1]
[2419460.637423] Call Trace:
[2419460.641044]  <IRQ>  [<ffffffff9e361dc1>] dump_stack+0x19/0x1b
[2419460.647980]  [<ffffffff9dc97648>] __warn+0xd8/0x100
[2419460.654023]  [<ffffffff9dc9778d>] warn_slowpath_null+0x1d/0x20
[2419460.661025]  [<ffffffffc05d28c6>] hfi1_rc_rcv_tid_rdma_ack+0x8f6/0xa90 [hfi1]
[2419460.669333]  [<ffffffffc05c21cc>] hfi1_kdeth_eager_rcv+0x1dc/0x210 [hfi1]
[2419460.677295]  [<ffffffffc05c23ef>] ? hfi1_kdeth_expected_rcv+0x1ef/0x210 [hfi1]
[2419460.685693]  [<ffffffffc0574f15>] kdeth_process_eager+0x35/0x90 [hfi1]
[2419460.693394]  [<ffffffffc0575b5a>] handle_receive_interrupt_nodma_rtail+0x17a/0x2b0 [hfi1]
[2419460.702745]  [<ffffffffc056a623>] receive_context_interrupt+0x23/0x40 [hfi1]
[2419460.710963]  [<ffffffff9dd4a294>] __handle_irq_event_percpu+0x44/0x1c0
[2419460.718659]  [<ffffffff9dd4a442>] handle_irq_event_percpu+0x32/0x80
[2419460.726086]  [<ffffffff9dd4a4cc>] handle_irq_event+0x3c/0x60
[2419460.732903]  [<ffffffff9dd4d27f>] handle_edge_irq+0x7f/0x150
[2419460.739710]  [<ffffffff9dc2e554>] handle_irq+0xe4/0x1a0
[2419460.746091]  [<ffffffff9e3795dd>] do_IRQ+0x4d/0xf0
[2419460.752040]  [<ffffffff9e36b362>] common_interrupt+0x162/0x162
[2419460.759029]  <EOI>  [<ffffffff9dfa0f79>] ? swiotlb_map_page+0x49/0x150
[2419460.766758]  [<ffffffffc05c2ed1>] hfi1_verbs_send_dma+0x291/0xb70 [hfi1]
[2419460.774637]  [<ffffffffc05c2c40>] ? hfi1_wait_kmem+0xf0/0xf0 [hfi1]
[2419460.782080]  [<ffffffffc05c3f26>] hfi1_verbs_send+0x126/0x2b0 [hfi1]
[2419460.789606]  [<ffffffffc05ce683>] _hfi1_do_tid_send+0x1d3/0x320 [hfi1]
[2419460.797298]  [<ffffffff9dcb9d4f>] process_one_work+0x17f/0x440
[2419460.804292]  [<ffffffff9dcbade6>] worker_thread+0x126/0x3c0
[2419460.811025]  [<ffffffff9dcbacc0>] ? manage_workers.isra.25+0x2a0/0x2a0
[2419460.818710]  [<ffffffff9dcc1c31>] kthread+0xd1/0xe0
[2419460.824751]  [<ffffffff9dcc1b60>] ? insert_kthread_work+0x40/0x40
[2419460.832013]  [<ffffffff9e374c1d>] ret_from_fork_nospec_begin+0x7/0x21
[2419460.839611]  [<ffffffff9dcc1b60>] ? insert_kthread_work+0x40/0x40

This patch fixes the issue by adjusting the resync_psn first if the flow
generation has been advanced for a pending segment.

Fixes: 9e93e967f7b4 ("IB/hfi1: Add a function to receive TID RDMA ACK packet")
Cc: <stable@vger.kernel.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
---
 drivers/infiniband/hw/hfi1/tid_rdma.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/infiniband/hw/hfi1/tid_rdma.c b/drivers/infiniband/hw/hfi1/tid_rdma.c
index e53f542..8a2e0d9 100644
--- a/drivers/infiniband/hw/hfi1/tid_rdma.c
+++ b/drivers/infiniband/hw/hfi1/tid_rdma.c
@@ -4633,6 +4633,15 @@ void hfi1_rc_rcv_tid_rdma_ack(struct hfi1_packet *packet)
 			 */
 			fpsn = full_flow_psn(flow, flow->flow_state.spsn);
 			req->r_ack_psn = psn;
+			/*
+			 * If resync_psn points to the last flow PSN for a
+			 * segment and the new segment (likely from a new
+			 * request) starts with a new generation number, we
+			 * need to adjust resync_psn accordingly.
+			 */
+			if (flow->flow_state.generation !=
+			    (resync_psn >> HFI1_KDETH_BTH_SEQ_SHIFT))
+				resync_psn = mask_psn(fpsn - 1);
 			flow->resync_npkts +=
 				delta_psn(mask_psn(resync_psn + 1), fpsn);
 			/*

