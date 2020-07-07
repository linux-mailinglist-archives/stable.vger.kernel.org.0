Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4F8217125
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729671AbgGGPYg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:24:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:38218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729085AbgGGPYf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:24:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80E072065D;
        Tue,  7 Jul 2020 15:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135475;
        bh=JE9Pc3l9KUo/kiQ0jt7wUFYfAizCkUiPcI2ByP56Mdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rMK2td3mY1ktWVO2HwPj/siOJgRV87UhDYCuYdCxSR5ar3bv6tpjphGjKUyGd6PUp
         Jp9enLjQyFvtfNu+2hxd6XGlmvAyqZrt9iNb+Beyf0bxK80dWqX6lpvMGlbCv34YOT
         5nmVBGbZqbUHY4RpPchYN2dUMyqbFCetU1qAkXrw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Zhang <markz@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 054/112] RDMA/counter: Query a counter before release
Date:   Tue,  7 Jul 2020 17:16:59 +0200
Message-Id: <20200707145803.570726049@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
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
index 2257d7f7810fd..738d1faf4bba5 100644
--- a/drivers/infiniband/core/counters.c
+++ b/drivers/infiniband/core/counters.c
@@ -202,7 +202,7 @@ static int __rdma_counter_unbind_qp(struct ib_qp *qp)
 	return ret;
 }
 
-static void counter_history_stat_update(const struct rdma_counter *counter)
+static void counter_history_stat_update(struct rdma_counter *counter)
 {
 	struct ib_device *dev = counter->device;
 	struct rdma_port_counter *port_counter;
@@ -212,6 +212,8 @@ static void counter_history_stat_update(const struct rdma_counter *counter)
 	if (!port_counter->hstats)
 		return;
 
+	rdma_counter_query_stats(counter);
+
 	for (i = 0; i < counter->stats->num_counters; i++)
 		port_counter->hstats->value[i] += counter->stats->value[i];
 }
-- 
2.25.1



