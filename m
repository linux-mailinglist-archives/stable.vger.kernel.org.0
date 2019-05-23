Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C76012885A
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390467AbfEWTZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:25:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:36580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391055AbfEWTZL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:25:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 944902184E;
        Thu, 23 May 2019 19:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639511;
        bh=LtAw2JPeh35qAaYGeZsx8jGPw5if8EhsDrE/tt2wK5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2OHFkfg46zr+lRvvKVqoFeBj1X1VpynvEc0NVd9DiiP1P8DtiBkYyM8G5fhworlUU
         PUNh08FCajfnprafcj8FQmxQlhVRl3ZZgCzxu0vhAMwLxJhSLvJMdbwb0bvTfdWyaX
         Z7J1L3onzOJ+WZmGXW9mU+wofCSTmfQALaZuXc34=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 115/139] PCI: Fix issue with "pci=disable_acs_redir" parameter being ignored
Date:   Thu, 23 May 2019 21:06:43 +0200
Message-Id: <20190523181734.807123874@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181720.120897565@linuxfoundation.org>
References: <20190523181720.120897565@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index e91005d0f20c7..3f77bab698ced 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -6266,8 +6266,7 @@ static int __init pci_setup(char *str)
 			} else if (!strncmp(str, "pcie_scan_all", 13)) {
 				pci_add_flags(PCI_SCAN_ALL_PCIE_DEVS);
 			} else if (!strncmp(str, "disable_acs_redir=", 18)) {
-				disable_acs_redir_param =
-					kstrdup(str + 18, GFP_KERNEL);
+				disable_acs_redir_param = str + 18;
 			} else {
 				printk(KERN_ERR "PCI: Unknown option `%s'\n",
 						str);
@@ -6278,3 +6277,19 @@ static int __init pci_setup(char *str)
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



