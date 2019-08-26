Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9E3F9CC33
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 11:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730443AbfHZJH7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 05:07:59 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:49623 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730398AbfHZJH7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Aug 2019 05:07:59 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 15292377;
        Mon, 26 Aug 2019 05:07:58 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 26 Aug 2019 05:07:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=BpLf3J
        KzbMR7l5PNwcIbdNAaWgSsvD+F5Bx46vs9CWE=; b=fkKqUF8dBuWOYClFv6CLkz
        vm7RRS8JjisZzjfnBVEDWxrSw+UedfKzzjVEo4OYNfzJpMG/0kxAcHCO2YpT84A3
        kuMwXRGxLg0jbjKD68tRGF1LOkECb6j6FZL2Lu3BUv1k+eqKpOkfwqIBtjv6Y/wp
        /wIKZgZuuFQPKYHCKe9IIj0W6SOh2P4Bd1Xi2IX+ku2zwmZONg0FawMe9ta/SN9L
        rqCYj1KsDYNM605EkN1oO0KteLgDheR31saGZJpptKW5DZS/h35RpTF2g9rH+WMh
        09QYIpsJUw/w56p1lXy0wycX8ZT5hDohtnLx/MgkFpvSU424Y/Ta6c37/D/R9NGA
        ==
X-ME-Sender: <xms:baFjXXe7UzBGrS477zqrjJEcKjceW9buvhUN1pkFIp-Jx830hBffuw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudehgedguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeelrddvtdehrdduvd
    ekrddvgeeinecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtgho
    mhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:baFjXYOh3iqoM03MVKaKhP1L708WW8hh6SJI5ImdWw74k5JZ2MYR5w>
    <xmx:baFjXfgqW9fGeUT0bsKh7NzgeGCCvMDH3u87s1K9dLE31uqn1e-15w>
    <xmx:baFjXaouHrIlnpXJzFoH9EgLCNMwc2PcyLIvEi_xUzNB71M_rmeQWg>
    <xmx:baFjXYAbSxrya4G-7E6Ufi6gYh6tWJ4GXL3BfTwQra3PmBZ_OVu49w>
Received: from localhost (unknown [89.205.128.246])
        by mail.messagingengine.com (Postfix) with ESMTPA id D2202D6005A;
        Mon, 26 Aug 2019 05:07:56 -0400 (EDT)
Subject: FAILED: patch "[PATCH] IB/hfi1: Drop stale TID RDMA packets" failed to apply to 5.2-stable tree
To:     kaike.wan@intel.com, dennis.dalessandro@intel.com,
        dledford@redhat.com, mike.marciniszyn@intel.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 26 Aug 2019 11:07:54 +0200
Message-ID: <156681047429195@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.2-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d58c1834bf0d218a0bc00f8fb44874551b21da84 Mon Sep 17 00:00:00 2001
From: Kaike Wan <kaike.wan@intel.com>
Date: Thu, 15 Aug 2019 15:20:33 -0400
Subject: [PATCH] IB/hfi1: Drop stale TID RDMA packets

In a congested fabric with adaptive routing enabled, traces show that
the sender could receive stale TID RDMA NAK packets that contain newer
KDETH PSNs and older Verbs PSNs. If not dropped, these packets could
cause the incorrect rewinding of the software flows and the incorrect
completion of TID RDMA WRITE requests, and eventually leading to memory
corruption and kernel crash.

The current code drops stale TID RDMA ACK/NAK packets solely based
on KDETH PSNs, which may lead to erroneous processing. This patch
fixes the issue by also checking the Verbs PSN. Addition checks are
added before rewinding the TID RDMA WRITE DATA packets.

Fixes: 9e93e967f7b4 ("IB/hfi1: Add a function to receive TID RDMA ACK packet")
Cc: <stable@vger.kernel.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Link: https://lore.kernel.org/r/20190815192033.105923.44192.stgit@awfm-01.aw.intel.com
Signed-off-by: Doug Ledford <dledford@redhat.com>

diff --git a/drivers/infiniband/hw/hfi1/tid_rdma.c b/drivers/infiniband/hw/hfi1/tid_rdma.c
index 996fc298207e..94070144fef5 100644
--- a/drivers/infiniband/hw/hfi1/tid_rdma.c
+++ b/drivers/infiniband/hw/hfi1/tid_rdma.c
@@ -4509,7 +4509,7 @@ void hfi1_rc_rcv_tid_rdma_ack(struct hfi1_packet *packet)
 	struct rvt_swqe *wqe;
 	struct tid_rdma_request *req;
 	struct tid_rdma_flow *flow;
-	u32 aeth, psn, req_psn, ack_psn, resync_psn, ack_kpsn;
+	u32 aeth, psn, req_psn, ack_psn, flpsn, resync_psn, ack_kpsn;
 	unsigned long flags;
 	u16 fidx;
 
@@ -4538,6 +4538,9 @@ void hfi1_rc_rcv_tid_rdma_ack(struct hfi1_packet *packet)
 		ack_kpsn--;
 	}
 
+	if (unlikely(qp->s_acked == qp->s_tail))
+		goto ack_op_err;
+
 	wqe = rvt_get_swqe_ptr(qp, qp->s_acked);
 
 	if (wqe->wr.opcode != IB_WR_TID_RDMA_WRITE)
@@ -4550,7 +4553,8 @@ void hfi1_rc_rcv_tid_rdma_ack(struct hfi1_packet *packet)
 	trace_hfi1_tid_flow_rcv_tid_ack(qp, req->acked_tail, flow);
 
 	/* Drop stale ACK/NAK */
-	if (cmp_psn(psn, full_flow_psn(flow, flow->flow_state.spsn)) < 0)
+	if (cmp_psn(psn, full_flow_psn(flow, flow->flow_state.spsn)) < 0 ||
+	    cmp_psn(req_psn, flow->flow_state.resp_ib_psn) < 0)
 		goto ack_op_err;
 
 	while (cmp_psn(ack_kpsn,
@@ -4712,7 +4716,12 @@ done:
 		switch ((aeth >> IB_AETH_CREDIT_SHIFT) &
 			IB_AETH_CREDIT_MASK) {
 		case 0: /* PSN sequence error */
+			if (!req->flows)
+				break;
 			flow = &req->flows[req->acked_tail];
+			flpsn = full_flow_psn(flow, flow->flow_state.lpsn);
+			if (cmp_psn(psn, flpsn) > 0)
+				break;
 			trace_hfi1_tid_flow_rcv_tid_ack(qp, req->acked_tail,
 							flow);
 			req->r_ack_psn = mask_psn(be32_to_cpu(ohdr->bth[2]));

