Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 475EACAAAC
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392288AbfJCRLZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 13:11:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:38708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403843AbfJCQbi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:31:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 715302133F;
        Thu,  3 Oct 2019 16:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120298;
        bh=1qcIqWVNgDnORZDuw7aMihN8tv/7ZLu/i1Km/FS0zBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y/C3uoQZXJ4kku/Wz5zjSwvS81fkRBFjggOnCnP5Ur9evriVx4hhiugL2OYQfucXg
         xR7dPW2Mq+EaRfi/hAQLA7H8pZg7PXZfHbJ/KBuXN8cb7+0Pa5CP1new2nhkE89XJB
         tSO+1T5zNJDbYNMHgKwERjTf6gqtp17VYiA4qpuk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenwen Wang <wenwen@cs.uga.edu>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 171/313] ACPI / PCI: fix acpi_pci_irq_enable() memory leak
Date:   Thu,  3 Oct 2019 17:52:29 +0200
Message-Id: <20191003154549.846979728@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenwen Wang <wenwen@cs.uga.edu>

[ Upstream commit 29b49958cf73b439b17fa29e9a25210809a6c01c ]

In acpi_pci_irq_enable(), 'entry' is allocated by kzalloc() in
acpi_pci_irq_check_entry() (invoked from acpi_pci_irq_lookup()). However,
it is not deallocated if acpi_pci_irq_valid() returns false, leading to a
memory leak. To fix this issue, free 'entry' before returning 0.

Fixes: e237a5518425 ("x86/ACPI/PCI: Recognize that Interrupt Line 255 means "not connected"")
Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/pci_irq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
index d2549ae65e1b6..dea8a60e18a4c 100644
--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -449,8 +449,10 @@ int acpi_pci_irq_enable(struct pci_dev *dev)
 		 * No IRQ known to the ACPI subsystem - maybe the BIOS /
 		 * driver reported one, then use it. Exit in any case.
 		 */
-		if (!acpi_pci_irq_valid(dev, pin))
+		if (!acpi_pci_irq_valid(dev, pin)) {
+			kfree(entry);
 			return 0;
+		}
 
 		if (acpi_isa_register_gsi(dev))
 			dev_warn(&dev->dev, "PCI INT %c: no GSI\n",
-- 
2.20.1



