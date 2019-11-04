Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF068EEE4D
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389721AbfKDWJp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:09:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:42884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390005AbfKDWJo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:09:44 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 146E8205C9;
        Mon,  4 Nov 2019 22:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905383;
        bh=4BXDrXI9xj1Zj4UQmnaTufcVaddUamXeSea8JUCcXZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kahwR6lpVURSAd3f4MGOoKSkHjtVxlIhJ14xCt3jp9nrWQnOBpuOdxajXQ06tTekS
         uCumUAyZy5ANzlmzMz60rTSVPRH4vUlQlr2bU5qfisO8O1tymA7wVobsYuLJrH6yeI
         mNkHwr7G1wm+7OWKIi1IQ3mifhBLkMd8+DBxFMD8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Kaike Wan <kaike.wan@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Doug Ledford <dledford@redhat.com>
Subject: [PATCH 5.3 126/163] IB/hfi1: Avoid excessive retry for TID RDMA READ request
Date:   Mon,  4 Nov 2019 22:45:16 +0100
Message-Id: <20191104212149.372726382@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kaike Wan <kaike.wan@intel.com>

commit 9ed5bd7d22241ad232fd3a5be404e83eb6cadc04 upstream.

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
Link: https://lore.kernel.org/r/20191004204035.26542.41684.stgit@awfm-01.aw.intel.com
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/hfi1/tid_rdma.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/infiniband/hw/hfi1/tid_rdma.c
+++ b/drivers/infiniband/hw/hfi1/tid_rdma.c
@@ -2728,11 +2728,6 @@ static bool handle_read_kdeth_eflags(str
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


