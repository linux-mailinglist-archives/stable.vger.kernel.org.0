Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53B22217272
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729553AbgGGPd2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:33:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:60644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729101AbgGGPUb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:20:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3198207C4;
        Tue,  7 Jul 2020 15:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135230;
        bh=2/wcxTfSZVKPIqZmrP9UFwXFqbCALUtx4RAQSmRyGfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zxoowkVl/8xuo7bQdOfLpGcuIg7Ep95IGt2XNWc2d3fd8Mp4K6n83y6yxx/LsFvSx
         Qv+OadznjyRTGe2G3hF9GpJsJUVHcFNP/c3omkeflY863JXKufMxmb1YDkvzTpRkIx
         ZY5O8xlQOpJ9GyI1sfVAxObY8x5vhofu8RytB/zQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Zhang <markz@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 24/65] RDMA/counter: Query a counter before release
Date:   Tue,  7 Jul 2020 17:17:03 +0200
Message-Id: <20200707145753.653869309@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145752.417212219@linuxfoundation.org>
References: <20200707145752.417212219@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

[ Upstream commit c1d869d64a1955817c4d6fff08ecbbe8e59d36f8 ]

Query a dynamically-allocated counter before release it, to update it's
hwcounters and log all of them into history data. Otherwise all values of
these hwcounters will be lost.

Fixes: f34a55e497e8 ("RDMA/core: Get sum value of all counters when perform a sysfs stat read")
Link: https://lore.kernel.org/r/20200621110000.56059-1-leon@kernel.org
Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/counters.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
index 46dd50ff7c85a..11210bf7fd61b 100644
--- a/drivers/infiniband/core/counters.c
+++ b/drivers/infiniband/core/counters.c
@@ -195,7 +195,7 @@ static int __rdma_counter_unbind_qp(struct ib_qp *qp)
 	return ret;
 }
 
-static void counter_history_stat_update(const struct rdma_counter *counter)
+static void counter_history_stat_update(struct rdma_counter *counter)
 {
 	struct ib_device *dev = counter->device;
 	struct rdma_port_counter *port_counter;
@@ -205,6 +205,8 @@ static void counter_history_stat_update(const struct rdma_counter *counter)
 	if (!port_counter->hstats)
 		return;
 
+	rdma_counter_query_stats(counter);
+
 	for (i = 0; i < counter->stats->num_counters; i++)
 		port_counter->hstats->value[i] += counter->stats->value[i];
 }
-- 
2.25.1



