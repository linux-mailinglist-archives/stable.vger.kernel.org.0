Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1B5037D268
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244181AbhELSJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:09:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:51338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352498AbhELSDY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:03:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19D1861438;
        Wed, 12 May 2021 18:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842536;
        bh=lQVEHXpOkP+0xKhQL1ij6j/rrt8ZABA81dSlc2Bmugo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uzuyvJoDiFdyVWUxqzCYgT5OP/oXfabb9Z7xCJlFgF63RXepFVnUpCSaYOb/AIyhV
         lDgpbwJlU2fY0tRllP0lv0YSkX5VREPbukS6BFJPjqb1NlvxEmcyekJJUJKF9g/0Hj
         +ggslJOzSvw9ZLDbDeYBeDgV2ocrJUlzBRGeL7YvOHS6qvQFneNAoyjgLEmB/kim3Z
         BUT9kdEs3dV0lbloMiBPFkzn+A2yfg5nsfJBNBsBixZ6kjtbtRqYkmdtcf8U6k9gRU
         d6TBujD1cuzYOgrZ/Z3eUcr2aDxBfWGmljFXLjqxFfk9QaO3sDg3JYOOfdW6oYqQ3b
         wBq+3q38IF5Fw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Feilong Lin <linfeilong@huawei.com>,
        Zhiqiang Liu <liuzhiqiang26@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 06/35] ACPI / hotplug / PCI: Fix reference count leak in enable_slot()
Date:   Wed, 12 May 2021 14:01:36 -0400
Message-Id: <20210512180206.664536-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180206.664536-1-sashal@kernel.org>
References: <20210512180206.664536-1-sashal@kernel.org>
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

