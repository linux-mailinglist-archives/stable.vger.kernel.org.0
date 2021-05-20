Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8487938A0C8
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbhETJ0B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:26:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:52098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231559AbhETJ0B (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:26:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DADBB6121E;
        Thu, 20 May 2021 09:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621502680;
        bh=lQVEHXpOkP+0xKhQL1ij6j/rrt8ZABA81dSlc2Bmugo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AMyImmjL5z9kBz99qBv2BbGbKrHLaHjWOKyWrwGRs5iAkc/SGAqhpKkDR6AyHhbBl
         S7mtvsPM3BCwvZ+7l/ji7EE6xWRatJdGGAU2Av1crhIiigp40+aWNpx4BeZMxGUTEe
         bdpw1SM1bXjPnhOxCaYpbvGTqCbNpX4GIusZs11k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Feilong Lin <linfeilong@huawei.com>,
        Zhiqiang Liu <liuzhiqiang26@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 11/45] ACPI / hotplug / PCI: Fix reference count leak in enable_slot()
Date:   Thu, 20 May 2021 11:21:59 +0200
Message-Id: <20210520092053.892302971@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092053.516042993@linuxfoundation.org>
References: <20210520092053.516042993@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



