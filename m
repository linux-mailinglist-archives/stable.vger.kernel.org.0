Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4883BD1FA
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235377AbhGFLlB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:41:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237435AbhGFLgK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2506961D81;
        Tue,  6 Jul 2021 11:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570860;
        bh=IRPEpEYxB0BX+tGtZoRbR9CFvmpTsjSrVMI6u1tpC74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bPnsi8lnLDTEpIAlVZbSLsQ2YAAyKkqp89U2J93iO1qQVdDqb0BZcGUFnOzM+KA3s
         6Ob2R5vjJAAvmC5EtlobCRwowTVoXEh9l6NWVEzjduRjp0vgXT3YrG6nnv3unsD6qs
         MBdYlU0WvAL/SMi5KPBqBaVJCkCkdIGu/3BEQIKdVGybUsPuDjb3mcrAvaA1dyVL5X
         Siw+uiZlTA1Ruy0B5DGwOIYApex/sQZ5GucIqDMIwkRip78Ozq/HVijHmzLlwFyZRN
         JOYtxBxSoj8dBc2XSXNzafgQgVeQD/JnLJetl8PMEEgyXUl2iRPkI7vQjqTlJ5DVkg
         62L067S9edMnA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gerd Rausch <gerd.rausch@oracle.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 49/55] RDMA/cma: Fix rdma_resolve_route() memory leak
Date:   Tue,  6 Jul 2021 07:26:32 -0400
Message-Id: <20210706112638.2065023-49-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112638.2065023-1-sashal@kernel.org>
References: <20210706112638.2065023-1-sashal@kernel.org>
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
index 8cdf933310d1..842a30947bdc 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2558,7 +2558,8 @@ static int cma_resolve_ib_route(struct rdma_id_private *id_priv, int timeout_ms)
 
 	cma_init_resolve_route_work(work, id_priv);
 
-	route->path_rec = kmalloc(sizeof *route->path_rec, GFP_KERNEL);
+	if (!route->path_rec)
+		route->path_rec = kmalloc(sizeof *route->path_rec, GFP_KERNEL);
 	if (!route->path_rec) {
 		ret = -ENOMEM;
 		goto err1;
-- 
2.30.2

