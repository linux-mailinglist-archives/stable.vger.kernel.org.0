Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D888F37C7D5
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236294AbhELQCq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:02:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:36416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238058AbhELP5N (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:57:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CEF261C2E;
        Wed, 12 May 2021 15:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833386;
        bh=PBlvU4EiqU0lF6uDNw9+mxI5aZhdAzvgpone1Y59t5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BCYlFMZW1jVIs5ibhJ75QahaHC4FxsSK/FG8D5K6cMkZYT65CNEEGDxMlGC3HhE6l
         LWmqhu5AsBa9H/55uW64aF2VCoeoivoMCtia8vgaNxSO7Qw+t3EYyArL6UAPRzU9jI
         4+h+uDSLUmZXN40keivQ0W8z88tFnDcdhDlToewk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 129/601] ARM: dts: exynos: correct fuel gauge interrupt trigger level on GT-I9100
Date:   Wed, 12 May 2021 16:43:26 +0200
Message-Id: <20210512144832.073332835@linuxfoundation.org>
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

[ Upstream commit 46799802136670e00498f19898f1635fbc85f583 ]

The Maxim fuel gauge datasheets describe the interrupt line as active
low with a requirement of acknowledge from the CPU.  The falling edge
interrupt will mostly work but it's not correct.

Fixes: 8620cc2f99b7 ("ARM: dts: exynos: Add devicetree file for the Galaxy S2")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20201210212534.216197-1-krzk@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos4210-i9100.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos4210-i9100.dts b/arch/arm/boot/dts/exynos4210-i9100.dts
index a0c3bab382ae..e56b64e237d3 100644
--- a/arch/arm/boot/dts/exynos4210-i9100.dts
+++ b/arch/arm/boot/dts/exynos4210-i9100.dts
@@ -136,7 +136,7 @@
 			compatible = "maxim,max17042";
 
 			interrupt-parent = <&gpx2>;
-			interrupts = <3 IRQ_TYPE_EDGE_FALLING>;
+			interrupts = <3 IRQ_TYPE_LEVEL_LOW>;
 
 			pinctrl-0 = <&max17042_fuel_irq>;
 			pinctrl-names = "default";
-- 
2.30.2



