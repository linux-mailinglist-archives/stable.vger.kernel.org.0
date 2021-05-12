Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECFD37CBBC
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235940AbhELQhb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:37:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:42846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241768AbhELQ2B (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:28:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1FAE6192C;
        Wed, 12 May 2021 15:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834964;
        bh=knwDJ4o9VWGHtdo0GzgXmfFq6KFeRYtBVKask9MlZlg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LGGCDemUIcWIdKS2k8Cs8XoolzoEgDkHCRU2WO8zYOdy7kJ94a19Cmbz8HqvrCHdj
         trb36Tlm3mC4wKWCOO4eVUHT5pWJJirJ7lV9qtrw8ywcVdmjSk2Pgq6mfkhDWlUhuT
         pxMO7XSIZgNlRThUei39lQmx1n2b1xHJ3tC+ky84=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 147/677] ARM: dts: exynos: correct fuel gauge interrupt trigger level on Midas family
Date:   Wed, 12 May 2021 16:43:13 +0200
Message-Id: <20210512144842.126700364@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 8a45f33bd36efbb624198cfa9fdf1f66fd1c3d26 ]

The Maxim fuel gauge datasheets describe the interrupt line as active
low with a requirement of acknowledge from the CPU.  The falling edge
interrupt will mostly work but it's not correct.

Fixes: e8614292cd41 ("ARM: dts: Add Maxim 77693 fuel gauge node for exynos4412-trats2")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20201210212534.216197-3-krzk@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos4412-midas.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos4412-midas.dtsi b/arch/arm/boot/dts/exynos4412-midas.dtsi
index 111c32bae02c..b8b75dc81aa1 100644
--- a/arch/arm/boot/dts/exynos4412-midas.dtsi
+++ b/arch/arm/boot/dts/exynos4412-midas.dtsi
@@ -221,7 +221,7 @@
 		fuel-gauge@36 {
 			compatible = "maxim,max17047";
 			interrupt-parent = <&gpx2>;
-			interrupts = <3 IRQ_TYPE_EDGE_FALLING>;
+			interrupts = <3 IRQ_TYPE_LEVEL_LOW>;
 			pinctrl-names = "default";
 			pinctrl-0 = <&max77693_fuel_irq>;
 			reg = <0x36>;
-- 
2.30.2



