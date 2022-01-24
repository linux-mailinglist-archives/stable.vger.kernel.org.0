Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3650149A4B2
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2369580AbiAYACM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:02:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457499AbiAXX2Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:28:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDF52C01D7FB;
        Mon, 24 Jan 2022 13:32:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8ACCEB8105C;
        Mon, 24 Jan 2022 21:32:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BCD4C340E4;
        Mon, 24 Jan 2022 21:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059935;
        bh=kYzQ6x4/8WDwUsKjGgcujq30v/9ofPlAvon/fiopj00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oJrWUXi2vxbgCPV2sF5oWKv2H1PXleQVcB/lmwkr36GM0ZWY+on95eCMTO6IopfwV
         LlB9xqXfQHFmeArSRoYPph8oK2J7qDPdUUEHIjBC7+9+BmKV9A5eGS1r5kgf/8ygnf
         e3EqN0xw/HgOrCQ4r8yCTWBtiKxn36SQiW3/I+Hs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Vasut <marek.vasut+renesas@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        linux-renesas-soc@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0784/1039] PCI: rcar: Check if device is runtime suspended instead of __clk_is_enabled()
Date:   Mon, 24 Jan 2022 19:42:53 +0100
Message-Id: <20220124184151.639481546@linuxfoundation.org>
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

From: Marek Vasut <marek.vasut+renesas@gmail.com>

[ Upstream commit d2a14b54989e9ccea8401895fdfbc213bd1f56af ]

Replace __clk_is_enabled() with pm_runtime_suspended(),
as __clk_is_enabled() was checking the wrong bus clock
and caused the following build error too:
  arm-linux-gnueabi-ld: drivers/pci/controller/pcie-rcar-host.o: in function `rcar_pcie_aarch32_abort_handler':
  pcie-rcar-host.c:(.text+0xdd0): undefined reference to `__clk_is_enabled'

Link: https://lore.kernel.org/r/20211115204641.12941-1-marek.vasut@gmail.com
Fixes: a115b1bd3af0 ("PCI: rcar: Add L1 link state fix into data abort hook")
Signed-off-by: Marek Vasut <marek.vasut+renesas@gmail.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: Wolfram Sang <wsa@the-dreams.de>
Cc: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc: linux-renesas-soc@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-rcar-host.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/controller/pcie-rcar-host.c b/drivers/pci/controller/pcie-rcar-host.c
index e12c2d8be05a3..780e60159993c 100644
--- a/drivers/pci/controller/pcie-rcar-host.c
+++ b/drivers/pci/controller/pcie-rcar-host.c
@@ -50,10 +50,10 @@ struct rcar_msi {
  */
 static void __iomem *pcie_base;
 /*
- * Static copy of bus clock pointer, so we can check whether the clock
- * is enabled or not.
+ * Static copy of PCIe device pointer, so we can check whether the
+ * device is runtime suspended or not.
  */
-static struct clk *pcie_bus_clk;
+static struct device *pcie_dev;
 #endif
 
 /* Structure representing the PCIe interface */
@@ -792,7 +792,7 @@ static int rcar_pcie_get_resources(struct rcar_pcie_host *host)
 #ifdef CONFIG_ARM
 	/* Cache static copy for L1 link state fixup hook on aarch32 */
 	pcie_base = pcie->base;
-	pcie_bus_clk = host->bus_clk;
+	pcie_dev = pcie->dev;
 #endif
 
 	return 0;
@@ -1062,7 +1062,7 @@ static int rcar_pcie_aarch32_abort_handler(unsigned long addr,
 
 	spin_lock_irqsave(&pmsr_lock, flags);
 
-	if (!pcie_base || !__clk_is_enabled(pcie_bus_clk)) {
+	if (!pcie_base || pm_runtime_suspended(pcie_dev)) {
 		ret = 1;
 		goto unlock_exit;
 	}
-- 
2.34.1



