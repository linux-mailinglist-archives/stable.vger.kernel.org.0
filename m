Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 522C2101802
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbfKSFgc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:36:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:57822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729489AbfKSFgb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:36:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B885F20862;
        Tue, 19 Nov 2019 05:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141789;
        bh=xkvu+qdCQbxDVa7d84FR8fu/87uky6F6FefWzjf1y68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H58AQDz6KVZgOoEh3BIu24VsTOsKB/ocSTbRdtpNlKUB6M1VaCQiXkO5xsloLk6+W
         PS6leuLJFyYwxMm3ZiK6Z31onFtKw54Ejd85ysWHMk6s2wJorV18muS60tXMHeDjXk
         zUKDFl+8riHsrdlIr5tGlOpGxS4X65w66n7nG5wc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 282/422] net: hns3: Clear client pointer when initialize client failed or unintialize finished
Date:   Tue, 19 Nov 2019 06:17:59 +0100
Message-Id: <20191119051417.258839597@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit 49dd80541c75c2f21c28bbbdd958e993b55bf97b ]

If initialize client failed or finish uninitializing client, we should
clear the client pointer. It may cause unexpected result when use
uninitialized client. Meanwhile, we also should check whether client
exist when uninitialize it.

Fixes: 46a3df9f9718 ("net: hns3: Add HNS3 Acceleration Engine & Compatibility Layer Support")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 25 +++++++++-----
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      | 33 ++++++++++++++-----
 2 files changed, 41 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 6889e83a55707..c5e617fdb809f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -5476,13 +5476,13 @@ static int hclge_init_client_instance(struct hnae3_client *client,
 			vport->nic.client = client;
 			ret = client->ops->init_instance(&vport->nic);
 			if (ret)
-				return ret;
+				goto clear_nic;
 
 			ret = hclge_init_instance_hw(hdev);
 			if (ret) {
 			        client->ops->uninit_instance(&vport->nic,
 			                                     0);
-			        return ret;
+				goto clear_nic;
 			}
 
 			if (hdev->roce_client &&
@@ -5491,11 +5491,11 @@ static int hclge_init_client_instance(struct hnae3_client *client,
 
 				ret = hclge_init_roce_base_info(vport);
 				if (ret)
-					return ret;
+					goto clear_roce;
 
 				ret = rc->ops->init_instance(&vport->roce);
 				if (ret)
-					return ret;
+					goto clear_roce;
 			}
 
 			break;
@@ -5505,7 +5505,7 @@ static int hclge_init_client_instance(struct hnae3_client *client,
 
 			ret = client->ops->init_instance(&vport->nic);
 			if (ret)
-				return ret;
+				goto clear_nic;
 
 			break;
 		case HNAE3_CLIENT_ROCE:
@@ -5517,16 +5517,25 @@ static int hclge_init_client_instance(struct hnae3_client *client,
 			if (hdev->roce_client && hdev->nic_client) {
 				ret = hclge_init_roce_base_info(vport);
 				if (ret)
-					return ret;
+					goto clear_roce;
 
 				ret = client->ops->init_instance(&vport->roce);
 				if (ret)
-					return ret;
+					goto clear_roce;
 			}
 		}
 	}
 
 	return 0;
+
+clear_nic:
+	hdev->nic_client = NULL;
+	vport->nic.client = NULL;
+	return ret;
+clear_roce:
+	hdev->roce_client = NULL;
+	vport->roce.client = NULL;
+	return ret;
 }
 
 static void hclge_uninit_client_instance(struct hnae3_client *client,
@@ -5546,7 +5555,7 @@ static void hclge_uninit_client_instance(struct hnae3_client *client,
 		}
 		if (client->type == HNAE3_CLIENT_ROCE)
 			return;
-		if (client->ops->uninit_instance) {
+		if (hdev->nic_client && client->ops->uninit_instance) {
 			hclge_uninit_instance_hw(hdev);
 			client->ops->uninit_instance(&vport->nic, 0);
 			hdev->nic_client = NULL;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 5570fb5dc2eb4..83fcdd326de71 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1629,17 +1629,17 @@ static int hclgevf_init_client_instance(struct hnae3_client *client,
 
 		ret = client->ops->init_instance(&hdev->nic);
 		if (ret)
-			return ret;
+			goto clear_nic;
 
 		if (hdev->roce_client && hnae3_dev_roce_supported(hdev)) {
 			struct hnae3_client *rc = hdev->roce_client;
 
 			ret = hclgevf_init_roce_base_info(hdev);
 			if (ret)
-				return ret;
+				goto clear_roce;
 			ret = rc->ops->init_instance(&hdev->roce);
 			if (ret)
-				return ret;
+				goto clear_roce;
 		}
 		break;
 	case HNAE3_CLIENT_UNIC:
@@ -1648,7 +1648,7 @@ static int hclgevf_init_client_instance(struct hnae3_client *client,
 
 		ret = client->ops->init_instance(&hdev->nic);
 		if (ret)
-			return ret;
+			goto clear_nic;
 		break;
 	case HNAE3_CLIENT_ROCE:
 		if (hnae3_dev_roce_supported(hdev)) {
@@ -1659,15 +1659,24 @@ static int hclgevf_init_client_instance(struct hnae3_client *client,
 		if (hdev->roce_client && hdev->nic_client) {
 			ret = hclgevf_init_roce_base_info(hdev);
 			if (ret)
-				return ret;
+				goto clear_roce;
 
 			ret = client->ops->init_instance(&hdev->roce);
 			if (ret)
-				return ret;
+				goto clear_roce;
 		}
 	}
 
 	return 0;
+
+clear_nic:
+	hdev->nic_client = NULL;
+	hdev->nic.client = NULL;
+	return ret;
+clear_roce:
+	hdev->roce_client = NULL;
+	hdev->roce.client = NULL;
+	return ret;
 }
 
 static void hclgevf_uninit_client_instance(struct hnae3_client *client,
@@ -1676,13 +1685,19 @@ static void hclgevf_uninit_client_instance(struct hnae3_client *client,
 	struct hclgevf_dev *hdev = ae_dev->priv;
 
 	/* un-init roce, if it exists */
-	if (hdev->roce_client)
+	if (hdev->roce_client) {
 		hdev->roce_client->ops->uninit_instance(&hdev->roce, 0);
+		hdev->roce_client = NULL;
+		hdev->roce.client = NULL;
+	}
 
 	/* un-init nic/unic, if this was not called by roce client */
-	if ((client->ops->uninit_instance) &&
-	    (client->type != HNAE3_CLIENT_ROCE))
+	if (client->ops->uninit_instance && hdev->nic_client &&
+	    client->type != HNAE3_CLIENT_ROCE) {
 		client->ops->uninit_instance(&hdev->nic, 0);
+		hdev->nic_client = NULL;
+		hdev->nic.client = NULL;
+	}
 }
 
 static int hclgevf_pci_init(struct hclgevf_dev *hdev)
-- 
2.20.1



