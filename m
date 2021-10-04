Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A976F4205B3
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 08:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232615AbhJDGKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 02:10:52 -0400
Received: from linux.microsoft.com ([13.77.154.182]:34230 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231935AbhJDGKw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 02:10:52 -0400
Received: from sequoia.work.tihix.com (162-237-133-238.lightspeed.rcsntx.sbcglobal.net [162.237.133.238])
        by linux.microsoft.com (Postfix) with ESMTPSA id EB31720B861E;
        Sun,  3 Oct 2021 23:09:02 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com EB31720B861E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1633327743;
        bh=THyLkAVaDs1Hb92aOse98gBjcNS/im3qub3b4KePinA=;
        h=From:To:Cc:Subject:Date:From;
        b=i+YokozB2sWf+jfr4g4qRR+P8mPaGVgPum+tXZWOEsAZ+R22OlXDCUy5XbRObxXEv
         exyzKR5zFEwUz/BUaWxBHY9hHEc4AyOwvc3NhKOfOWmHnKVi5IPdjdJfRJppXxY49k
         sh8rY3g1BAedoeMia9cDVJYJeZam7CN3gR9P4N/s=
From:   Tyler Hicks <tyhicks@linux.microsoft.com>
To:     stable@vger.kernel.org
Cc:     Rob Herring <robh@kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.4] PCI: Fix pci_host_bridge struct device release/free handling
Date:   Mon,  4 Oct 2021 01:08:38 -0500
Message-Id: <20211004060838.678790-1-tyhicks@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
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
---

This commit has been identified as a fix for random memory corruption
that we're experiencing in production. The memory corruption is easily
reproducible on 5.4.150 and we get a nice KASAN splat that led us to
discovering the upstream fix that wasn't marked for stable inclusion. I
don't see any obvious reasons why this wouldn't be a valid linux-5.4.y
candidate and hope we can get it applied there.

I've verified that the KASAN splat goes away and I don't see any other
evidence of the memory corruption issue once this commit is applied to
5.4.150.

 drivers/pci/probe.c  | 36 +++++++++++++++++++-----------------
 drivers/pci/remove.c |  2 +-
 2 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index f28213b62527..a41d04c57642 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -564,7 +564,7 @@ static struct pci_bus *pci_alloc_bus(struct pci_bus *parent)
 	return b;
 }
 
-static void devm_pci_release_host_bridge_dev(struct device *dev)
+static void pci_release_host_bridge_dev(struct device *dev)
 {
 	struct pci_host_bridge *bridge = to_pci_host_bridge(dev);
 
@@ -573,12 +573,7 @@ static void devm_pci_release_host_bridge_dev(struct device *dev)
 
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
@@ -597,6 +592,8 @@ static void pci_init_host_bridge(struct pci_host_bridge *bridge)
 	bridge->native_shpc_hotplug = 1;
 	bridge->native_pme = 1;
 	bridge->native_ltr = 1;
+
+	device_initialize(&bridge->dev);
 }
 
 struct pci_host_bridge *pci_alloc_host_bridge(size_t priv)
@@ -614,17 +611,25 @@ struct pci_host_bridge *pci_alloc_host_bridge(size_t priv)
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
@@ -632,10 +637,7 @@ EXPORT_SYMBOL(devm_pci_alloc_host_bridge);
 
 void pci_free_host_bridge(struct pci_host_bridge *bridge)
 {
-	pci_free_resource_list(&bridge->windows);
-	pci_free_resource_list(&bridge->dma_ranges);
-
-	kfree(bridge);
+	put_device(&bridge->dev);
 }
 EXPORT_SYMBOL(pci_free_host_bridge);
 
@@ -866,7 +868,7 @@ static int pci_register_host_bridge(struct pci_host_bridge *bridge)
 	if (err)
 		goto free;
 
-	err = device_register(&bridge->dev);
+	err = device_add(&bridge->dev);
 	if (err) {
 		put_device(&bridge->dev);
 		goto free;
@@ -933,7 +935,7 @@ static int pci_register_host_bridge(struct pci_host_bridge *bridge)
 
 unregister:
 	put_device(&bridge->dev);
-	device_unregister(&bridge->dev);
+	device_del(&bridge->dev);
 
 free:
 	kfree(bus);
@@ -2945,7 +2947,7 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 	return bridge->bus;
 
 err_out:
-	kfree(bridge);
+	put_device(&bridge->dev);
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(pci_create_root_bus);
diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index e9c6b120cf45..95dec03d9f2a 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -160,6 +160,6 @@ void pci_remove_root_bus(struct pci_bus *bus)
 	host_bridge->bus = NULL;
 
 	/* remove the host bridge */
-	device_unregister(&host_bridge->dev);
+	device_del(&host_bridge->dev);
 }
 EXPORT_SYMBOL_GPL(pci_remove_root_bus);
-- 
2.25.1

