Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1F94125F2
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385550AbhITSuh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:50:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:59828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1383896AbhITSqP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:46:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8DB86335D;
        Mon, 20 Sep 2021 17:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159181;
        bh=Jw4U4ftzzDsPSsfXsuww/SwEe7hHyW068K7bPWkIikw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ktGiPhbDdXa4t9j40kcGMXdzsZjH2hPunF38Yin9HAp3xllbLohG7Nh5LFTPdd4N8
         1PPWnh3nSY4YRYXqRPv9iriJKpdwgNQumfQ+i+oUl6FB4RZAoHaHe0sR/8P7B+kzDC
         jEkSotohQpfwqL2ItW/yF6iT6SsWpX8b67G3L3i0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vishal Aslot <os.vaslot@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 114/168] PCI: ibmphp: Fix double unmap of io_mem
Date:   Mon, 20 Sep 2021 18:44:12 +0200
Message-Id: <20210920163925.385330820@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -910,8 +909,6 @@ error:
 	kfree(tmp_slot);
 error_no_slot:
 	free_ebda_hpc(hpc_ptr);
-error_no_hpc:
-	iounmap(io_mem);
 	return rc;
 }
 
-- 
2.30.2



