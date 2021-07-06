Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4C983BD507
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 14:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233305AbhGFMSh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 08:18:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236893AbhGFLfq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8060161C4B;
        Tue,  6 Jul 2021 11:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570679;
        bh=vnqtDYBKNdLzbsGPy+KXkh2z2UP9zRWW8jlw3m3PVMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z3hh3Dl8jo2aGER6SHv2XfzIONG2QY4m1ArAx6luZ/XZ0vu+N5wfgMVZcIiqJOlVc
         gjubY4PSpx44XriBDgWroUF3xDD2mGhTakCRDRa4sXimt4nNj1kzrlE7Et4bgKObmJ
         jaJSCc6fMsjvT9r6ZVo1RtDe/XeIlSS8jIXci8yFhrS3rlf8S51g5bNKMApVQI1OL/
         4dqpnMZdo9E0Mg/7MsoEq5uaaUASLJARm8Ey2zkYvvVLRG5OuFfAOvaGjEP/Mz5jVd
         bJpVpa/titQU08r5o2OuOL/LVGhIgt+lZFOk6sxgPpk7aZaypkLQ2MfeEcE+ayOep4
         LiBx0QoUkTlhQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gerd Rausch <gerd.rausch@oracle.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 120/137] RDMA/cma: Fix rdma_resolve_route() memory leak
Date:   Tue,  6 Jul 2021 07:21:46 -0400
Message-Id: <20210706112203.2062605-120-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gerd Rausch <gerd.rausch@oracle.com>

[ Upstream commit 74f160ead74bfe5f2b38afb4fcf86189f9ff40c9 ]

Fix a memory leak when "mda_resolve_route() is called more than once on
the same "rdma_cm_id".

This is possible if cma_query_handler() triggers the
RDMA_CM_EVENT_ROUTE_ERROR flow which puts the state machine back and
allows rdma_resolve_route() to be called again.

Link: https://lore.kernel.org/r/f6662b7b-bdb7-2706-1e12-47c61d3474b6@oracle.com
Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index d1e94147fb16..fad06233412f 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2785,7 +2785,8 @@ static int cma_resolve_ib_route(struct rdma_id_private *id_priv,
 
 	cma_init_resolve_route_work(work, id_priv);
 
-	route->path_rec = kmalloc(sizeof *route->path_rec, GFP_KERNEL);
+	if (!route->path_rec)
+		route->path_rec = kmalloc(sizeof *route->path_rec, GFP_KERNEL);
 	if (!route->path_rec) {
 		ret = -ENOMEM;
 		goto err1;
-- 
2.30.2

