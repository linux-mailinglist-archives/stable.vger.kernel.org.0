Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E84814514A9
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348953AbhKOULq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:11:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:45408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344893AbhKOTZk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8AE5636DC;
        Mon, 15 Nov 2021 19:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003164;
        bh=SXpQl//cSzbQ+JqKvV+gLM4SyzCJrP/Vt0cswMvhN00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zo1RMsnNA2EjWtd7nzqEC/BLyM8RJAEMQ7M4KtkcXSA7EaWkgAMqlutwE3GqG+Ztc
         3JMuvBlit5INkMPveaRq3uOQJ9Teeeff20151o+nP2RlyN2jgdZvN9BX4fWp6eM9Sm
         zuKIDqb2fc3Q7WaePkBFSsgtelqvZtwd2wv9EwRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jie Wang <wangjie125@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 834/917] net: hns3: fix ROCE base interrupt vector initialization bug
Date:   Mon, 15 Nov 2021 18:05:29 +0100
Message-Id: <20211115165457.327518138@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jie Wang <wangjie125@huawei.com>

[ Upstream commit beb27ca451a57a1c0e52b5268703f3c3173c1f8c ]

Currently, NIC init ROCE interrupt vector with MSIX interrupt. But ROCE use
pci_irq_vector() to get interrupt vector, which adds the relative interrupt
vector again and gets wrong interrupt vector.

So fixes it by assign relative interrupt vector to ROCE instead of MSIX
interrupt vector and delete the unused struct member base_msi_vector
declaration of hclgevf_dev.

Fixes: 46a3df9f9718 ("net: hns3: Add HNS3 Acceleration Engine & Compatibility Layer Support")
Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 6 +-----
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h   | 2 --
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 5 +----
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h | 2 --
 4 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index d891390d492f6..ffd85cd297ef3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2498,7 +2498,7 @@ static int hclge_init_roce_base_info(struct hclge_vport *vport)
 	if (hdev->num_msi < hdev->num_nic_msi + hdev->num_roce_msi)
 		return -EINVAL;
 
-	roce->rinfo.base_vector = hdev->roce_base_vector;
+	roce->rinfo.base_vector = hdev->num_nic_msi;
 
 	roce->rinfo.netdev = nic->kinfo.netdev;
 	roce->rinfo.roce_io_base = hdev->hw.io_base;
@@ -2534,10 +2534,6 @@ static int hclge_init_msi(struct hclge_dev *hdev)
 	hdev->num_msi = vectors;
 	hdev->num_msi_left = vectors;
 
-	hdev->base_msi_vector = pdev->irq;
-	hdev->roce_base_vector = hdev->base_msi_vector +
-				hdev->num_nic_msi;
-
 	hdev->vector_status = devm_kcalloc(&pdev->dev, hdev->num_msi,
 					   sizeof(u16), GFP_KERNEL);
 	if (!hdev->vector_status) {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 69cd8f87b4c86..9111b8c84d786 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -876,12 +876,10 @@ struct hclge_dev {
 	u16 num_msi;
 	u16 num_msi_left;
 	u16 num_msi_used;
-	u32 base_msi_vector;
 	u16 *vector_status;
 	int *vector_irq;
 	u16 num_nic_msi;	/* Num of nic vectors for this PF */
 	u16 num_roce_msi;	/* Num of roce vectors for this PF */
-	int roce_base_vector;
 
 	unsigned long service_timer_period;
 	unsigned long service_timer_previous;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index cf00ad7bb881f..4cf34f1693544 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2557,7 +2557,7 @@ static int hclgevf_init_roce_base_info(struct hclgevf_dev *hdev)
 	    hdev->num_msi_left == 0)
 		return -EINVAL;
 
-	roce->rinfo.base_vector = hdev->roce_base_vector;
+	roce->rinfo.base_vector = hdev->roce_base_msix_offset;
 
 	roce->rinfo.netdev = nic->kinfo.netdev;
 	roce->rinfo.roce_io_base = hdev->hw.io_base;
@@ -2823,9 +2823,6 @@ static int hclgevf_init_msi(struct hclgevf_dev *hdev)
 	hdev->num_msi = vectors;
 	hdev->num_msi_left = vectors;
 
-	hdev->base_msi_vector = pdev->irq;
-	hdev->roce_base_vector = pdev->irq + hdev->roce_base_msix_offset;
-
 	hdev->vector_status = devm_kcalloc(&pdev->dev, hdev->num_msi,
 					   sizeof(u16), GFP_KERNEL);
 	if (!hdev->vector_status) {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index 28288d7e33032..4bd922b475012 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -308,8 +308,6 @@ struct hclgevf_dev {
 	u16 num_nic_msix;	/* Num of nic vectors for this VF */
 	u16 num_roce_msix;	/* Num of roce vectors for this VF */
 	u16 roce_base_msix_offset;
-	int roce_base_vector;
-	u32 base_msi_vector;
 	u16 *vector_status;
 	int *vector_irq;
 
-- 
2.33.0



