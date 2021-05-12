Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFE7137C85B
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239505AbhELQIN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:08:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:48386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235990AbhELQCA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:02:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6BA061C38;
        Wed, 12 May 2021 15:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833595;
        bh=zZ6p1BxpzGjv7NsHd7N5HZsq0EUFT5qEINQVLvSGYy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VDHH3MHzcUvLjAEs+Fq2vkIwXrUd4tOXA6SIqH/Am5pedZeX95ywCEmlUMUSAnRxT
         qTYoQCaUtHUelr1ynJp2Ff2BMTTOuqRlsUStObP0hIzw9lWsQcsOvY4I4hmQBRW3Ql
         hgbyPOVia7RuUbUVbofNUjGKxcjH2kgWiG7NvzZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hsin-Yi Wang <hsinyi@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 211/601] arm64: dts: mt8183: Add gce client reg for display subcomponents
Date:   Wed, 12 May 2021 16:44:48 +0200
Message-Id: <20210512144834.793035805@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hsin-Yi Wang <hsinyi@chromium.org>

[ Upstream commit b7a8f50a1437164607f73831075c06120aa1f3b3 ]

Add mediatek,gce-client-reg for mmsys, ccorr, aal, gamma, dither.

Fixes: 91f9c963ce79 ("arm64: dts: mt8183: Add display nodes for MT8183")
Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
Tested-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Link: https://lore.kernel.org/r/20210324070842.1037233-1-hsinyi@chromium.org
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183.dtsi b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
index 36a90dd2fa7c..5477a49dc2fa 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
@@ -969,6 +969,9 @@
 			compatible = "mediatek,mt8183-mmsys", "syscon";
 			reg = <0 0x14000000 0 0x1000>;
 			#clock-cells = <1>;
+			mboxes = <&gce 0 CMDQ_THR_PRIO_HIGHEST>,
+				 <&gce 1 CMDQ_THR_PRIO_HIGHEST>;
+			mediatek,gce-client-reg = <&gce SUBSYS_1400XXXX 0 0x1000>;
 		};
 
 		ovl0: ovl@14008000 {
@@ -1044,6 +1047,7 @@
 			interrupts = <GIC_SPI 232 IRQ_TYPE_LEVEL_LOW>;
 			power-domains = <&spm MT8183_POWER_DOMAIN_DISP>;
 			clocks = <&mmsys CLK_MM_DISP_CCORR0>;
+			mediatek,gce-client-reg = <&gce SUBSYS_1400XXXX 0xf000 0x1000>;
 		};
 
 		aal0: aal@14010000 {
@@ -1053,6 +1057,7 @@
 			interrupts = <GIC_SPI 233 IRQ_TYPE_LEVEL_LOW>;
 			power-domains = <&spm MT8183_POWER_DOMAIN_DISP>;
 			clocks = <&mmsys CLK_MM_DISP_AAL0>;
+			mediatek,gce-client-reg = <&gce SUBSYS_1401XXXX 0 0x1000>;
 		};
 
 		gamma0: gamma@14011000 {
@@ -1061,6 +1066,7 @@
 			interrupts = <GIC_SPI 234 IRQ_TYPE_LEVEL_LOW>;
 			power-domains = <&spm MT8183_POWER_DOMAIN_DISP>;
 			clocks = <&mmsys CLK_MM_DISP_GAMMA0>;
+			mediatek,gce-client-reg = <&gce SUBSYS_1401XXXX 0x1000 0x1000>;
 		};
 
 		dither0: dither@14012000 {
@@ -1069,6 +1075,7 @@
 			interrupts = <GIC_SPI 235 IRQ_TYPE_LEVEL_LOW>;
 			power-domains = <&spm MT8183_POWER_DOMAIN_DISP>;
 			clocks = <&mmsys CLK_MM_DISP_DITHER0>;
+			mediatek,gce-client-reg = <&gce SUBSYS_1401XXXX 0x2000 0x1000>;
 		};
 
 		dsi0: dsi@14014000 {
-- 
2.30.2



