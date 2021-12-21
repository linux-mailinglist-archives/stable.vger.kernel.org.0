Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD5AF47B7AB
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 03:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbhLUCBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 21:01:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234086AbhLUCAN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 21:00:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD7BC06137D;
        Mon, 20 Dec 2021 18:00:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79883B81113;
        Tue, 21 Dec 2021 02:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5021CC36AE8;
        Tue, 21 Dec 2021 02:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640052010;
        bh=1rkQI2Le5cSkC8pp8ZXRUV1s8iNS+eYg6LzavWXGSH4=;
        h=From:To:Cc:Subject:Date:From;
        b=IqNoA21TJCfZJXK784ELUDRuZwJhugpqBR/189felzMK7CB6Beesqy17vUWUyArR1
         uPUfIVpxMdheHQiWhbQPrSf1ylSqtIAnXK2Ml3lXy/ngOwtzv3N1WEdsQoD2dWLzhS
         rIxwWLDfUg/EoI0EYyG++jyddpvf/hZkvir8/dhAtYZOBJ1ae1eVB8cOoMJSPEOrPp
         /dorPjFoaDi+6ZvmsNeouISdP8pqcatobZwmS0kvNGa1uY/bD2ZxHx2iNsk3xHGXEt
         dhpas2xiakaLrmvRgxARc109J3bN4w8pWdERitBTH0ZvoCQC6W8lVP+/8Fg/JnKFSo
         34AGML2fWKWPA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, leoyang.li@nxp.com,
        robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 01/14] ARM: dts: ls1021a-tsn: update RGMII delays for sja1105 switch
Date:   Mon, 20 Dec 2021 20:59:39 -0500
Message-Id: <20211221015952.117052-1-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit e691f9282a89e24a8e87cdb91a181c6283ee5124 ]

In the new behavior, the sja1105 driver expects there to be explicit
RGMII delays present on the fixed-link ports, otherwise it will complain
that it falls back to legacy behavior, which is to apply RGMII delays
incorrectly derived from the phy-mode string.

In this case, the legacy behavior of the driver is to not apply delays
in any direction (mostly because the SJA1105T can't do that, so this
board uses PCB traces). To preserve that but also silence the driver,
use explicit delays of 0 ns. The delay information from the phy-mode is
ignored by new kernels (it's still RGMII as long as it's "rgmii*"
something), and the explicit {rx,tx}-internal-delay-ps properties are
ignored by old kernels, so the change works both ways.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ls1021a-tsn.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/ls1021a-tsn.dts b/arch/arm/boot/dts/ls1021a-tsn.dts
index 7235ce2a32936..d5dce78c85617 100644
--- a/arch/arm/boot/dts/ls1021a-tsn.dts
+++ b/arch/arm/boot/dts/ls1021a-tsn.dts
@@ -90,6 +90,8 @@ port@4 {
 				/* Internal port connected to eth2 */
 				ethernet = <&enet2>;
 				phy-mode = "rgmii";
+				rx-internal-delay-ps = <0>;
+				tx-internal-delay-ps = <0>;
 				reg = <4>;
 
 				fixed-link {
-- 
2.34.1

