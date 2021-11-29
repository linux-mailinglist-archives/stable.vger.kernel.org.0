Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50DE1462283
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 21:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233794AbhK2Uxj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 15:53:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbhK2Uvj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 15:51:39 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 299E2C0F4B0E;
        Mon, 29 Nov 2021 10:25:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 76AE7CE13D7;
        Mon, 29 Nov 2021 18:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21293C53FAD;
        Mon, 29 Nov 2021 18:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210317;
        bh=HgITJXjaBTSUfRyLh5gJqj5Vdw55Eix186vbneIGS9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DW7h5UjYBgmBunmqtbYV02YhhIPkwA1I0rdT9B94i2JTqELZK9TT6ewOvT4eI+7HV
         44JSpiZImXYdTBgPcYl/yXu0KszQfNcGuZ5IQsQypMX7fIDNL3W7SkVh1bornvNIS4
         DGBOBdbLlE76HVuc5AdcnfdQVpTk0lrBOlh2RNWg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.4 38/92] PCI: aardvark: Simplify initialization of rootcap on virtual bridge
Date:   Mon, 29 Nov 2021 19:18:07 +0100
Message-Id: <20211129181708.698251937@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit 454c53271fc11f3aa5e44e41fd99ca181bd32c62 upstream.

PCIe config space can be initialized also before pci_bridge_emul_init()
call, so move rootcap initialization after PCI config space initialization.

This simplifies the function a little since it removes one if (ret < 0)
check.

Link: https://lore.kernel.org/r/20211005180952.6812-11-kabel@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -898,7 +898,6 @@ static struct pci_bridge_emul_ops advk_p
 static int advk_sw_pci_bridge_init(struct advk_pcie *pcie)
 {
 	struct pci_bridge_emul *bridge = &pcie->bridge;
-	int ret;
 
 	bridge->conf.vendor =
 		cpu_to_le16(advk_readl(pcie, PCIE_CORE_DEV_ID_REG) & 0xffff);
@@ -918,19 +917,14 @@ static int advk_sw_pci_bridge_init(struc
 	/* Support interrupt A for MSI feature */
 	bridge->conf.intpin = PCIE_CORE_INT_A_ASSERT_ENABLE;
 
+	/* Indicates supports for Completion Retry Status */
+	bridge->pcie_conf.rootcap = cpu_to_le16(PCI_EXP_RTCAP_CRSVIS);
+
 	bridge->has_pcie = true;
 	bridge->data = pcie;
 	bridge->ops = &advk_pci_bridge_emul_ops;
 
-	/* PCIe config space can be initialized after pci_bridge_emul_init() */
-	ret = pci_bridge_emul_init(bridge, 0);
-	if (ret < 0)
-		return ret;
-
-	/* Indicates supports for Completion Retry Status */
-	bridge->pcie_conf.rootcap = cpu_to_le16(PCI_EXP_RTCAP_CRSVIS);
-
-	return 0;
+	return pci_bridge_emul_init(bridge, 0);
 }
 
 static bool advk_pcie_valid_device(struct advk_pcie *pcie, struct pci_bus *bus,


