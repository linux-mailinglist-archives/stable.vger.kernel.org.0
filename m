Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAAC1AFB62
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 13:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727611AbfIKLa6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Sep 2019 07:30:58 -0400
Received: from mga12.intel.com ([192.55.52.136]:57172 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727565AbfIKLa5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Sep 2019 07:30:57 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Sep 2019 04:30:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="187154149"
Received: from sedona.ch.intel.com ([10.2.136.157])
  by orsmga003.jf.intel.com with ESMTP; 11 Sep 2019 04:30:56 -0700
Received: from awfm-01.aw.intel.com (awfm-01.aw.intel.com [10.228.212.213])
        by sedona.ch.intel.com (8.14.3/8.14.3/Standard MailSET/Hub) with ESMTP id x8BBUtf5065287;
        Wed, 11 Sep 2019 04:30:55 -0700
Received: from awfm-01.aw.intel.com (localhost [127.0.0.1])
        by awfm-01.aw.intel.com (8.14.7/8.14.7) with ESMTP id x8BBUrYc126130;
        Wed, 11 Sep 2019 07:30:54 -0400
Subject: [PATCH for-next 3/3] IB/hfi1: Define variables as unsigned long to
 fix KASAN warning
From:   Dennis Dalessandro <dennis.dalessandro@intel.com>
To:     jgg@ziepe.ca, dledford@redhat.com
Cc:     linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Ira Weiny <ira.weiny@intel.com>, stable@vger.kernel.org,
        Kaike Wan <kaike.wan@intel.com>
Date:   Wed, 11 Sep 2019 07:30:53 -0400
Message-ID: <20190911113053.126040.47327.stgit@awfm-01.aw.intel.com>
In-Reply-To: <20190911112912.126040.72184.stgit@awfm-01.aw.intel.com>
References: <20190911112912.126040.72184.stgit@awfm-01.aw.intel.com>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

Define the working variables to be unsigned long to be compatible with
for_each_set_bit and change types as needed.

While we are at it remove unused variables from a couple of functions.

This was found because of the following KASAN warning:
[ 1383.018461] ==================================================================
[ 1383.029116] BUG: KASAN: stack-out-of-bounds in find_first_bit+0x19/0x70
[ 1383.038646] Read of size 8 at addr ffff888362d778d0 by task kworker/u308:2/1889
[ 1383.049006]
[ 1383.052766] CPU: 21 PID: 1889 Comm: kworker/u308:2 Tainted: G W         5.3.0-rc2-mm1+ #2
[ 1383.064765] Hardware name: Intel Corporation W2600CR/W2600CR, BIOS SE5C600.86B.02.04.0003.102320141138 10/23/2014
[ 1383.078498] Workqueue: ib-comp-unb-wq ib_cq_poll_work [ib_core]
[ 1383.087314] Call Trace:
[ 1383.092211]  dump_stack+0x9a/0xf0
[ 1383.098074]  ? find_first_bit+0x19/0x70
[ 1383.104546]  print_address_description+0x6c/0x332
[ 1383.111986]  ? find_first_bit+0x19/0x70
[ 1383.118443]  ? find_first_bit+0x19/0x70
[ 1383.124882]  __kasan_report.cold.6+0x1a/0x3b
[ 1383.131808]  ? find_first_bit+0x19/0x70
[ 1383.138244]  kasan_report+0xe/0x12
[ 1383.144169]  find_first_bit+0x19/0x70
[ 1383.150413]  pma_get_opa_portstatus+0x5cc/0xa80 [hfi1]
[ 1383.158275]  ? ret_from_fork+0x3a/0x50
[ 1383.164583]  ? pma_get_opa_port_ectrs+0x200/0x200 [hfi1]
[ 1383.172629]  ? stack_trace_consume_entry+0x80/0x80
[ 1383.180097]  hfi1_process_mad+0x39b/0x26c0 [hfi1]
[ 1383.187420]  ? __lock_acquire+0x65e/0x21b0
[ 1383.194081]  ? clear_linkup_counters+0xb0/0xb0 [hfi1]
[ 1383.201788]  ? check_chain_key+0x1d7/0x2e0
[ 1383.208391]  ? lock_downgrade+0x3a0/0x3a0
[ 1383.214906]  ? match_held_lock+0x2e/0x250
[ 1383.221479]  ib_mad_recv_done+0x698/0x15e0 [ib_core]
[ 1383.229187]  ? clear_linkup_counters+0xb0/0xb0 [hfi1]
[ 1383.236977]  ? ib_mad_send_done+0xc80/0xc80 [ib_core]
[ 1383.244778]  ? mark_held_locks+0x79/0xa0
[ 1383.251341]  ? _raw_spin_unlock_irqrestore+0x44/0x60
[ 1383.259086]  ? rvt_poll_cq+0x1e1/0x340 [rdmavt]
[ 1383.266362]  __ib_process_cq+0x97/0x100 [ib_core]
[ 1383.273822]  ib_cq_poll_work+0x31/0xb0 [ib_core]
[ 1383.281169]  process_one_work+0x4ee/0xa00
[ 1383.287822]  ? pwq_dec_nr_in_flight+0x110/0x110
[ 1383.295047]  ? do_raw_spin_lock+0x113/0x1d0
[ 1383.301880]  worker_thread+0x57/0x5a0
[ 1383.308138]  ? process_one_work+0xa00/0xa00
[ 1383.314937]  kthread+0x1bb/0x1e0
[ 1383.320643]  ? kthread_create_on_node+0xc0/0xc0
[ 1383.327822]  ret_from_fork+0x3a/0x50
[ 1383.333928]
[ 1383.337640] The buggy address belongs to the page:
[ 1383.345080] page:ffffea000d8b5dc0 refcount:0 mapcount:0 mapping:0000000000000000 index:0x0
[ 1383.356490] flags: 0x17ffffc0000000()
[ 1383.362705] raw: 0017ffffc0000000 0000000000000000 ffffea000d8b5dc8 0000000000000000
[ 1383.373530] raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
[ 1383.384321] page dumped because: kasan: bad access detected
[ 1383.392659]
[ 1383.396350] addr ffff888362d778d0 is located in stack of task kworker/u308:2/1889 at offset 32 in frame:
[ 1383.409191]  pma_get_opa_portstatus+0x0/0xa80 [hfi1]
[ 1383.416843]
[ 1383.420497] this frame has 1 object:
[ 1383.426494]  [32, 36) 'vl_select_mask'
[ 1383.426495]
[ 1383.436313] Memory state around the buggy address:
[ 1383.443706]  ffff888362d77780: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 1383.453865]  ffff888362d77800: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 1383.464033] >ffff888362d77880: 00 00 00 00 00 00 f1 f1 f1 f1 04 f2 f2 f2 00 00
[ 1383.474199]                                                  ^
[ 1383.482828]  ffff888362d77900: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 1383.493071]  ffff888362d77980: 00 00 00 00 00 00 00 00 f1 f1 f1 f1 04 f2 f2 f2
[ 1383.503314]
==================================================================

Cc: <stable@vger.kernel.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
---
 drivers/infiniband/hw/hfi1/mad.c |   45 ++++++++++++++++----------------------
 1 file changed, 19 insertions(+), 26 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
index 184dba3..d8ff063 100644
--- a/drivers/infiniband/hw/hfi1/mad.c
+++ b/drivers/infiniband/hw/hfi1/mad.c
@@ -2326,7 +2326,7 @@ struct opa_port_status_req {
 	__be32 vl_select_mask;
 };
 
-#define VL_MASK_ALL		0x000080ff
+#define VL_MASK_ALL		0x00000000000080ffUL
 
 struct opa_port_status_rsp {
 	__u8 port_num;
@@ -2625,15 +2625,14 @@ static int pma_get_opa_classportinfo(struct opa_pma_mad *pmp,
 }
 
 static void a0_portstatus(struct hfi1_pportdata *ppd,
-			  struct opa_port_status_rsp *rsp, u32 vl_select_mask)
+			  struct opa_port_status_rsp *rsp)
 {
 	if (!is_bx(ppd->dd)) {
 		unsigned long vl;
 		u64 sum_vl_xmit_wait = 0;
-		u32 vl_all_mask = VL_MASK_ALL;
+		unsigned long vl_all_mask = VL_MASK_ALL;
 
-		for_each_set_bit(vl, (unsigned long *)&(vl_all_mask),
-				 8 * sizeof(vl_all_mask)) {
+		for_each_set_bit(vl, &vl_all_mask, BITS_PER_LONG) {
 			u64 tmp = sum_vl_xmit_wait +
 				  read_port_cntr(ppd, C_TX_WAIT_VL,
 						 idx_from_vl(vl));
@@ -2730,12 +2729,12 @@ static int pma_get_opa_portstatus(struct opa_pma_mad *pmp,
 		(struct opa_port_status_req *)pmp->data;
 	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
 	struct opa_port_status_rsp *rsp;
-	u32 vl_select_mask = be32_to_cpu(req->vl_select_mask);
+	unsigned long vl_select_mask = be32_to_cpu(req->vl_select_mask);
 	unsigned long vl;
 	size_t response_data_size;
 	u32 nports = be32_to_cpu(pmp->mad_hdr.attr_mod) >> 24;
 	u8 port_num = req->port_num;
-	u8 num_vls = hweight32(vl_select_mask);
+	u8 num_vls = hweight64(vl_select_mask);
 	struct _vls_pctrs *vlinfo;
 	struct hfi1_ibport *ibp = to_iport(ibdev, port);
 	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
@@ -2770,7 +2769,7 @@ static int pma_get_opa_portstatus(struct opa_pma_mad *pmp,
 
 	hfi1_read_link_quality(dd, &rsp->link_quality_indicator);
 
-	rsp->vl_select_mask = cpu_to_be32(vl_select_mask);
+	rsp->vl_select_mask = cpu_to_be32((u32)vl_select_mask);
 	rsp->port_xmit_data = cpu_to_be64(read_dev_cntr(dd, C_DC_XMIT_FLITS,
 					  CNTR_INVALID_VL));
 	rsp->port_rcv_data = cpu_to_be64(read_dev_cntr(dd, C_DC_RCV_FLITS,
@@ -2841,8 +2840,7 @@ static int pma_get_opa_portstatus(struct opa_pma_mad *pmp,
 	 * So in the for_each_set_bit() loop below, we don't need
 	 * any additional checks for vl.
 	 */
-	for_each_set_bit(vl, (unsigned long *)&(vl_select_mask),
-			 8 * sizeof(vl_select_mask)) {
+	for_each_set_bit(vl, &vl_select_mask, BITS_PER_LONG) {
 		memset(vlinfo, 0, sizeof(*vlinfo));
 
 		tmp = read_dev_cntr(dd, C_DC_RX_FLIT_VL, idx_from_vl(vl));
@@ -2883,7 +2881,7 @@ static int pma_get_opa_portstatus(struct opa_pma_mad *pmp,
 		vfi++;
 	}
 
-	a0_portstatus(ppd, rsp, vl_select_mask);
+	a0_portstatus(ppd, rsp);
 
 	if (resp_len)
 		*resp_len += response_data_size;
@@ -2930,16 +2928,14 @@ static u64 get_error_counter_summary(struct ib_device *ibdev, u8 port,
 	return error_counter_summary;
 }
 
-static void a0_datacounters(struct hfi1_pportdata *ppd, struct _port_dctrs *rsp,
-			    u32 vl_select_mask)
+static void a0_datacounters(struct hfi1_pportdata *ppd, struct _port_dctrs *rsp)
 {
 	if (!is_bx(ppd->dd)) {
 		unsigned long vl;
 		u64 sum_vl_xmit_wait = 0;
-		u32 vl_all_mask = VL_MASK_ALL;
+		unsigned long vl_all_mask = VL_MASK_ALL;
 
-		for_each_set_bit(vl, (unsigned long *)&(vl_all_mask),
-				 8 * sizeof(vl_all_mask)) {
+		for_each_set_bit(vl, &vl_all_mask, BITS_PER_LONG) {
 			u64 tmp = sum_vl_xmit_wait +
 				  read_port_cntr(ppd, C_TX_WAIT_VL,
 						 idx_from_vl(vl));
@@ -2994,7 +2990,7 @@ static int pma_get_opa_datacounters(struct opa_pma_mad *pmp,
 	u64 port_mask;
 	u8 port_num;
 	unsigned long vl;
-	u32 vl_select_mask;
+	unsigned long vl_select_mask;
 	int vfi;
 	u16 link_width;
 	u16 link_speed;
@@ -3071,8 +3067,7 @@ static int pma_get_opa_datacounters(struct opa_pma_mad *pmp,
 	 * So in the for_each_set_bit() loop below, we don't need
 	 * any additional checks for vl.
 	 */
-	for_each_set_bit(vl, (unsigned long *)&(vl_select_mask),
-			 8 * sizeof(req->vl_select_mask)) {
+	for_each_set_bit(vl, &vl_select_mask, BITS_PER_LONG) {
 		memset(vlinfo, 0, sizeof(*vlinfo));
 
 		rsp->vls[vfi].port_vl_xmit_data =
@@ -3120,7 +3115,7 @@ static int pma_get_opa_datacounters(struct opa_pma_mad *pmp,
 		vfi++;
 	}
 
-	a0_datacounters(ppd, rsp, vl_select_mask);
+	a0_datacounters(ppd, rsp);
 
 	if (resp_len)
 		*resp_len += response_data_size;
@@ -3215,7 +3210,7 @@ static int pma_get_opa_porterrors(struct opa_pma_mad *pmp,
 	struct _vls_ectrs *vlinfo;
 	unsigned long vl;
 	u64 port_mask, tmp;
-	u32 vl_select_mask;
+	unsigned long vl_select_mask;
 	int vfi;
 
 	req = (struct opa_port_error_counters64_msg *)pmp->data;
@@ -3273,8 +3268,7 @@ static int pma_get_opa_porterrors(struct opa_pma_mad *pmp,
 	vlinfo = &rsp->vls[0];
 	vfi = 0;
 	vl_select_mask = be32_to_cpu(req->vl_select_mask);
-	for_each_set_bit(vl, (unsigned long *)&(vl_select_mask),
-			 8 * sizeof(req->vl_select_mask)) {
+	for_each_set_bit(vl, &vl_select_mask, BITS_PER_LONG) {
 		memset(vlinfo, 0, sizeof(*vlinfo));
 		rsp->vls[vfi].port_vl_xmit_discards =
 			cpu_to_be64(read_port_cntr(ppd, C_SW_XMIT_DSCD_VL,
@@ -3485,7 +3479,7 @@ static int pma_set_opa_portstatus(struct opa_pma_mad *pmp,
 	u32 nports = be32_to_cpu(pmp->mad_hdr.attr_mod) >> 24;
 	u64 portn = be64_to_cpu(req->port_select_mask[3]);
 	u32 counter_select = be32_to_cpu(req->counter_select_mask);
-	u32 vl_select_mask = VL_MASK_ALL; /* clear all per-vl cnts */
+	unsigned long vl_select_mask = VL_MASK_ALL; /* clear all per-vl cnts */
 	unsigned long vl;
 
 	if ((nports != 1) || (portn != 1 << port)) {
@@ -3579,8 +3573,7 @@ static int pma_set_opa_portstatus(struct opa_pma_mad *pmp,
 	if (counter_select & CS_UNCORRECTABLE_ERRORS)
 		write_dev_cntr(dd, C_DC_UNC_ERR, CNTR_INVALID_VL, 0);
 
-	for_each_set_bit(vl, (unsigned long *)&(vl_select_mask),
-			 8 * sizeof(vl_select_mask)) {
+	for_each_set_bit(vl, &vl_select_mask, BITS_PER_LONG) {
 		if (counter_select & CS_PORT_XMIT_DATA)
 			write_port_cntr(ppd, C_TX_FLIT_VL, idx_from_vl(vl), 0);
 

