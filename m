Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40A4B2050F
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 13:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbfEPLko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 07:40:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:49120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727853AbfEPLkn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 May 2019 07:40:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A87AD20833;
        Thu, 16 May 2019 11:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558006843;
        bh=r7nnwI+HvDXg+ImLSt4ZAXpJMRrhBsAaw98ka5+lgnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WgtrNL7LwicreP2tQTMZaeGnKVifE5IxkmWA6gq0EPt3Pmj7oA3ALC7R2NHAXJvHh
         Ohei5/CC7/CF7Ad7iMf3rZ7upVy4bDU1Jk6PgdxW+Can/UVlefQ26yHb8z7LD4Owhc
         PvJL2pupaChMtUE4nfQrrjgHqSPK9XofSgCMrBmo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Logan Gunthorpe <logang@deltatee.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 12/25] PCI: Fix issue with "pci=disable_acs_redir" parameter being ignored
Date:   Thu, 16 May 2019 07:40:15 -0400
Message-Id: <20190516114029.8682-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190516114029.8682-1-sashal@kernel.org>
References: <20190516114029.8682-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Logan Gunthorpe <logang@deltatee.com>

[ Upstream commit d5bc73f34cc97c4b4b9202cc93182c2515076edf ]

In most cases, kmalloc() will not be available early in boot when
pci_setup() is called.  Thus, the kstrdup() call that was added to fix the
__initdata bug with the disable_acs_redir parameter usually returns NULL,
so the parameter is discarded and has no effect.

To fix this, store the string that's in initdata until an initcall function
can allocate the memory appropriately.  This way we don't need any
additional static memory.

Fixes: d2fd6e81912a ("PCI: Fix __initdata issue with "pci=disable_acs_redir" parameter")
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 30649addc6252..61f2ef28ea1c7 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -6135,8 +6135,7 @@ static int __init pci_setup(char *str)
 			} else if (!strncmp(str, "pcie_scan_all", 13)) {
 				pci_add_flags(PCI_SCAN_ALL_PCIE_DEVS);
 			} else if (!strncmp(str, "disable_acs_redir=", 18)) {
-				disable_acs_redir_param =
-					kstrdup(str + 18, GFP_KERNEL);
+				disable_acs_redir_param = str + 18;
 			} else {
 				printk(KERN_ERR "PCI: Unknown option `%s'\n",
 						str);
@@ -6147,3 +6146,19 @@ static int __init pci_setup(char *str)
 	return 0;
 }
 early_param("pci", pci_setup);
+
+/*
+ * 'disable_acs_redir_param' is initialized in pci_setup(), above, to point
+ * to data in the __initdata section which will be freed after the init
+ * sequence is complete. We can't allocate memory in pci_setup() because some
+ * architectures do not have any memory allocation service available during
+ * an early_param() call. So we allocate memory and copy the variable here
+ * before the init section is freed.
+ */
+static int __init pci_realloc_setup_params(void)
+{
+	disable_acs_redir_param = kstrdup(disable_acs_redir_param, GFP_KERNEL);
+
+	return 0;
+}
+pure_initcall(pci_realloc_setup_params);
-- 
2.20.1

