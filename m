Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 286F840770C
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 15:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236408AbhIKNOj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 09:14:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236266AbhIKNNg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Sep 2021 09:13:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3EDB6108B;
        Sat, 11 Sep 2021 13:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631365944;
        bh=MznIBEeT4uqOL6YVdEqOi56t+PHKc+D+hfPTw/tzeNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NEGGEkg9qGP6emT6Ge73TDTO93/R9Eh6QDvtLCtYdpuaFrubSBmh3Ctrap4o+8i2h
         Gt5js7y3RNCZi/Ap9alOEcMSJm9r2aAaLAWL8vAx0V3QGLOkRFbFUhl/L282MSCjkV
         xvH3g1MU5Dose88wkSSqZYoQ3hvFyAEv7WJuta5txk9ME7c03I8rrqn9X33/AV2TQ2
         VSH8c7Erz79kCNh5dLzfn92tM1kBueQbCqxRl299XOGt7eBZG+TD29v+hXv7OiBZo/
         v2xj3AuVgCaeVM6WDCnMTm/BsxHJZQcdt8oELjUbJBlWU1FKaHidk48cmEa95lR59D
         ESXvjMbDKCmeA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vishal Aslot <os.vaslot@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 26/32] PCI: ibmphp: Fix double unmap of io_mem
Date:   Sat, 11 Sep 2021 09:11:43 -0400
Message-Id: <20210911131149.284397-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210911131149.284397-1-sashal@kernel.org>
References: <20210911131149.284397-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vishal Aslot <os.vaslot@gmail.com>

[ Upstream commit faa2e05ad0dccf37f995bcfbb8d1980d66c02c11 ]

ebda_rsrc_controller() calls iounmap(io_mem) on the error path. Its caller,
ibmphp_access_ebda(), also calls iounmap(io_mem) on good and error paths.

Remove the iounmap(io_mem) invocation from ebda_rsrc_controller().

[bhelgaas: remove item from TODO]
Link: https://lore.kernel.org/r/20210818165751.591185-1-os.vaslot@gmail.com
Signed-off-by: Vishal Aslot <os.vaslot@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/hotplug/TODO          | 3 ---
 drivers/pci/hotplug/ibmphp_ebda.c | 5 +----
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/pci/hotplug/TODO b/drivers/pci/hotplug/TODO
index a32070be5adf..cc6194aa24c1 100644
--- a/drivers/pci/hotplug/TODO
+++ b/drivers/pci/hotplug/TODO
@@ -40,9 +40,6 @@ ibmphp:
 
 * The return value of pci_hp_register() is not checked.
 
-* iounmap(io_mem) is called in the error path of ebda_rsrc_controller()
-  and once more in the error path of its caller ibmphp_access_ebda().
-
 * The various slot data structures are difficult to follow and need to be
   simplified.  A lot of functions are too large and too complex, they need
   to be broken up into smaller, manageable pieces.  Negative examples are
diff --git a/drivers/pci/hotplug/ibmphp_ebda.c b/drivers/pci/hotplug/ibmphp_ebda.c
index 11a2661dc062..7fb75401ad8a 100644
--- a/drivers/pci/hotplug/ibmphp_ebda.c
+++ b/drivers/pci/hotplug/ibmphp_ebda.c
@@ -714,8 +714,7 @@ static int __init ebda_rsrc_controller(void)
 		/* init hpc structure */
 		hpc_ptr = alloc_ebda_hpc(slot_num, bus_num);
 		if (!hpc_ptr) {
-			rc = -ENOMEM;
-			goto error_no_hpc;
+			return -ENOMEM;
 		}
 		hpc_ptr->ctlr_id = ctlr_id;
 		hpc_ptr->ctlr_relative_id = ctlr;
@@ -910,8 +909,6 @@ static int __init ebda_rsrc_controller(void)
 	kfree(tmp_slot);
 error_no_slot:
 	free_ebda_hpc(hpc_ptr);
-error_no_hpc:
-	iounmap(io_mem);
 	return rc;
 }
 
-- 
2.30.2

