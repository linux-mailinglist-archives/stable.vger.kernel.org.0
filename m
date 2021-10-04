Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1D9420DDB
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236348AbhJDNTR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:19:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235644AbhJDNSK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:18:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46B5261401;
        Mon,  4 Oct 2021 13:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352845;
        bh=N2rJ718O84x0hLnlf6FP1msC88XuBpJqMlyEEtlJP6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y/JL1bqUczEzim3ccGce9bKQhZ+qjElixbAiESehQrH2cueoDrMy++u4VU+6x2O/b
         c34ze+zbLGyvjbQFxCLD04v7QQa1HrIy3qo75dMOal0rgYmTGio0da4EomFfOrglDE
         LR91hlbwjGBzF4sH6IO4JmHkio97/GnR0C3ANAQM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anders Roxell <anders.roxell@linaro.org>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Tyler Hicks <tyhicks@linux.microsoft.com>
Subject: [PATCH 5.4 47/56] PCI: Fix pci_host_bridge struct device release/free handling
Date:   Mon,  4 Oct 2021 14:53:07 +0200
Message-Id: <20211004125031.486249023@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125030.002116402@linuxfoundation.org>
References: <20211004125030.002116402@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

commit 9885440b16b8fc1dd7275800fd28f56a92f60896 upstream.

The PCI code has several paths where the struct pci_host_bridge is freed
directly. This is wrong because it contains a struct device which is
refcounted and should be freed using put_device(). This can result in
use-after-free errors. I think this problem has existed since 2012 with
commit 7b5436635800 ("PCI: add generic device into pci_host_bridge
struct"). It generally hasn't mattered as most host bridge drivers are
still built-in and can't unbind.

The problem is a struct device should never be freed directly once
device_initialize() is called and a ref is held, but that doesn't happen
until pci_register_host_bridge(). There's then a window between allocating
the host bridge and pci_register_host_bridge() where kfree should be used.
This is fragile and requires callers to do the right thing. To fix this, we
need to split device_register() into device_initialize() and device_add()
calls, so that the host bridge struct is always freed by using a
put_device().

devm_pci_alloc_host_bridge() is using devm_kzalloc() to allocate struct
pci_host_bridge which will be freed directly. Instead, we can use a custom
devres action to call put_device().

Link: https://lore.kernel.org/r/20200513223859.11295-2-robh@kernel.org
Reported-by: Anders Roxell <anders.roxell@linaro.org>
Tested-by: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
[tyhicks: Minor contextual change in pci_init_host_bridge() due to the
 lack of a native_dpc member in the pci_host_bridge struct. It was added
 in v5.7 with commit ac1c8e35a326 ("PCI/DPC: Add Error Disconnect
 Recover (EDR) support")]
Signed-off-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/probe.c  |   36 +++++++++++++++++++-----------------
 drivers/pci/remove.c |    2 +-
 2 files changed, 20 insertions(+), 18 deletions(-)

--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -564,7 +564,7 @@ static struct pci_bus *pci_alloc_bus(str
 	return b;
 }
 
-static void devm_pci_release_host_bridge_dev(struct device *dev)
+static void pci_release_host_bridge_dev(struct device *dev)
 {
 	struct pci_host_bridge *bridge = to_pci_host_bridge(dev);
 
@@ -573,12 +573,7 @@ static void devm_pci_release_host_bridge
 
 	pci_free_resource_list(&bridge->windows);
 	pci_free_resource_list(&bridge->dma_ranges);
-}
-
-static void pci_release_host_bridge_dev(struct device *dev)
-{
-	devm_pci_release_host_bridge_dev(dev);
-	kfree(to_pci_host_bridge(dev));
+	kfree(bridge);
 }
 
 static void pci_init_host_bridge(struct pci_host_bridge *bridge)
@@ -597,6 +592,8 @@ static void pci_init_host_bridge(struct
 	bridge->native_shpc_hotplug = 1;
 	bridge->native_pme = 1;
 	bridge->native_ltr = 1;
+
+	device_initialize(&bridge->dev);
 }
 
 struct pci_host_bridge *pci_alloc_host_bridge(size_t priv)
@@ -614,17 +611,25 @@ struct pci_host_bridge *pci_alloc_host_b
 }
 EXPORT_SYMBOL(pci_alloc_host_bridge);
 
+static void devm_pci_alloc_host_bridge_release(void *data)
+{
+	pci_free_host_bridge(data);
+}
+
 struct pci_host_bridge *devm_pci_alloc_host_bridge(struct device *dev,
 						   size_t priv)
 {
+	int ret;
 	struct pci_host_bridge *bridge;
 
-	bridge = devm_kzalloc(dev, sizeof(*bridge) + priv, GFP_KERNEL);
+	bridge = pci_alloc_host_bridge(priv);
 	if (!bridge)
 		return NULL;
 
-	pci_init_host_bridge(bridge);
-	bridge->dev.release = devm_pci_release_host_bridge_dev;
+	ret = devm_add_action_or_reset(dev, devm_pci_alloc_host_bridge_release,
+				       bridge);
+	if (ret)
+		return NULL;
 
 	return bridge;
 }
@@ -632,10 +637,7 @@ EXPORT_SYMBOL(devm_pci_alloc_host_bridge
 
 void pci_free_host_bridge(struct pci_host_bridge *bridge)
 {
-	pci_free_resource_list(&bridge->windows);
-	pci_free_resource_list(&bridge->dma_ranges);
-
-	kfree(bridge);
+	put_device(&bridge->dev);
 }
 EXPORT_SYMBOL(pci_free_host_bridge);
 
@@ -866,7 +868,7 @@ static int pci_register_host_bridge(stru
 	if (err)
 		goto free;
 
-	err = device_register(&bridge->dev);
+	err = device_add(&bridge->dev);
 	if (err) {
 		put_device(&bridge->dev);
 		goto free;
@@ -933,7 +935,7 @@ static int pci_register_host_bridge(stru
 
 unregister:
 	put_device(&bridge->dev);
-	device_unregister(&bridge->dev);
+	device_del(&bridge->dev);
 
 free:
 	kfree(bus);
@@ -2945,7 +2947,7 @@ struct pci_bus *pci_create_root_bus(stru
 	return bridge->bus;
 
 err_out:
-	kfree(bridge);
+	put_device(&bridge->dev);
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(pci_create_root_bus);
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -160,6 +160,6 @@ void pci_remove_root_bus(struct pci_bus
 	host_bridge->bus = NULL;
 
 	/* remove the host bridge */
-	device_unregister(&host_bridge->dev);
+	device_del(&host_bridge->dev);
 }
 EXPORT_SYMBOL_GPL(pci_remove_root_bus);


