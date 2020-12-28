Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 512092E646B
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404018AbgL1Nlk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:41:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:41182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391716AbgL1NlR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:41:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B8362072C;
        Mon, 28 Dec 2020 13:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162861;
        bh=n29iSIayAGoQthCSX7cDc41eygdBqzktyUvlH1Jq6z8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vq1oDNbGevKjrNw3O8sFWW+cS7LfjYWpEqBBVdJ+Cju2kMyd0AEHxyz+UxB1sRjeL
         clGDQ7M2Y5M6nZXpJ8W+aj53XrEK7Bd/VOaHTEssoEj99P6IsqrFA7isuc+5KNIfyF
         G3KPgPjuRPEmxJvV3pxBZ9clowqH0QkNzEjePTAQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Pearson <rpearson@hpe.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 087/453] RDMA/rxe: Compute PSN windows correctly
Date:   Mon, 28 Dec 2020 13:45:23 +0100
Message-Id: <20201228124941.418830198@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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
index e5031172c0193..a4d6e0b7901e9 100644
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



