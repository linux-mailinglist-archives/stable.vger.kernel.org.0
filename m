Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD4E1927D
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbfEITIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 15:08:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:37058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727300AbfEISpS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:45:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86933217F9;
        Thu,  9 May 2019 18:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427518;
        bh=wjbGWFqpVYEx/KMtz9p5c0//79ohF9cJwwfkSlbOwzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y2PxZTHvAMJ0VQUI09efvh+BDGZpskARNafy3j04FKvxg00AMaPzIs2M8zGX7WQQd
         EgTtepgRRNtXaUdSzgWW8kIVm8gnBKCIZotr67u3cpht3u+r/byXDe4J8aY3DpWoZd
         oDaP4j0dViukqoxXnoMqJIe967BInGxoOOd3H/H0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Kaike Wan <kaike.wan@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 12/42] IB/hfi1: Eliminate opcode tests on mr deref
Date:   Thu,  9 May 2019 20:42:01 +0200
Message-Id: <20190509181255.161329314@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181252.616018683@linuxfoundation.org>
References: <20190509181252.616018683@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a8639a79e85c18c16c10089edd589c7948f19bbd ]

When an old ack_queue entry is used to store an incoming request, it may
need to clean up the old entry if it is still referencing the
MR. Originally only RDMA READ request needed to reference MR on the
responder side and therefore the opcode was tested when cleaning up the
old entry. The introduction of tid rdma specific operations in the
ack_queue makes the specific opcode tests wrong.  Multiple opcodes (RDMA
READ, TID RDMA READ, and TID RDMA WRITE) may need MR ref cleanup.

Remove the opcode specific tests associated with the ack_queue.

Fixes: f48ad614c100 ("IB/hfi1: Move driver out of staging")
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/rc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index d3b8cb92fd6d6..28eb7003c297e 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -2309,7 +2309,7 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 			update_ack_queue(qp, next);
 		}
 		e = &qp->s_ack_queue[qp->r_head_ack_queue];
-		if (e->opcode == OP(RDMA_READ_REQUEST) && e->rdma_sge.mr) {
+		if (e->rdma_sge.mr) {
 			rvt_put_mr(e->rdma_sge.mr);
 			e->rdma_sge.mr = NULL;
 		}
@@ -2383,7 +2383,7 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 			update_ack_queue(qp, next);
 		}
 		e = &qp->s_ack_queue[qp->r_head_ack_queue];
-		if (e->opcode == OP(RDMA_READ_REQUEST) && e->rdma_sge.mr) {
+		if (e->rdma_sge.mr) {
 			rvt_put_mr(e->rdma_sge.mr);
 			e->rdma_sge.mr = NULL;
 		}
-- 
2.20.1



