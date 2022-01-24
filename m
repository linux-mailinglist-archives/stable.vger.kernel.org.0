Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13AD149A50C
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2370573AbiAYAF2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:05:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1850665AbiAXXag (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:30:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 631B8C0AD1A2;
        Mon, 24 Jan 2022 13:34:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2AF5DB811FB;
        Mon, 24 Jan 2022 21:34:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A893C340E4;
        Mon, 24 Jan 2022 21:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060091;
        bh=zBueeHikAA85moR0e9cXIh0B9MY89d969ZB1EM1xt0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UFNAlSrXw5S74frSy/RhfRMDZjt1hpAK4SOpUhk+4Xqo/X+JZAlYC+vCmVTPeS4Iv
         iBB9Yrxj6VuVCcqbc6S7TRCS60lfsvx0qgHMoVEQK+43d1gXsWVNr/2PNhvnxLajew
         8of75bl4NPONe4I0RlHDQYXjDkQ3jZV6sjQrB1hU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0803/1039] PCI: mvebu: Setup PCIe controller to Root Complex mode
Date:   Mon, 24 Jan 2022 19:43:12 +0100
Message-Id: <20220124184152.298163867@linuxfoundation.org>
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

[ Upstream commit df08ac016124bd88b8598ac0599d7b89c0642774 ]

This driver operates only in Root Complex mode, so ensure that hardware is
properly configured in Root Complex mode.

Link: https://lore.kernel.org/r/20211125124605.25915-10-pali@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-mvebu.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pci-mvebu.c b/drivers/pci/controller/pci-mvebu.c
index abed58db56877..f279471e340ee 100644
--- a/drivers/pci/controller/pci-mvebu.c
+++ b/drivers/pci/controller/pci-mvebu.c
@@ -55,6 +55,7 @@
 #define  PCIE_MASK_ENABLE_INTS          0x0f000000
 #define PCIE_CTRL_OFF		0x1a00
 #define  PCIE_CTRL_X1_MODE		0x0001
+#define  PCIE_CTRL_RC_MODE		BIT(1)
 #define PCIE_STAT_OFF		0x1a04
 #define  PCIE_STAT_BUS                  0xff00
 #define  PCIE_STAT_DEV                  0x1f0000
@@ -218,7 +219,12 @@ static void mvebu_pcie_setup_wins(struct mvebu_pcie_port *port)
 
 static void mvebu_pcie_setup_hw(struct mvebu_pcie_port *port)
 {
-	u32 cmd, mask;
+	u32 ctrl, cmd, mask;
+
+	/* Setup PCIe controller to Root Complex mode. */
+	ctrl = mvebu_readl(port, PCIE_CTRL_OFF);
+	ctrl |= PCIE_CTRL_RC_MODE;
+	mvebu_writel(port, ctrl, PCIE_CTRL_OFF);
 
 	/* Disable Root Bridge I/O space, memory space and bus mastering. */
 	cmd = mvebu_readl(port, PCIE_CMD_OFF);
-- 
2.34.1



