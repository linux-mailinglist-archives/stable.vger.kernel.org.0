Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 734E837CBD2
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237458AbhELQiF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:38:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:44832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236156AbhELQ22 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:28:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6ACD861457;
        Wed, 12 May 2021 15:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834991;
        bh=jWLih/kWXEOghmOP4RosI7GuLSFMduJJoALYfyg02Iw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J/MG2A3Nk2r/unF9VbbJTXomAdClmDzeSgCbsZarAjYa/mq6CFRjOLC/En95rnk3a
         B2fNV55/Qg/Fn/DPmmcw56c5i5aHONcVh6xz4q9RqmTk/LiftGUu0BpBcOfVoSoEhD
         SPVMJeyP5jIfDhx3YkxrefuOhC5vIvHxF7AXa5fk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 148/677] ARM: dts: exynos: correct MUIC interrupt trigger level on Midas family
Date:   Wed, 12 May 2021 16:43:14 +0200
Message-Id: <20210512144842.160755733@linuxfoundation.org>
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

[ Upstream commit 15107e443ab8c6cb35eff10438993e4bc944d9ae ]

The Maxim MUIC datasheets describe the interrupt line as active low
with a requirement of acknowledge from the CPU.  Without specifying the
interrupt type in Devicetree, kernel might apply some fixed
configuration, not necessarily working for this hardware.

Additionally, the interrupt line is shared so using level sensitive
interrupt is here especially important to avoid races.

Fixes: 7eec1266751b ("ARM: dts: Add Maxim 77693 PMIC to exynos4412-trats2")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20201210212534.216197-4-krzk@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos4412-midas.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos4412-midas.dtsi b/arch/arm/boot/dts/exynos4412-midas.dtsi
index b8b75dc81aa1..d75f554efde0 100644
--- a/arch/arm/boot/dts/exynos4412-midas.dtsi
+++ b/arch/arm/boot/dts/exynos4412-midas.dtsi
@@ -173,7 +173,7 @@
 		pmic@66 {
 			compatible = "maxim,max77693";
 			interrupt-parent = <&gpx1>;
-			interrupts = <5 IRQ_TYPE_EDGE_FALLING>;
+			interrupts = <5 IRQ_TYPE_LEVEL_LOW>;
 			pinctrl-names = "default";
 			pinctrl-0 = <&max77693_irq>;
 			reg = <0x66>;
-- 
2.30.2



