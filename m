Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 189203FDC15
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343551AbhIAMqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:46:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345652AbhIAMoy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:44:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1319061154;
        Wed,  1 Sep 2021 12:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499932;
        bh=l8nPTfKhlM/qqzPRroo3NihJBeZ4JbfeIYsatbT5ZbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vGCMvZEqKtKQtNBBH/97fhxcyC9bhUix/EUwlmWRaRx05UgQ3Sr5rf8127JLrNy1H
         dte93JVzSsml3/Jc6pWft0QzdeZS7giaFhhXL6smCMa4R0VlZMX3iBRPDPHoK+bilb
         vPSJmGjJVy2Z8QOwCG0aaY8gKxxENn7a7qIBS9xM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Bob Pearson <rpearsonhpe@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 040/113] RDMA/rxe: Fix memory allocation while in a spin lock
Date:   Wed,  1 Sep 2021 14:27:55 +0200
Message-Id: <20210901122303.334935866@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Pearson <rpearsonhpe@gmail.com>

[ Upstream commit 65a81b61d8c5e96748671824cc46339afbd831d0 ]

rxe_mcast_add_grp_elem() in rxe_mcast.c calls rxe_alloc() while holding
spinlocks which in turn calls kzalloc(size, GFP_KERNEL) which is
incorrect.  This patch replaces rxe_alloc() by rxe_alloc_locked() which
uses GFP_ATOMIC.  This bug was caused by the below mentioned commit and
failing to handle the need for the atomic allocate.

Fixes: 4276fd0dddc9 ("RDMA/rxe: Remove RXE_POOL_ATOMIC")
Link: https://lore.kernel.org/r/20210813210625.4484-1-rpearsonhpe@gmail.com
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_mcast.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_mcast.c b/drivers/infiniband/sw/rxe/rxe_mcast.c
index 0ea9a5aa4ec0..1c1d1b53312d 100644
--- a/drivers/infiniband/sw/rxe/rxe_mcast.c
+++ b/drivers/infiniband/sw/rxe/rxe_mcast.c
@@ -85,7 +85,7 @@ int rxe_mcast_add_grp_elem(struct rxe_dev *rxe, struct rxe_qp *qp,
 		goto out;
 	}
 
-	elem = rxe_alloc(&rxe->mc_elem_pool);
+	elem = rxe_alloc_locked(&rxe->mc_elem_pool);
 	if (!elem) {
 		err = -ENOMEM;
 		goto out;
-- 
2.30.2



