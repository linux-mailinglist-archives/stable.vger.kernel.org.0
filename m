Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55FD1328D91
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235224AbhCATN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:13:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:39682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241123AbhCATIQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:08:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6B3164F3A;
        Mon,  1 Mar 2021 17:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618268;
        bh=6jv3u8/6dFLbw4S02vIg7NuvhYZZh0Kw7OCCSGXZ8h0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r7xXX5+aW3PrI9Uaclwdo3DM5c1Nidyk8DYZqr7foB9hwXIz4ztFdgbCnySjFDMmU
         QhJJWgp/j46+xe8tP7svp5SebJpExKsCEfaJ7KcoZ/WFvZUE2C34Nzye33bdy8etzQ
         MVxnuy2TQYDfBaNua68RaXfvLbvFdJPry5kBprwU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Ford <aford173@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 025/663] arm64: dts: renesas: beacon kit: Fix choppy Bluetooth Audio
Date:   Mon,  1 Mar 2021 17:04:33 +0100
Message-Id: <20210301161143.040608419@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Ford <aford173@gmail.com>

[ Upstream commit db030c5a9658846a42fbed4d43a8b5f28a2d7ab7 ]

The Bluetooth chip is capable of operating at 4Mbps, but the
max-speed setting was on the UART node instead of the Bluetooth
node, so the chip didn't operate at the correct speed resulting
in choppy audio.  Fix this by setting the max-speed in the proper
node.

Fixes: a1d8a344f1ca ("arm64: dts: renesas: Introduce r8a774a1-beacon-rzg2m-kit")
Signed-off-by: Adam Ford <aford173@gmail.com>
Link: https://lore.kernel.org/r/20201213183759.223246-3-aford173@gmail.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi b/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi
index 97272f5fa0abf..6d24b36ca0a7c 100644
--- a/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi
+++ b/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi
@@ -88,7 +88,6 @@
 	pinctrl-names = "default";
 	uart-has-rtscts;
 	status = "okay";
-	max-speed = <4000000>;
 
 	bluetooth {
 		compatible = "brcm,bcm43438-bt";
@@ -97,6 +96,7 @@
 		device-wakeup-gpios = <&pca9654 5 GPIO_ACTIVE_HIGH>;
 		clocks = <&osc_32k>;
 		clock-names = "extclk";
+		max-speed = <4000000>;
 	};
 };
 
-- 
2.27.0



