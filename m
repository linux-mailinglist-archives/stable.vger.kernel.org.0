Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAB7356FC42
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233156AbiGKJl2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233166AbiGKJkv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:40:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5DC752FC7;
        Mon, 11 Jul 2022 02:20:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73AD9B80E7A;
        Mon, 11 Jul 2022 09:20:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47FDC34115;
        Mon, 11 Jul 2022 09:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531245;
        bh=eGIB+8Gu4xZaEbCEbELdjBA9oQry6AsxRl7YUzHrQBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zMHpNaC0fDuIvex4Q/nBaXUMysu9qH3hQbdetnCHXJkW2CyeVRNperg1fjf8ljBCW
         JTeQ17JqMvldSJxZKpsVjJrfNc6L5oXDdMT25w6TQqBxTop5K1oz0LWI8d+C2XR898
         PjLMuMoWFm0TztkWe4YJxhOXEkgkJkOHQQYdIldc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 034/230] PCI/portdrv: Rename pm_iter() to pcie_port_device_iter()
Date:   Mon, 11 Jul 2022 11:04:50 +0200
Message-Id: <20220711090605.047935590@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit 3134689f98f9e09004a4727370adc46e7635b4be ]

Rename pm_iter() to pcie_port_device_iter() and make it visible outside
CONFIG_PM and portdrv_core.c so it can be used for pciehp slot reset
recovery.

[bhelgaas: split into its own patch]
Link: https://lore.kernel.org/linux-pci/08c046b0-c9f2-3489-eeef-7e7aca435bb9@gmail.com/
Link: https://lore.kernel.org/r/251f4edcc04c14f873ff1c967bc686169cd07d2d.1627638184.git.lukas@wunner.de
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/portdrv.h      |  1 +
 drivers/pci/pcie/portdrv_core.c | 20 ++++++++++----------
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/pci/pcie/portdrv.h b/drivers/pci/pcie/portdrv.h
index 2ff5724b8f13..6126ee4676a7 100644
--- a/drivers/pci/pcie/portdrv.h
+++ b/drivers/pci/pcie/portdrv.h
@@ -110,6 +110,7 @@ void pcie_port_service_unregister(struct pcie_port_service_driver *new);
 
 extern struct bus_type pcie_port_bus_type;
 int pcie_port_device_register(struct pci_dev *dev);
+int pcie_port_device_iter(struct device *dev, void *data);
 #ifdef CONFIG_PM
 int pcie_port_device_suspend(struct device *dev);
 int pcie_port_device_resume_noirq(struct device *dev);
diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
index 3ee63968deaa..604feeb84ee4 100644
--- a/drivers/pci/pcie/portdrv_core.c
+++ b/drivers/pci/pcie/portdrv_core.c
@@ -367,24 +367,24 @@ int pcie_port_device_register(struct pci_dev *dev)
 	return status;
 }
 
-#ifdef CONFIG_PM
-typedef int (*pcie_pm_callback_t)(struct pcie_device *);
+typedef int (*pcie_callback_t)(struct pcie_device *);
 
-static int pm_iter(struct device *dev, void *data)
+int pcie_port_device_iter(struct device *dev, void *data)
 {
 	struct pcie_port_service_driver *service_driver;
 	size_t offset = *(size_t *)data;
-	pcie_pm_callback_t cb;
+	pcie_callback_t cb;
 
 	if ((dev->bus == &pcie_port_bus_type) && dev->driver) {
 		service_driver = to_service_driver(dev->driver);
-		cb = *(pcie_pm_callback_t *)((void *)service_driver + offset);
+		cb = *(pcie_callback_t *)((void *)service_driver + offset);
 		if (cb)
 			return cb(to_pcie_device(dev));
 	}
 	return 0;
 }
 
+#ifdef CONFIG_PM
 /**
  * pcie_port_device_suspend - suspend port services associated with a PCIe port
  * @dev: PCI Express port to handle
@@ -392,13 +392,13 @@ static int pm_iter(struct device *dev, void *data)
 int pcie_port_device_suspend(struct device *dev)
 {
 	size_t off = offsetof(struct pcie_port_service_driver, suspend);
-	return device_for_each_child(dev, &off, pm_iter);
+	return device_for_each_child(dev, &off, pcie_port_device_iter);
 }
 
 int pcie_port_device_resume_noirq(struct device *dev)
 {
 	size_t off = offsetof(struct pcie_port_service_driver, resume_noirq);
-	return device_for_each_child(dev, &off, pm_iter);
+	return device_for_each_child(dev, &off, pcie_port_device_iter);
 }
 
 /**
@@ -408,7 +408,7 @@ int pcie_port_device_resume_noirq(struct device *dev)
 int pcie_port_device_resume(struct device *dev)
 {
 	size_t off = offsetof(struct pcie_port_service_driver, resume);
-	return device_for_each_child(dev, &off, pm_iter);
+	return device_for_each_child(dev, &off, pcie_port_device_iter);
 }
 
 /**
@@ -418,7 +418,7 @@ int pcie_port_device_resume(struct device *dev)
 int pcie_port_device_runtime_suspend(struct device *dev)
 {
 	size_t off = offsetof(struct pcie_port_service_driver, runtime_suspend);
-	return device_for_each_child(dev, &off, pm_iter);
+	return device_for_each_child(dev, &off, pcie_port_device_iter);
 }
 
 /**
@@ -428,7 +428,7 @@ int pcie_port_device_runtime_suspend(struct device *dev)
 int pcie_port_device_runtime_resume(struct device *dev)
 {
 	size_t off = offsetof(struct pcie_port_service_driver, runtime_resume);
-	return device_for_each_child(dev, &off, pm_iter);
+	return device_for_each_child(dev, &off, pcie_port_device_iter);
 }
 #endif /* PM */
 
-- 
2.35.1



