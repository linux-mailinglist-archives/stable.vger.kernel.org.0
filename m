Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8501412179E
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728963AbfLPShd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:37:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:45538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729927AbfLPSGG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:06:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D81D02072D;
        Mon, 16 Dec 2019 18:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519565;
        bh=KiyNRWnPGiJF+WXmZXgXlZosUasZ2NlvW0XqNFnF0p0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0ZZd4q720VcAOlaCVh6loIb8BrgT5DxMgEHEcbbm7xEXdznkF3DonfDCZlfSwQ1fN
         KXebLk9yXE/0LBzrUJLvFXhBhSvUKu2hP0Qc6DrJA3CUXaL0nhsILtEyYeUrrNjE4/
         a0h7N7/xWufur3NxAsfYV0yyLPbVRelMoxW8Z7R8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huazhong Tan <tanhuazhong@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 118/140] net: hns3: change hnae3_register_ae_dev() to int
Date:   Mon, 16 Dec 2019 18:49:46 +0100
Message-Id: <20191216174820.078472441@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174747.111154704@linuxfoundation.org>
References: <20191216174747.111154704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>

[ Upstream commit 74354140a579008fd164241e3697d9c37e5b8989 ]

hnae3_register_ae_dev() may fail, and it should return a error code
to its caller, so change hnae3_register_ae_dev() return type to int.

Also, when hnae3_register_ae_dev() return error, hns3_probe() should
do some error handling and return the error code.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.c     | 10 +++++++++-
 drivers/net/ethernet/hisilicon/hns3/hnae3.h     |  2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c |  8 ++++++--
 3 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.c b/drivers/net/ethernet/hisilicon/hns3/hnae3.c
index 2097f92e14c5c..f98bff60bec37 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.c
@@ -239,7 +239,7 @@ EXPORT_SYMBOL(hnae3_unregister_ae_algo);
  * @ae_dev: the AE device
  * NOTE: the duplicated name will not be checked
  */
-void hnae3_register_ae_dev(struct hnae3_ae_dev *ae_dev)
+int hnae3_register_ae_dev(struct hnae3_ae_dev *ae_dev)
 {
 	const struct pci_device_id *id;
 	struct hnae3_ae_algo *ae_algo;
@@ -260,6 +260,7 @@ void hnae3_register_ae_dev(struct hnae3_ae_dev *ae_dev)
 
 		if (!ae_dev->ops) {
 			dev_err(&ae_dev->pdev->dev, "ae_dev ops are null\n");
+			ret = -EOPNOTSUPP;
 			goto out_err;
 		}
 
@@ -286,8 +287,15 @@ void hnae3_register_ae_dev(struct hnae3_ae_dev *ae_dev)
 				ret);
 	}
 
+	mutex_unlock(&hnae3_common_lock);
+
+	return 0;
+
 out_err:
+	list_del(&ae_dev->node);
 	mutex_unlock(&hnae3_common_lock);
+
+	return ret;
 }
 EXPORT_SYMBOL(hnae3_register_ae_dev);
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index f5c7fc9c5e5cc..5e1a7ab06c63b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -513,7 +513,7 @@ struct hnae3_handle {
 #define hnae3_get_bit(origin, shift) \
 	hnae3_get_field((origin), (0x1 << (shift)), (shift))
 
-void hnae3_register_ae_dev(struct hnae3_ae_dev *ae_dev);
+int hnae3_register_ae_dev(struct hnae3_ae_dev *ae_dev);
 void hnae3_unregister_ae_dev(struct hnae3_ae_dev *ae_dev);
 
 void hnae3_unregister_ae_algo(struct hnae3_ae_algo *ae_algo);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 4b4d9de0a6bb5..0788e78747d94 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1604,9 +1604,13 @@ static int hns3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	ae_dev->dev_type = HNAE3_DEV_KNIC;
 	pci_set_drvdata(pdev, ae_dev);
 
-	hnae3_register_ae_dev(ae_dev);
+	ret = hnae3_register_ae_dev(ae_dev);
+	if (ret) {
+		devm_kfree(&pdev->dev, ae_dev);
+		pci_set_drvdata(pdev, NULL);
+	}
 
-	return 0;
+	return ret;
 }
 
 /* hns3_remove - Device removal routine
-- 
2.20.1



