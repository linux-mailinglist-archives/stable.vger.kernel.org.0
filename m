Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FDAD81C9D
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731279AbfHENZs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:25:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:34320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731288AbfHENZr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:25:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3F2820651;
        Mon,  5 Aug 2019 13:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011546;
        bh=DRDerXr9DW86qLGdmqopt7ynBm6nHUnwaVDipglW7BA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=niOxGXooJz3aBI+grsWaEPpuX7RGxjW2F42uCpcQxzVgcahXqBoRN6Up21UbL1Ro1
         Knhwxc/g6tRXWEqupTDSQjrKoIWH1sUqMYYFH2JzCGwSiU+rHPdIkIpINWxGcu1htg
         dMInEVnim/tNv456FDGlszgPKhyEVp9uu4WTzXLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Kaike Wan <kaike.wan@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.2 129/131] IB/hfi1: Field not zero-ed when allocating TID flow memory
Date:   Mon,  5 Aug 2019 15:03:36 +0200
Message-Id: <20190805125000.619598200@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kaike Wan <kaike.wan@intel.com>

commit dc25b239ebeaa3c58e5ceaa732140427d386aa16 upstream.

The field flow->resync_npkts is added for TID RDMA WRITE request and
zero-ed when a TID RDMA WRITE RESP packet is received by the requester.
This field is used to rewind a request during retry in the function
hfi1_tid_rdma_restart_req() shared by both TID RDMA WRITE and TID RDMA
READ requests. Therefore, when a TID RDMA READ request is retried, this
field may not be initialized at all, which causes the retry to start at an
incorrect psn, leading to the drop of the retry request by the responder.

This patch fixes the problem by zeroing out the field when the flow memory
is allocated.

Fixes: 838b6fd2d9ca ("IB/hfi1: TID RDMA RcvArray programming and TID allocation")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190715164534.74174.6177.stgit@awfm-01.aw.intel.com
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/hfi1/tid_rdma.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/infiniband/hw/hfi1/tid_rdma.c
+++ b/drivers/infiniband/hw/hfi1/tid_rdma.c
@@ -1620,6 +1620,7 @@ static int hfi1_kern_exp_rcv_alloc_flows
 		flows[i].req = req;
 		flows[i].npagesets = 0;
 		flows[i].pagesets[0].mapped =  0;
+		flows[i].resync_npkts = 0;
 	}
 	req->flows = flows;
 	return 0;


