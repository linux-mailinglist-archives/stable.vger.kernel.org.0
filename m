Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3520D40919C
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244515AbhIMOC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:02:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:46240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343575AbhIMOAq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:00:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF791613A8;
        Mon, 13 Sep 2021 13:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540267;
        bh=sZ4Hm5b8lpaGGXkwBBXLGyzJlZZ8AkWArhVJVdu+wqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n2eREta5ahXh7w7R0fUwZ6371hDsGyep4yIegwaycGvlAwigwIh7/WCFWyfWrFisH
         jqXN4bPRwoBeIXkdnu6lN/QBwK9kdG05awzUF8qTw30OmEx/i9F9G5nnmd+X83Xc+2
         u2RRYaPV5zsdcFfPpJUx9CaZXwXEQDKGxZ7tHDEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Demetris Ierokipides <ierokipides.dem@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 121/300] ARM: dts: meson8: Use a higher default GPU clock frequency
Date:   Mon, 13 Sep 2021 15:13:02 +0200
Message-Id: <20210913131113.486094496@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
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
index 157a950a55d3..686c7b7c79d5 100644
--- a/arch/arm/boot/dts/meson8.dtsi
+++ b/arch/arm/boot/dts/meson8.dtsi
@@ -304,8 +304,13 @@
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
 			#cooling-cells = <2>; /* min followed by max */
 		};
-- 
2.30.2



