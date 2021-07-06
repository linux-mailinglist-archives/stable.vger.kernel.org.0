Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 090413BD54B
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 14:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237479AbhGFMTk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 08:19:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:47548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234954AbhGFLgd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A808361DB9;
        Tue,  6 Jul 2021 11:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570966;
        bh=/IikJBtmk0hrQzITWiQ2FCpY/8RGdJgd/uILc+4NcxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=seuoGqZy4/RTBnOY/lW3gGElWUsW/8wyq99EotaQf5oXao9q8Zp0E+qB8kH3GZFYd
         jGj7CRsn70jL4H3ZC/ScEaFsWpH9tYYgNg6Rluw6qApQvE/TcuLcbjvo2b8SxQEqn5
         0Dtv5gAdNnYkO5O0lsJ70QAVMz3MwJbYUc8JxwXpqFI7RgjuOUZ/PwXNkvODPXPlu0
         3GLey3o10Jl69KiWzGTL9L3LEG00QDHg8lHM1/sewCpDQcKjSQTdRFQ8do/gk8/6Mi
         ldp9BmZkLrUCu7SqNA4ubg1F4Z2YyDmLCRWiIUI4P5UiD8Fy0BGHjhYYPIEdIGzWlS
         gNA5nRKSjxQiQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gerd Rausch <gerd.rausch@oracle.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 31/35] RDMA/cma: Fix rdma_resolve_route() memory leak
Date:   Tue,  6 Jul 2021 07:28:43 -0400
Message-Id: <20210706112848.2066036-31-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112848.2066036-1-sashal@kernel.org>
References: <20210706112848.2066036-1-sashal@kernel.org>
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
index 0a6cc78ebcf7..149d210c68ab 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2370,7 +2370,8 @@ static int cma_resolve_ib_route(struct rdma_id_private *id_priv, int timeout_ms)
 	work->new_state = RDMA_CM_ROUTE_RESOLVED;
 	work->event.event = RDMA_CM_EVENT_ROUTE_RESOLVED;
 
-	route->path_rec = kmalloc(sizeof *route->path_rec, GFP_KERNEL);
+	if (!route->path_rec)
+		route->path_rec = kmalloc(sizeof *route->path_rec, GFP_KERNEL);
 	if (!route->path_rec) {
 		ret = -ENOMEM;
 		goto err1;
-- 
2.30.2

