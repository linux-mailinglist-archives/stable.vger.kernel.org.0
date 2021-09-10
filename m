Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22904406245
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241556AbhIJApM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:45:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231688AbhIJAVD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:21:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BEF7610A3;
        Fri, 10 Sep 2021 00:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233193;
        bh=7jlOgkdKVe7hA6Z6ANWR/t8EF2ywyinc3JPE2mS7ib0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VNwZ4MggTtTSQNUeBeotd1bux4/IyCNO6FqYUliL2YcOFnH0I2OvD3Zm2C4Ap6H+J
         zzortN8NwJDUF7nUjmZdiFQlyTULFszlakz3fv+uA4Xfk+wytc9QIHQhzMZbV9HihR
         iX+nJDqBIidfk/gR2L+LO3+eN9RGXp5fFMyhFcYWOup+5jXLNldOzztrxlZ0ptV05/
         04X5xF2MhH9qqVmrn94SkQkwL2qvDKYh3ENIVer6y7kFhgammxnN/aPXqmkjsM7hib
         LwKTH5wjlSS9w0LhFzE0bc4bOlTKwBnygygr2kRXkJy2Mj8O9XLM2Zc05gkFPZq9cU
         jD/afFUzcuc6Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 66/88] RDMA/core/sa_query: Retry SA queries
Date:   Thu,  9 Sep 2021 20:17:58 -0400
Message-Id: <20210910001820.174272-66-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001820.174272-1-sashal@kernel.org>
References: <20210910001820.174272-1-sashal@kernel.org>
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
index 5d3b8b8d163d..c40791baced5 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -3132,6 +3132,9 @@ int rdma_resolve_route(struct rdma_cm_id *id, unsigned long timeout_ms)
 	struct rdma_id_private *id_priv;
 	int ret;
 
+	if (!timeout_ms)
+		return -EINVAL;
+
 	id_priv = container_of(id, struct rdma_id_private, id);
 	if (!cma_comp_exch(id_priv, RDMA_CM_ADDR_RESOLVED, RDMA_CM_ROUTE_QUERY))
 		return -EINVAL;
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 8f1705c403b4..753d66158146 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -1360,6 +1360,7 @@ static int send_mad(struct ib_sa_query *query, unsigned long timeout_ms,
 {
 	unsigned long flags;
 	int ret, id;
+	const int nmbr_sa_query_retries = 10;
 
 	xa_lock_irqsave(&queries, flags);
 	ret = __xa_alloc(&queries, &id, query, xa_limit_32b, gfp_mask);
@@ -1367,7 +1368,13 @@ static int send_mad(struct ib_sa_query *query, unsigned long timeout_ms,
 	if (ret < 0)
 		return ret;
 
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

