Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 309371FDD94
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731784AbgFRB1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:27:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:35004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731775AbgFRB1F (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:27:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59BEC221F1;
        Thu, 18 Jun 2020 01:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443625;
        bh=DNU3oItBRD+t8hHUsLAxFM9xsQJ+HUY8qPQ4nN96+A0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vMTLdNNo5yewFxluxxNdwteL3CsHyT+4SJPeEnY/3cVDk9eYQtcs5YPzoA00KGYC8
         CiAhrLYd2gqfxU/dSbyGDu+MS5pD9VIMgOHOuKPEc/ooYTvDRlaU6WTGEq4AQ5vyjz
         FLQIHQaGSNBr5wCyjWs2xn5Sgr7ono5vnXjwLi3c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 050/108] PCI/ASPM: Allow ASPM on links to PCIe-to-PCI/PCI-X Bridges
Date:   Wed, 17 Jun 2020 21:25:02 -0400
Message-Id: <20200618012600.608744-50-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012600.608744-1-sashal@kernel.org>
References: <20200618012600.608744-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit 66ff14e59e8a30690755b08bc3042359703fb07a ]

7d715a6c1ae5 ("PCI: add PCI Express ASPM support") added the ability for
Linux to enable ASPM, but for some undocumented reason, it didn't enable
ASPM on links where the downstream component is a PCIe-to-PCI/PCI-X Bridge.

Remove this exclusion so we can enable ASPM on these links.

The Dell OptiPlex 7080 mentioned in the bugzilla has a TI XIO2001
PCIe-to-PCI Bridge.  Enabling ASPM on the link leading to it allows the
Intel SoC to enter deeper Package C-states, which is a significant power
savings.

[bhelgaas: commit log]
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=207571
Link: https://lore.kernel.org/r/20200505173423.26968-1-kai.heng.feng@canonical.com
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/aspm.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 400031622b76..04d5c62588b7 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -584,16 +584,6 @@ static void pcie_aspm_cap_init(struct pcie_link_state *link, int blacklist)
 
 	/* Setup initial capable state. Will be updated later */
 	link->aspm_capable = link->aspm_support;
-	/*
-	 * If the downstream component has pci bridge function, don't
-	 * do ASPM for now.
-	 */
-	list_for_each_entry(child, &linkbus->devices, bus_list) {
-		if (pci_pcie_type(child) == PCI_EXP_TYPE_PCI_BRIDGE) {
-			link->aspm_disable = ASPM_STATE_ALL;
-			break;
-		}
-	}
 
 	/* Get and check endpoint acceptable latencies */
 	list_for_each_entry(child, &linkbus->devices, bus_list) {
-- 
2.25.1

