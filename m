Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B42A0328BE3
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240163AbhCASlz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:41:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:48296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239632AbhCASgP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:36:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 394066513B;
        Mon,  1 Mar 2021 17:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618276;
        bh=4Tt1Vg4d+TfUBsNbofEbS0TXbpw+jQIlfHw17KtA81g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TzYU5Tx9vWFLADDgPHr3xuyN0QU1vI0ZdRktRqIqNuRj8Wc6YjGBY7pk59ySQOuCR
         jjZVY2y5dLhQT27EnDkxSaGa2Rr7UhMOJqK2hiZ+D8GfJ2YnV0f8GWOVhSt0btmRBc
         Wc2mAXTXrTtjCcblEuiR3L5k/AbhLjRtf7Xs9nsc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 028/663] ARM: dts: exynos: correct PMIC interrupt trigger level on Monk
Date:   Mon,  1 Mar 2021 17:04:36 +0100
Message-Id: <20210301161143.188116752@linuxfoundation.org>
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
index c1a68e6120370..7e99e5812a4d3 100644
--- a/arch/arm/boot/dts/exynos3250-monk.dts
+++ b/arch/arm/boot/dts/exynos3250-monk.dts
@@ -200,7 +200,7 @@
 	s2mps14_pmic@66 {
 		compatible = "samsung,s2mps14-pmic";
 		interrupt-parent = <&gpx0>;
-		interrupts = <7 IRQ_TYPE_NONE>;
+		interrupts = <7 IRQ_TYPE_LEVEL_LOW>;
 		reg = <0x66>;
 		wakeup-source;
 
-- 
2.27.0



