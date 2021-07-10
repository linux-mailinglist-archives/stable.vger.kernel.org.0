Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 855953C378A
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232412AbhGJXw0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:52:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:39250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232405AbhGJXwT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:52:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EED88610CA;
        Sat, 10 Jul 2021 23:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625960973;
        bh=yZ19D2EA1OUhyCLOW/hS71/J5T/SbBrNsg3xivWuV4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lYNnltzu1ZaITfdos5QI2ncu2JwZJYzyYB9u9eKVwinpnO1J70XTtRu+BqExL+KwH
         B1PWUtDgFK1EuWnH+mPMv7ztzjFbU0XZx4wbE9iiYdHtYyp1EhFtpkduSH3r3RaxBO
         3yW3Z5biDxMRy4u9yM0bEzD4Sm8TMSMo7SSotctoEwBNsyGsSfd3S7eWx9wlY61pwC
         u3Sr2QHGDBVR4krStPl3CeK4sKMcTgrsndSRzpqsGRA5lfMwvekIO0yrGj/vPnzzmf
         nV1tRTPrguIQLC4zAVn3XOYjYsca7n8iR9S0KR2xubY83SpYlJ0EuMrvD+v/gz15Ty
         yGktGkhIAg7IQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Logan Gunthorpe <logang@deltatee.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 11/43] PCI/P2PDMA: Avoid pci_get_slot(), which may sleep
Date:   Sat, 10 Jul 2021 19:48:43 -0400
Message-Id: <20210710234915.3220342-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710234915.3220342-1-sashal@kernel.org>
References: <20210710234915.3220342-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Logan Gunthorpe <logang@deltatee.com>

[ Upstream commit 3ec0c3ec2d92c09465534a1ff9c6f9d9506ffef6 ]

In order to use upstream_bridge_distance_warn() from a dma_map function, it
must not sleep. However, pci_get_slot() takes the pci_bus_sem so it might
sleep.

In order to avoid this, try to get the host bridge's device from the first
element in the device list. It should be impossible for the host bridge's
device to go away while references are held on child devices, so the first
element should not be able to change and, thus, this should be safe.

Introduce a static function called pci_host_bridge_dev() to obtain the host
bridge's root device.

Link: https://lore.kernel.org/r/20210610160609.28447-7-logang@deltatee.com
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/p2pdma.c | 34 ++++++++++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 196382630363..c49c13a5fedc 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -308,10 +308,41 @@ static const struct pci_p2pdma_whitelist_entry {
 	{}
 };
 
+/*
+ * This lookup function tries to find the PCI device corresponding to a given
+ * host bridge.
+ *
+ * It assumes the host bridge device is the first PCI device in the
+ * bus->devices list and that the devfn is 00.0. These assumptions should hold
+ * for all the devices in the whitelist above.
+ *
+ * This function is equivalent to pci_get_slot(host->bus, 0), however it does
+ * not take the pci_bus_sem lock seeing __host_bridge_whitelist() must not
+ * sleep.
+ *
+ * For this to be safe, the caller should hold a reference to a device on the
+ * bridge, which should ensure the host_bridge device will not be freed
+ * or removed from the head of the devices list.
+ */
+static struct pci_dev *pci_host_bridge_dev(struct pci_host_bridge *host)
+{
+	struct pci_dev *root;
+
+	root = list_first_entry_or_null(&host->bus->devices,
+					struct pci_dev, bus_list);
+
+	if (!root)
+		return NULL;
+	if (root->devfn != PCI_DEVFN(0, 0))
+		return NULL;
+
+	return root;
+}
+
 static bool __host_bridge_whitelist(struct pci_host_bridge *host,
 				    bool same_host_bridge)
 {
-	struct pci_dev *root = pci_get_slot(host->bus, PCI_DEVFN(0, 0));
+	struct pci_dev *root = pci_host_bridge_dev(host);
 	const struct pci_p2pdma_whitelist_entry *entry;
 	unsigned short vendor, device;
 
@@ -320,7 +351,6 @@ static bool __host_bridge_whitelist(struct pci_host_bridge *host,
 
 	vendor = root->vendor;
 	device = root->device;
-	pci_dev_put(root);
 
 	for (entry = pci_p2pdma_whitelist; entry->vendor; entry++) {
 		if (vendor != entry->vendor || device != entry->device)
-- 
2.30.2

