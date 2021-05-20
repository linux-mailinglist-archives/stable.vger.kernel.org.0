Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E037738A7FD
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237636AbhETKpS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:45:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:43868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237227AbhETKmn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:42:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61BF861C93;
        Thu, 20 May 2021 09:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504582;
        bh=84ey2UjrGv61T0itePr91cHQ3aTRkpF+WMV1VJ404U4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uiwv9SctZh2jHZj9uqjIE8VVObmOf4+R8+1h4wpmrrREAmRD7dGc2mQOtVd3sQ8mp
         niSSN4C9ZNvw8lmRiEncFrkSZz1oRkiH+qD3JhsBWCGOKVhC4YRj1b8suMl69r4uDj
         4AW2IRKkiUW+gN2D1+22lL388fGNX5SYDqADLEK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Feilong Lin <linfeilong@huawei.com>,
        Zhiqiang Liu <liuzhiqiang26@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 310/323] ACPI / hotplug / PCI: Fix reference count leak in enable_slot()
Date:   Thu, 20 May 2021 11:23:22 +0200
Message-Id: <20210520092130.857967546@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
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
index f2c1008e0f76..40e936e3a480 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -509,6 +509,7 @@ static void enable_slot(struct acpiphp_slot *slot)
 			slot->flags &= (~SLOT_ENABLED);
 			continue;
 		}
+		pci_dev_put(dev);
 	}
 }
 
-- 
2.30.2



