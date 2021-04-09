Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 475E9359AF0
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 12:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233821AbhDIKHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 06:07:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:51298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233569AbhDIKDA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 06:03:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E9F36115B;
        Fri,  9 Apr 2021 10:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962423;
        bh=bJgG9no5xh/Cz0WtH7XO6q/37s45CFSv3lDISxUTGNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rfyV7VrmFYWLLxVI2m6r3c0LICPUmQpoW+JyJ3+nODrSX1nJlFW8izFLAWyajfC1h
         G9PRhzDGx21tlrFGmmUeeLVq8AE6aj19J5nkSdRIeR4P8qwxuBS5cT3KK1o8X77/nD
         0F0w9ZDBy4TMUpnvNql0vICye/WPjmpu4U9Khc80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tong Zhang <ztong0001@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 10/45] net: arcnet: com20020 fix error handling
Date:   Fri,  9 Apr 2021 11:53:36 +0200
Message-Id: <20210409095305.723972395@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095305.397149021@linuxfoundation.org>
References: <20210409095305.397149021@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tong Zhang <ztong0001@gmail.com>

[ Upstream commit 6577b9a551aedb86bca6d4438c28386361845108 ]

There are two issues when handling error case in com20020pci_probe()

1. priv might be not initialized yet when calling com20020pci_remove()
from com20020pci_probe(), since the priv is set at the very last but it
can jump to error handling in the middle and priv remains NULL.
2. memory leak - the net device is allocated in alloc_arcdev but not
properly released if error happens in the middle of the big for loop

[    1.529110] BUG: kernel NULL pointer dereference, address: 0000000000000008
[    1.531447] RIP: 0010:com20020pci_remove+0x15/0x60 [com20020_pci]
[    1.536805] Call Trace:
[    1.536939]  com20020pci_probe+0x3f2/0x48c [com20020_pci]
[    1.537226]  local_pci_probe+0x48/0x80
[    1.539918]  com20020pci_init+0x3f/0x1000 [com20020_pci]

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/arcnet/com20020-pci.c | 34 +++++++++++++++++--------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/net/arcnet/com20020-pci.c b/drivers/net/arcnet/com20020-pci.c
index 8bdc44b7e09a..3c8f665c1558 100644
--- a/drivers/net/arcnet/com20020-pci.c
+++ b/drivers/net/arcnet/com20020-pci.c
@@ -127,6 +127,8 @@ static int com20020pci_probe(struct pci_dev *pdev,
 	int i, ioaddr, ret;
 	struct resource *r;
 
+	ret = 0;
+
 	if (pci_enable_device(pdev))
 		return -EIO;
 
@@ -139,6 +141,8 @@ static int com20020pci_probe(struct pci_dev *pdev,
 	priv->ci = ci;
 	mm = &ci->misc_map;
 
+	pci_set_drvdata(pdev, priv);
+
 	INIT_LIST_HEAD(&priv->list_dev);
 
 	if (mm->size) {
@@ -161,7 +165,7 @@ static int com20020pci_probe(struct pci_dev *pdev,
 		dev = alloc_arcdev(device);
 		if (!dev) {
 			ret = -ENOMEM;
-			goto out_port;
+			break;
 		}
 		dev->dev_port = i;
 
@@ -178,7 +182,7 @@ static int com20020pci_probe(struct pci_dev *pdev,
 			pr_err("IO region %xh-%xh already allocated\n",
 			       ioaddr, ioaddr + cm->size - 1);
 			ret = -EBUSY;
-			goto out_port;
+			goto err_free_arcdev;
 		}
 
 		/* Dummy access after Reset
@@ -216,18 +220,18 @@ static int com20020pci_probe(struct pci_dev *pdev,
 		if (arcnet_inb(ioaddr, COM20020_REG_R_STATUS) == 0xFF) {
 			pr_err("IO address %Xh is empty!\n", ioaddr);
 			ret = -EIO;
-			goto out_port;
+			goto err_free_arcdev;
 		}
 		if (com20020_check(dev)) {
 			ret = -EIO;
-			goto out_port;
+			goto err_free_arcdev;
 		}
 
 		card = devm_kzalloc(&pdev->dev, sizeof(struct com20020_dev),
 				    GFP_KERNEL);
 		if (!card) {
 			ret = -ENOMEM;
-			goto out_port;
+			goto err_free_arcdev;
 		}
 
 		card->index = i;
@@ -253,29 +257,29 @@ static int com20020pci_probe(struct pci_dev *pdev,
 
 		ret = devm_led_classdev_register(&pdev->dev, &card->tx_led);
 		if (ret)
-			goto out_port;
+			goto err_free_arcdev;
 
 		ret = devm_led_classdev_register(&pdev->dev, &card->recon_led);
 		if (ret)
-			goto out_port;
+			goto err_free_arcdev;
 
 		dev_set_drvdata(&dev->dev, card);
 
 		ret = com20020_found(dev, IRQF_SHARED);
 		if (ret)
-			goto out_port;
+			goto err_free_arcdev;
 
 		devm_arcnet_led_init(dev, dev->dev_id, i);
 
 		list_add(&card->list, &priv->list_dev);
-	}
+		continue;
 
-	pci_set_drvdata(pdev, priv);
-
-	return 0;
-
-out_port:
-	com20020pci_remove(pdev);
+err_free_arcdev:
+		free_arcdev(dev);
+		break;
+	}
+	if (ret)
+		com20020pci_remove(pdev);
 	return ret;
 }
 
-- 
2.30.2



