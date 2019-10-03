Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2632BCA41E
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390262AbfJCQWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:22:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:50772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390259AbfJCQWN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:22:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 615272054F;
        Thu,  3 Oct 2019 16:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119731;
        bh=3rTeblbVDwNiYlE+FOhFUdQvtJ+DL9jEiRgU/2hcQAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D0JYBvp1Rp+AtOM12LcwJj9tICM22+0B02VEY9kJgnxudR3DUP08swBRlq2qjqHWB
         bCjglMXSS1UT8yP17rOB+xh/s3Fr7NEYLufEfD4bO9ZRWbhPO1IjCZccY8qs90/Cop
         MNRsTYLFgVeRXNkIDAGIKRD+4fO8CUuE1D2Yyuxg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Kaike Wan <kaike.wan@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 4.19 155/211] IB/hfi1: Define variables as unsigned long to fix KASAN warning
Date:   Thu,  3 Oct 2019 17:53:41 +0200
Message-Id: <20191003154523.427874200@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

commit f8659d68e2bee5b86a1beaf7be42d942e1fc81f4 upstream.

Define the working variables to be unsigned long to be compatible with
for_each_set_bit and change types as needed.

While we are at it remove unused variables from a couple of functions.

This was found because of the following KASAN warning:
 ==================================================================
   BUG: KASAN: stack-out-of-bounds in find_first_bit+0x19/0x70
   Read of size 8 at addr ffff888362d778d0 by task kworker/u308:2/1889

   CPU: 21 PID: 1889 Comm: kworker/u308:2 Tainted: G W         5.3.0-rc2-mm1+ #2
   Hardware name: Intel Corporation W2600CR/W2600CR, BIOS SE5C600.86B.02.04.0003.102320141138 10/23/2014
   Workqueue: ib-comp-unb-wq ib_cq_poll_work [ib_core]
   Call Trace:
    dump_stack+0x9a/0xf0
    ? find_first_bit+0x19/0x70
    print_address_description+0x6c/0x332
    ? find_first_bit+0x19/0x70
    ? find_first_bit+0x19/0x70
    __kasan_report.cold.6+0x1a/0x3b
    ? find_first_bit+0x19/0x70
    kasan_report+0xe/0x12
    find_first_bit+0x19/0x70
    pma_get_opa_portstatus+0x5cc/0xa80 [hfi1]
    ? ret_from_fork+0x3a/0x50
    ? pma_get_opa_port_ectrs+0x200/0x200 [hfi1]
    ? stack_trace_consume_entry+0x80/0x80
    hfi1_process_mad+0x39b/0x26c0 [hfi1]
    ? __lock_acquire+0x65e/0x21b0
    ? clear_linkup_counters+0xb0/0xb0 [hfi1]
    ? check_chain_key+0x1d7/0x2e0
    ? lock_downgrade+0x3a0/0x3a0
    ? match_held_lock+0x2e/0x250
    ib_mad_recv_done+0x698/0x15e0 [ib_core]
    ? clear_linkup_counters+0xb0/0xb0 [hfi1]
    ? ib_mad_send_done+0xc80/0xc80 [ib_core]
    ? mark_held_locks+0x79/0xa0
    ? _raw_spin_unlock_irqrestore+0x44/0x60
    ? rvt_poll_cq+0x1e1/0x340 [rdmavt]
    __ib_process_cq+0x97/0x100 [ib_core]
    ib_cq_poll_work+0x31/0xb0 [ib_core]
    process_one_work+0x4ee/0xa00
    ? pwq_dec_nr_in_flight+0x110/0x110
    ? do_raw_spin_lock+0x113/0x1d0
    worker_thread+0x57/0x5a0
    ? process_one_work+0xa00/0xa00
    kthread+0x1bb/0x1e0
    ? kthread_create_on_node+0xc0/0xc0
    ret_from_fork+0x3a/0x50

   The buggy address belongs to the page:
   page:ffffea000d8b5dc0 refcount:0 mapcount:0 mapping:0000000000000000 index:0x0
   flags: 0x17ffffc0000000()
   raw: 0017ffffc0000000 0000000000000000 ffffea000d8b5dc8 0000000000000000
   raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
   page dumped because: kasan: bad access detected

   addr ffff888362d778d0 is located in stack of task kworker/u308:2/1889 at offset 32 in frame:
    pma_get_opa_portstatus+0x0/0xa80 [hfi1]

   this frame has 1 object:
    [32, 36) 'vl_select_mask'

   Memory state around the buggy address:
    ffff888362d77780: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    ffff888362d77800: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
   >ffff888362d77880: 00 00 00 00 00 00 f1 f1 f1 f1 04 f2 f2 f2 00 00
                                                    ^
    ffff888362d77900: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    ffff888362d77980: 00 00 00 00 00 00 00 00 f1 f1 f1 f1 04 f2 f2 f2

 ==================================================================

Cc: <stable@vger.kernel.org>
Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Link: https://lore.kernel.org/r/20190911113053.126040.47327.stgit@awfm-01.aw.intel.com
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/hfi1/mad.c |   45 ++++++++++++++++-----------------------
 1 file changed, 19 insertions(+), 26 deletions(-)

--- a/drivers/infiniband/hw/hfi1/mad.c
+++ b/drivers/infiniband/hw/hfi1/mad.c
@@ -2326,7 +2326,7 @@ struct opa_port_status_req {
 	__be32 vl_select_mask;
 };
 
-#define VL_MASK_ALL		0x000080ff
+#define VL_MASK_ALL		0x00000000000080ffUL
 
 struct opa_port_status_rsp {
 	__u8 port_num;
@@ -2625,15 +2625,14 @@ static int pma_get_opa_classportinfo(str
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
@@ -2730,12 +2729,12 @@ static int pma_get_opa_portstatus(struct
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
@@ -2771,7 +2770,7 @@ static int pma_get_opa_portstatus(struct
 
 	hfi1_read_link_quality(dd, &rsp->link_quality_indicator);
 
-	rsp->vl_select_mask = cpu_to_be32(vl_select_mask);
+	rsp->vl_select_mask = cpu_to_be32((u32)vl_select_mask);
 	rsp->port_xmit_data = cpu_to_be64(read_dev_cntr(dd, C_DC_XMIT_FLITS,
 					  CNTR_INVALID_VL));
 	rsp->port_rcv_data = cpu_to_be64(read_dev_cntr(dd, C_DC_RCV_FLITS,
@@ -2842,8 +2841,7 @@ static int pma_get_opa_portstatus(struct
 	 * So in the for_each_set_bit() loop below, we don't need
 	 * any additional checks for vl.
 	 */
-	for_each_set_bit(vl, (unsigned long *)&(vl_select_mask),
-			 8 * sizeof(vl_select_mask)) {
+	for_each_set_bit(vl, &vl_select_mask, BITS_PER_LONG) {
 		memset(vlinfo, 0, sizeof(*vlinfo));
 
 		tmp = read_dev_cntr(dd, C_DC_RX_FLIT_VL, idx_from_vl(vl));
@@ -2884,7 +2882,7 @@ static int pma_get_opa_portstatus(struct
 		vfi++;
 	}
 
-	a0_portstatus(ppd, rsp, vl_select_mask);
+	a0_portstatus(ppd, rsp);
 
 	if (resp_len)
 		*resp_len += response_data_size;
@@ -2931,16 +2929,14 @@ static u64 get_error_counter_summary(str
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
@@ -2995,7 +2991,7 @@ static int pma_get_opa_datacounters(stru
 	u64 port_mask;
 	u8 port_num;
 	unsigned long vl;
-	u32 vl_select_mask;
+	unsigned long vl_select_mask;
 	int vfi;
 	u16 link_width;
 	u16 link_speed;
@@ -3073,8 +3069,7 @@ static int pma_get_opa_datacounters(stru
 	 * So in the for_each_set_bit() loop below, we don't need
 	 * any additional checks for vl.
 	 */
-	for_each_set_bit(vl, (unsigned long *)&(vl_select_mask),
-			 8 * sizeof(req->vl_select_mask)) {
+	for_each_set_bit(vl, &vl_select_mask, BITS_PER_LONG) {
 		memset(vlinfo, 0, sizeof(*vlinfo));
 
 		rsp->vls[vfi].port_vl_xmit_data =
@@ -3122,7 +3117,7 @@ static int pma_get_opa_datacounters(stru
 		vfi++;
 	}
 
-	a0_datacounters(ppd, rsp, vl_select_mask);
+	a0_datacounters(ppd, rsp);
 
 	if (resp_len)
 		*resp_len += response_data_size;
@@ -3217,7 +3212,7 @@ static int pma_get_opa_porterrors(struct
 	struct _vls_ectrs *vlinfo;
 	unsigned long vl;
 	u64 port_mask, tmp;
-	u32 vl_select_mask;
+	unsigned long vl_select_mask;
 	int vfi;
 
 	req = (struct opa_port_error_counters64_msg *)pmp->data;
@@ -3276,8 +3271,7 @@ static int pma_get_opa_porterrors(struct
 	vlinfo = &rsp->vls[0];
 	vfi = 0;
 	vl_select_mask = be32_to_cpu(req->vl_select_mask);
-	for_each_set_bit(vl, (unsigned long *)&(vl_select_mask),
-			 8 * sizeof(req->vl_select_mask)) {
+	for_each_set_bit(vl, &vl_select_mask, BITS_PER_LONG) {
 		memset(vlinfo, 0, sizeof(*vlinfo));
 		rsp->vls[vfi].port_vl_xmit_discards =
 			cpu_to_be64(read_port_cntr(ppd, C_SW_XMIT_DSCD_VL,
@@ -3488,7 +3482,7 @@ static int pma_set_opa_portstatus(struct
 	u32 nports = be32_to_cpu(pmp->mad_hdr.attr_mod) >> 24;
 	u64 portn = be64_to_cpu(req->port_select_mask[3]);
 	u32 counter_select = be32_to_cpu(req->counter_select_mask);
-	u32 vl_select_mask = VL_MASK_ALL; /* clear all per-vl cnts */
+	unsigned long vl_select_mask = VL_MASK_ALL; /* clear all per-vl cnts */
 	unsigned long vl;
 
 	if ((nports != 1) || (portn != 1 << port)) {
@@ -3582,8 +3576,7 @@ static int pma_set_opa_portstatus(struct
 	if (counter_select & CS_UNCORRECTABLE_ERRORS)
 		write_dev_cntr(dd, C_DC_UNC_ERR, CNTR_INVALID_VL, 0);
 
-	for_each_set_bit(vl, (unsigned long *)&(vl_select_mask),
-			 8 * sizeof(vl_select_mask)) {
+	for_each_set_bit(vl, &vl_select_mask, BITS_PER_LONG) {
 		if (counter_select & CS_PORT_XMIT_DATA)
 			write_port_cntr(ppd, C_TX_FLIT_VL, idx_from_vl(vl), 0);
 


