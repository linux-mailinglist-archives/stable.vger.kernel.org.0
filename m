Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECF76328B96
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240198AbhCASh7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:37:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:44972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238495AbhCAS3T (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:29:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE502650A6;
        Mon,  1 Mar 2021 17:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620093;
        bh=gaW4vRaQTt+47THnGWySP+iKIOkMRWzopiQ1jQepuWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=heGlSwGE/2hMrinka52ECLnP4dnjg+NBdzy+jN9kORGqdcVtEfVpVEXXEGLFFyi6D
         KP8EzW7zz+K8UF9wWojj35Rro21fbN4cKZ8459m0Ed6LlYlLubn4MKqiGjSv4p/KG8
         bxP0DDU0kYMkl3m+FmgQB7a9e7oK6hxNSPak4XKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Ford <aford173@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 027/775] arm64: dts: renesas: beacon kit: Fix choppy Bluetooth Audio
Date:   Mon,  1 Mar 2021 17:03:15 +0100
Message-Id: <20210301161203.061434952@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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
index 8ac167aa18f04..b93219a95afcd 100644
--- a/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi
+++ b/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi
@@ -89,7 +89,6 @@
 	pinctrl-names = "default";
 	uart-has-rtscts;
 	status = "okay";
-	max-speed = <4000000>;
 
 	bluetooth {
 		compatible = "brcm,bcm43438-bt";
@@ -98,6 +97,7 @@
 		device-wakeup-gpios = <&pca9654 5 GPIO_ACTIVE_HIGH>;
 		clocks = <&osc_32k>;
 		clock-names = "extclk";
+		max-speed = <4000000>;
 	};
 };
 
-- 
2.27.0



