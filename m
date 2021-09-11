Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E79A6407768
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 15:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237273AbhIKNRJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 09:17:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:41214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236858AbhIKNPM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Sep 2021 09:15:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DAA461216;
        Sat, 11 Sep 2021 13:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631365986;
        bh=MznIBEeT4uqOL6YVdEqOi56t+PHKc+D+hfPTw/tzeNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GbKUGI4vZqWdhJ0WZxPNhMGoXRnCvbsLL4HK4W+aA3zrcf6FPhVChdlLdlTlihJ8A
         3LD6/SbI8+TrHvf8O0kMRs8yVPCPt9/BMbMGbY0u7aJuAGzsnQpPp69JT1ZhOzbHmU
         7FFifNiFzrTVroWxAjnlQqS6XApeoClYn4xPNNczs97KkAdk+LLj0w/wzRA0MwZUZn
         l6y/ylTgCoGzDzDL7eJGHVZBJe/N2BSAI9WjdqKFDUEw3v693TXOLl76Q0i9ejCdmc
         HE5YcHbSmL4eVXn/ocCr5KahIXIZ7K8TzfelbE3KF8itm6r7Q5qOwmIdQRb0/baNeg
         QDFUXTuwT39Zg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vishal Aslot <os.vaslot@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 25/29] PCI: ibmphp: Fix double unmap of io_mem
Date:   Sat, 11 Sep 2021 09:12:29 -0400
Message-Id: <20210911131233.284800-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210911131233.284800-1-sashal@kernel.org>
References: <20210911131233.284800-1-sashal@kernel.org>
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

