Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C461010191A
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbfKSFVv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:21:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:36948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727453AbfKSFVt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:21:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D7B922317;
        Tue, 19 Nov 2019 05:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574140907;
        bh=YrvwauQVrOFWjlsHqR4XC8aBJ1O/HYeF+6Oy9gFRt7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XjZ6fniELyHH7R+pUX2rehowxHkw4437Dmb2QJoBH5clz2J3qKTIBD2ytrf5xshVc
         GkmJ879liD53zEiM08Sqa9Fc4lH7o6UFSfgUrT3ArleAA0uAli+cfHLPJOt79Z7OOq
         hOGm7IZbC7vAVHOThs+i8NsRfgV/8SGxat3OEAg4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Kaike Wan <kaike.wan@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.3 27/48] IB/hfi1: Ensure r_tid_ack is valid before building TID RDMA ACK packet
Date:   Tue, 19 Nov 2019 06:19:47 +0100
Message-Id: <20191119051009.167843775@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119050946.745015350@linuxfoundation.org>
References: <20191119050946.745015350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kaike Wan <kaike.wan@intel.com>

commit c1abd865bd125015783286b353abb8da51644f59 upstream.

The index r_tid_ack is used to indicate the next TID RDMA WRITE request to
acknowledge in the ring s_ack_queue[] on the responder side and should be
set to a valid index other than its initial value before r_tid_tail is
advanced to the next TID RDMA WRITE request and particularly before a TID
RDMA ACK is built. Otherwise, a NULL pointer dereference may result:

  BUG: unable to handle kernel paging request at ffff9a32d27abff8
  IP: [<ffffffffc0d87ea6>] hfi1_make_tid_rdma_pkt+0x476/0xcb0 [hfi1]
  PGD 2749032067 PUD 0
  Oops: 0000 1 SMP
  Modules linked in: osp(OE) ofd(OE) lfsck(OE) ost(OE) mgc(OE) osd_zfs(OE) lquota(OE) lustre(OE) lmv(OE) mdc(OE) lov(OE) fid(OE) fld(OE) ko2iblnd(OE) ptlrpc(OE) obdclass(OE) lnet(OE) libcfs(OE) ib_ipoib(OE) hfi1(OE) rdmavt(OE) nfsv3 nfs_acl rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace fscache ib_isert iscsi_target_mod target_core_mod ib_ucm dm_mirror dm_region_hash dm_log mlx5_ib dm_mod zfs(POE) rpcrdma sunrpc rdma_ucm ib_uverbs opa_vnic ib_iser zunicode(POE) ib_umad zavl(POE) icp(POE) sb_edac intel_powerclamp coretemp rdma_cm intel_rapl iosf_mbi iw_cm libiscsi scsi_transport_iscsi kvm ib_cm iTCO_wdt mxm_wmi iTCO_vendor_support irqbypass crc32_pclmul ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper ablk_helper cryptd zcommon(POE) znvpair(POE) pcspkr spl(OE) mei_me
  sg mei ioatdma lpc_ich joydev i2c_i801 shpchp ipmi_si ipmi_devintf ipmi_msghandler wmi acpi_power_meter ip_tables xfs libcrc32c sd_mod crc_t10dif crct10dif_generic mgag200 mlx5_core drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ixgbe ahci ttm mlxfw ib_core libahci devlink mdio crct10dif_pclmul crct10dif_common drm ptp libata megaraid_sas crc32c_intel i2c_algo_bit pps_core i2c_core dca [last unloaded: rdmavt]
  CPU: 15 PID: 68691 Comm: kworker/15:2H Kdump: loaded Tainted: P W OE ------------ 3.10.0-862.2.3.el7_lustre.x86_64 #1
  Hardware name: Intel Corporation S2600WTT/S2600WTT, BIOS SE5C610.86B.01.01.0016.033120161139 03/31/2016
  Workqueue: hfi0_0 _hfi1_do_tid_send [hfi1]
  task: ffff9a01f47faf70 ti: ffff9a11776a8000 task.ti: ffff9a11776a8000
  RIP: 0010:[<ffffffffc0d87ea6>] [<ffffffffc0d87ea6>] hfi1_make_tid_rdma_pkt+0x476/0xcb0 [hfi1]
  RSP: 0018:ffff9a11776abd08 EFLAGS: 00010002
  RAX: ffff9a32d27abfc0 RBX: ffff99f2d27aa000 RCX: 00000000ffffffff
  RDX: 0000000000000000 RSI: 0000000000000220 RDI: ffff99f2ffc05300
  RBP: ffff9a11776abd88 R08: 000000000001c310 R09: ffffffffc0d87ad4
  R10: 0000000000000000 R11: 0000000000000000 R12: ffff9a117a423c00
  R13: ffff9a117a423c00 R14: ffff9a03500c0000 R15: ffff9a117a423cb8
  FS: 0000000000000000(0000) GS:ffff9a117e9c0000(0000) knlGS:0000000000000000
  CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: ffff9a32d27abff8 CR3: 0000002748a0e000 CR4: 00000000001607e0
  Call Trace:
  [<ffffffffc0d88874>] _hfi1_do_tid_send+0x194/0x320 [hfi1]
  [<ffffffffaf0b2dff>] process_one_work+0x17f/0x440
  [<ffffffffaf0b3ac6>] worker_thread+0x126/0x3c0
  [<ffffffffaf0b39a0>] ? manage_workers.isra.24+0x2a0/0x2a0
  [<ffffffffaf0bae31>] kthread+0xd1/0xe0
  [<ffffffffaf0bad60>] ? insert_kthread_work+0x40/0x40
  [<ffffffffaf71f5f7>] ret_from_fork_nospec_begin+0x21/0x21
  [<ffffffffaf0bad60>] ? insert_kthread_work+0x40/0x40
  hfi1 0000:05:00.0: hfi1_0: reserved_op: opcode 0xf2, slot 2, rsv_used 1, rsv_ops 1
  Code: 00 00 41 8b 8d d8 02 00 00 89 c8 48 89 45 b0 48 c1 65 b0 06 48 8b 83 a0 01 00 00 48 01 45 b0 48 8b 45 b0 41 80 bd 10 03 00 00 00 <48> 8b 50 38 4c 8d 7a 50 74 45 8b b2 d0 00 00 00 85 f6 0f 85 72
  RIP [<ffffffffc0d87ea6>] hfi1_make_tid_rdma_pkt+0x476/0xcb0 [hfi1]
  RSP <ffff9a11776abd08>
  CR2: ffff9a32d27abff8

This problem can happen if a RESYNC request is received before r_tid_ack
is modified.

This patch fixes the issue by making sure that r_tid_ack is set to a valid
value before a TID RDMA ACK is built. Functions are defined to simplify
the code.

Fixes: 07b923701e38 ("IB/hfi1: Add functions to receive TID RDMA WRITE request")
Fixes: 7cf0ad679de4 ("IB/hfi1: Add a function to receive TID RDMA RESYNC packet")
Link: https://lore.kernel.org/r/20191025195830.106825.44022.stgit@awfm-01.aw.intel.com
Cc: <stable@vger.kernel.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/hfi1/tid_rdma.c |   44 ++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 17 deletions(-)

--- a/drivers/infiniband/hw/hfi1/tid_rdma.c
+++ b/drivers/infiniband/hw/hfi1/tid_rdma.c
@@ -136,6 +136,26 @@ static void update_r_next_psn_fecn(struc
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
@@ -2997,10 +3017,7 @@ nak_psn:
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
@@ -3518,7 +3535,7 @@ static void hfi1_tid_write_alloc_resourc
 		/*
 		 * If overtaking req->acked_tail, send an RNR NAK. Because the
 		 * QP is not queued in this case, and the issue can only be
-		 * caused due a delay in scheduling the second leg which we
+		 * caused by a delay in scheduling the second leg which we
 		 * cannot estimate, we use a rather arbitrary RNR timeout of
 		 * (MAX_FLOWS / 2) segments
 		 */
@@ -3526,8 +3543,7 @@ static void hfi1_tid_write_alloc_resourc
 				MAX_FLOWS)) {
 			ret = -EAGAIN;
 			to_seg = MAX_FLOWS >> 1;
-			qpriv->s_flags |= RVT_S_ACK_PENDING;
-			hfi1_schedule_tid_send(qp);
+			tid_rdma_trigger_ack(qp);
 			break;
 		}
 
@@ -4327,8 +4343,7 @@ void hfi1_rc_rcv_tid_rdma_write_data(str
 	trace_hfi1_tid_req_rcv_write_data(qp, 0, e->opcode, e->psn, e->lpsn,
 					  req);
 	trace_hfi1_tid_write_rsp_rcv_data(qp);
-	if (priv->r_tid_ack == HFI1_QP_WQE_INVALID)
-		priv->r_tid_ack = priv->r_tid_tail;
+	validate_r_tid_ack(priv);
 
 	if (opcode == TID_OP(WRITE_DATA_LAST)) {
 		release_rdma_sge_mr(e);
@@ -4367,8 +4382,7 @@ void hfi1_rc_rcv_tid_rdma_write_data(str
 	}
 
 done:
-	priv->s_flags |= RVT_S_ACK_PENDING;
-	hfi1_schedule_tid_send(qp);
+	tid_rdma_schedule_ack(qp);
 exit:
 	priv->r_next_psn_kdeth = flow->flow_state.r_next_psn;
 	if (fecn)
@@ -4380,10 +4394,7 @@ send_nak:
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
@@ -4931,8 +4942,7 @@ void hfi1_rc_rcv_tid_rdma_resync(struct
 	qpriv->resync = true;
 	/* RESYNC request always gets a TID RDMA ACK. */
 	qpriv->s_nak_state = 0;
-	qpriv->s_flags |= RVT_S_ACK_PENDING;
-	hfi1_schedule_tid_send(qp);
+	tid_rdma_trigger_ack(qp);
 bail:
 	if (fecn)
 		qp->s_flags |= RVT_S_ECN;


