Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AECC126BF7
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729843AbfLSSvZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:51:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:45560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730128AbfLSSvT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:51:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AE902064B;
        Thu, 19 Dec 2019 18:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781479;
        bh=0QL1Ak8h+NY9/TrgI6ww+xyNPWumj0sy+A/klAr8Tg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FvLTbYp282PFMKNU9Er0cDgyvgq6t0HxTLc1jU0L4Hu822k2HZHUqGGvrkvDWhn+Y
         pbk51QtBhzhKem12rsgFBPVZc5Mj5Wq1u+m4vofl45a5iep5F/admGhO0p67cfztNr
         KuVC+M0TwPtyTQR9qUuy0tBh8r6CQG8UPNWNkw28=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        George Cherian <george.cherian@marvell.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Robert Richter <rrichter@marvell.com>
Subject: [PATCH 4.14 17/36] PCI: Apply Cavium ACS quirk to ThunderX2 and ThunderX3
Date:   Thu, 19 Dec 2019 19:34:34 +0100
Message-Id: <20191219182902.884582321@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219182848.708141124@linuxfoundation.org>
References: <20191219182848.708141124@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: George Cherian <george.cherian@marvell.com>

commit f338bb9f0179cb959977b74e8331b312264d720b upstream.

Enhance the ACS quirk for Cavium Processors. Add the root port vendor IDs
for ThunderX2 and ThunderX3 series of processors.

[bhelgaas: add Fixes: and stable tag]
Fixes: f2ddaf8dfd4a ("PCI: Apply Cavium ThunderX ACS quirk to more Root Ports")
Link: https://lore.kernel.org/r/20191111024243.GA11408@dc5-eodlnx05.marvell.com
Signed-off-by: George Cherian <george.cherian@marvell.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Robert Richter <rrichter@marvell.com>
Cc: stable@vger.kernel.org	# v4.12+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/quirks.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4252,15 +4252,21 @@ static int pci_quirk_amd_sb_acs(struct p
 
 static bool pci_quirk_cavium_acs_match(struct pci_dev *dev)
 {
+	if (!pci_is_pcie(dev) || pci_pcie_type(dev) != PCI_EXP_TYPE_ROOT_PORT)
+		return false;
+
+	switch (dev->device) {
 	/*
-	 * Effectively selects all downstream ports for whole ThunderX 1
-	 * family by 0xf800 mask (which represents 8 SoCs), while the lower
-	 * bits of device ID are used to indicate which subdevice is used
-	 * within the SoC.
+	 * Effectively selects all downstream ports for whole ThunderX1
+	 * (which represents 8 SoCs).
 	 */
-	return (pci_is_pcie(dev) &&
-		(pci_pcie_type(dev) == PCI_EXP_TYPE_ROOT_PORT) &&
-		((dev->device & 0xf800) == 0xa000));
+	case 0xa000 ... 0xa7ff: /* ThunderX1 */
+	case 0xaf84:  /* ThunderX2 */
+	case 0xb884:  /* ThunderX3 */
+		return true;
+	default:
+		return false;
+	}
 }
 
 static int pci_quirk_cavium_acs(struct pci_dev *dev, u16 acs_flags)


