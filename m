Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE4EE4D873
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbfFTSFo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:05:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:59364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726200AbfFTSFo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:05:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D878F2089C;
        Thu, 20 Jun 2019 18:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561053943;
        bh=GEx5pq0zga8EQ/2xGAHSBQA9HsHPaefSc6zn/tC0Bn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GYtOxwEqDB7gp/rWgjkPQr2uFt1uuWxHk2amXQXDvdLYs4IpAGHj8Yj1QxJ+3D+yU
         v96P67zjWc8gJSwMlcHnhVd4t0BfBVWon2Y/tT8BI9DyUTU70FO/WOLje6ZrFQ++3Y
         lnJ3BkAEqHrGQtPHb39UCTAOyNjeNIpjqykabdLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 042/117] PCI: rpadlpar: Fix leaked device_node references in add/remove paths
Date:   Thu, 20 Jun 2019 19:56:16 +0200
Message-Id: <20190620174354.508606171@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174351.964339809@linuxfoundation.org>
References: <20190620174351.964339809@linuxfoundation.org>
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
index c614ff7c3bc3..d3562df64456 100644
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
@@ -313,6 +315,7 @@ int dlpar_add_slot(char *drc_name)
 			rc = dlpar_add_phb(drc_name, dn);
 			break;
 	}
+	of_node_put(dn);
 
 	printk(KERN_INFO "%s: slot %s added\n", DLPAR_MODULE_NAME, drc_name);
 exit:
@@ -446,6 +449,7 @@ int dlpar_remove_slot(char *drc_name)
 			rc = dlpar_remove_pci_slot(drc_name, dn);
 			break;
 	}
+	of_node_put(dn);
 	vm_unmap_aliases();
 
 	printk(KERN_INFO "%s: slot %s removed\n", DLPAR_MODULE_NAME, drc_name);
-- 
2.20.1



