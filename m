Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2157D450E30
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240751AbhKOSNR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:13:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:46096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240104AbhKOSFi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:05:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 871E063289;
        Mon, 15 Nov 2021 17:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998146;
        bh=JAyqS7BqGJw/stY68/Ag8aSXGGADM5aDR20auzDfsd8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BCxUlSBgptHc0tu6OR286Lpv4HadtnNVXmt1cj9yOkEPuWNk/Enr5F1uuMNK/8iM5
         yzwAnLU7kvFhXAiLnUcp0ub1pYHwO7Gl93llNRAp3Y7LpaPUPJtBCfBNHkT3wAt93w
         CGzFq0ZXGSjYtTjd/CfUiFiSoXPtFvDtKG6UbD3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Ford <aford173@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 405/575] arm64: dts: renesas: beacon: Fix Ethernet PHY mode
Date:   Mon, 15 Nov 2021 18:02:10 +0100
Message-Id: <20211115165357.770246733@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 59a8bda062f8646d99ff8c4956adf37dee1cb75e ]

While networking works fine in RGMII mode when using the Linux generic
PHY driver, it fails when using the Atheros PHY driver.
Fix this by correcting the Ethernet PHY mode to RGMII-RXID, which works
fine with both drivers.

Fixes: a5200e63af57d05e ("arm64: dts: renesas: rzg2: Convert EtherAVB to explicit delay handling")
Reported-by: Adam Ford <aford173@gmail.com>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/2a4c15b2df23bb63f15abf9dfb88860477f4f523.1632465965.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi b/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi
index 3c73dfc430afc..929c7910c68df 100644
--- a/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi
+++ b/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi
@@ -54,6 +54,7 @@
 &avb {
 	pinctrl-0 = <&avb_pins>;
 	pinctrl-names = "default";
+	phy-mode = "rgmii-rxid";
 	phy-handle = <&phy0>;
 	rx-internal-delay-ps = <1800>;
 	tx-internal-delay-ps = <2000>;
-- 
2.33.0



