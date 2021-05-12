Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4888637D2E3
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242091AbhELSO7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:14:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:53126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241620AbhELSIz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:08:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92D676162A;
        Wed, 12 May 2021 18:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842699;
        bh=4mcbU77nyHedrXOEqFa7BLF94C6/zWkzvSLUnk0h/MM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VOQOZgyxaWRbX4nltGYOs7yJCms90H2YCKMfEiKSFvFtaq8MCvIwQEmt8OtbFx0Vk
         b4R0KEExQmQp30es3c8qJDVGMrA0ZHTQcGCrv7EBTUiF3+5dQy0rEw2iVBUMlLPDru
         YS92pdUO0YdCkCoWxYq6GVke4qhlq0MjfMhmNXgCs8LQ/bLo8onKc3vxuz8qMpReJU
         rq0babfCkOVPm0f9JGtqbrRaHAuZ0ZiyqYbVS/7gVMb6hRRMZzXwJr3iKEaUIbGCfI
         84nz/qn/bH1RFum1Yk7NGBGhULkKfRn1u0jPGs4aI0HcvhMbOIlu+2fDiiNeEFsaDo
         9w+fhhBN5ntpQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Feilong Lin <linfeilong@huawei.com>,
        Zhiqiang Liu <liuzhiqiang26@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 05/18] ACPI / hotplug / PCI: Fix reference count leak in enable_slot()
Date:   Wed, 12 May 2021 14:04:36 -0400
Message-Id: <20210512180450.665586-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180450.665586-1-sashal@kernel.org>
References: <20210512180450.665586-1-sashal@kernel.org>
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
index be35bbfa6968..3d8844e7090a 100644
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

