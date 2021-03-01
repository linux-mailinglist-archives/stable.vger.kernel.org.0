Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB463286F1
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237783AbhCARRp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:17:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:37624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236667AbhCARIl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:08:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AAD365013;
        Mon,  1 Mar 2021 16:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616920;
        bh=xDwEW4+jr+KPC+KdUdpWdvNyAV8fF00I/vEh8pQNG/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xWwY0Iq3/GuY6Yha1lPQA6m2n3p55nebOLnKT9atVmSzpjGykfhe5ZsS6C4bUUQ1A
         wlZ5seJWZ6WNcNdO4PMAcULJNZs0FgVJ9/jzHfSdg8Akcuhol5uiS2RXUXX6ToqT4L
         G+bhyQpTMkuKStfw6KBmOBCl7eY1K7EROsMyPyk4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Pearson <rpearson@hpe.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 141/247] RDMA/rxe: Fix coding error in rxe_recv.c
Date:   Mon,  1 Mar 2021 17:12:41 +0100
Message-Id: <20210301161038.573369527@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
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
index b8f3e65402d1d..d94e2c5bc317d 100644
--- a/drivers/infiniband/sw/rxe/rxe_recv.c
+++ b/drivers/infiniband/sw/rxe/rxe_recv.c
@@ -36,21 +36,26 @@
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
@@ -58,7 +63,7 @@ static int check_type_state(struct rxe_dev *rxe, struct rxe_pkt_info *pkt,
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



