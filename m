Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E53142E3C48
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436532AbgL1OAf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:00:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:34300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436517AbgL1OAd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:00:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D73AD207A9;
        Mon, 28 Dec 2020 13:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163992;
        bh=T1cwB131nMEUdgfIE5pWH1enmq/+5bJNUEAWm38jwsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ysMIByW2XnBV2KyitDngKHZ41kllRPHN7PHdCeWf9U2w+jNRqR+54G4GVpDJOcTCJ
         R9FceQWTLmgOIbKVz2+F2B1D5Y+tJkZUrQ3sYZ32M6oymZa8PzTERRXxfdl5uHy2h0
         AqKWY0nKSs+zCKbuqiDWp4Qql9suDOZWsZcGay/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Pearson <rpearson@hpe.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 023/717] RDMA/rxe: Compute PSN windows correctly
Date:   Mon, 28 Dec 2020 13:40:21 +0100
Message-Id: <20201228125022.092965027@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
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
index af3923bf0a36b..d4917646641aa 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -634,7 +634,8 @@ next_wqe:
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



