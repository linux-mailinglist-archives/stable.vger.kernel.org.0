Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01473CA307
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732197AbfJCQLa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:11:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:33208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387848AbfJCQL2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:11:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3764207FF;
        Thu,  3 Oct 2019 16:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119088;
        bh=QJorBsuu7/I+O7IoyuxkA/c3Do8nJw9lZYvwg/ZsupQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VvIsFKyEFodebJwxReNE8d2HtfoOd5vB0uRBUZEpHSLM9mNc+iPyrJSj1CBVN0y6o
         D+JSS2AtXhNWo96SC7Ra2/n3t452Y/c6DO0JKyceEr/cEHsDrQHeBQLNSmiSEpjsWD
         8bMIgSisUej71uJJmKl1f6Eua5J/G2eJGFGBL/ZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenwen Wang <wenwen@cs.uga.edu>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 120/185] ACPI / PCI: fix acpi_pci_irq_enable() memory leak
Date:   Thu,  3 Oct 2019 17:53:18 +0200
Message-Id: <20191003154505.159043587@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154437.541662648@linuxfoundation.org>
References: <20191003154437.541662648@linuxfoundation.org>
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
index c576a6fe4ebb3..94ded9513c73b 100644
--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -462,8 +462,10 @@ int acpi_pci_irq_enable(struct pci_dev *dev)
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



