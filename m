Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F69A43A13F
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236182AbhJYThz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:37:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:53864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236645AbhJYTfB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:35:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3812261152;
        Mon, 25 Oct 2021 19:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190322;
        bh=KJNJsJnm7S8PyXPj79TUWceDUe9/fgkmmekB/mRRqL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jEMsMV/qPXaWM2iwQ/nfDObTYI/foMQAs6WQQi4V9WeMdKGrCnddUF6zIHvEl0Lrr
         C6rY84OMxWZMHQMC0x6RNsx18g8FboUHEXI5sNJicNkPjL62pWyXPnfdSe8IWlNmSs
         P69KltnlTOCYSs9jFvLzh6GJ3AOIv/NLK6da19vE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Li <lipeng321@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 28/95] net: hns3: disable sriov before unload hclge layer
Date:   Mon, 25 Oct 2021 21:14:25 +0200
Message-Id: <20211025191000.985823944@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190956.374447057@linuxfoundation.org>
References: <20211025190956.374447057@linuxfoundation.org>
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
index eef1b2764d34..67b0bf310daa 100644
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
index 912c51e327d6..4a9576a449e1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -754,6 +754,7 @@ struct hnae3_handle {
 int hnae3_register_ae_dev(struct hnae3_ae_dev *ae_dev);
 void hnae3_unregister_ae_dev(struct hnae3_ae_dev *ae_dev);
 
+void hnae3_unregister_ae_algo_prepare(struct hnae3_ae_algo *ae_algo);
 void hnae3_unregister_ae_algo(struct hnae3_ae_algo *ae_algo);
 void hnae3_register_ae_algo(struct hnae3_ae_algo *ae_algo);
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 0e869f449f12..7b94764b4f5d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -11518,6 +11518,7 @@ static int hclge_init(void)
 
 static void hclge_exit(void)
 {
+	hnae3_unregister_ae_algo_prepare(&ae_algo);
 	hnae3_unregister_ae_algo(&ae_algo);
 	destroy_workqueue(hclge_wq);
 }
-- 
2.33.0



