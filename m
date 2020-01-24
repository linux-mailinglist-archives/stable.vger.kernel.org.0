Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFDD147BF7
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387509AbgAXJry (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:47:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:47882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387471AbgAXJrx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:47:53 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55A5920718;
        Fri, 24 Jan 2020 09:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859272;
        bh=qlfoaB1IacJcjBNthaYQgQg8gFQHjahpZSgqLwUX33o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BCL018bPNacMyQErYH5nxIa9g50hEaSQUSQiJlxXCFfPk0j/fPd/P6Uq5zIs3WaEr
         P8XQMoeL++5HHGNeTECtM92HcLSEPxaT5mqret/DuTSSHCVKUtgVSYxMLGwZTCxSwd
         IgBwu0hToJx+zGn8bK1RcKZ/3+fZraFPo9JWyRd4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Zapolskiy <vz@mleia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 082/343] ARM: dts: lpc32xx: add required clocks property to keypad device node
Date:   Fri, 24 Jan 2020 10:28:20 +0100
Message-Id: <20200124092930.727936202@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Zapolskiy <vz@mleia.com>

[ Upstream commit 3e88bc38b9f6fe4b69cecf81badd3c19fde97f97 ]

NXP LPC32xx keypad controller requires a clock property to be defined.

The change fixes the driver initialization problem:

  lpc32xx_keys 40050000.key: failed to get clock
  lpc32xx_keys: probe of 40050000.key failed with error -2

Fixes: 93898eb775e5 ("arm: dts: lpc32xx: add clock properties to device nodes")
Signed-off-by: Vladimir Zapolskiy <vz@mleia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/lpc32xx.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/lpc32xx.dtsi b/arch/arm/boot/dts/lpc32xx.dtsi
index d077bd2b9583e..2ca881055ef0e 100644
--- a/arch/arm/boot/dts/lpc32xx.dtsi
+++ b/arch/arm/boot/dts/lpc32xx.dtsi
@@ -462,6 +462,7 @@
 			key: key@40050000 {
 				compatible = "nxp,lpc3220-key";
 				reg = <0x40050000 0x1000>;
+				clocks = <&clk LPC32XX_CLK_KEY>;
 				interrupts = <54 IRQ_TYPE_LEVEL_HIGH>;
 				status = "disabled";
 			};
-- 
2.20.1



