Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1630437D292
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350840AbhELSKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:10:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:52446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352886AbhELSEZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:04:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CF5161412;
        Wed, 12 May 2021 18:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842596;
        bh=lQVEHXpOkP+0xKhQL1ij6j/rrt8ZABA81dSlc2Bmugo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SZKmukidSLUaAq2pgDFWyegg3FHCLtLKRxix+xMnsP26qLAa1KIyxx6D9zSZf/HXD
         6pnCBu/dO9Xte0NokpVZYxnJjbHk0C9RgALhiKBH7b6k0xCr14qHgRlGNuUSldQfh4
         rax7OZzlBj7NDtbphPFj3iHYqQNTDedoCWoERGm3NuLwHWcrxVhwTWLnEVg+z45dLP
         GkN3tzK8wkEK2wKdtqEl1f8ygehDBFLFTqYYZqz9Jz4r0o2cRK4t/2mRaDwS/hPmoi
         b4uZV2/cc/+jgir9+ewYb7gr6T6YJwcusdY+eEhpuy5Itmrs+rXhhi077gl8/QOrNA
         OvLyrmKUu0xWg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Feilong Lin <linfeilong@huawei.com>,
        Zhiqiang Liu <liuzhiqiang26@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 06/34] ACPI / hotplug / PCI: Fix reference count leak in enable_slot()
Date:   Wed, 12 May 2021 14:02:37 -0400
Message-Id: <20210512180306.664925-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180306.664925-1-sashal@kernel.org>
References: <20210512180306.664925-1-sashal@kernel.org>
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
index 3365c93abf0e..f031302ad401 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -533,6 +533,7 @@ static void enable_slot(struct acpiphp_slot *slot, bool bridge)
 			slot->flags &= ~SLOT_ENABLED;
 			continue;
 		}
+		pci_dev_put(dev);
 	}
 }
 
-- 
2.30.2

