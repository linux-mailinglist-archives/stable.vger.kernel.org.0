Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B67F40637A
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbhIJAry (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:47:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:49406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234732AbhIJAYI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:24:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 765946103E;
        Fri, 10 Sep 2021 00:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233378;
        bh=4L5vuTbpSrv+vmaFy1sWjRejcs7DDjJo7CRflacYlN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dj7G21Ie+igQzpiUG/glJOCo967pnMcSF4HKHZZSg0nejmzX7btmQy0hABFzWyV2M
         rhl6l20/ZAOgK03Sqq3Cb9CRTiG1HskQD6tGIgMY2Ba9AVdh4nGMaPkI31LAxMkrEv
         tfmUU1cxRCMLr7OejOvuPtW0eofk6F3bauyjgoAnTA7fm0lP8YghuDb5HUeOGQ3lAe
         TwA4VijnEfr7srYhPaFuWiLf/c5VDkE/GXkwzQPgbEIiFASvs1No6K/1Z+RlvTAJOm
         mGHUpQvHWTJwnSXIEiTdK8EYmg7OuCs3esH9+rY38mS9QM4GIiYeFaX2H/KxPHkXKF
         G/eDAKuViEdEQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 18/25] RDMA/core/sa_query: Retry SA queries
Date:   Thu,  9 Sep 2021 20:22:26 -0400
Message-Id: <20210910002234.176125-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002234.176125-1-sashal@kernel.org>
References: <20210910002234.176125-1-sashal@kernel.org>
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
index 842a30947bdc..f3a0745c1b06 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2776,6 +2776,9 @@ int rdma_resolve_route(struct rdma_cm_id *id, int timeout_ms)
 	struct rdma_id_private *id_priv;
 	int ret;
 
+	if (!timeout_ms)
+		return -EINVAL;
+
 	id_priv = container_of(id, struct rdma_id_private, id);
 	if (!cma_comp_exch(id_priv, RDMA_CM_ADDR_RESOLVED, RDMA_CM_ROUTE_QUERY))
 		return -EINVAL;
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 9881e6fa9fe4..251772737764 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -1413,6 +1413,7 @@ static int send_mad(struct ib_sa_query *query, int timeout_ms, gfp_t gfp_mask)
 	bool preload = gfpflags_allow_blocking(gfp_mask);
 	unsigned long flags;
 	int ret, id;
+	const int nmbr_sa_query_retries = 10;
 
 	if (preload)
 		idr_preload(gfp_mask);
@@ -1426,7 +1427,13 @@ static int send_mad(struct ib_sa_query *query, int timeout_ms, gfp_t gfp_mask)
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

