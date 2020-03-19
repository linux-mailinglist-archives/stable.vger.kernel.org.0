Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCAFA18B592
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729923AbgCSNTr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:19:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728503AbgCSNTr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:19:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A3E42098B;
        Thu, 19 Mar 2020 13:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623986;
        bh=maftcec7q/7Gg+skBb0iIpevHKDV5RwkZc9HnEZIWp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0rEP3si22LQHdSGoyeYRanbYXHFlF3tAZWX/NcirpzIk+a6EwjPQLUApDkwkDdInT
         IWklAeJmEyUlPgogMg40bpoXfjrd6ltKyYje6odw3ScIAg1QhgutAPNzUyyCFEwy2O
         POOK59dPCHYCDvhfgkhipvuBxrMz+KrnCXEmxM/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luo bin <luobin9@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 20/48] hinic: fix a irq affinity bug
Date:   Thu, 19 Mar 2020 14:04:02 +0100
Message-Id: <20200319123909.403633619@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123902.941451241@linuxfoundation.org>
References: <20200319123902.941451241@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luo bin <luobin9@huawei.com>

[ Upstream commit 0bff777bd0cba73ad4cd0145696ad284d7e6a99f ]

can not use a local variable as an input parameter of
irq_set_affinity_hint

Signed-off-by: Luo bin <luobin9@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/huawei/hinic/hinic_hw_qp.h | 1 +
 drivers/net/ethernet/huawei/hinic/hinic_rx.c    | 5 ++---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_qp.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_qp.h
index 6c84f83ec2831..d46cfd4fbbbc5 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_qp.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_qp.h
@@ -103,6 +103,7 @@ struct hinic_rq {
 
 	struct hinic_wq         *wq;
 
+	struct cpumask		affinity_mask;
 	u32                     irq;
 	u16                     msix_entry;
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_rx.c b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
index 06b24a92ed7d4..3467d84d96c39 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_rx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
@@ -414,7 +414,6 @@ static int rx_request_irq(struct hinic_rxq *rxq)
 	struct hinic_hwdev *hwdev = nic_dev->hwdev;
 	struct hinic_rq *rq = rxq->rq;
 	struct hinic_qp *qp;
-	struct cpumask mask;
 	int err;
 
 	rx_add_napi(rxq);
@@ -431,8 +430,8 @@ static int rx_request_irq(struct hinic_rxq *rxq)
 	}
 
 	qp = container_of(rq, struct hinic_qp, rq);
-	cpumask_set_cpu(qp->q_id % num_online_cpus(), &mask);
-	return irq_set_affinity_hint(rq->irq, &mask);
+	cpumask_set_cpu(qp->q_id % num_online_cpus(), &rq->affinity_mask);
+	return irq_set_affinity_hint(rq->irq, &rq->affinity_mask);
 }
 
 static void rx_free_irq(struct hinic_rxq *rxq)
-- 
2.20.1



