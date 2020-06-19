Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0DB201717
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389047AbgFSQeL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:34:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:44436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389418AbgFSOvJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:51:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64AC521548;
        Fri, 19 Jun 2020 14:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578269;
        bh=ed5UvQWkwOySrDiddzC7rusa9jUpPSdfPpjp03LaDyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qOTqPGWoxbxuFitDULY3YrBu96WbYjBQ6vKg1Xbq5vQd59Ly7dWkREALcXQglXymr
         B5+v5Zt8+M8YYiCl7JJtgy1qCT2MLPmKRDwPWn/TZ3twH/FLZ2X5yqgURrL6mUR6DS
         LEDDxEz73Vgpx7v3nJpiTJpsWAvve75OIQpCRLMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Zhiqiang <Zhiqiang.Hou@nxp.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Minghuan Lian <minghuan.Lian@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 148/190] PCI: Disable MSI for Freescale Layerscape PCIe RC mode
Date:   Fri, 19 Jun 2020 16:33:13 +0200
Message-Id: <20200619141641.120639909@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141633.446429600@linuxfoundation.org>
References: <20200619141633.446429600@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Zhiqiang <Zhiqiang.Hou@nxp.com>

[ Upstream commit 06dc4ee54e306eff61cbdac3593b42b09f618103 ]

The Freescale PCIe controller advertises the MSI/MSI-X capability in both
RC and Endpoint mode, but in RC mode it doesn't support MSI/MSI-X by
itself; it can only transfer MSI/MSI-X from downstream devices.

Add a quirk to prevent use of MSI/MSI-X in RC mode.

Signed-off-by: Hou Zhiqiang <Zhiqiang.Hou@nxp.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Minghuan Lian <minghuan.Lian@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index e7ed051ec125..c751f2f81142 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4912,3 +4912,11 @@ static void quirk_no_ats(struct pci_dev *pdev)
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x98e4, quirk_no_ats);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x6900, quirk_no_ats);
 #endif /* CONFIG_PCI_ATS */
+
+/* Freescale PCIe doesn't support MSI in RC mode */
+static void quirk_fsl_no_msi(struct pci_dev *pdev)
+{
+	if (pci_pcie_type(pdev) == PCI_EXP_TYPE_ROOT_PORT)
+		pdev->no_msi = 1;
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_FREESCALE, PCI_ANY_ID, quirk_fsl_no_msi);
-- 
2.25.1



