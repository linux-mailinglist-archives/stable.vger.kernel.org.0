Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3725E4D0B
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 15:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505320AbfJYN53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 09:57:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:52182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394825AbfJYN5Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Oct 2019 09:57:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A1DF21E6F;
        Fri, 25 Oct 2019 13:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572011844;
        bh=s2yQoOMO/7vJo00zrg4wbCZ/eAiOz/CEpJ75Q9s+nw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VSzZUcm3j3FHuQ9FkU/G9r3NYPktT1wuBRhdQaMe8ctPuhg/H7DQ2BBqcA09TpcJD
         kV0W77409VWfYRHFVgMncaEuYAMthq2IIjHQVUm+jaoBIQnZhXpHsF5rqEokfyc5z8
         eMHCU2A+ppmbyN7LW0XPanblwwa4h5NSrAcEG+as=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chad Dupuis <cdupuis@marvell.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 06/25] scsi: qedf: Do not retry ELS request if qedf_alloc_cmd fails
Date:   Fri, 25 Oct 2019 09:56:54 -0400
Message-Id: <20191025135715.25468-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025135715.25468-1-sashal@kernel.org>
References: <20191025135715.25468-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chad Dupuis <cdupuis@marvell.com>

[ Upstream commit f1c43590365bac054d753d808dbbd207d09e088d ]

If we cannot allocate an ELS middlepath request, simply fail instead of
trying to delay and then reallocate.  This delay logic is causing soft
lockup messages:

NMI watchdog: BUG: soft lockup - CPU#2 stuck for 22s! [kworker/2:1:7639]
Modules linked in: xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun devlink ip6t_rpfilter ipt_REJECT nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute bridge stp llc ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter dm_service_time vfat fat rpcrdma sunrpc ib_isert iscsi_target_mod ib_iser libiscsi scsi_transport_iscsi ib_srpt target_core_mod ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm sb_edac intel_powerclamp coretemp intel_rapl iosf_mbi kvm_intel kvm
irqbypass crc32_pclmul ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper ablk_helper cryptd iTCO_wdt iTCO_vendor_support qedr(OE) ib_core joydev ipmi_ssif pcspkr hpilo hpwdt sg ipmi_si ipmi_devintf ipmi_msghandler ioatdma shpchp lpc_ich wmi dca acpi_power_meter dm_multipath ip_tables xfs libcrc32c sd_mod crc_t10dif crct10dif_generic qedf(OE) libfcoe mgag200 libfc i2c_algo_bit drm_kms_helper scsi_transport_fc qede(OE) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm qed(OE) drm crct10dif_pclmul e1000e crct10dif_common crc32c_intel scsi_tgt hpsa i2c_core ptp scsi_transport_sas pps_core dm_mirror dm_region_hash dm_log dm_mod
CPU: 2 PID: 7639 Comm: kworker/2:1 Kdump: loaded Tainted: G           OEL ------------   3.10.0-861.el7.x86_64 #1
Hardware name: HP ProLiant DL580 Gen9/ProLiant DL580 Gen9, BIOS U17 07/21/2016
Workqueue: qedf_2_dpc qedf_handle_rrq [qedf]
task: ffff959edd628fd0 ti: ffff959ed6f08000 task.ti: ffff959ed6f08000
RIP: 0010:[<ffffffff8355913a>]  [<ffffffff8355913a>] delay_tsc+0x3a/0x60
RSP: 0018:ffff959ed6f0bd30  EFLAGS: 00000246
RAX: 000000008ef5f791 RBX: 5f646d635f666465 RCX: 0000025b8ededa2f
RDX: 000000000000025b RSI: 0000000000000002 RDI: 0000000000217d1e
RBP: ffff959ed6f0bd30 R08: ffffffffc079aae8 R09: 0000000000000200
R10: ffffffffc07952c6 R11: 0000000000000000 R12: 6c6c615f66646571
R13: ffff959ed6f0bcc8 R14: ffff959ed6f0bd08 R15: ffff959e00000028
FS:  0000000000000000(0000) GS:ffff959eff480000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4117fa1eb0 CR3: 0000002039e66000 CR4: 00000000003607e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
[<ffffffff8355907d>] __const_udelay+0x2d/0x30
[<ffffffffc079444a>] qedf_initiate_els+0x13a/0x450 [qedf]
[<ffffffffc0794210>] ? qedf_srr_compl+0x2a0/0x2a0 [qedf]
[<ffffffffc0795337>] qedf_send_rrq+0x127/0x230 [qedf]
[<ffffffffc078ed55>] qedf_handle_rrq+0x15/0x20 [qedf]
[<ffffffff832b2dff>] process_one_work+0x17f/0x440
[<ffffffff832b3ac6>] worker_thread+0x126/0x3c0
[<ffffffff832b39a0>] ? manage_workers.isra.24+0x2a0/0x2a0
[<ffffffff832bae31>] kthread+0xd1/0xe0
[<ffffffff832bad60>] ? insert_kthread_work+0x40/0x40
[<ffffffff8391f637>] ret_from_fork_nospec_begin+0x21/0x21
[<ffffffff832bad60>] ? insert_kthread_work+0x40/0x40

Signed-off-by: Chad Dupuis <cdupuis@marvell.com>
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedf/qedf_els.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_els.c b/drivers/scsi/qedf/qedf_els.c
index 59c18ca4cda98..e5927a09f7bce 100644
--- a/drivers/scsi/qedf/qedf_els.c
+++ b/drivers/scsi/qedf/qedf_els.c
@@ -23,8 +23,6 @@ static int qedf_initiate_els(struct qedf_rport *fcport, unsigned int op,
 	int rc = 0;
 	uint32_t did, sid;
 	uint16_t xid;
-	uint32_t start_time = jiffies / HZ;
-	uint32_t current_time;
 	struct fcoe_wqe *sqe;
 	unsigned long flags;
 	u16 sqe_idx;
@@ -50,18 +48,12 @@ static int qedf_initiate_els(struct qedf_rport *fcport, unsigned int op,
 		goto els_err;
 	}
 
-retry_els:
 	els_req = qedf_alloc_cmd(fcport, QEDF_ELS);
 	if (!els_req) {
-		current_time = jiffies / HZ;
-		if ((current_time - start_time) > 10) {
-			QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_ELS,
-				   "els: Failed els 0x%x\n", op);
-			rc = -ENOMEM;
-			goto els_err;
-		}
-		mdelay(20 * USEC_PER_MSEC);
-		goto retry_els;
+		QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_ELS,
+			  "Failed to alloc ELS request 0x%x\n", op);
+		rc = -ENOMEM;
+		goto els_err;
 	}
 
 	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_ELS, "initiate_els els_req = "
-- 
2.20.1

