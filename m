Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F36F729BEB3
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1814497AbgJ0Q4g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:56:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:47264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1794353AbgJ0PLZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:11:25 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 457AF20657;
        Tue, 27 Oct 2020 15:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811484;
        bh=INZga2ZUpoVs+ZrcWWqAdpisOiUGM/5WS6wpVM+ZhA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZwemQyh+rLWqpSDvkmLY6oT3CaKgun0EzGqno6OZnAbsoiF4uR2C5ADaqjtXMT5Ek
         dMuccQi32bSeuVxNAymKhcgX1A3zpIa78JbDbmcLTWttVDudmTiZ45k+LmyJ5dLLqG
         xtzk/QEULYjndIxWGY5zFViUwxVq/KYtIB6fY81w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Holger Assmann <h.assmann@pengutronix.de>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 508/633] ARM: dts: stm32: lxa-mc1: Fix kernel warning about PHY delays
Date:   Tue, 27 Oct 2020 14:54:11 +0100
Message-Id: <20201027135546.566236413@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Holger Assmann <h.assmann@pengutronix.de>

[ Upstream commit 42a31ac6698681363363d48335559d212a26a7ca ]

The KSZ9031 PHY skew timings for rxc/txc, originally set to achieve
the desired phase shift between clock- and data-signal, now trigger a
kernel warning when used in rgmii-id mode:

 *-skew-ps values should be used only with phy-mode = "rgmii"

This is because commit bcf3440c6dd7 ("net: phy: micrel: add phy-mode
support for the KSZ9031 PHY") now configures own timings when
phy-mode = "rgmii-id". Device trees wanting to set their own delays
should use phy-mode "rgmii" instead as the warning prescribes.

The "standard" timings now used with "rgmii-id" work fine on this
board, so drop the explicit timings in the device tree and thereby
silence the warning.

Fixes: 666b5ca85cd3 ("ARM: dts: stm32: add STM32MP1-based Linux Automation MC-1 board")
Signed-off-by: Holger Assmann <h.assmann@pengutronix.de>
Acked-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Signed-off-by: Alexandre Torgue <alexandre.torgue@st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp157c-lxa-mc1.dts | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/boot/dts/stm32mp157c-lxa-mc1.dts b/arch/arm/boot/dts/stm32mp157c-lxa-mc1.dts
index 5700e6b700d36..b85025d009437 100644
--- a/arch/arm/boot/dts/stm32mp157c-lxa-mc1.dts
+++ b/arch/arm/boot/dts/stm32mp157c-lxa-mc1.dts
@@ -121,8 +121,6 @@ ethphy: ethernet-phy@3 { /* KSZ9031RN */
 			reset-gpios = <&gpiog 0 GPIO_ACTIVE_LOW>; /* ETH_RST# */
 			interrupt-parent = <&gpioa>;
 			interrupts = <6 IRQ_TYPE_EDGE_FALLING>; /* ETH_MDINT# */
-			rxc-skew-ps = <1860>;
-			txc-skew-ps = <1860>;
 			reset-assert-us = <10000>;
 			reset-deassert-us = <300>;
 			micrel,force-master;
-- 
2.25.1



