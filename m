Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92C37408D59
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240189AbhIMNZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:25:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:34834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240567AbhIMNWM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:22:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBF5461159;
        Mon, 13 Sep 2021 13:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539246;
        bh=xCLWryCJ5SZE9fvXRVPIiVQjE4zis4KoslvYXRyheEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KnKk/H2k5SKLjYs/CUN2imOc09WPxXCMJ5hsNPdHgOhAGUVwAfze86vRmElGHBK9N
         dYyh1AZXRfcrfqes1b+Bl6Qxzl28kCaMBqqz7OTESBoYIrm1CmrLwlpupQVlzf0gsv
         g9K+mjBkkm25w8Se8f66uXGeCCEL47BkSpitKxbU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Demetris Ierokipides <ierokipides.dem@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 065/144] ARM: dts: meson8: Use a higher default GPU clock frequency
Date:   Mon, 13 Sep 2021 15:14:06 +0200
Message-Id: <20210913131050.141913889@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131047.974309396@linuxfoundation.org>
References: <20210913131047.974309396@linuxfoundation.org>
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
index 3efe9d41c2bb..d7c9dbee0f01 100644
--- a/arch/arm/boot/dts/meson8.dtsi
+++ b/arch/arm/boot/dts/meson8.dtsi
@@ -241,8 +241,13 @@
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



