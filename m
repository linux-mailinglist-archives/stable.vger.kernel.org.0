Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C13A49A4AA
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2369572AbiAYACL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:02:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1585459AbiAXX2Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:28:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3CFDC06137B;
        Mon, 24 Jan 2022 13:33:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6FF85B81057;
        Mon, 24 Jan 2022 21:33:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F5EEC340E4;
        Mon, 24 Jan 2022 21:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060000;
        bh=83ctBQqKYvJoAd9wQ3c3uQz73mSpKbIn7Mp3jAIt8wo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZyX7FGeb8gKIl3u2pKw+5xa87vKm4QbyXrg1rvffkkKZ9WGWC8I84p9PfE6/F0xun
         rKkADoQGi3qGr0+aeGO3EsyzcGO4bQ7rWMT4TP49ka5BuQs/zqYC4espxdLiUSjCw3
         UIJr+D3na7gb9jibxkQnBYkRLYJCSPk1LHoC4LXw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0806/1039] PCI: mvebu: Fix support for PCI_EXP_RTSTA on emulated bridge
Date:   Mon, 24 Jan 2022 19:43:15 +0100
Message-Id: <20220124184152.404506156@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 838ff44a398ff47fe9b924961d91aee325821220 ]

PME Status bit in Root Status Register (PCIE_RC_RTSTA_OFF) is read-only and
can be cleared only by writing 0b to the Interrupt Cause RW0C register
(PCIE_INT_CAUSE_OFF).

Link: https://lore.kernel.org/r/20211125124605.25915-15-pali@kernel.org
Fixes: 1f08673eef12 ("PCI: mvebu: Convert to PCI emulated bridge config space")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-mvebu.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pci-mvebu.c b/drivers/pci/controller/pci-mvebu.c
index 0052e83c95de9..618c34e8879ec 100644
--- a/drivers/pci/controller/pci-mvebu.c
+++ b/drivers/pci/controller/pci-mvebu.c
@@ -51,6 +51,8 @@
 	 PCIE_CONF_FUNC(PCI_FUNC(devfn)) | PCIE_CONF_REG(where) | \
 	 PCIE_CONF_ADDR_EN)
 #define PCIE_CONF_DATA_OFF	0x18fc
+#define PCIE_INT_CAUSE_OFF	0x1900
+#define  PCIE_INT_PM_PME		BIT(28)
 #define PCIE_MASK_OFF		0x1910
 #define  PCIE_MASK_ENABLE_INTS          0x0f000000
 #define PCIE_CTRL_OFF		0x1a00
@@ -604,7 +606,14 @@ mvebu_pci_bridge_emul_pcie_conf_write(struct pci_bridge_emul *bridge,
 		break;
 
 	case PCI_EXP_RTSTA:
-		mvebu_writel(port, new, PCIE_RC_RTSTA);
+		/*
+		 * PME Status bit in Root Status Register (PCIE_RC_RTSTA)
+		 * is read-only and can be cleared only by writing 0b to the
+		 * Interrupt Cause RW0C register (PCIE_INT_CAUSE_OFF). So
+		 * clear PME via Interrupt Cause.
+		 */
+		if (new & PCI_EXP_RTSTA_PME)
+			mvebu_writel(port, ~PCIE_INT_PM_PME, PCIE_INT_CAUSE_OFF);
 		break;
 	}
 }
-- 
2.34.1



