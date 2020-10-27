Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1294929B279
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1762218AbgJ0Olb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:41:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:40840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2899181AbgJ0Ol2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:41:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5195206B2;
        Tue, 27 Oct 2020 14:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809688;
        bh=6iNgf1jOVE5Jgq3YA/ekXFTlsyVoU1AiArcDjjJpnNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=npjGJsxHg06ON55uLns2bk3lSeIZ9dBga1Qbv2bv6xmhKSmN1OW/lnlJ3tVNN5hzJ
         3PPkut1WZ9mE5FvU5Z83fYIKJheD7tZLe8ZcrfEHssfLblFEJufuENZBOTaT6VLDZr
         PP51xzNKi8jLEhI0kFU4FCw2RrRWxtefQCGptfgA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Pearson <rpearson@hpe.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 253/408] RDMA/rxe: Handle skb_clone() failure in rxe_recv.c
Date:   Tue, 27 Oct 2020 14:53:11 +0100
Message-Id: <20201027135506.775858094@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Pearson <rpearsonhpe@gmail.com>

[ Upstream commit 71abf20b28ff87fee6951ec2218d5ce7969c4e87 ]

If skb_clone() is unable to allocate memory for a new sk_buff this is not
detected by the current code.

Check for a NULL return and continue. This is similar to other errors in
this loop over QPs attached to the multicast address and consistent with
the unreliable UD transport.

Fixes: e7ec96fc7932f ("RDMA/rxe: Fix skb lifetime in rxe_rcv_mcast_pkt()")
Addresses-Coverity-ID: 1497804: Null pointer dereferences (NULL_RETURNS)
Link: https://lore.kernel.org/r/20201013184236.5231-1-rpearson@hpe.com
Signed-off-by: Bob Pearson <rpearson@hpe.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_recv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_recv.c b/drivers/infiniband/sw/rxe/rxe_recv.c
index be6416a982c70..9bfb98056fc2a 100644
--- a/drivers/infiniband/sw/rxe/rxe_recv.c
+++ b/drivers/infiniband/sw/rxe/rxe_recv.c
@@ -319,6 +319,9 @@ static void rxe_rcv_mcast_pkt(struct rxe_dev *rxe, struct sk_buff *skb)
 		else
 			per_qp_skb = skb;
 
+		if (unlikely(!per_qp_skb))
+			continue;
+
 		per_qp_pkt = SKB_TO_PKT(per_qp_skb);
 		per_qp_pkt->qp = qp;
 		rxe_add_ref(qp);
-- 
2.25.1



