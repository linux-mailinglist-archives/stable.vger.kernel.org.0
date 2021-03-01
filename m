Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00677328A37
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239527AbhCASNd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:13:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:58726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239335AbhCASI0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:08:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5873651DD;
        Mon,  1 Mar 2021 17:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619137;
        bh=mHwt9QB6yCfDBu3fYdlxEqHsTNgwJJxz/99L786tIbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U4GfgLTkfVONmilpC3WAXSEJOLW48FIz3sVFpKv5kD5gBVKi/ijtvhJL1ug7847Ni
         YC7mMrEvz3gMgiwln3OEUNfnnXB4MunQ6hTmHJ/IOGC9aYVbQ1VZTg11TTWtYYpnXj
         o+H2iS7CG1WiD3lbHtqdRHrLddJh2xwRSzi5oj5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Pearson <rpearson@hpe.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 345/663] RDMA/rxe: Fix coding error in rxe_recv.c
Date:   Mon,  1 Mar 2021 17:09:53 +0100
Message-Id: <20210301161158.917102922@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Pearson <rpearsonhpe@gmail.com>

[ Upstream commit 7d9ae80e31df57dd3253e1ec514f0000aa588a81 ]

check_type_state() in rxe_recv.c is written as if the type bits in the
packet opcode were a bit mask which is not correct. This patch corrects
this code to compare all 3 type bits to the required type.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Link: https://lore.kernel.org/r/20210127214500.3707-1-rpearson@hpe.com
Signed-off-by: Bob Pearson <rpearson@hpe.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_recv.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_recv.c b/drivers/infiniband/sw/rxe/rxe_recv.c
index c9984a28eecc7..db0ee5c3962e4 100644
--- a/drivers/infiniband/sw/rxe/rxe_recv.c
+++ b/drivers/infiniband/sw/rxe/rxe_recv.c
@@ -9,21 +9,26 @@
 #include "rxe.h"
 #include "rxe_loc.h"
 
+/* check that QP matches packet opcode type and is in a valid state */
 static int check_type_state(struct rxe_dev *rxe, struct rxe_pkt_info *pkt,
 			    struct rxe_qp *qp)
 {
+	unsigned int pkt_type;
+
 	if (unlikely(!qp->valid))
 		goto err1;
 
+	pkt_type = pkt->opcode & 0xe0;
+
 	switch (qp_type(qp)) {
 	case IB_QPT_RC:
-		if (unlikely((pkt->opcode & IB_OPCODE_RC) != 0)) {
+		if (unlikely(pkt_type != IB_OPCODE_RC)) {
 			pr_warn_ratelimited("bad qp type\n");
 			goto err1;
 		}
 		break;
 	case IB_QPT_UC:
-		if (unlikely(!(pkt->opcode & IB_OPCODE_UC))) {
+		if (unlikely(pkt_type != IB_OPCODE_UC)) {
 			pr_warn_ratelimited("bad qp type\n");
 			goto err1;
 		}
@@ -31,7 +36,7 @@ static int check_type_state(struct rxe_dev *rxe, struct rxe_pkt_info *pkt,
 	case IB_QPT_UD:
 	case IB_QPT_SMI:
 	case IB_QPT_GSI:
-		if (unlikely(!(pkt->opcode & IB_OPCODE_UD))) {
+		if (unlikely(pkt_type != IB_OPCODE_UD)) {
 			pr_warn_ratelimited("bad qp type\n");
 			goto err1;
 		}
-- 
2.27.0



