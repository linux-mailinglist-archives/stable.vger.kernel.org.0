Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 957BA49A4BD
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2369605AbiAYACO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:02:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1572900AbiAXX2Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:28:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D07FBC01D7FD;
        Mon, 24 Jan 2022 13:32:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98E1EB8105C;
        Mon, 24 Jan 2022 21:32:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC73BC340E4;
        Mon, 24 Jan 2022 21:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059944;
        bh=vqNbZ/QgN62kkNQGfD6HduBejctEmovphbmTpQUP7KY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p7fR+ZSS1Q2jhLpUR3LqYDADPC44hGRpt+x+T/MoQQaCXxQLKyCPuf97coRGlysDG
         S81rR5lTZeh0QyteKg7vk3flmz88MEYvCdek0t7OG66byPkGIQz4zSIiqHD2567cNc
         siH97xj94usC7Ezxpp/8eSc14CjI0aAjn38q2ECI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hector Martin <marcan@marcan.st>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0787/1039] PCI: apple: Fix REFCLK1 enable/poll logic
Date:   Mon, 24 Jan 2022 19:42:56 +0100
Message-Id: <20220124184151.746567209@linuxfoundation.org>
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

From: Hector Martin <marcan@marcan.st>

[ Upstream commit 75d36df6807838f3c826c21c0fa51cdc079667d1 ]

REFCLK1 has req/ack bits that need to be programmed, just like REFCLK0.

Link: https://lore.kernel.org/r/20211117140044.193865-1-marcan@marcan.st
Fixes: 1e33888fbe44 ("PCI: apple: Add initial hardware bring-up")
Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-apple.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/controller/pcie-apple.c b/drivers/pci/controller/pcie-apple.c
index b090924b41fee..537ac9fe2e842 100644
--- a/drivers/pci/controller/pcie-apple.c
+++ b/drivers/pci/controller/pcie-apple.c
@@ -42,8 +42,9 @@
 #define   CORE_FABRIC_STAT_MASK		0x001F001F
 #define CORE_LANE_CFG(port)		(0x84000 + 0x4000 * (port))
 #define   CORE_LANE_CFG_REFCLK0REQ	BIT(0)
-#define   CORE_LANE_CFG_REFCLK1		BIT(1)
+#define   CORE_LANE_CFG_REFCLK1REQ	BIT(1)
 #define   CORE_LANE_CFG_REFCLK0ACK	BIT(2)
+#define   CORE_LANE_CFG_REFCLK1ACK	BIT(3)
 #define   CORE_LANE_CFG_REFCLKEN	(BIT(9) | BIT(10))
 #define CORE_LANE_CTL(port)		(0x84004 + 0x4000 * (port))
 #define   CORE_LANE_CTL_CFGACC		BIT(15)
@@ -482,9 +483,9 @@ static int apple_pcie_setup_refclk(struct apple_pcie *pcie,
 	if (res < 0)
 		return res;
 
-	rmw_set(CORE_LANE_CFG_REFCLK1, pcie->base + CORE_LANE_CFG(port->idx));
+	rmw_set(CORE_LANE_CFG_REFCLK1REQ, pcie->base + CORE_LANE_CFG(port->idx));
 	res = readl_relaxed_poll_timeout(pcie->base + CORE_LANE_CFG(port->idx),
-					 stat, stat & CORE_LANE_CFG_REFCLK1,
+					 stat, stat & CORE_LANE_CFG_REFCLK1ACK,
 					 100, 50000);
 
 	if (res < 0)
-- 
2.34.1



