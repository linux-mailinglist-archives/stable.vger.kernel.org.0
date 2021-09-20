Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46EEF41240E
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352672AbhITSaZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:30:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:47572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1379137AbhITS2Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:28:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79171632DC;
        Mon, 20 Sep 2021 17:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158777;
        bh=eF4lGOIJqEJogiqRfPw2Sl4O5D19RFioPeEQb+uyoek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PLfCAfClUHvthXwrscc0anom7gMuGAv024d8ZmEzqtWLaNjRL23V4mFSHNNhjLRi5
         9I8/q3beQhGe+9mdvrG8HT47oer4MH7iV7le6A03rYs0poS1dY/VBbDJlQT+fHgbir
         5PAofIPzNwWvrT4L4RrUwiP7sRj/LRgVy7tD/Rmc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufeng Mo <moyufeng@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 051/122] net: hns3: change affinity_mask to numa node range
Date:   Mon, 20 Sep 2021 18:43:43 +0200
Message-Id: <20210920163917.462993128@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

commit 1dc839ec09d3ab2a4156dc98328b8bc3586f2b70 upstream.

Currently, affinity_mask is set to a single cpu. As a result,
irqbalance becomes invalid in SUBSET or EXACT mode. To solve
this problem, change affinity_mask to numa node range. In this
way, irqbalance can be performed on the cpu of the numa node.

Fixes: 0812545487ec ("net: hns3: add interrupt affinity support for misc interrupt")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1463,9 +1463,10 @@ static void hclge_init_kdump_kernel_conf
 
 static int hclge_configure(struct hclge_dev *hdev)
 {
+	const struct cpumask *cpumask = cpu_online_mask;
 	struct hclge_cfg cfg;
 	unsigned int i;
-	int ret;
+	int node, ret;
 
 	ret = hclge_get_cfg(hdev, &cfg);
 	if (ret)
@@ -1526,11 +1527,12 @@ static int hclge_configure(struct hclge_
 
 	hclge_init_kdump_kernel_config(hdev);
 
-	/* Set the init affinity based on pci func number */
-	i = cpumask_weight(cpumask_of_node(dev_to_node(&hdev->pdev->dev)));
-	i = i ? PCI_FUNC(hdev->pdev->devfn) % i : 0;
-	cpumask_set_cpu(cpumask_local_spread(i, dev_to_node(&hdev->pdev->dev)),
-			&hdev->affinity_mask);
+	/* Set the affinity based on numa node */
+	node = dev_to_node(&hdev->pdev->dev);
+	if (node != NUMA_NO_NODE)
+		cpumask = cpumask_of_node(node);
+
+	cpumask_copy(&hdev->affinity_mask, cpumask);
 
 	return ret;
 }


