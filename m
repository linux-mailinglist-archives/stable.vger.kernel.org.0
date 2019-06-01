Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE5FF31D26
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728909AbfFAN1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:27:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:57722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729804AbfFAN1H (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:27:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54522273CD;
        Sat,  1 Jun 2019 13:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395627;
        bh=3K6/aUg3C52Mziko9m56XexLE8geFfS7O36EjOwfNKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kJ48E0JkWSo9dkFWAXyRWVGOD9IxwW2yPNiKYPtTo2Yn+IZ2i/2EdzWsnAm50YLXO
         P0eu/2GqTzRkYA7BWaqDoq2Wq8HCrIGcnUFTeMdZLc3C5LU7TjEWvigztOYgVEfF9G
         Z1zIgFmu0mAHT0aJc/RwKmXrXmmSCKtpnL+/9sj8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tyrel Datwyler <tyreld@linux.vnet.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.4 39/56] PCI: rpadlpar: Fix leaked device_node references in add/remove paths
Date:   Sat,  1 Jun 2019 09:25:43 -0400
Message-Id: <20190601132600.27427-39-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601132600.27427-1-sashal@kernel.org>
References: <20190601132600.27427-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>

[ Upstream commit fb26228bfc4ce3951544848555c0278e2832e618 ]

The find_dlpar_node() helper returns a device node with its reference
incremented.  Both the add and remove paths use this helper for find the
appropriate node, but fail to release the reference when done.

Annotate the find_dlpar_node() helper with a comment about the incremented
reference count and call of_node_put() on the obtained device_node in the
add and remove paths.  Also, fixup a reference leak in the find_vio_slot()
helper where we fail to call of_node_put() on the vdevice node after we
iterate over its children.

Signed-off-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/hotplug/rpadlpar_core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pci/hotplug/rpadlpar_core.c b/drivers/pci/hotplug/rpadlpar_core.c
index f2fcbe944d940..aae295708ea7a 100644
--- a/drivers/pci/hotplug/rpadlpar_core.c
+++ b/drivers/pci/hotplug/rpadlpar_core.c
@@ -55,6 +55,7 @@ static struct device_node *find_vio_slot_node(char *drc_name)
 		if ((rc == 0) && (!strcmp(drc_name, name)))
 			break;
 	}
+	of_node_put(parent);
 
 	return dn;
 }
@@ -78,6 +79,7 @@ static struct device_node *find_php_slot_pci_node(char *drc_name,
 	return np;
 }
 
+/* Returns a device_node with its reference count incremented */
 static struct device_node *find_dlpar_node(char *drc_name, int *node_type)
 {
 	struct device_node *dn;
@@ -314,6 +316,7 @@ int dlpar_add_slot(char *drc_name)
 			rc = dlpar_add_phb(drc_name, dn);
 			break;
 	}
+	of_node_put(dn);
 
 	printk(KERN_INFO "%s: slot %s added\n", DLPAR_MODULE_NAME, drc_name);
 exit:
@@ -447,6 +450,7 @@ int dlpar_remove_slot(char *drc_name)
 			rc = dlpar_remove_pci_slot(drc_name, dn);
 			break;
 	}
+	of_node_put(dn);
 	vm_unmap_aliases();
 
 	printk(KERN_INFO "%s: slot %s removed\n", DLPAR_MODULE_NAME, drc_name);
-- 
2.20.1

