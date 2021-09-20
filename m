Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFA6841256A
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349454AbhITSpD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:45:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:56444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1382711AbhITSmR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:42:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C0C160ED7;
        Mon, 20 Sep 2021 17:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159098;
        bh=nahmwN+1vmBJpkw0w1mb+Bp/zccUUYudua2x62yBPBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BAC1vT/OWIwzBh0FBIIStvEQ6R4mEOUl9cwLl89nseYGE8MmtSfIcAP19bssVofaP
         xHtXW8hbV3mzq2iv8fQSmpXlVbVsWTbLCX50egtSPn7X/JBH15pw0N9sexI+eckF4F
         UwhLPGhGOSzjb34CAsFdhNbZdk6ljGc6AFgMjBxs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufeng Mo <moyufeng@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.14 076/168] net: hns3: change affinity_mask to numa node range
Date:   Mon, 20 Sep 2021 18:43:34 +0200
Message-Id: <20210920163924.139379470@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
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
@@ -1528,9 +1528,10 @@ static void hclge_init_kdump_kernel_conf
 static int hclge_configure(struct hclge_dev *hdev)
 {
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
+	const struct cpumask *cpumask = cpu_online_mask;
 	struct hclge_cfg cfg;
 	unsigned int i;
-	int ret;
+	int node, ret;
 
 	ret = hclge_get_cfg(hdev, &cfg);
 	if (ret)
@@ -1595,11 +1596,12 @@ static int hclge_configure(struct hclge_
 
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


