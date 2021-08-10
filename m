Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB93B3E57EA
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 12:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238752AbhHJKE2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 06:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239677AbhHJKEB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Aug 2021 06:04:01 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6429CC06179F;
        Tue, 10 Aug 2021 03:03:39 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id f3so9653448plg.3;
        Tue, 10 Aug 2021 03:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3JU96kQ8IMjxSi+e0LRvIglTv3Bdf6B0X88+jFY3sPY=;
        b=OaMUVnX7ps570oEg1f7Q+UPknQYbtwK6/aX0IBm4jq0oDAPuBolvSkrTqrKNP1VNeq
         e2MV6i7BDcLzeQYN1lC3O6rYfYtjldvwl0XJZf+2d8WAuhvTuClyZ1hry6Cnkk89AbP0
         yRdtLTw4Pw7zvSs/qKcNQyhDW1/cUCB1j2rWg1UxILCs/4De+jvNyn0io9648TbYzGtI
         Q4BiM0AkeO8vvp4+l06QlLmSAhkl132z3UbTOVvZTiH+ASDF9JgpUd7282MKDcSJGrMA
         P+ULeXHMpjGHquoRFuha4m9gqsgMorvCSAr4IPkjMaQ4Rqs46QxSS1t8zcHiWmWHQDnR
         TlSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3JU96kQ8IMjxSi+e0LRvIglTv3Bdf6B0X88+jFY3sPY=;
        b=jorBTf+jAhiPfvPSjZWyZxsw4RfLGe3m3IknywZUuc1vrrMSoJhXjHQ9a7TQKukpO9
         8XBi3rvrZ9np/XDt1iqZoiP2bbClgKoPKEDGastAY577yGawmCfP2iO+DQobJkUNy+ET
         HzTnQdSWvBelvE63MCRD/QyBxuEbz5+l5V5PGn7Q9goQe+uIlgzLcqHLz2e3mOkWia0/
         72WsWDOMsukbkhxw72Lr8DpMkuHim87StYZhJD4/BD0vT4VLkQyfQHx1v2JRwDet76um
         SnDnxA99AQ38g8nFnVjOhzP48I5tEOINCvHEx2AXpdESv2+93YgOCIFrg7gm+znEbmCr
         Ft9w==
X-Gm-Message-State: AOAM533Ap5ipHa+Jm6exSQCNO8wLQpMwTVX/CmUuUr88iIn3qvp4l/F4
        P249ncMGKqSxORprisDDSws=
X-Google-Smtp-Source: ABdhPJwl6UZtG2TMjQs7gCi533fPy0e/MinI36y+nb+VdFDzwyBgcFzoVPBQgvUpz7yljLeuHnwXgQ==
X-Received: by 2002:a63:b59:: with SMTP id a25mr41468pgl.373.1628589818852;
        Tue, 10 Aug 2021 03:03:38 -0700 (PDT)
Received: from localhost.localdomain ([154.16.166.217])
        by smtp.gmail.com with ESMTPSA id e13sm22943413pfi.210.2021.08.10.03.03.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 03:03:38 -0700 (PDT)
From:   Dongliang Mu <mudongliangabcd@gmail.com>
To:     Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        Aditya Srivastava <yashsri421@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Cc:     stable@vger.kernel.org, industrypack-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/2] ipack: tpci200: fix many double free issues in tpci200_pci_probe
Date:   Tue, 10 Aug 2021 18:03:18 +0800
Message-Id: <20210810100323.3938492-1-mudongliangabcd@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The function tpci200_register called by tpci200_install and
tpci200_unregister called by tpci200_uninstall are in pair. However,
tpci200_unregister has some cleanup operations not in the
tpci200_register. So the error handling code of tpci200_pci_probe has
many different double free issues.

Fix this problem by moving those cleanup operations out of
tpci200_unregister, into tpci200_pci_remove and reverting
the previous commit 9272e5d0028d ("ipack/carriers/tpci200:
Fix a double free in tpci200_pci_probe").

Reported-by: Dongliang Mu <mudongliangabcd@gmail.com>
Fixes: 9272e5d0028d ("ipack/carriers/tpci200: Fix a double free in tpci200_pci_probe")
Cc: stable@vger.kernel.org
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
v1->v2: revise PATCH 2/3, 3/3, not depending on PATCH 1/3; move the
location change of tpci_unregister into one separate patch;
v2->v3: double check all pci_iounmap api invocations
v3->v4: add a tag - Cc: stable@vger.kernel.org
 drivers/ipack/carriers/tpci200.c | 36 ++++++++++++++++----------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/ipack/carriers/tpci200.c b/drivers/ipack/carriers/tpci200.c
index 3461b0a7dc62..92795a0230ca 100644
--- a/drivers/ipack/carriers/tpci200.c
+++ b/drivers/ipack/carriers/tpci200.c
@@ -89,16 +89,13 @@ static void tpci200_unregister(struct tpci200_board *tpci200)
 	free_irq(tpci200->info->pdev->irq, (void *) tpci200);
 
 	pci_iounmap(tpci200->info->pdev, tpci200->info->interface_regs);
-	pci_iounmap(tpci200->info->pdev, tpci200->info->cfg_regs);
 
 	pci_release_region(tpci200->info->pdev, TPCI200_IP_INTERFACE_BAR);
 	pci_release_region(tpci200->info->pdev, TPCI200_IO_ID_INT_SPACES_BAR);
 	pci_release_region(tpci200->info->pdev, TPCI200_MEM16_SPACE_BAR);
 	pci_release_region(tpci200->info->pdev, TPCI200_MEM8_SPACE_BAR);
-	pci_release_region(tpci200->info->pdev, TPCI200_CFG_MEM_BAR);
 
 	pci_disable_device(tpci200->info->pdev);
-	pci_dev_put(tpci200->info->pdev);
 }
 
 static void tpci200_enable_irq(struct tpci200_board *tpci200,
@@ -527,7 +524,7 @@ static int tpci200_pci_probe(struct pci_dev *pdev,
 	tpci200->info = kzalloc(sizeof(struct tpci200_infos), GFP_KERNEL);
 	if (!tpci200->info) {
 		ret = -ENOMEM;
-		goto out_err_info;
+		goto err_tpci200;
 	}
 
 	pci_dev_get(pdev);
@@ -538,7 +535,7 @@ static int tpci200_pci_probe(struct pci_dev *pdev,
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to allocate PCI Configuration Memory");
 		ret = -EBUSY;
-		goto out_err_pci_request;
+		goto err_tpci200_info;
 	}
 	tpci200->info->cfg_regs = ioremap(
 			pci_resource_start(pdev, TPCI200_CFG_MEM_BAR),
@@ -546,7 +543,7 @@ static int tpci200_pci_probe(struct pci_dev *pdev,
 	if (!tpci200->info->cfg_regs) {
 		dev_err(&pdev->dev, "Failed to map PCI Configuration Memory");
 		ret = -EFAULT;
-		goto out_err_ioremap;
+		goto err_request_region;
 	}
 
 	/* Disable byte swapping for 16 bit IP module access. This will ensure
@@ -569,7 +566,7 @@ static int tpci200_pci_probe(struct pci_dev *pdev,
 	if (ret) {
 		dev_err(&pdev->dev, "error during tpci200 install\n");
 		ret = -ENODEV;
-		goto out_err_install;
+		goto err_cfg_regs;
 	}
 
 	/* Register the carrier in the industry pack bus driver */
@@ -581,7 +578,7 @@ static int tpci200_pci_probe(struct pci_dev *pdev,
 		dev_err(&pdev->dev,
 			"error registering the carrier on ipack driver\n");
 		ret = -EFAULT;
-		goto out_err_bus_register;
+		goto err_tpci200_install;
 	}
 
 	/* save the bus number given by ipack to logging purpose */
@@ -592,19 +589,16 @@ static int tpci200_pci_probe(struct pci_dev *pdev,
 		tpci200_create_device(tpci200, i);
 	return 0;
 
-out_err_bus_register:
+err_tpci200_install:
 	tpci200_uninstall(tpci200);
-	/* tpci200->info->cfg_regs is unmapped in tpci200_uninstall */
-	tpci200->info->cfg_regs = NULL;
-out_err_install:
-	if (tpci200->info->cfg_regs)
-		iounmap(tpci200->info->cfg_regs);
-out_err_ioremap:
+err_cfg_regs:
+	pci_iounmap(tpci200->info->pdev, tpci200->info->cfg_regs);
+err_request_region:
 	pci_release_region(pdev, TPCI200_CFG_MEM_BAR);
-out_err_pci_request:
-	pci_dev_put(pdev);
+err_tpci200_info:
 	kfree(tpci200->info);
-out_err_info:
+	pci_dev_put(pdev);
+err_tpci200:
 	kfree(tpci200);
 	return ret;
 }
@@ -614,6 +608,12 @@ static void __tpci200_pci_remove(struct tpci200_board *tpci200)
 	ipack_bus_unregister(tpci200->info->ipack_bus);
 	tpci200_uninstall(tpci200);
 
+	pci_iounmap(tpci200->info->pdev, tpci200->info->cfg_regs);
+
+	pci_release_region(tpci200->info->pdev, TPCI200_CFG_MEM_BAR);
+
+	pci_dev_put(tpci200->info->pdev);
+
 	kfree(tpci200->info);
 	kfree(tpci200);
 }
-- 
2.25.1

