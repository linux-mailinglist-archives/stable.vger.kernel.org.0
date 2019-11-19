Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF081014B4
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729973AbfKSFge (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:36:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:57908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729967AbfKSFgd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:36:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F13B921823;
        Tue, 19 Nov 2019 05:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141792;
        bh=ywNhEScQxGyUtNz2ejcOlNsXIbG842gGHK6BzEnToYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B1QbmbM7xQlhG0cEvzKEXSvdUSGyeRHc88iiaRbYlugNmWiluOv+KNfvKAkHV1tD1
         fInJG5RDWHYK1Nz0L0AJaObddGOTRMwlP/DzGS5ybtQdBZPyOdHo5hgHIK/Snk6k1m
         RKh2SnYtd33o58lKoW6roKEAf9zI4L92FHj6UR0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 283/422] net: hns3: Fix client initialize state issue when roce client initialize failed
Date:   Tue, 19 Nov 2019 06:18:00 +0100
Message-Id: <20191119051417.323358107@linuxfoundation.org>
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

[ Upstream commit d9f28fc23d544f673d087b00a6c7132d972f89ea ]

When roce is loaded before nic, the roce client will not be initialized
until nic client is initialized, but roce init flag is set before it.
Furthermore, in this case of nic initialized success and roce failed,
the nic init flag is not set, and roce init flag is not cleared.

This patch fixes it by set init flag only after the client is initialized
successfully.

Fixes: e2cb1dec9779 ("net: hns3: Add HNS3 VF HCL(Hardware Compatibility Layer) Support")
Fixes: 46a3df9f9718 ("net: hns3: Add HNS3 Acceleration Engine & Compatibility Layer Support")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.c          | 12 +++++-------
 drivers/net/ethernet/hisilicon/hns3/hnae3.h          |  3 +++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c  |  9 +++++++++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c    |  9 +++++++++
 4 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.c b/drivers/net/ethernet/hisilicon/hns3/hnae3.c
index 0594a6c3dccda..2097f92e14c5c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.c
@@ -29,8 +29,8 @@ static bool hnae3_client_match(enum hnae3_client_type client_type,
 	return false;
 }
 
-static void hnae3_set_client_init_flag(struct hnae3_client *client,
-				       struct hnae3_ae_dev *ae_dev, int inited)
+void hnae3_set_client_init_flag(struct hnae3_client *client,
+				struct hnae3_ae_dev *ae_dev, int inited)
 {
 	switch (client->type) {
 	case HNAE3_CLIENT_KNIC:
@@ -46,6 +46,7 @@ static void hnae3_set_client_init_flag(struct hnae3_client *client,
 		break;
 	}
 }
+EXPORT_SYMBOL(hnae3_set_client_init_flag);
 
 static int hnae3_get_client_init_flag(struct hnae3_client *client,
 				       struct hnae3_ae_dev *ae_dev)
@@ -86,14 +87,11 @@ static int hnae3_match_n_instantiate(struct hnae3_client *client,
 	/* now, (un-)instantiate client by calling lower layer */
 	if (is_reg) {
 		ret = ae_dev->ops->init_client_instance(client, ae_dev);
-		if (ret) {
+		if (ret)
 			dev_err(&ae_dev->pdev->dev,
 				"fail to instantiate client, ret = %d\n", ret);
-			return ret;
-		}
 
-		hnae3_set_client_init_flag(client, ae_dev, 1);
-		return 0;
+		return ret;
 	}
 
 	if (hnae3_get_client_init_flag(client, ae_dev)) {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 67befff0bfc50..f5c7fc9c5e5cc 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -521,4 +521,7 @@ void hnae3_register_ae_algo(struct hnae3_ae_algo *ae_algo);
 
 void hnae3_unregister_client(struct hnae3_client *client);
 int hnae3_register_client(struct hnae3_client *client);
+
+void hnae3_set_client_init_flag(struct hnae3_client *client,
+				struct hnae3_ae_dev *ae_dev, int inited);
 #endif
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index c5e617fdb809f..b04df79f393f8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -5485,6 +5485,8 @@ static int hclge_init_client_instance(struct hnae3_client *client,
 				goto clear_nic;
 			}
 
+			hnae3_set_client_init_flag(client, ae_dev, 1);
+
 			if (hdev->roce_client &&
 			    hnae3_dev_roce_supported(hdev)) {
 				struct hnae3_client *rc = hdev->roce_client;
@@ -5496,6 +5498,9 @@ static int hclge_init_client_instance(struct hnae3_client *client,
 				ret = rc->ops->init_instance(&vport->roce);
 				if (ret)
 					goto clear_roce;
+
+				hnae3_set_client_init_flag(hdev->roce_client,
+							   ae_dev, 1);
 			}
 
 			break;
@@ -5507,6 +5512,8 @@ static int hclge_init_client_instance(struct hnae3_client *client,
 			if (ret)
 				goto clear_nic;
 
+			hnae3_set_client_init_flag(client, ae_dev, 1);
+
 			break;
 		case HNAE3_CLIENT_ROCE:
 			if (hnae3_dev_roce_supported(hdev)) {
@@ -5522,6 +5529,8 @@ static int hclge_init_client_instance(struct hnae3_client *client,
 				ret = client->ops->init_instance(&vport->roce);
 				if (ret)
 					goto clear_roce;
+
+				hnae3_set_client_init_flag(client, ae_dev, 1);
 			}
 		}
 	}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 83fcdd326de71..beae1e2cd59b1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1631,6 +1631,8 @@ static int hclgevf_init_client_instance(struct hnae3_client *client,
 		if (ret)
 			goto clear_nic;
 
+		hnae3_set_client_init_flag(client, ae_dev, 1);
+
 		if (hdev->roce_client && hnae3_dev_roce_supported(hdev)) {
 			struct hnae3_client *rc = hdev->roce_client;
 
@@ -1640,6 +1642,9 @@ static int hclgevf_init_client_instance(struct hnae3_client *client,
 			ret = rc->ops->init_instance(&hdev->roce);
 			if (ret)
 				goto clear_roce;
+
+			hnae3_set_client_init_flag(hdev->roce_client, ae_dev,
+						   1);
 		}
 		break;
 	case HNAE3_CLIENT_UNIC:
@@ -1649,6 +1654,8 @@ static int hclgevf_init_client_instance(struct hnae3_client *client,
 		ret = client->ops->init_instance(&hdev->nic);
 		if (ret)
 			goto clear_nic;
+
+		hnae3_set_client_init_flag(client, ae_dev, 1);
 		break;
 	case HNAE3_CLIENT_ROCE:
 		if (hnae3_dev_roce_supported(hdev)) {
@@ -1665,6 +1672,8 @@ static int hclgevf_init_client_instance(struct hnae3_client *client,
 			if (ret)
 				goto clear_roce;
 		}
+
+		hnae3_set_client_init_flag(client, ae_dev, 1);
 	}
 
 	return 0;
-- 
2.20.1



