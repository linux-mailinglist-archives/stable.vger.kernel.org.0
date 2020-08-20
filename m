Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4595B24BBD4
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728922AbgHTMee (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:34:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:53974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729574AbgHTJsq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:48:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F84520724;
        Thu, 20 Aug 2020 09:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916926;
        bh=Nahniq3tivwXHlULeR3BZ+n9Or9Il37c18TVMl+h06Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AxBiNsh3DFkWOYy8sCt/Bv+6SuRlrTJUamQXkVnxNL4iAWDK2BOqoeaUuhP6KB9xt
         3X1hbYTgBucc3n6GJftRYq3sB0lYdFtdJq0ktkZ+PrbzpOan04m4CBvJl/hnnZ28XQ
         T2pcKBivRT10J1FVIt2eZ6hibuYt/mAIN5JeqZvM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Zhang <markz@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 094/152] RDMA/counter: Only bind user QPs in auto mode
Date:   Thu, 20 Aug 2020 11:21:01 +0200
Message-Id: <20200820091558.542037319@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091553.615456912@linuxfoundation.org>
References: <20200820091553.615456912@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

[ Upstream commit c9f557421e505f75da4234a6af8eff46bc08614b ]

In auto mode only bind user QPs to a dynamic counter, since this feature
is mainly used for system statistic and diagnostic purpose, while there's
no need to counter kernel QPs so far.

Fixes: 99fa331dc862 ("RDMA/counter: Add "auto" configuration mode support")
Link: https://lore.kernel.org/r/20200702082933.424537-3-leon@kernel.org
Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/counters.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
index 11210bf7fd61b..42809f612c2c4 100644
--- a/drivers/infiniband/core/counters.c
+++ b/drivers/infiniband/core/counters.c
@@ -284,7 +284,7 @@ int rdma_counter_bind_qp_auto(struct ib_qp *qp, u8 port)
 	struct rdma_counter *counter;
 	int ret;
 
-	if (!qp->res.valid)
+	if (!qp->res.valid || rdma_is_kernel_res(&qp->res))
 		return 0;
 
 	if (!rdma_is_port_valid(dev, port))
-- 
2.25.1



