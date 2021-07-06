Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9892E3BD190
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238536AbhGFLjp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:39:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:47578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237250AbhGFLgC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A1B261EE9;
        Tue,  6 Jul 2021 11:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570787;
        bh=eSSeVjX4tABcygdynp3aCwh5KTzk60SBxkDdrdVEiRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K+3Wgea/axzVa6Wvx+T0F8rq35JWKiN2x75OHBc17Tfs2egdchJp5GP/UDzk8bx09
         roULUIlGn5WC0Q54b9giWF2MZ1o/mmS1SwUI/0NFPF/V1OFQHGa0rKsXmx3mIh8Zx8
         KcdF4la9ZSL6ke10PMHtS6KXkPE0d73q4bJ4oL1SEqSkeLj2LgABdbOQ+HXkI/VA/n
         fX3UXKNV3iH5Czknw1QYRB7N+BVTNlpFf+2QCXC5VDcqlWazEflPpg/bL/FVN0umEr
         Kdu6OTQbba6rBbD3ywVEenIXNe+UZ8ralW/VJFophUoaOdEK241UYEhXw7LHtQ2j6y
         iwblqLxPsdQUQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gerd Rausch <gerd.rausch@oracle.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 66/74] RDMA/cma: Fix rdma_resolve_route() memory leak
Date:   Tue,  6 Jul 2021 07:24:54 -0400
Message-Id: <20210706112502.2064236-66-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112502.2064236-1-sashal@kernel.org>
References: <20210706112502.2064236-1-sashal@kernel.org>
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
index 92428990f0cc..ec9e9598894f 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2719,7 +2719,8 @@ static int cma_resolve_ib_route(struct rdma_id_private *id_priv,
 
 	cma_init_resolve_route_work(work, id_priv);
 
-	route->path_rec = kmalloc(sizeof *route->path_rec, GFP_KERNEL);
+	if (!route->path_rec)
+		route->path_rec = kmalloc(sizeof *route->path_rec, GFP_KERNEL);
 	if (!route->path_rec) {
 		ret = -ENOMEM;
 		goto err1;
-- 
2.30.2

