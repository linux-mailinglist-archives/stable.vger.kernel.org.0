Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3759B38A8DF
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237415AbhETKzF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:55:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:52614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239144AbhETKwV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:52:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84D0161CD1;
        Thu, 20 May 2021 10:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504818;
        bh=7EjtfTgjnZWz5ODTHWQEGkADYgCzxFgSDanAMjZISA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kpIjG+6AshwCOa/GqoOa/p3qyT3/rjcWw1swniMivN66H6/rITTb8x3HD3S6RTrpR
         cbbw41kL0XWzk3LEyBLCA4Oc5xJR9tgoglOOwbryq9lP7vdxUysz3PdRW1AO1pSWRr
         iuCZ0xAx7c2+5jy7qBqNT9cbwEsbKPBQf5bP3VUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 094/240] ARM: dts: exynos: correct PMIC interrupt trigger level on Snow
Date:   Thu, 20 May 2021 11:21:26 +0200
Message-Id: <20210520092111.849481733@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 8987efbb17c2522be8615085df9a14da2ab53d34 ]

The Maxim PMIC datasheets describe the interrupt line as active low
with a requirement of acknowledge from the CPU.  Without specifying the
interrupt type in Devicetree, kernel might apply some fixed
configuration, not necessarily working for this hardware.

Additionally, the interrupt line is shared so using level sensitive
interrupt is here especially important to avoid races.

Fixes: c61248afa819 ("ARM: dts: Add max77686 RTC interrupt to cros5250-common")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20201210212534.216197-9-krzk@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos5250-snow-common.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos5250-snow-common.dtsi b/arch/arm/boot/dts/exynos5250-snow-common.dtsi
index d5d51916bb74..b24a77781e75 100644
--- a/arch/arm/boot/dts/exynos5250-snow-common.dtsi
+++ b/arch/arm/boot/dts/exynos5250-snow-common.dtsi
@@ -280,7 +280,7 @@
 	max77686: max77686@09 {
 		compatible = "maxim,max77686";
 		interrupt-parent = <&gpx3>;
-		interrupts = <2 IRQ_TYPE_NONE>;
+		interrupts = <2 IRQ_TYPE_LEVEL_LOW>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&max77686_irq>;
 		wakeup-source;
-- 
2.30.2



