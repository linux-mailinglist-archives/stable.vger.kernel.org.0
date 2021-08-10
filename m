Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44FF23E7FA3
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234846AbhHJRlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:41:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:43252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234150AbhHJRjw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:39:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0BC0610FD;
        Tue, 10 Aug 2021 17:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617061;
        bh=HpJ+F8ebKBDZUBOjMQ7CcFLgdG6fDfmvB4EIhCoNFik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qj8NVxFrkusNO4cE57BeCilV1cYvkgbiWTBu4zKYv+CGA9tGW7/5XWahjlcut/DPw
         PGjQIqDoT1hjGWIAKJ8/hlbWTM4MrWx1smxyRO3ZdBbvfmfMxKNtkPb8A8nf27CJ40
         TsgSSgqThMcaZXKIste0BQgSSK4UR2WCUk05TVvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Patrick Delaunay <patrick.delaunay@foss.st.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 027/135] ARM: dts: stm32: Disable LAN8710 EDPD on DHCOM
Date:   Tue, 10 Aug 2021 19:29:21 +0200
Message-Id: <20210810172956.599446244@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 36862c1ebc92a7e6fcc55002965c44b8ad17d4ca ]

The LAN8710 Energy Detect Power Down (EDPD) functionality might cause
unreliable cable detection. There are multiple accounts of this in the
SMSC PHY driver patches which attempted to make EDPD reliable, however
it seems there is always some sort of corner case left. Unfortunatelly,
there is no errata documented which would confirm this to be a silicon
bug on the LAN87xx series of PHYs (LAN8700, LAN8710, LAN8720 at least).

Disable EDPD on the DHCOM SoM, just like multiple other boards already
do as well, to make the cable detection reliable.

Fixes: 34e0c7847dcf ("ARM: dts: stm32: Add DH Electronics DHCOM STM32MP1 SoM and PDK2 board")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Patrice Chotard <patrice.chotard@foss.st.com>
Cc: Patrick Delaunay <patrick.delaunay@foss.st.com>
Cc: linux-stm32@st-md-mailman.stormreply.com
To: linux-arm-kernel@lists.infradead.org
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi b/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi
index 8221bf69fefe..000af7177701 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi
@@ -133,6 +133,7 @@
 			reset-gpios = <&gpioh 3 GPIO_ACTIVE_LOW>;
 			reset-assert-us = <500>;
 			reset-deassert-us = <500>;
+			smsc,disable-energy-detect;
 			interrupt-parent = <&gpioi>;
 			interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
 		};
-- 
2.30.2



