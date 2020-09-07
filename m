Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB83B26016D
	for <lists+stable@lfdr.de>; Mon,  7 Sep 2020 19:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730394AbgIGREo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Sep 2020 13:04:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:47008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730333AbgIGQdN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Sep 2020 12:33:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9000221973;
        Mon,  7 Sep 2020 16:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599496392;
        bh=yvfnzkumOLeNZfCzoJKHdy3baNkUPfQBaVECQlvIDrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N1xBt7gLf7BCrHQ+tuuwPPhXyaHZjCpTjvlR0xSdkCi66iHckqV+m/RVn9Qm2K8s3
         1zHO03vUgO99sBQdsJkINLmqocCscZ1c1pa9qx578bQs6m1DDEV8c8jRpVce3gN8I0
         KzNHeY+s9e6FiZvf2BLOtL9TsD7U0b339u/B1Lh8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evgeniy Didin <Evgeniy.Didin@synopsys.com>,
        Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>,
        Alexey Brodkin <abrodkin@synopsys.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-snps-arc@lists.infradead.org
Subject: [PATCH AUTOSEL 5.8 41/53] ARC: [plat-hsdk]: Switch ethernet phy-mode to rgmii-id
Date:   Mon,  7 Sep 2020 12:32:07 -0400
Message-Id: <20200907163220.1280412-41-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200907163220.1280412-1-sashal@kernel.org>
References: <20200907163220.1280412-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evgeniy Didin <Evgeniy.Didin@synopsys.com>

[ Upstream commit 26907eb605fbc3ba9dbf888f21d9d8d04471271d ]

HSDK board has Micrel KSZ9031, recent commit
bcf3440c6dd ("net: phy: micrel: add phy-mode support for the KSZ9031 PHY")
caused a breakdown of Ethernet.
Using 'phy-mode = "rgmii"' is not correct because accodring RGMII
specification it is necessary to have delay on RX (PHY to MAX)
which is not generated in case of "rgmii".
Using "rgmii-id" adds necessary delay and solves the issue.

Also adding name of PHY placed on HSDK board.

Signed-off-by: Evgeniy Didin <Evgeniy.Didin@synopsys.com>
Cc: Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>
Cc: Alexey Brodkin <abrodkin@synopsys.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/boot/dts/hsdk.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arc/boot/dts/hsdk.dts b/arch/arc/boot/dts/hsdk.dts
index 5d64a5a940ee6..dcaa44e408ace 100644
--- a/arch/arc/boot/dts/hsdk.dts
+++ b/arch/arc/boot/dts/hsdk.dts
@@ -210,7 +210,7 @@ gmac: ethernet@8000 {
 			reg = <0x8000 0x2000>;
 			interrupts = <10>;
 			interrupt-names = "macirq";
-			phy-mode = "rgmii";
+			phy-mode = "rgmii-id";
 			snps,pbl = <32>;
 			snps,multicast-filter-bins = <256>;
 			clocks = <&gmacclk>;
@@ -228,7 +228,7 @@ mdio {
 				#address-cells = <1>;
 				#size-cells = <0>;
 				compatible = "snps,dwmac-mdio";
-				phy0: ethernet-phy@0 {
+				phy0: ethernet-phy@0 { /* Micrel KSZ9031 */
 					reg = <0>;
 				};
 			};
-- 
2.25.1

