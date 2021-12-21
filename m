Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 167F147B704
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 02:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbhLUB56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 20:57:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231674AbhLUB56 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 20:57:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31B9FC061574;
        Mon, 20 Dec 2021 17:57:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1B6AB810FE;
        Tue, 21 Dec 2021 01:57:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0FA6C36AEA;
        Tue, 21 Dec 2021 01:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640051875;
        bh=nwIldBV2EYbv9oUkDcGCzsWpKwoC2I4wBYpPS5LWTJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EQoOteLetUJWMqgIw/mBhV0Wy1sn8i4anRC7/9Kss4/CrfF4Ek/VysKpSbkSfRDf1
         NnJYe3LZMi/V5rc+fIgyGZrVDG75upW52/Sr9sh2FOdIot2MOtD9/4Su8oqPfgNbSx
         yJG5LGxpHFrm9glvGPAQfYmeCiEglxIES2oDxenpjGWlwlFtDns4bN789QSIYdd6Eu
         DA4ZcP/EyVp95mPJ4GKUYnYblR2YEVXQoNPSaZ6NVU6JEnS7pH0a8aPLFEo3/CMScw
         vTleFM6bY9MpFOnJvzAA2C9JAXvR6Wt5N9/g3YbTRQJ3GGR5wjgQaRHDFqJqQgVYhY
         C2pOMEVQkNq6g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, leoyang.li@nxp.com,
        robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 02/29] ARM: dts: ls1021a-tsn: update RGMII delays for sja1105 switch
Date:   Mon, 20 Dec 2021 20:57:23 -0500
Message-Id: <20211221015751.116328-2-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221015751.116328-1-sashal@kernel.org>
References: <20211221015751.116328-1-sashal@kernel.org>
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
index aca78b5eddf20..194748737724c 100644
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

