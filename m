Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA9844D598
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbfFTR7M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 13:59:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:46386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726455AbfFTR7L (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 13:59:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A99E32083B;
        Thu, 20 Jun 2019 17:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561053550;
        bh=wNhGpldHqTgyHP8MSOSDAAejiyodthLvrS3+CG36lXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GPLJ3Hr45ww6Y0QpcamkJGeACPN18MOyT/hXefQTmyiIVVtEeaFDlZFO5J/vm78lQ
         C0aQFieiG0wsr34iA8Q8SY11GJ49Nu5CRMjB4ay7ZaYBipZZ3rehOmPhAXVyWltPlT
         RgYtMtZKb1p5+XXqVws73iqFxceYmy4Fc/zXLyyg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 27/84] PCI: rpadlpar: Fix leaked device_node references in add/remove paths
Date:   Thu, 20 Jun 2019 19:56:24 +0200
Message-Id: <20190620174341.830774010@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174337.538228162@linuxfoundation.org>
References: <20190620174337.538228162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index f2fcbe944d94..aae295708ea7 100644
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



