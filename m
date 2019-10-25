Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B494E54BF
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 21:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbfJYT6e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 15:58:34 -0400
Received: from mga03.intel.com ([134.134.136.65]:47292 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbfJYT6d (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Oct 2019 15:58:33 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Oct 2019 12:58:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,229,1569308400"; 
   d="scan'208";a="400217792"
Received: from sedona.ch.intel.com ([10.2.136.157])
  by fmsmga006.fm.intel.com with ESMTP; 25 Oct 2019 12:58:32 -0700
Received: from awfm-01.aw.intel.com (awfm-01.aw.intel.com [10.228.212.213])
        by sedona.ch.intel.com (8.14.3/8.14.3/Standard MailSET/Hub) with ESMTP id x9PJwVc9024308;
        Fri, 25 Oct 2019 12:58:31 -0700
Received: from awfm-01.aw.intel.com (localhost [127.0.0.1])
        by awfm-01.aw.intel.com (8.14.7/8.14.7) with ESMTP id x9PJwUfr111979;
        Fri, 25 Oct 2019 15:58:30 -0400
Subject: [PATCH for-rc 2/4] IB/hfi1: Ensure r_tid_ack is valid before
 building TID RDMA ACK packet
From:   Dennis Dalessandro <dennis.dalessandro@intel.com>
To:     jgg@ziepe.ca, dledford@redhat.com
Cc:     linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>
Date:   Fri, 25 Oct 2019 15:58:30 -0400
Message-ID: <20191025195830.106825.44022.stgit@awfm-01.aw.intel.com>
In-Reply-To: <20191025161717.106825.14421.stgit@awfm-01.aw.intel.com>
References: <20191025161717.106825.14421.stgit@awfm-01.aw.intel.com>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kaike Wan <kaike.wan@intel.com>

The index r_tid_ack is used to indicate the next TID RDMA WRITE request
to acknowledge in the ring s_ack_queue[] on the responder side and
should be set to a valid index other than its initial value before
r_tid_tail is advanced to the next TID RDMA WRITE request and
particularly before a TID RDMA ACK is built. Otherwise, a NULL pointer
dereference may result:

[1372301.686240] BUG: unable to handle kernel paging request at ffff9a32d27abff8
[1372301.686270] IP: [<ffffffffc0d87ea6>] hfi1_make_tid_rdma_pkt+0x476/0xcb0 [hfi1]
[1372301.686272] PGD 2749032067 PUD 0
[1372301.686273] Oops: 0000 1 SMP
[1372301.686306] Modules linked in: osp(OE) ofd(OE) lfsck(OE) ost(OE) mgc(OE) osd_zfs(OE) lquota(OE) lustre(OE) lmv(OE) mdc(OE) lov(OE) fid(OE) fld(OE) ko2iblnd(OE) ptlrpc(OE) obdclass(OE) lnet(OE) libcfs(OE) ib_ipoib(OE) hfi1(OE) rdmavt(OE) nfsv3 nfs_acl rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace fscache ib_isert iscsi_target_mod target_core_mod ib_ucm dm_mirror dm_region_hash dm_log mlx5_ib dm_mod zfs(POE) rpcrdma sunrpc rdma_ucm ib_uverbs opa_vnic ib_iser zunicode(POE) ib_umad zavl(POE) icp(POE) sb_edac intel_powerclamp coretemp rdma_cm intel_rapl iosf_mbi iw_cm libiscsi scsi_transport_iscsi kvm ib_cm iTCO_wdt mxm_wmi iTCO_vendor_support irqbypass crc32_pclmul ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper ablk_helper cryptd zcommon(POE) znvpair(POE) pcspkr spl(OE) mei_me
[1372301.686322] sg mei ioatdma lpc_ich joydev i2c_i801 shpchp ipmi_si ipmi_devintf ipmi_msghandler wmi acpi_power_meter ip_tables xfs libcrc32c sd_mod crc_t10dif crct10dif_generic mgag200 mlx5_core drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ixgbe ahci ttm mlxfw ib_core libahci devlink mdio crct10dif_pclmul crct10dif_common drm ptp libata megaraid_sas crc32c_intel i2c_algo_bit pps_core i2c_core dca [last unloaded: rdmavt]
[1372301.686326] CPU: 15 PID: 68691 Comm: kworker/15:2H Kdump: loaded Tainted: P W OE ------------ 3.10.0-862.2.3.el7_lustre.x86_64 #1
[1372301.686327] Hardware name: Intel Corporation S2600WTT/S2600WTT, BIOS SE5C610.86B.01.01.0016.033120161139 03/31/2016
[1372301.686341] Workqueue: hfi0_0 _hfi1_do_tid_send [hfi1]
[1372301.686342] task: ffff9a01f47faf70 ti: ffff9a11776a8000 task.ti: ffff9a11776a8000
[1372301.686355] RIP: 0010:[<ffffffffc0d87ea6>] [<ffffffffc0d87ea6>] hfi1_make_tid_rdma_pkt+0x476/0xcb0 [hfi1]
[1372301.686356] RSP: 0018:ffff9a11776abd08 EFLAGS: 00010002
[1372301.686357] RAX: ffff9a32d27abfc0 RBX: ffff99f2d27aa000 RCX: 00000000ffffffff
[1372301.686358] RDX: 0000000000000000 RSI: 0000000000000220 RDI: ffff99f2ffc05300
[1372301.686359] RBP: ffff9a11776abd88 R08: 000000000001c310 R09: ffffffffc0d87ad4
[1372301.686359] R10: 0000000000000000 R11: 0000000000000000 R12: ffff9a117a423c00
[1372301.686360] R13: ffff9a117a423c00 R14: ffff9a03500c0000 R15: ffff9a117a423cb8
[1372301.686361] FS: 0000000000000000(0000) GS:ffff9a117e9c0000(0000) knlGS:0000000000000000
[1372301.686362] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[1372301.686363] CR2: ffff9a32d27abff8 CR3: 0000002748a0e000 CR4: 00000000001607e0
[1372301.686363] Call Trace:
[1372301.686378] [<ffffffffc0d88874>] _hfi1_do_tid_send+0x194/0x320 [hfi1]
[1372301.686383] [<ffffffffaf0b2dff>] process_one_work+0x17f/0x440
[1372301.686385] [<ffffffffaf0b3ac6>] worker_thread+0x126/0x3c0
[1372301.686386] [<ffffffffaf0b39a0>] ? manage_workers.isra.24+0x2a0/0x2a0
[1372301.686389] [<ffffffffaf0bae31>] kthread+0xd1/0xe0
[1372301.686391] [<ffffffffaf0bad60>] ? insert_kthread_work+0x40/0x40
[1372301.686394] [<ffffffffaf71f5f7>] ret_from_fork_nospec_begin+0x21/0x21
[1372301.686396] [<ffffffffaf0bad60>] ? insert_kthread_work+0x40/0x40
[1372301.686398] hfi1 0000:05:00.0: hfi1_0: reserved_op: opcode 0xf2, slot 2, rsv_used 1, rsv_ops 1
[1372301.686414] Code: 00 00 41 8b 8d d8 02 00 00 89 c8 48 89 45 b0 48 c1 65 b0 06 48 8b 83 a0 01 00 00 48 01 45 b0 48 8b 45 b0 41 80 bd 10 03 00 00 00 <48> 8b 50 38 4c 8d 7a 50 74 45 8b b2 d0 00 00 00 85 f6 0f 85 72
[1372301.686426] RIP [<ffffffffc0d87ea6>] hfi1_make_tid_rdma_pkt+0x476/0xcb0 [hfi1]
[1372301.686427] RSP <ffff9a11776abd08>
[1372301.686427] CR2: ffff9a32d27abff8

This problem can happen if a RESYNC request is received before
r_tid_ack is modified.

This patch fixes the issue by making sure that r_tid_ack is set to a
valid value before a TID RDMA ACK is built. Functions are defined to
simplify the code.

Fixes: 07b923701e38 ("IB/hfi1: Add functions to receive TID RDMA WRITE request")
Fixes: 7cf0ad679de4 ("IB/hfi1: Add a function to receive TID RDMA RESYNC packet")
Cc: <stable@vger.kernel.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
---
 drivers/infiniband/hw/hfi1/tid_rdma.c |   44 ++++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/tid_rdma.c b/drivers/infiniband/hw/hfi1/tid_rdma.c
index f21fca3..73bc78b 100644
--- a/drivers/infiniband/hw/hfi1/tid_rdma.c
+++ b/drivers/infiniband/hw/hfi1/tid_rdma.c
@@ -136,6 +136,26 @@ static void update_r_next_psn_fecn(struct hfi1_packet *packet,
 				   struct tid_rdma_flow *flow,
 				   bool fecn);
 
+static void validate_r_tid_ack(struct hfi1_qp_priv *priv)
+{
+	if (priv->r_tid_ack == HFI1_QP_WQE_INVALID)
+		priv->r_tid_ack = priv->r_tid_tail;
+}
+
+static void tid_rdma_schedule_ack(struct rvt_qp *qp)
+{
+	struct hfi1_qp_priv *priv = qp->priv;
+
+	priv->s_flags |= RVT_S_ACK_PENDING;
+	hfi1_schedule_tid_send(qp);
+}
+
+static void tid_rdma_trigger_ack(struct rvt_qp *qp)
+{
+	validate_r_tid_ack(qp->priv);
+	tid_rdma_schedule_ack(qp);
+}
+
 static u64 tid_rdma_opfn_encode(struct tid_rdma_params *p)
 {
 	return
@@ -3005,10 +3025,7 @@ bool hfi1_handle_kdeth_eflags(struct hfi1_ctxtdata *rcd,
 		qpriv->s_nak_state = IB_NAK_PSN_ERROR;
 		/* We are NAK'ing the next expected PSN */
 		qpriv->s_nak_psn = mask_psn(flow->flow_state.r_next_psn);
-		qpriv->s_flags |= RVT_S_ACK_PENDING;
-		if (qpriv->r_tid_ack == HFI1_QP_WQE_INVALID)
-			qpriv->r_tid_ack = qpriv->r_tid_tail;
-		hfi1_schedule_tid_send(qp);
+		tid_rdma_trigger_ack(qp);
 	}
 	goto unlock;
 }
@@ -3526,7 +3543,7 @@ static void hfi1_tid_write_alloc_resources(struct rvt_qp *qp, bool intr_ctx)
 		/*
 		 * If overtaking req->acked_tail, send an RNR NAK. Because the
 		 * QP is not queued in this case, and the issue can only be
-		 * caused due a delay in scheduling the second leg which we
+		 * caused by a delay in scheduling the second leg which we
 		 * cannot estimate, we use a rather arbitrary RNR timeout of
 		 * (MAX_FLOWS / 2) segments
 		 */
@@ -3534,8 +3551,7 @@ static void hfi1_tid_write_alloc_resources(struct rvt_qp *qp, bool intr_ctx)
 				MAX_FLOWS)) {
 			ret = -EAGAIN;
 			to_seg = MAX_FLOWS >> 1;
-			qpriv->s_flags |= RVT_S_ACK_PENDING;
-			hfi1_schedule_tid_send(qp);
+			tid_rdma_trigger_ack(qp);
 			break;
 		}
 
@@ -4335,8 +4351,7 @@ void hfi1_rc_rcv_tid_rdma_write_data(struct hfi1_packet *packet)
 	trace_hfi1_tid_req_rcv_write_data(qp, 0, e->opcode, e->psn, e->lpsn,
 					  req);
 	trace_hfi1_tid_write_rsp_rcv_data(qp);
-	if (priv->r_tid_ack == HFI1_QP_WQE_INVALID)
-		priv->r_tid_ack = priv->r_tid_tail;
+	validate_r_tid_ack(priv);
 
 	if (opcode == TID_OP(WRITE_DATA_LAST)) {
 		release_rdma_sge_mr(e);
@@ -4375,8 +4390,7 @@ void hfi1_rc_rcv_tid_rdma_write_data(struct hfi1_packet *packet)
 	}
 
 done:
-	priv->s_flags |= RVT_S_ACK_PENDING;
-	hfi1_schedule_tid_send(qp);
+	tid_rdma_schedule_ack(qp);
 exit:
 	priv->r_next_psn_kdeth = flow->flow_state.r_next_psn;
 	if (fecn)
@@ -4388,10 +4402,7 @@ void hfi1_rc_rcv_tid_rdma_write_data(struct hfi1_packet *packet)
 	if (!priv->s_nak_state) {
 		priv->s_nak_state = IB_NAK_PSN_ERROR;
 		priv->s_nak_psn = flow->flow_state.r_next_psn;
-		priv->s_flags |= RVT_S_ACK_PENDING;
-		if (priv->r_tid_ack == HFI1_QP_WQE_INVALID)
-			priv->r_tid_ack = priv->r_tid_tail;
-		hfi1_schedule_tid_send(qp);
+		tid_rdma_trigger_ack(qp);
 	}
 	goto done;
 }
@@ -4939,8 +4950,7 @@ void hfi1_rc_rcv_tid_rdma_resync(struct hfi1_packet *packet)
 	qpriv->resync = true;
 	/* RESYNC request always gets a TID RDMA ACK. */
 	qpriv->s_nak_state = 0;
-	qpriv->s_flags |= RVT_S_ACK_PENDING;
-	hfi1_schedule_tid_send(qp);
+	tid_rdma_trigger_ack(qp);
 bail:
 	if (fecn)
 		qp->s_flags |= RVT_S_ECN;

