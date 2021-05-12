Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1F437D2C9
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237993AbhELSNd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:13:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:53126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353020AbhELSGl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:06:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E62CA6143C;
        Wed, 12 May 2021 18:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842660;
        bh=3WOgU9R3HTQh4L1lax9mFnSBwko27WKEGwCXCUecxJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aq9//EBI8+T53z9PR4cAJL/YSFPJQDzuM90CMFVVT3kt72zD9Rsepxqkhj030mhSu
         A5RVOZSBiynA+5sqhCeRY9QdTG+vcKSq4AUkw3xmgb9OdJwINAsX/TEIW0eNTJKPxh
         zoohfo+mmKxLyqMjdRSuxs0lUfhbYig7BYowKil2jyVBJKBXu7tZ4cg1+8vkHfI0ev
         ItPIOdrJV4Ic5delxwi86sC9fzySUGSVDv8FQGuDaQj2y5IxI03l18ApzqEetI0DXs
         CLKhDX+NvqctW2XYPBLD8sfH1jTfj/ALBCl0dZ16yvT8oEpBeuF56JATDQJEoT8vAq
         HpHcgWvP7L2uQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Feilong Lin <linfeilong@huawei.com>,
        Zhiqiang Liu <liuzhiqiang26@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 06/23] ACPI / hotplug / PCI: Fix reference count leak in enable_slot()
Date:   Wed, 12 May 2021 14:03:50 -0400
Message-Id: <20210512180408.665338-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180408.665338-1-sashal@kernel.org>
References: <20210512180408.665338-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Feilong Lin <linfeilong@huawei.com>

[ Upstream commit 3bbfd319034ddce59e023837a4aa11439460509b ]

In enable_slot(), if pci_get_slot() returns NULL, we clear the SLOT_ENABLED
flag. When pci_get_slot() finds a device, it increments the device's
reference count.  In this case, we did not call pci_dev_put() to decrement
the reference count, so the memory of the device (struct pci_dev type) will
eventually leak.

Call pci_dev_put() to decrement its reference count when pci_get_slot()
returns a PCI device.

Link: https://lore.kernel.org/r/b411af88-5049-a1c6-83ac-d104a1f429be@huawei.com
Signed-off-by: Feilong Lin <linfeilong@huawei.com>
Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/hotplug/acpiphp_glue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 6e60b4b1bf53..98be06ac2af2 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -540,6 +540,7 @@ static void enable_slot(struct acpiphp_slot *slot, bool bridge)
 			slot->flags &= ~SLOT_ENABLED;
 			continue;
 		}
+		pci_dev_put(dev);
 	}
 }
 
-- 
2.30.2

