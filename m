Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4114063CD
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234112AbhIJAtB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:49:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:50360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234954AbhIJAZ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:25:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E41F960FC0;
        Fri, 10 Sep 2021 00:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233458;
        bh=MtfGygH15cIAw60uI+peoOoFP+IjGl/ij2upxPiTYSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V0kFiewcjLy0xCye9CtRrHiOz6T26RoaWUnZFXbYVh1QrLJP7ASE7WkXeiD5b1p4N
         m0IzDAYx8YtI79cxLL8Do5yV94OdP1+LOGVD7nca5NOs97N0TMBkit2ymMzLYBepXs
         mgnawYM9SPuNIo5OazsDtIYXwTMOLI/9V0DVevFGPFWOu4aL4RXY3LtiaPMKS63VFA
         vos0NqhL9mqFeQZVnh0KPwL0hulOdfMBVbC9NEMuXrpb/AqsapU+d8nKyQThxVkZP6
         91pqCt6omTvQlXBZl/un+oxZyRukNMpJcPDHLrEWAxn2b2s4iJ/ZAwEmW+EH3iOaNO
         P1OWUEXkqtWyA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 11/14] RDMA/core/sa_query: Retry SA queries
Date:   Thu,  9 Sep 2021 20:24:00 -0400
Message-Id: <20210910002403.176887-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002403.176887-1-sashal@kernel.org>
References: <20210910002403.176887-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Håkon Bugge <haakon.bugge@oracle.com>

[ Upstream commit 5f5a650999d5718af766fc70a120230b04235a6f ]

A MAD packet is sent as an unreliable datagram (UD). SA requests are sent
as MAD packets. As such, SA requests or responses may be silently dropped.

IB Core's MAD layer has a timeout and retry mechanism, which amongst
other, is used by RDMA CM. But it is not used by SA queries. The lack of
retries of SA queries leads to long specified timeout, and error being
returned in case of packet loss. The ULP or user-land process has to
perform the retry.

Fix this by taking advantage of the MAD layer's retry mechanism.

First, a check against a zero timeout is added in rdma_resolve_route(). In
send_mad(), we set the MAD layer timeout to one tenth of the specified
timeout and the number of retries to 10. The special case when timeout is
less than 10 is handled.

With this fix:

 # ucmatose -c 1000 -S 1024 -C 1

runs stable on an Infiniband fabric. Without this fix, we see an
intermittent behavior and it errors out with:

cmatose: event: RDMA_CM_EVENT_ROUTE_ERROR, error: -110

(110 is ETIMEDOUT)

Link: https://lore.kernel.org/r/1628784755-28316-1-git-send-email-haakon.bugge@oracle.com
Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cma.c      | 3 +++
 drivers/infiniband/core/sa_query.c | 9 ++++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index b5e7bd23857e..88a59557cabd 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2390,6 +2390,9 @@ int rdma_resolve_route(struct rdma_cm_id *id, int timeout_ms)
 	struct rdma_id_private *id_priv;
 	int ret;
 
+	if (!timeout_ms)
+		return -EINVAL;
+
 	id_priv = container_of(id, struct rdma_id_private, id);
 	if (!cma_comp_exch(id_priv, RDMA_CM_ADDR_RESOLVED, RDMA_CM_ROUTE_QUERY))
 		return -EINVAL;
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index d3b7ecd106f7..070b1ab80674 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -1091,6 +1091,7 @@ static int send_mad(struct ib_sa_query *query, int timeout_ms, gfp_t gfp_mask)
 	bool preload = gfpflags_allow_blocking(gfp_mask);
 	unsigned long flags;
 	int ret, id;
+	const int nmbr_sa_query_retries = 10;
 
 	if (preload)
 		idr_preload(gfp_mask);
@@ -1104,7 +1105,13 @@ static int send_mad(struct ib_sa_query *query, int timeout_ms, gfp_t gfp_mask)
 	if (id < 0)
 		return id;
 
-	query->mad_buf->timeout_ms  = timeout_ms;
+	query->mad_buf->timeout_ms  = timeout_ms / nmbr_sa_query_retries;
+	query->mad_buf->retries = nmbr_sa_query_retries;
+	if (!query->mad_buf->timeout_ms) {
+		/* Special case, very small timeout_ms */
+		query->mad_buf->timeout_ms = 1;
+		query->mad_buf->retries = timeout_ms;
+	}
 	query->mad_buf->context[0] = query;
 	query->id = id;
 
-- 
2.30.2

