Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA80C1AC274
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895778AbgDPN2b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:28:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:37420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2895759AbgDPN21 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:28:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1D0021D82;
        Thu, 16 Apr 2020 13:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587043705;
        bh=8g4rtJKK7f7hAR4yH8/t0x0WZTPgRBWJXq9lOexgqK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v6fNHGj3tKnKdZWYdG0ypjoilqkysCBi6i3oyDKDk/A/rOm09HLjQpFFlhf1qu5BU
         r/P4aiKLefKEk6uHbW7ejNDzch8q8JTuqR+z82YleqqnVG8JunQkkqd5PFNd/jI160
         3sS/BdSGi30DCMTKkszfcAQ+vxnzJ9/fjzFMBncA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yicong Yang <yangyicong@hisilicon.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 4.19 065/146] PCI/ASPM: Clear the correct bits when enabling L1 substates
Date:   Thu, 16 Apr 2020 15:23:26 +0200
Message-Id: <20200416131251.804144228@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131242.353444678@linuxfoundation.org>
References: <20200416131242.353444678@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yicong Yang <yangyicong@hisilicon.com>

commit 58a3862a10a317a81097ab0c78aecebabb1704f5 upstream.

In pcie_config_aspm_l1ss(), we cleared the wrong bits when enabling ASPM L1
Substates.  Instead of the L1.x enable bits (PCI_L1SS_CTL1_L1SS_MASK, 0xf), we
cleared the Link Activation Interrupt Enable bit (PCI_L1SS_CAP_L1_PM_SS,
0x10).

Clear the L1.x enable bits before writing the new L1.x configuration.

[bhelgaas: changelog]
Fixes: aeda9adebab8 ("PCI/ASPM: Configure L1 substate settings")
Link: https://lore.kernel.org/r/1584093227-1292-1-git-send-email-yangyicong@hisilicon.com
Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
CC: stable@vger.kernel.org	# v4.11+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/pcie/aspm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -747,9 +747,9 @@ static void pcie_config_aspm_l1ss(struct
 
 	/* Enable what we need to enable */
 	pci_clear_and_set_dword(parent, up_cap_ptr + PCI_L1SS_CTL1,
-				PCI_L1SS_CAP_L1_PM_SS, val);
+				PCI_L1SS_CTL1_L1SS_MASK, val);
 	pci_clear_and_set_dword(child, dw_cap_ptr + PCI_L1SS_CTL1,
-				PCI_L1SS_CAP_L1_PM_SS, val);
+				PCI_L1SS_CTL1_L1SS_MASK, val);
 }
 
 static void pcie_config_aspm_dev(struct pci_dev *pdev, u32 val)


