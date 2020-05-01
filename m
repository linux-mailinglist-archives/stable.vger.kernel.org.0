Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9061C173C
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729136AbgEAOAI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 10:00:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:50920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729549AbgEAN2H (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:28:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A00D220757;
        Fri,  1 May 2020 13:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339687;
        bh=x2uCDa77BlqepwyvFeUriEjiz65ckEjs0ku5mYLWxhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L+FoRYlaOLinqTC9Pkxlq1VSi1vrXrCc6pJDKXC7IDvVra1ZzpqUyfpWm225S685R
         ib9RIH40NAWfWAMwDvRXyhXwYGmlOmV0mA0Cfd272ClmSwe7YmZc3kEHieMnmuO86O
         pLn+kquFymZcvurrfOZ6ndSpwQoFlUU0Yh2ZS2dg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 19/80] PCI/ASPM: Allow re-enabling Clock PM
Date:   Fri,  1 May 2020 15:21:13 +0200
Message-Id: <20200501131520.392924662@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131513.810761598@linuxfoundation.org>
References: <20200501131513.810761598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 35efea32b26f9aacc99bf07e0d2cdfba2028b099 ]

Previously Clock PM could not be re-enabled after being disabled by
pci_disable_link_state() because clkpm_capable was reset.  Change this by
adding a clkpm_disable field similar to aspm_disable.

Link: https://lore.kernel.org/r/4e8a66db-7d53-4a66-c26c-f0037ffaa705@gmail.com
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/aspm.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index b12fe65d07f82..4a5fde58974a6 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -57,6 +57,7 @@ struct pcie_link_state {
 	u32 clkpm_capable:1;		/* Clock PM capable? */
 	u32 clkpm_enabled:1;		/* Current Clock PM state */
 	u32 clkpm_default:1;		/* Default Clock PM state by BIOS */
+	u32 clkpm_disable:1;		/* Clock PM disabled */
 
 	/* Exit latencies */
 	struct aspm_latency latency_up;	/* Upstream direction exit latency */
@@ -138,8 +139,11 @@ static void pcie_set_clkpm_nocheck(struct pcie_link_state *link, int enable)
 
 static void pcie_set_clkpm(struct pcie_link_state *link, int enable)
 {
-	/* Don't enable Clock PM if the link is not Clock PM capable */
-	if (!link->clkpm_capable)
+	/*
+	 * Don't enable Clock PM if the link is not Clock PM capable
+	 * or Clock PM is disabled
+	 */
+	if (!link->clkpm_capable || link->clkpm_disable)
 		enable = 0;
 	/* Need nothing if the specified equals to current state */
 	if (link->clkpm_enabled == enable)
@@ -169,7 +173,8 @@ static void pcie_clkpm_cap_init(struct pcie_link_state *link, int blacklist)
 	}
 	link->clkpm_enabled = enabled;
 	link->clkpm_default = enabled;
-	link->clkpm_capable = (blacklist) ? 0 : capable;
+	link->clkpm_capable = capable;
+	link->clkpm_disable = blacklist ? 1 : 0;
 }
 
 static bool pcie_retrain_link(struct pcie_link_state *link)
@@ -773,10 +778,9 @@ static void __pci_disable_link_state(struct pci_dev *pdev, int state, bool sem)
 		link->aspm_disable |= ASPM_STATE_L1;
 	pcie_config_aspm_link(link, policy_to_aspm_state(link));
 
-	if (state & PCIE_LINK_STATE_CLKPM) {
-		link->clkpm_capable = 0;
-		pcie_set_clkpm(link, 0);
-	}
+	if (state & PCIE_LINK_STATE_CLKPM)
+		link->clkpm_disable = 1;
+	pcie_set_clkpm(link, policy_to_clkpm_state(link));
 	mutex_unlock(&aspm_lock);
 	if (sem)
 		up_read(&pci_bus_sem);
-- 
2.20.1



