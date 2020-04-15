Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D95CE1AA213
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 14:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370396AbgDOMuJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 08:50:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:34424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408927AbgDOLmy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:42:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDBD920768;
        Wed, 15 Apr 2020 11:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950972;
        bh=oooFEStGUZHNuhXxGFvK4GTwAIxHao8rhtCGvyKcdGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=An62GPDx/H6S+dKeEU5uxW74KlZUlpdjX+UL0zGJJ5munUEztdnHSGaMA2Eqs7xMX
         ACRsaccnlHEcIArDNAH2pqaCI4ttLyhv78pE/+q27NVJo9p5Q8gF7D28ROCLO/n5Lc
         s7cT1WBK/s4ozJB8Smsr0eEE5FrMRbHngXiYfU2c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Baruch Siach <baruch@tkos.co.il>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 021/106] arm64: dts: clearfog-gt-8k: set gigabit PHY reset deassert delay
Date:   Wed, 15 Apr 2020 07:41:01 -0400
Message-Id: <20200415114226.13103-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114226.13103-1-sashal@kernel.org>
References: <20200415114226.13103-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit 46f94c7818e7ab82758fca74935ef3d454340b4e ]

If the mv88e6xxx DSA driver is built as a module, it causes the
ethernet driver to re-probe when it's loaded. This in turn causes
the gigabit PHY to be momentarily reset and reprogrammed. However,
we attempt to reprogram the PHY immediately after deasserting reset,
and the PHY ignores the writes.

This results in the PHY operating in the wrong mode, and the copper
link states down.

Set a reset deassert delay of 10ms for the gigabit PHY to avoid this.

Fixes: babc5544c293 ("arm64: dts: clearfog-gt-8k: 1G eth PHY reset signal")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Acked-by: Baruch Siach <baruch@tkos.co.il>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts b/arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts
index a211a046b2f2f..b90d78a5724b2 100644
--- a/arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts
+++ b/arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts
@@ -367,6 +367,7 @@
 		pinctrl-0 = <&cp0_copper_eth_phy_reset>;
 		reset-gpios = <&cp0_gpio2 11 GPIO_ACTIVE_LOW>;
 		reset-assert-us = <10000>;
+		reset-deassert-us = <10000>;
 	};
 
 	switch0: switch0@4 {
-- 
2.20.1

