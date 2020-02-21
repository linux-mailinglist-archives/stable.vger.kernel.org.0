Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4DB167829
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728672AbgBUHtW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:49:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:45814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728157AbgBUHtV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:49:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AAC6207FD;
        Fri, 21 Feb 2020 07:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271360;
        bh=rCXYJ5PKjm9buXg6u9PeIasd//I73jZZx7q8swnUgA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SMKRIauR544SoClycoUlZnVC31qkKDmcA3IV7aiQo4y9vuQoHNgxaDDlUAsvVIHD+
         ElmnGSFEW3iR9uQ33mbgCVr1onYzfC4eB5/L/0FaTKE8UohFSTDyvozWEbJwMsGe3R
         RbaSv2ZbJeOSl0bk6Ru0N3qtJeD5Dk27yEUV45dM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Drake <drake@endlessm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 136/399] PCI: Add generic quirk for increasing D3hot delay
Date:   Fri, 21 Feb 2020 08:37:41 +0100
Message-Id: <20200221072415.701296364@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Drake <drake@endlessm.com>

[ Upstream commit 62fe23df067715a21c4aef44068efe7ceaa8f627 ]

Separate the D3 delay increase functionality out of quirk_radeon_pm() into
its own function so that it can be shared with other quirks, including the
AMD Ryzen XHCI quirk that will be introduced in a followup commit.

Tweak the function name and message to indicate more clearly that the delay
relates to a D3hot-to-D0 transition.

Link: https://lore.kernel.org/r/20191127053836.31624-1-drake@endlessm.com
Signed-off-by: Daniel Drake <drake@endlessm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 5cd6a77ddefff..27008edce1a24 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1871,16 +1871,21 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	0x2609, quirk_intel_pcie_pm);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	0x260a, quirk_intel_pcie_pm);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	0x260b, quirk_intel_pcie_pm);
 
+static void quirk_d3hot_delay(struct pci_dev *dev, unsigned int delay)
+{
+	if (dev->d3_delay >= delay)
+		return;
+
+	dev->d3_delay = delay;
+	pci_info(dev, "extending delay after power-on from D3hot to %d msec\n",
+		 dev->d3_delay);
+}
+
 static void quirk_radeon_pm(struct pci_dev *dev)
 {
 	if (dev->subsystem_vendor == PCI_VENDOR_ID_APPLE &&
-	    dev->subsystem_device == 0x00e2) {
-		if (dev->d3_delay < 20) {
-			dev->d3_delay = 20;
-			pci_info(dev, "extending delay after power-on from D3 to %d msec\n",
-				 dev->d3_delay);
-		}
-	}
+	    dev->subsystem_device == 0x00e2)
+		quirk_d3hot_delay(dev, 20);
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x6741, quirk_radeon_pm);
 
-- 
2.20.1



