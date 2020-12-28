Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B36982E6889
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729513AbgL1NBK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:01:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:56982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729561AbgL1NA5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:00:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38EA7207C9;
        Mon, 28 Dec 2020 13:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160441;
        bh=RAKZPBiKwUYgtMrrN2cjCwOMTfw9vKVB8nQaQndcDxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SbE+T26LLE4BfNDfNlaRb4O3f3BY9Pd0LlvnfW6/SAD0dyjUJaNRDBr6nDnGj/4wd
         wv9xiMCs6tUZCvIctImdakeJxmdhM9iAUqdAxSXuj6bJFYPyVcbOpDJFgUAj75y9GF
         8pLRSKKHQzQnUXLJePKqLuiVa2R/ZNw8LCcQL/K0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Pearson <rpearson@hpe.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 051/175] RDMA/rxe: Compute PSN windows correctly
Date:   Mon, 28 Dec 2020 13:48:24 +0100
Message-Id: <20201228124855.731250553@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
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
index 5a2d7b0050f4c..463c4b3e73661 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -661,7 +661,8 @@ next_wqe:
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



