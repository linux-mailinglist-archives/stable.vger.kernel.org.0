Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7A043A092
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235488AbhJYTcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:32:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:48326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235493AbhJYTaC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:30:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FBA360273;
        Mon, 25 Oct 2021 19:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190031;
        bh=wwiPaLhbLtDcShVrPrWN8l3oAOEu3aULhUyum+taE4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KD0K1vYUnEhVwp4NRq/zYCUZHUDy6GpkYGf4xW0j1Rh9sbvvNA9WRyStjzEuMlWPF
         ybxEJyI+K6j5YgEH2yMqgSnNgxk7sgqlh7hBlwShQ95oW4oP00oxcQn/LgtncSAKRV
         mO78xA+aGJ/PUiRKF6Ma1VeyL6ITBwMx6cswdzjU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Li <lipeng321@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 16/58] net: hns3: disable sriov before unload hclge layer
Date:   Mon, 25 Oct 2021 21:14:33 +0200
Message-Id: <20211025190940.070786468@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190937.555108060@linuxfoundation.org>
References: <20211025190937.555108060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

[ Upstream commit 0dd8a25f355b4df2d41c08df1716340854c7d4c5 ]

HNS3 driver includes hns3.ko, hnae3.ko and hclge.ko.
hns3.ko includes network stack and pci_driver, hclge.ko includes
HW device action, algo_ops and timer task, hnae3.ko includes some
register function.

When SRIOV is enable and hclge.ko is removed, HW device is unloaded
but VF still exists, PF will not reply VF mbx messages, and cause
errors.

This patch fix it by disable SRIOV before remove hclge.ko.

Fixes: e2cb1dec9779 ("net: hns3: Add HNS3 VF HCL(Hardware Compatibility Layer) Support")
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.c   | 21 +++++++++++++++++++
 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |  1 +
 .../hisilicon/hns3/hns3pf/hclge_main.c        |  1 +
 3 files changed, 23 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.c b/drivers/net/ethernet/hisilicon/hns3/hnae3.c
index 03ca7d925e8e..2e38c7d214c4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.c
@@ -10,6 +10,27 @@ static LIST_HEAD(hnae3_ae_algo_list);
 static LIST_HEAD(hnae3_client_list);
 static LIST_HEAD(hnae3_ae_dev_list);
 
+void hnae3_unregister_ae_algo_prepare(struct hnae3_ae_algo *ae_algo)
+{
+	const struct pci_device_id *pci_id;
+	struct hnae3_ae_dev *ae_dev;
+
+	if (!ae_algo)
+		return;
+
+	list_for_each_entry(ae_dev, &hnae3_ae_dev_list, node) {
+		if (!hnae3_get_bit(ae_dev->flag, HNAE3_DEV_INITED_B))
+			continue;
+
+		pci_id = pci_match_id(ae_algo->pdev_id_table, ae_dev->pdev);
+		if (!pci_id)
+			continue;
+		if (IS_ENABLED(CONFIG_PCI_IOV))
+			pci_disable_sriov(ae_dev->pdev);
+	}
+}
+EXPORT_SYMBOL(hnae3_unregister_ae_algo_prepare);
+
 /* we are keeping things simple and using single lock for all the
  * list. This is a non-critical code so other updations, if happen
  * in parallel, can wait.
diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 0db835d87d09..6cf849011064 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -666,6 +666,7 @@ struct hnae3_handle {
 int hnae3_register_ae_dev(struct hnae3_ae_dev *ae_dev);
 void hnae3_unregister_ae_dev(struct hnae3_ae_dev *ae_dev);
 
+void hnae3_unregister_ae_algo_prepare(struct hnae3_ae_algo *ae_algo);
 void hnae3_unregister_ae_algo(struct hnae3_ae_algo *ae_algo);
 void hnae3_register_ae_algo(struct hnae3_ae_algo *ae_algo);
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index f44e8401496b..8ecfabaefa85 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -10274,6 +10274,7 @@ static int hclge_init(void)
 
 static void hclge_exit(void)
 {
+	hnae3_unregister_ae_algo_prepare(&ae_algo);
 	hnae3_unregister_ae_algo(&ae_algo);
 }
 module_init(hclge_init);
-- 
2.33.0



