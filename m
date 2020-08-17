Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2CC2470CA
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390650AbgHQSO7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:14:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:54250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731053AbgHQQGX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:06:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B80720658;
        Mon, 17 Aug 2020 16:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680374;
        bh=MjrENXJKdwxN5BZbjYPF3FJVWJtHmP5do7pjlhfS0Vo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D03OkFWvSK0vRIElLx7EaM39sq+2GAnBpa7dJu2opOMDT9lC7o/WmE1PpRz/l4J5V
         bJ8ObBTlXNgxXmSIBA4kX2u7kIUTTGaXw/8J8mVpDCSO/DFb8vsE6uaCWGdT85FoM9
         TMsYT6yXE722TN49+/mqx0OQFCszY7mlOrK8m9G4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Xiang Zheng <zhengxiang9@huawei.com>,
        Heyi Guo <guoheyi@huawei.com>,
        Biaoxiang Ye <yebiaoxiang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 131/270] PCI: Fix pci_cfg_wait queue locking problem
Date:   Mon, 17 Aug 2020 17:15:32 +0200
Message-Id: <20200817143802.306082833@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit 2a7e32d0547f41c5ce244f84cf5d6ca7fccee7eb ]

The pci_cfg_wait queue is used to prevent user-space config accesses to
devices while they are recovering from reset.

Previously we used these operations on pci_cfg_wait:

  __add_wait_queue(&pci_cfg_wait, ...)
  __remove_wait_queue(&pci_cfg_wait, ...)
  wake_up_all(&pci_cfg_wait)

The wake_up acquires the wait queue lock, but the add and remove do not.

Originally these were all protected by the pci_lock, but cdcb33f98244
("PCI: Avoid possible deadlock on pci_lock and p->pi_lock"), moved
wake_up_all() outside pci_lock, so it could race with add/remove
operations, which caused occasional kernel panics, e.g., during vfio-pci
hotplug/unplug testing:

  Unable to handle kernel read from unreadable memory at virtual address ffff802dac469000

Resolve this by using wait_event() instead of __add_wait_queue() and
__remove_wait_queue().  The wait queue lock is held by both wait_event()
and wake_up_all(), so it provides mutual exclusion.

Fixes: cdcb33f98244 ("PCI: Avoid possible deadlock on pci_lock and p->pi_lock")
Link: https://lore.kernel.org/linux-pci/79827f2f-9b43-4411-1376-b9063b67aee3@huawei.com/T/#u
Based-on: https://lore.kernel.org/linux-pci/20191210031527.40136-1-zhengxiang9@huawei.com/
Based-on-patch-by: Xiang Zheng <zhengxiang9@huawei.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Xiang Zheng <zhengxiang9@huawei.com>
Cc: Heyi Guo <guoheyi@huawei.com>
Cc: Biaoxiang Ye <yebiaoxiang@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/access.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/access.c b/drivers/pci/access.c
index 2fccb5762c762..0914ddeae17f4 100644
--- a/drivers/pci/access.c
+++ b/drivers/pci/access.c
@@ -204,17 +204,13 @@ EXPORT_SYMBOL(pci_bus_set_ops);
 static DECLARE_WAIT_QUEUE_HEAD(pci_cfg_wait);
 
 static noinline void pci_wait_cfg(struct pci_dev *dev)
+	__must_hold(&pci_lock)
 {
-	DECLARE_WAITQUEUE(wait, current);
-
-	__add_wait_queue(&pci_cfg_wait, &wait);
 	do {
-		set_current_state(TASK_UNINTERRUPTIBLE);
 		raw_spin_unlock_irq(&pci_lock);
-		schedule();
+		wait_event(pci_cfg_wait, !dev->block_cfg_access);
 		raw_spin_lock_irq(&pci_lock);
 	} while (dev->block_cfg_access);
-	__remove_wait_queue(&pci_cfg_wait, &wait);
 }
 
 /* Returns 0 on success, negative values indicate error. */
-- 
2.25.1



