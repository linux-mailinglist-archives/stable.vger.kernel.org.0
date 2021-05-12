Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2920837D2ED
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350459AbhELSPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:15:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:55186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349973AbhELSKR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:10:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 684F96193E;
        Wed, 12 May 2021 18:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842729;
        bh=84ey2UjrGv61T0itePr91cHQ3aTRkpF+WMV1VJ404U4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hxvFUaoQyUjjghhZt4BRIvt5bawWTXHW0OxRmlBssxJsYMIc4v2TXp+Hb4zndBWnO
         urj/NDAniJdGfpyll4sy+2tYIyqgeL4bFx75Xv2/chrEvceDi8wYbBjiQUryJLLEob
         DB6pJnTsGIQbmmlhi0mHqvTUEPrDfNIcfdvawesY3WMC6LUs4R6R13ujFpYcNa2K5K
         sgcSQ2Ipnx0eEku9aduRq7dXc9Usg4rw9aLXiRo8O4h2/s3OHb6uHnacviuMmq348G
         cWsmgx+No+e2uvkalEjru/grJg6tx1RpRgcC7bho63i00DDx+if3QcjL+SIdmc6H4a
         9J7TfAjraas2A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Feilong Lin <linfeilong@huawei.com>,
        Zhiqiang Liu <liuzhiqiang26@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 04/12] ACPI / hotplug / PCI: Fix reference count leak in enable_slot()
Date:   Wed, 12 May 2021 14:05:14 -0400
Message-Id: <20210512180522.665788-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180522.665788-1-sashal@kernel.org>
References: <20210512180522.665788-1-sashal@kernel.org>
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

