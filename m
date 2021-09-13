Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 221B3408F3E
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242772AbhIMNk6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:40:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:41644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242335AbhIMNjE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:39:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C581161268;
        Mon, 13 Sep 2021 13:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539726;
        bh=ekp0c+JreeUF5Hl977yEOzwqN9bp4phjA7F5h8JaNpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gVpGmKrq1Ngs5SmQY3EOIwOtxDQue/xVZ8inQfWNNdTBG3AYC1UtDVC2G7Ea9rCgS
         +/xDsJ8eVJzS0yKUaDqy1dVyg8woZlCkytUCO/9UCKeYNpm98+QzsTmGPHqaDjw4kf
         SSAqg/jg6Gw1+3YnNtAdyI+3VQDZN8XpGXk2W5Js=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Demetris Ierokipides <ierokipides.dem@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 104/236] ARM: dts: meson8: Use a higher default GPU clock frequency
Date:   Mon, 13 Sep 2021 15:13:29 +0200
Message-Id: <20210913131103.879142541@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit 44cf630bcb8c5ec78125805c9447dd5766792224 ]

We are seeing "imprecise external abort (0x1406)" errors during boot
(which then cause the whole board to hang) on Meson8 (but not Meson8m2).
These are observed while trying to access the GPU's registers when the
MALI clock is running at it's default setting of 24MHz. The 3.10 vendor
kernel uses 318.75MHz as "default" GPU frequency. Using that makes the
"imprecise external aborts" go away.
Add the assigned-clocks and assigned-clock-rates properties to also bump
the MALI clock to 318.75MHz before accessing any of it's registers.

Fixes: 7d3f6b536e72c9 ("ARM: dts: meson8: add the Mali-450 MP6 GPU")
Reported-by: Demetris Ierokipides <ierokipides.dem@gmail.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://lore.kernel.org/r/20210711214023.2163565-1-martin.blumenstingl@googlemail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/meson8.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/meson8.dtsi b/arch/arm/boot/dts/meson8.dtsi
index 04688e8abce2..740a6c816266 100644
--- a/arch/arm/boot/dts/meson8.dtsi
+++ b/arch/arm/boot/dts/meson8.dtsi
@@ -251,8 +251,13 @@
 					  "pp2", "ppmmu2", "pp4", "ppmmu4",
 					  "pp5", "ppmmu5", "pp6", "ppmmu6";
 			resets = <&reset RESET_MALI>;
+
 			clocks = <&clkc CLKID_CLK81>, <&clkc CLKID_MALI>;
 			clock-names = "bus", "core";
+
+			assigned-clocks = <&clkc CLKID_MALI>;
+			assigned-clock-rates = <318750000>;
+
 			operating-points-v2 = <&gpu_opp_table>;
 		};
 	};
-- 
2.30.2



