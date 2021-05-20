Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E10B38ABB2
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241243AbhETL0j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:26:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241675AbhETLZT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:25:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 068A561DA4;
        Thu, 20 May 2021 10:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505577;
        bh=GHNW1VEkKb55FmHjQlxYLF5p1T+n36T/oqo5B8UjFYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PrI3QY4U2OkijQxU2azc5s4jlLFWEyBhQr+YZUgjqf4RRAnOcY4Ot6mfXw/+jOS1k
         zUpXaZ0O9QTnctrqD8oVOLRybjS0c8b4UvU8GNK5M+TzBhGaqxCmp7hsWVF+EuyWIY
         FgbIZ9FUZXjsxvZ9FLMP8loPkBQCxdbJazq5RfEA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Feilong Lin <linfeilong@huawei.com>,
        Zhiqiang Liu <liuzhiqiang26@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 183/190] ACPI / hotplug / PCI: Fix reference count leak in enable_slot()
Date:   Thu, 20 May 2021 11:24:07 +0200
Message-Id: <20210520092108.222974065@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
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
index 6727471ea5b4..d0f5c526c8e6 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -538,6 +538,7 @@ static void enable_slot(struct acpiphp_slot *slot)
 			slot->flags &= (~SLOT_ENABLED);
 			continue;
 		}
+		pci_dev_put(dev);
 	}
 }
 
-- 
2.30.2



