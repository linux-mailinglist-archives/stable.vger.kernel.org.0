Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E328F405331
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353763AbhIIMtL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:49:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:57488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355157AbhIIMlo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:41:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DD8E61BE6;
        Thu,  9 Sep 2021 11:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188513;
        bh=yPJYZgqJxNxEVRDvxlqf7dqm7sFFZsS9Mu/g6PLHJSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qOYzyMGMkz+9q97NLjtZopDve2UVYUnX8dKmiPviXByINmGD1TkSIAxiOK6IGeMjK
         OpgMs+0Q94Op49YmaZIR6QkmVEJSW9OIdMsMw9d2rcR1G0/QqmqW6/XOYEos63aZ01
         WaSZjcjGvto22eF5MV6C1yKRoQxXhbWifF4BdGDgLYHi2h1/KHVw+GGwagJkclSB2p
         RfrwKCNeVYmhme24UZxTl7Ie51SKZwnHxiWZzUKA5JSkhw7KyDLteSUuAtlZY2ib+P
         qYglCds/lZXbxNKBjfgpiY2CKh3XAipunKAF5ITpctuz0HUll5iODi/zBFd9FxwyQg
         cvImXTZOv4vUQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 005/109] PCI: Use pci_update_current_state() in pci_enable_device_flags()
Date:   Thu,  9 Sep 2021 07:53:22 -0400
Message-Id: <20210909115507.147917-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115507.147917-1-sashal@kernel.org>
References: <20210909115507.147917-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 14858dcc3b3587f4bb5c48e130ee7d68fc2b0a29 ]

Updating the current_state field of struct pci_dev the way it is done
in pci_enable_device_flags() before calling do_pci_enable_device() may
not work.  For example, if the given PCI device depends on an ACPI
power resource whose _STA method initially returns 0 ("off"), but the
config space of the PCI device is accessible and the power state
retrieved from the PCI_PM_CTRL register is D0, the current_state
field in the struct pci_dev representing that device will get out of
sync with the power.state of its ACPI companion object and that will
lead to power management issues going forward.

To avoid such issues, make pci_enable_device_flags() call
pci_update_current_state() which takes ACPI device power management
into account, if present, to retrieve the current power state of the
device.

Link: https://lore.kernel.org/lkml/20210314000439.3138941-1-luzmaximilian@gmail.com/
Reported-by: Maximilian Luz <luzmaximilian@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Maximilian Luz <luzmaximilian@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 3c3bc9f58498..65db3aa0670a 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1672,11 +1672,7 @@ static int pci_enable_device_flags(struct pci_dev *dev, unsigned long flags)
 	 * so that things like MSI message writing will behave as expected
 	 * (e.g. if the device really is in D0 at enable time).
 	 */
-	if (dev->pm_cap) {
-		u16 pmcsr;
-		pci_read_config_word(dev, dev->pm_cap + PCI_PM_CTRL, &pmcsr);
-		dev->current_state = (pmcsr & PCI_PM_CTRL_STATE_MASK);
-	}
+	pci_update_current_state(dev, dev->current_state);
 
 	if (atomic_inc_return(&dev->enable_cnt) > 1)
 		return 0;		/* already enabled */
-- 
2.30.2

