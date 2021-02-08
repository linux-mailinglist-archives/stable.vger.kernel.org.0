Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D42823137AF
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbhBHP3W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:29:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:35736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233628AbhBHPZB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:25:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B27CD64EFD;
        Mon,  8 Feb 2021 15:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797303;
        bh=DF4jAoOgabzFryVCwGhb/mi2gTD+rQOY9s7yNFIMy1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V4KdGoYiw/cDrGvex4RixBnILBUcFzT5ioF1ZLDhMLqQcMZ1zKTrhcmEShq7aiLUK
         uJe1NJlXbfnP8ZK2OwZ6Fo1Uy0i5W0e0Z/Tg+z3jhg2z8JSyCRxUfsgNjVgTwL7n6E
         bDxEzAo23os2/uk/ltEMFqCq5aYRIXvajN5vlvTo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil Armstrong <narmstrong@baylibre.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 031/120] arm64: dts: meson: switch TFLASH_VDD_EN pin to open drain on Odroid-C4
Date:   Mon,  8 Feb 2021 16:00:18 +0100
Message-Id: <20210208145819.629879488@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit daf12bee07b9e2f38216f58aca7ac4e4e66a7146 ]

For the proper reboot Odroid-C4 board requires to switch TFLASH_VDD_EN
pin to the high impedance mode, otherwise the board is stuck in the
middle of loading early stages of the bootloader from SD card.

This can be achieved by using the OPEN_DRAIN flag instead of the
ACTIVE_HIGH, what will leave the pin in input mode to achieve high state
(pin has the pull-up) and solve the issue.

Suggested-by: Neil Armstrong <narmstrong@baylibre.com>
Fixes: 326e57518b0d ("arm64: dts: meson-sm1: add support for Hardkernel ODROID-C4")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Link: https://lore.kernel.org/r/20210122055218.27241-1-m.szyprowski@samsung.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-sm1-odroid-c4.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-sm1-odroid-c4.dts b/arch/arm64/boot/dts/amlogic/meson-sm1-odroid-c4.dts
index cf5a98f0e47c8..a712273c905af 100644
--- a/arch/arm64/boot/dts/amlogic/meson-sm1-odroid-c4.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-sm1-odroid-c4.dts
@@ -52,7 +52,7 @@
 		regulator-min-microvolt = <3300000>;
 		regulator-max-microvolt = <3300000>;
 
-		gpio = <&gpio_ao GPIOAO_3 GPIO_ACTIVE_HIGH>;
+		gpio = <&gpio_ao GPIOAO_3 GPIO_OPEN_DRAIN>;
 		enable-active-high;
 		regulator-always-on;
 	};
-- 
2.27.0



