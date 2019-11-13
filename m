Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49777FA5DC
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbfKMBvg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:51:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:39518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727904AbfKMBvg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:51:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F21B422470;
        Wed, 13 Nov 2019 01:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609895;
        bh=OpXDIx5xOYY97zeVa/FNBxT/29iZH3I1AKxSms1pfW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kQQN30IX0DSAHnBchsug33lSvHn9jL4DC8LZcNlHXO4DPTh5R85t9/MHtzzAoYn4a
         5V/cRPdorAr16kw0CPFF8kglXDFIe/AWKf5Lor9UQszLt/zkPbzzNKiKtsisUBSl8V
         YfMigkPMpNmhGnj0CsC5QxBo4LO6/2IlgsBO5DMk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jon Derrick <jonathan.derrick@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 051/209] x86/PCI: Apply VMD's AERSID fixup generically
Date:   Tue, 12 Nov 2019 20:47:47 -0500
Message-Id: <20191113015025.9685-51-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Derrick <jonathan.derrick@intel.com>

[ Upstream commit 4f475e8e0a6d4f5d430350d1f74f7e4899fb1692 ]

A root port Device ID changed between simulation and production.  Rather
than match Device IDs which may not be future-proof if left unmaintained,
match all root ports which exist in a VMD domain.

Signed-off-by: Jon Derrick <jonathan.derrick@intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/pci/fixup.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
index bd372e8965571..527e69b120025 100644
--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -629,17 +629,11 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x8c10, quirk_apple_mbp_poweroff);
 static void quirk_no_aersid(struct pci_dev *pdev)
 {
 	/* VMD Domain */
-	if (is_vmd(pdev->bus))
+	if (is_vmd(pdev->bus) && pci_is_root_bus(pdev->bus))
 		pdev->bus->bus_flags |= PCI_BUS_FLAGS_NO_AERSID;
 }
-DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x2030, quirk_no_aersid);
-DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x2031, quirk_no_aersid);
-DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x2032, quirk_no_aersid);
-DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x2033, quirk_no_aersid);
-DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x334a, quirk_no_aersid);
-DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x334b, quirk_no_aersid);
-DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x334c, quirk_no_aersid);
-DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x334d, quirk_no_aersid);
+DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_VENDOR_ID_INTEL, PCI_ANY_ID,
+			      PCI_CLASS_BRIDGE_PCI, 8, quirk_no_aersid);
 
 static void quirk_intel_th_dnv(struct pci_dev *dev)
 {
-- 
2.20.1

