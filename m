Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A73C1328642
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234687AbhCARHQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:07:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:59376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236494AbhCARBx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:01:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2964564FEE;
        Mon,  1 Mar 2021 16:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616680;
        bh=+/L8aNOLb2ES4scNhsww1KbLC81FhqZ0cGaHosdwsbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KJ3g1T1WSdM3Ci6Y/Y5LAMhLatRUxqnryK6xvik+UDJUwboEd0glrk7SM1gJqnPom
         3XD1q77oRevNqQHfeZjNVMu4G01IY8CkjB+I9GkYfEQ0DwON/hbdJAQ5BUZbv2QqP0
         jcd/xTiTIVogwpX5nyvbpRVYETdHoaKOk5Y6xPx4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 028/247] ARM: dts: exynos: correct PMIC interrupt trigger level on Monk
Date:   Mon,  1 Mar 2021 17:10:48 +0100
Message-Id: <20210301161033.074030331@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 8528cda2b7c667e9cd173aef1a677c71b7d5a096 ]

The Samsung PMIC datasheets describe the interrupt line as active low
with a requirement of acknowledge from the CPU.  Without specifying the
interrupt type in Devicetree, kernel might apply some fixed
configuration, not necessarily working for this hardware.

Fixes: e0cefb3f79d3 ("ARM: dts: add board dts file for Exynos3250-based Monk board")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20201210212903.216728-2-krzk@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos3250-monk.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos3250-monk.dts b/arch/arm/boot/dts/exynos3250-monk.dts
index 6ffedf4ed9f2b..d343dc13ceecd 100644
--- a/arch/arm/boot/dts/exynos3250-monk.dts
+++ b/arch/arm/boot/dts/exynos3250-monk.dts
@@ -188,7 +188,7 @@
 	s2mps14_pmic@66 {
 		compatible = "samsung,s2mps14-pmic";
 		interrupt-parent = <&gpx0>;
-		interrupts = <7 IRQ_TYPE_NONE>;
+		interrupts = <7 IRQ_TYPE_LEVEL_LOW>;
 		reg = <0x66>;
 		wakeup-source;
 
-- 
2.27.0



