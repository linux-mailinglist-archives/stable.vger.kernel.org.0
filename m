Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07953AA864
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 18:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388503AbfIEQTB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 12:19:01 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35629 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388391AbfIEQSP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 12:18:15 -0400
Received: by mail-pg1-f195.google.com with SMTP id n4so1692185pgv.2
        for <stable@vger.kernel.org>; Thu, 05 Sep 2019 09:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tpqdWISBmI7/K+eXW/BM3B61WGwPfixYNx9jyTHk1dU=;
        b=K5DiiY2Fgz6MUrPKTtz10HsJkolwwVvGrdqBD69mgIMaQbkMXiTRCgCbb2ZyUxaTSS
         TsurgVMOb8XwbIXgdyeF+rfzsvnXsAM1sHLEQ4y5Ke840f0eEdtxvvN3Pb5ZdVwNLiXE
         UV+r4cWr5AN6DgFXtNn2GrDrgfsbA6uZcFqrnHfIbgan0lx/1+ZKIyh6gDp63fdh/v9I
         KCxMrdpVzkF4eB9dCxcnzu4IORv5zjU09dggJmJTVefvcrHEGmUqyNXgA3hCndJldZef
         81oH34LbhykA0VcHebAOIDd2RLBykltXAikm9fusMU2Bx4GGt+Kmw89s92q1rKZ+QSBQ
         hcng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tpqdWISBmI7/K+eXW/BM3B61WGwPfixYNx9jyTHk1dU=;
        b=T/IWwC553shXp/4geER9t72GweEc1QRBOsGZh2rVUT4aFehUbNPh0zW3RhYoMJNdmQ
         0Z+OoKZ14AkGWWq0VXIRh85tS+spvSBLkFLUabVf4H1LBwib1FKa1bT5uq7ht8WXBleW
         kgpFfyqNJocORlKuW7D+iQCppbvNH1fbp4/KP9uj6RtVyd3fIhCjvaTNnullP4c/P/1b
         Qmdi24D4KE4fFRTPqb/gZ9fC1ORJZXeECi4HdRxnGouoA6+xuf1OBESLHH+K3eAUV5BE
         a9KNEwN/MMRGAstVGbWjJsQnD3NH2UvKH8kOky1fZcnCasjLbapUrtjsLcndnYO34BLq
         GTLA==
X-Gm-Message-State: APjAAAVY0m47FSrRqfLH44cruvWpdCZ/1/lRnB6HWHCfxZZwcOH3XSQY
        riH9099pQhrbqE4CVTjONDS4zVGOT48=
X-Google-Smtp-Source: APXvYqzLPzIYaG0mi1vPeoIIvWEzHscZk32TWtoUUzrIK69h3pf7m60GZNfheMkCm5xxBpsI0LrElA==
X-Received: by 2002:aa7:8e08:: with SMTP id c8mr849847pfr.238.1567700294324;
        Thu, 05 Sep 2019 09:18:14 -0700 (PDT)
Received: from xps15.cg.shawcable.net (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id m129sm6324005pga.39.2019.09.05.09.18.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2019 09:18:13 -0700 (PDT)
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: [BACKPORT 4.14.y 11/18] misc: pci_endpoint_test: Fix BUG_ON error during pci_disable_msi()
Date:   Thu,  5 Sep 2019 10:17:52 -0600
Message-Id: <20190905161759.28036-12-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190905161759.28036-1-mathieu.poirier@linaro.org>
References: <20190905161759.28036-1-mathieu.poirier@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kishon Vijay Abraham I <kishon@ti.com>

commit b7636e816adcb52bc96b6fb7bc9d141cbfd17ddb upstream

pci_disable_msi() throws a Kernel BUG if the driver has successfully
requested an IRQ and not released it. Fix it here by freeing IRQs before
invoking pci_disable_msi().

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/misc/pci_endpoint_test.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/misc/pci_endpoint_test.c b/drivers/misc/pci_endpoint_test.c
index 504fa680825d..230f1e8538dc 100644
--- a/drivers/misc/pci_endpoint_test.c
+++ b/drivers/misc/pci_endpoint_test.c
@@ -92,6 +92,7 @@ struct pci_endpoint_test {
 	void __iomem	*bar[6];
 	struct completion irq_raised;
 	int		last_irq;
+	int		num_irqs;
 	/* mutex to protect the ioctls */
 	struct mutex	mutex;
 	struct miscdevice miscdev;
@@ -514,6 +515,7 @@ static int pci_endpoint_test_probe(struct pci_dev *pdev,
 		irq = pci_alloc_irq_vectors(pdev, 1, 32, PCI_IRQ_MSI);
 		if (irq < 0)
 			dev_err(dev, "failed to get MSI interrupts\n");
+		test->num_irqs = irq;
 	}
 
 	err = devm_request_irq(dev, pdev->irq, pci_endpoint_test_irqhandler,
@@ -581,6 +583,9 @@ static int pci_endpoint_test_probe(struct pci_dev *pdev,
 			pci_iounmap(pdev, test->bar[bar]);
 	}
 
+	for (i = 0; i < irq; i++)
+		devm_free_irq(dev, pdev->irq + i, test);
+
 err_disable_msi:
 	pci_disable_msi(pdev);
 	pci_release_regions(pdev);
@@ -594,6 +599,7 @@ static int pci_endpoint_test_probe(struct pci_dev *pdev,
 static void pci_endpoint_test_remove(struct pci_dev *pdev)
 {
 	int id;
+	int i;
 	enum pci_barno bar;
 	struct pci_endpoint_test *test = pci_get_drvdata(pdev);
 	struct miscdevice *misc_device = &test->miscdev;
@@ -609,6 +615,8 @@ static void pci_endpoint_test_remove(struct pci_dev *pdev)
 		if (test->bar[bar])
 			pci_iounmap(pdev, test->bar[bar]);
 	}
+	for (i = 0; i < test->num_irqs; i++)
+		devm_free_irq(&pdev->dev, pdev->irq + i, test);
 	pci_disable_msi(pdev);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
-- 
2.17.1

