Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBB4CCC456
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 22:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388638AbfJDUkj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 16:40:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:8925 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388633AbfJDUkj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 16:40:39 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Oct 2019 13:40:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,257,1566889200"; 
   d="scan'208";a="276158758"
Received: from sedona.ch.intel.com ([10.2.136.157])
  by orsmga001.jf.intel.com with ESMTP; 04 Oct 2019 13:40:38 -0700
Received: from awfm-01.aw.intel.com (awfm-01.aw.intel.com [10.228.212.213])
        by sedona.ch.intel.com (8.14.3/8.14.3/Standard MailSET/Hub) with ESMTP id x94Kebwh057931;
        Fri, 4 Oct 2019 13:40:38 -0700
Received: from awfm-01.aw.intel.com (localhost [127.0.0.1])
        by awfm-01.aw.intel.com (8.14.7/8.14.7) with ESMTP id x94KeZBZ026620;
        Fri, 4 Oct 2019 16:40:35 -0400
Subject: [PATCH for-rc 1/2] IB/hfi1: Avoid excessive retry for TID RDMA READ
 request
From:   Dennis Dalessandro <dennis.dalessandro@intel.com>
To:     jgg@ziepe.ca, dledford@redhat.com
Cc:     linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>
Date:   Fri, 04 Oct 2019 16:40:35 -0400
Message-ID: <20191004204035.26542.41684.stgit@awfm-01.aw.intel.com>
In-Reply-To: <20191004203739.26542.57060.stgit@awfm-01.aw.intel.com>
References: <20191004203739.26542.57060.stgit@awfm-01.aw.intel.com>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kaike Wan <kaike.wan@intel.com>

A TID RDMA READ request could be retried under one of the following
conditions:
- The RC retry timer expires;
- A later TID RDMA READ RESP packet is received before the next
  expected one.
For the latter, under normal conditions, the PSN in IB space is used
for comparison. More specifically, the IB PSN in the incoming TID RDMA
READ RESP packet is compared with the last IB PSN of a given TID RDMA
READ request to determine if the request should be retried. This is
similar to the retry logic for noraml RDMA READ request.

However, if a TID RDMA READ RESP packet is lost due to congestion,
header suppresion will be disabled and each incoming packet will raise
an interrupt until the hardware flow is reloaded. Under this condition,
each packet KDETH PSN will be checked by software against r_next_psn
and a retry will be requested if the packet KDETH PSN is later than
r_next_psn. Since each TID RDMA READ segment could have up to 64
packets and each TID RDMA READ request could have many segments, we
could make far more retries under such conditions, and thus leading to
RETRY_EXC_ERR status.

This patch fixes the issue by removing the retry when the incoming
packet KDETH PSN is later than r_next_psn. Instead, it resorts to
RC timer and normal IB PSN comparison for any request retry.

Fixes: 9905bf06e890 ("IB/hfi1: Add functions to receive TID RDMA READ response")
Cc: <stable@vger.kernel.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
---
 drivers/infiniband/hw/hfi1/tid_rdma.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/tid_rdma.c b/drivers/infiniband/hw/hfi1/tid_rdma.c
index b4dcc4d..f21fca3 100644
--- a/drivers/infiniband/hw/hfi1/tid_rdma.c
+++ b/drivers/infiniband/hw/hfi1/tid_rdma.c
@@ -2736,11 +2736,6 @@ static bool handle_read_kdeth_eflags(struct hfi1_ctxtdata *rcd,
 				diff = cmp_psn(psn,
 					       flow->flow_state.r_next_psn);
 				if (diff > 0) {
-					if (!(qp->r_flags & RVT_R_RDMAR_SEQ))
-						restart_tid_rdma_read_req(rcd,
-									  qp,
-									  wqe);
-
 					/* Drop the packet.*/
 					goto s_unlock;
 				} else if (diff < 0) {

