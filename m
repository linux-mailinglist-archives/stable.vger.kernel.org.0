Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE9E23CD883
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243207AbhGSOWt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:22:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:58284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242987AbhGSOVe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:21:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03314611EF;
        Mon, 19 Jul 2021 15:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626706922;
        bh=LN1AtvVyV5WbCWvPHZo2WiTaP2uHUMqCLCm0xSGamBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yyQtqqV4WcVV3ito8kye0f/18bq6S/Gx5V1uRdJoqXnjqWiuDMffjQ7sNgqvptHnO
         wszVkI7KLuuIoNAe5CaTnp1VMClT8wzzXI8FjjUjSdekv95uEvAP43RnGHAwoHGzvT
         BF4g8GOHMxmnGbOyY+y/IqN5H1SumsZ6ykKJS7tA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gerd Rausch <gerd.rausch@oracle.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 118/188] RDMA/cma: Fix rdma_resolve_route() memory leak
Date:   Mon, 19 Jul 2021 16:51:42 +0200
Message-Id: <20210719144940.248062364@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144913.076563739@linuxfoundation.org>
References: <20210719144913.076563739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index b59a4a819aaa..b5e7bd23857e 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2227,7 +2227,8 @@ static int cma_resolve_ib_route(struct rdma_id_private *id_priv, int timeout_ms)
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



