Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C081337C7B2
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236289AbhELQCH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:02:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:36238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238079AbhELP5R (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:57:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0ADB661457;
        Wed, 12 May 2021 15:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833389;
        bh=S56nj6QKapIf7OiO/4pzq4iLQgPLS6eLXidcsmoE+iY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jUDivqECzBPpNA/1SQFacMjZbqQl7VkNG1bd6p3ENP3Ht/TG6hvtv6vhAGhqfdB//
         2k8Jz3tTgMhIFwEx562yr2qg3PQX3ZN90kFOpsom2VUw9QVHChU7+CxfON9qt+Q2LE
         FVHBJgV4J5fM9yg8MiUq19/UPw9tKgdAzw2c/ndU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 130/601] ARM: dts: exynos: correct fuel gauge interrupt trigger level on P4 Note family
Date:   Wed, 12 May 2021 16:43:27 +0200
Message-Id: <20210512144832.110636537@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit c731a16e2cf424a462c7d42c33d6acd613576508 ]

The Maxim fuel gauge datasheets describe the interrupt line as active
low with a requirement of acknowledge from the CPU.  The falling edge
interrupt will mostly work but it's not correct.

Fixes: f48b5050c301 ("ARM: dts: exynos: add Samsung's Exynos4412-based P4 Note boards")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20201210212534.216197-2-krzk@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos4412-p4note.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos4412-p4note.dtsi b/arch/arm/boot/dts/exynos4412-p4note.dtsi
index b2f9d5448a18..5fe371543cbb 100644
--- a/arch/arm/boot/dts/exynos4412-p4note.dtsi
+++ b/arch/arm/boot/dts/exynos4412-p4note.dtsi
@@ -146,7 +146,7 @@
 			pinctrl-0 = <&fuel_alert_irq>;
 			pinctrl-names = "default";
 			interrupt-parent = <&gpx2>;
-			interrupts = <3 IRQ_TYPE_EDGE_FALLING>;
+			interrupts = <3 IRQ_TYPE_LEVEL_LOW>;
 			maxim,rsns-microohm = <10000>;
 			maxim,over-heat-temp = <600>;
 			maxim,over-volt = <4300>;
-- 
2.30.2



