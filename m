Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A777328A24
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732210AbfEWTJe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:09:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:42718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732171AbfEWTJe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:09:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF7F02133D;
        Thu, 23 May 2019 19:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558638573;
        bh=EZ8rB1scQTVvavkl6Mk/03mlqjq7T99535i9sMMlRnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P3l7OyTneBMI3A566MOm6sJmfL6vq3bGSMxt4sKZD/tBVvW2WHduEBLPVUQ8hoRpc
         K8eEr6BStmCJEb/0j0+O58W4bfb/9XHSzPu3BGcRKXDf/xkttAj/Wh/yPX/eMNtx6r
         sCClCCWV4WimzHviGeCbiV/0v9LW+t6jmJ+DE3q0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 4.9 39/53] PCI: Factor out pcie_retrain_link() function
Date:   Thu, 23 May 2019 21:06:03 +0200
Message-Id: <20190523181717.073365252@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181710.981455400@linuxfoundation.org>
References: <20190523181710.981455400@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Mätje <stefan.maetje@esd.eu>

commit 86fa6a344209d9414ea962b1f1ac6ade9dd7563a upstream.

Factor out pcie_retrain_link() to use for Pericom Retrain Link quirk.  No
functional change intended.

Signed-off-by: Stefan Mätje <stefan.maetje@esd.eu>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/pcie/aspm.c |   40 ++++++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 16 deletions(-)

--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -172,6 +172,29 @@ static void pcie_clkpm_cap_init(struct p
 	link->clkpm_capable = (blacklist) ? 0 : capable;
 }
 
+static bool pcie_retrain_link(struct pcie_link_state *link)
+{
+	struct pci_dev *parent = link->pdev;
+	unsigned long start_jiffies;
+	u16 reg16;
+
+	pcie_capability_read_word(parent, PCI_EXP_LNKCTL, &reg16);
+	reg16 |= PCI_EXP_LNKCTL_RL;
+	pcie_capability_write_word(parent, PCI_EXP_LNKCTL, reg16);
+
+	/* Wait for link training end. Break out after waiting for timeout */
+	start_jiffies = jiffies;
+	for (;;) {
+		pcie_capability_read_word(parent, PCI_EXP_LNKSTA, &reg16);
+		if (!(reg16 & PCI_EXP_LNKSTA_LT))
+			break;
+		if (time_after(jiffies, start_jiffies + LINK_RETRAIN_TIMEOUT))
+			break;
+		msleep(1);
+	}
+	return !(reg16 & PCI_EXP_LNKSTA_LT);
+}
+
 /*
  * pcie_aspm_configure_common_clock: check if the 2 ends of a link
  *   could use common clock. If they are, configure them to use the
@@ -181,7 +204,6 @@ static void pcie_aspm_configure_common_c
 {
 	int same_clock = 1;
 	u16 reg16, parent_reg, child_reg[8];
-	unsigned long start_jiffies;
 	struct pci_dev *child, *parent = link->pdev;
 	struct pci_bus *linkbus = parent->subordinate;
 	/*
@@ -221,21 +243,7 @@ static void pcie_aspm_configure_common_c
 		reg16 &= ~PCI_EXP_LNKCTL_CCC;
 	pcie_capability_write_word(parent, PCI_EXP_LNKCTL, reg16);
 
-	/* Retrain link */
-	reg16 |= PCI_EXP_LNKCTL_RL;
-	pcie_capability_write_word(parent, PCI_EXP_LNKCTL, reg16);
-
-	/* Wait for link training end. Break out after waiting for timeout */
-	start_jiffies = jiffies;
-	for (;;) {
-		pcie_capability_read_word(parent, PCI_EXP_LNKSTA, &reg16);
-		if (!(reg16 & PCI_EXP_LNKSTA_LT))
-			break;
-		if (time_after(jiffies, start_jiffies + LINK_RETRAIN_TIMEOUT))
-			break;
-		msleep(1);
-	}
-	if (!(reg16 & PCI_EXP_LNKSTA_LT))
+	if (pcie_retrain_link(link))
 		return;
 
 	/* Training failed. Restore common clock configurations */


