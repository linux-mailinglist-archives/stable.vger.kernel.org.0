Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63C356C17CC
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232611AbjCTPR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232413AbjCTPQ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:16:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11AF734C02
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:11:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5008A61575
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:11:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BAEBC433EF;
        Mon, 20 Mar 2023 15:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325116;
        bh=WWndxHJZNTsrxIc+pwI5u+xjuselPuDq71AsgzwNHd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gUE/Ne7RfHQqqmqgBZvr9s5sEkW4Piwn8YjR6WVox4Db//eKwE0T5/N3AMy6Ka8Zv
         FJjgm8OexlYMg5G7mUqC1UGG8hE3X3ip+2SMpHLduMYjRaMgi7MLPQl6JpPONtc/zt
         8yxKEurjGseRRZNVQfXgu83rx6JMMupWejA+TjIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Niklas Schnelle <schnelle@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 043/198] PCI: s390: Fix use-after-free of PCI resources with per-function hotplug
Date:   Mon, 20 Mar 2023 15:53:01 +0100
Message-Id: <20230320145509.272008740@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Schnelle <schnelle@linux.ibm.com>

[ Upstream commit ab909509850b27fd39b8ba99e44cda39dbc3858c ]

On s390 PCI functions may be hotplugged individually even when they
belong to a multi-function device. In particular on an SR-IOV device VFs
may be removed and later re-added.

In commit a50297cf8235 ("s390/pci: separate zbus creation from
scanning") it was missed however that struct pci_bus and struct
zpci_bus's resource list retained a reference to the PCI functions MMIO
resources even though those resources are released and freed on
hot-unplug. These stale resources may subsequently be claimed when the
PCI function re-appears resulting in use-after-free.

One idea of fixing this use-after-free in s390 specific code that was
investigated was to simply keep resources around from the moment a PCI
function first appeared until the whole virtual PCI bus created for
a multi-function device disappears. The problem with this however is
that due to the requirement of artificial MMIO addreesses (address
cookies) extra logic is then needed to keep the address cookies
compatible on re-plug. At the same time the MMIO resources semantically
belong to the PCI function so tying their lifecycle to the function
seems more logical.

Instead a simpler approach is to remove the resources of an individually
hot-unplugged PCI function from the PCI bus's resource list while
keeping the resources of other PCI functions on the PCI bus untouched.

This is done by introducing pci_bus_remove_resource() to remove an
individual resource. Similarly the resource also needs to be removed
from the struct zpci_bus's resource list. It turns out however, that
there is really no need to add the MMIO resources to the struct
zpci_bus's resource list at all and instead we can simply use the
zpci_bar_struct's resource pointer directly.

Fixes: a50297cf8235 ("s390/pci: separate zbus creation from scanning")
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://lore.kernel.org/r/20230306151014.60913-2-schnelle@linux.ibm.com
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/pci/pci.c     | 16 ++++++++++------
 arch/s390/pci/pci_bus.c | 12 +++++-------
 arch/s390/pci/pci_bus.h |  3 +--
 drivers/pci/bus.c       | 21 +++++++++++++++++++++
 include/linux/pci.h     |  1 +
 5 files changed, 38 insertions(+), 15 deletions(-)

diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index 73cdc55393847..2c99f9552b2f5 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -544,8 +544,7 @@ static struct resource *__alloc_res(struct zpci_dev *zdev, unsigned long start,
 	return r;
 }
 
-int zpci_setup_bus_resources(struct zpci_dev *zdev,
-			     struct list_head *resources)
+int zpci_setup_bus_resources(struct zpci_dev *zdev)
 {
 	unsigned long addr, size, flags;
 	struct resource *res;
@@ -581,7 +580,6 @@ int zpci_setup_bus_resources(struct zpci_dev *zdev,
 			return -ENOMEM;
 		}
 		zdev->bars[i].res = res;
-		pci_add_resource(resources, res);
 	}
 	zdev->has_resources = 1;
 
@@ -590,17 +588,23 @@ int zpci_setup_bus_resources(struct zpci_dev *zdev,
 
 static void zpci_cleanup_bus_resources(struct zpci_dev *zdev)
 {
+	struct resource *res;
 	int i;
 
+	pci_lock_rescan_remove();
 	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
-		if (!zdev->bars[i].size || !zdev->bars[i].res)
+		res = zdev->bars[i].res;
+		if (!res)
 			continue;
 
+		release_resource(res);
+		pci_bus_remove_resource(zdev->zbus->bus, res);
 		zpci_free_iomap(zdev, zdev->bars[i].map_idx);
-		release_resource(zdev->bars[i].res);
-		kfree(zdev->bars[i].res);
+		zdev->bars[i].res = NULL;
+		kfree(res);
 	}
 	zdev->has_resources = 0;
+	pci_unlock_rescan_remove();
 }
 
 int pcibios_device_add(struct pci_dev *pdev)
diff --git a/arch/s390/pci/pci_bus.c b/arch/s390/pci/pci_bus.c
index 6a8da1b742ae5..a99926af2b69a 100644
--- a/arch/s390/pci/pci_bus.c
+++ b/arch/s390/pci/pci_bus.c
@@ -41,9 +41,7 @@ static int zpci_nb_devices;
  */
 static int zpci_bus_prepare_device(struct zpci_dev *zdev)
 {
-	struct resource_entry *window, *n;
-	struct resource *res;
-	int rc;
+	int rc, i;
 
 	if (!zdev_enabled(zdev)) {
 		rc = zpci_enable_device(zdev);
@@ -57,10 +55,10 @@ static int zpci_bus_prepare_device(struct zpci_dev *zdev)
 	}
 
 	if (!zdev->has_resources) {
-		zpci_setup_bus_resources(zdev, &zdev->zbus->resources);
-		resource_list_for_each_entry_safe(window, n, &zdev->zbus->resources) {
-			res = window->res;
-			pci_bus_add_resource(zdev->zbus->bus, res, 0);
+		zpci_setup_bus_resources(zdev);
+		for (i = 0; i < PCI_STD_NUM_BARS; i++) {
+			if (zdev->bars[i].res)
+				pci_bus_add_resource(zdev->zbus->bus, zdev->bars[i].res, 0);
 		}
 	}
 
diff --git a/arch/s390/pci/pci_bus.h b/arch/s390/pci/pci_bus.h
index e96c9860e0644..af9f0ac79a1b1 100644
--- a/arch/s390/pci/pci_bus.h
+++ b/arch/s390/pci/pci_bus.h
@@ -30,8 +30,7 @@ static inline void zpci_zdev_get(struct zpci_dev *zdev)
 
 int zpci_alloc_domain(int domain);
 void zpci_free_domain(int domain);
-int zpci_setup_bus_resources(struct zpci_dev *zdev,
-			     struct list_head *resources);
+int zpci_setup_bus_resources(struct zpci_dev *zdev);
 
 static inline struct zpci_dev *zdev_from_bus(struct pci_bus *bus,
 					     unsigned int devfn)
diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 3cef835b375fd..feafa378bf8ea 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -76,6 +76,27 @@ struct resource *pci_bus_resource_n(const struct pci_bus *bus, int n)
 }
 EXPORT_SYMBOL_GPL(pci_bus_resource_n);
 
+void pci_bus_remove_resource(struct pci_bus *bus, struct resource *res)
+{
+	struct pci_bus_resource *bus_res, *tmp;
+	int i;
+
+	for (i = 0; i < PCI_BRIDGE_RESOURCE_NUM; i++) {
+		if (bus->resource[i] == res) {
+			bus->resource[i] = NULL;
+			return;
+		}
+	}
+
+	list_for_each_entry_safe(bus_res, tmp, &bus->resources, list) {
+		if (bus_res->res == res) {
+			list_del(&bus_res->list);
+			kfree(bus_res);
+			return;
+		}
+	}
+}
+
 void pci_bus_remove_resources(struct pci_bus *bus)
 {
 	int i;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index cb538bc579710..d20695184e0b9 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1417,6 +1417,7 @@ void pci_bus_add_resource(struct pci_bus *bus, struct resource *res,
 			  unsigned int flags);
 struct resource *pci_bus_resource_n(const struct pci_bus *bus, int n);
 void pci_bus_remove_resources(struct pci_bus *bus);
+void pci_bus_remove_resource(struct pci_bus *bus, struct resource *res);
 int devm_request_pci_bus_resources(struct device *dev,
 				   struct list_head *resources);
 
-- 
2.39.2



