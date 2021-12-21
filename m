Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10C3347B765
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 03:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232674AbhLUB7u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 20:59:50 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54622 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233747AbhLUB7S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 20:59:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 670DB61361;
        Tue, 21 Dec 2021 01:59:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F41C36AE5;
        Tue, 21 Dec 2021 01:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640051956;
        bh=nwIldBV2EYbv9oUkDcGCzsWpKwoC2I4wBYpPS5LWTJQ=;
        h=From:To:Cc:Subject:Date:From;
        b=mklFY1zJ5Gci+IJJz2ae3825E17ZKCUGeiT297UaGOnPjbKNAFNqu99MMMoQzqQft
         inQvZwMHhihpn8aPXxk/VMWIFsf6e6XemUhMedTEUCGaFTNSYubNKZCMGf2hyoKrZV
         L0zvckBntB/vnN6oaAqqRvo693cSonCEdzJPE2pU+gJ+hnMXIeFiRzbgsZ/Hw7pZ0j
         MSlk1DMbK/JwjPDxKqGfL4w46CxFbYFeOYtiBrNfHrfnBU/JczLYcnvKNU4AG78NQ8
         XQFCJUnqZ2a7iq5WNqf0pk1tLhYAzNpuS0p5PnJ7h/WPIj6urvxxNthQDBnyZPhvDF
         wtjM0rexQj66g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, leoyang.li@nxp.com,
        robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 01/19] ARM: dts: ls1021a-tsn: update RGMII delays for sja1105 switch
Date:   Mon, 20 Dec 2021 20:58:56 -0500
Message-Id: <20211221015914.116767-1-sashal@kernel.org>
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

