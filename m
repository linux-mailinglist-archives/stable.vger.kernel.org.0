Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21CFB18B6DA
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727549AbgCSNXR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:23:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:49132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730313AbgCSNXP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:23:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77936206D7;
        Thu, 19 Mar 2020 13:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624194;
        bh=CF0oxVd1Ljc33k3LLpWxJqOxe/MbmHC6fvTOzBAh5b0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q+dh4bfyxxyFeDekt7Flg1IHDT47OzzbroPZSFOyfjkU4tx9Jw+aTwXR32hfZYehX
         zZE1Mo+lPZ1sO1mgBVfxnNMrfiA7XhAAtCkK6Mh/83orHay7CLFzVimQvdija6KLh0
         kHB1sYNXZKwjpzaNebQTJrbYyjWtQ2fJmf/KTDmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luo bin <luobin9@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 39/60] hinic: fix a irq affinity bug
Date:   Thu, 19 Mar 2020 14:04:17 +0100
Message-Id: <20200319123932.030604081@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123919.441695203@linuxfoundation.org>
References: <20200319123919.441695203@linuxfoundation.org>
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
index f4a339b10b10b..79091e1314181 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_qp.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_qp.h
@@ -94,6 +94,7 @@ struct hinic_rq {
 
 	struct hinic_wq         *wq;
 
+	struct cpumask		affinity_mask;
 	u32                     irq;
 	u16                     msix_entry;
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_rx.c b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
index 56ea6d692f1c3..2695ad69fca60 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_rx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
@@ -475,7 +475,6 @@ static int rx_request_irq(struct hinic_rxq *rxq)
 	struct hinic_hwdev *hwdev = nic_dev->hwdev;
 	struct hinic_rq *rq = rxq->rq;
 	struct hinic_qp *qp;
-	struct cpumask mask;
 	int err;
 
 	rx_add_napi(rxq);
@@ -492,8 +491,8 @@ static int rx_request_irq(struct hinic_rxq *rxq)
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



