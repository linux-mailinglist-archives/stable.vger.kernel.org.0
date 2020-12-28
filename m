Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02BFD2E3874
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731403AbgL1NKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:10:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:37962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729679AbgL1NKa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:10:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E441A20728;
        Mon, 28 Dec 2020 13:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161014;
        bh=fRTe/BIEwO1lR6nwfXwwrFYIGxDT2pdPzAUgcL/kN0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D2UPcqcVHhlQEb/ojl327mHCBX+MXCq0ivV6z1cl2loksL3kVcNp9rPyBItMpzfNB
         12sy9A5+idS5ahACVV33oqHEHvofGL6OqpfY15NQ8cGiplspMm7XMQEab451+bewjB
         zgqR5kg4cly/8wEukQjSWyTH+NRhFUQC5ufsUgE4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Pearson <rpearson@hpe.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 070/242] RDMA/rxe: Compute PSN windows correctly
Date:   Mon, 28 Dec 2020 13:47:55 +0100
Message-Id: <20201228124908.132070682@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Pearson <rpearsonhpe@gmail.com>

[ Upstream commit bb3ab2979fd69db23328691cb10067861df89037 ]

The code which limited the number of unacknowledged PSNs was incorrect.
The PSNs are limited to 24 bits and wrap back to zero from 0x00ffffff.
The test was computing a 32 bit value which wraps at 32 bits so that
qp->req.psn can appear smaller than the limit when it is actually larger.

Replace '>' test with psn_compare which is used for other PSN comparisons
and correctly handles the 24 bit size.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Link: https://lore.kernel.org/r/20201013170741.3590-1-rpearson@hpe.com
Signed-off-by: Bob Pearson <rpearson@hpe.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_req.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index e6785b1ea85fc..693884160f001 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -664,7 +664,8 @@ next_wqe:
 	}
 
 	if (unlikely(qp_type(qp) == IB_QPT_RC &&
-		     qp->req.psn > (qp->comp.psn + RXE_MAX_UNACKED_PSNS))) {
+		psn_compare(qp->req.psn, (qp->comp.psn +
+				RXE_MAX_UNACKED_PSNS)) > 0)) {
 		qp->req.wait_psn = 1;
 		goto exit;
 	}
-- 
2.27.0



