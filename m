Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6319929C260
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1762189AbgJ0Rbc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:31:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:41516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2899416AbgJ0OmA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:42:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1385420773;
        Tue, 27 Oct 2020 14:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809719;
        bh=95HFYb+janRGtB6F7zuGEo2ExcIBnvjQ2yxvuyWyvZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A6ydMhLTbiuNq7TmyyzOQmB2mTYObSW99ZDLohpk69pt7LZmcXZ1aIBAIMLBjhlxI
         zgTy/GS8FNsO2vyaPwKoFrhLjugtxrbIf0srSzRXXTIw9vq0towiPwLyuSjb/ApROE
         Sy16FPCd/DPlQgzntG9ycTAreFqc6EJeX0kCcGdo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 296/408] ARM: dts: imx6sl: fix rng node
Date:   Tue, 27 Oct 2020 14:53:54 +0100
Message-Id: <20201027135508.771652408@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Horia Geantă <horia.geanta@nxp.com>

[ Upstream commit 82ffb35c2ce63ef8e0325f75eb48022abcf8edbe ]

rng DT node was added without a compatible string.

i.MX driver for RNGC (drivers/char/hw_random/imx-rngc.c) also claims
support for RNGB, and is currently used for i.MX25.

Let's use this driver also for RNGB block in i.MX6SL.

Fixes: e29fe21cff96 ("ARM: dts: add device tree source for imx6sl SoC")
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6sl.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/imx6sl.dtsi b/arch/arm/boot/dts/imx6sl.dtsi
index 3a96b5538a2a1..540880f0413fd 100644
--- a/arch/arm/boot/dts/imx6sl.dtsi
+++ b/arch/arm/boot/dts/imx6sl.dtsi
@@ -936,8 +936,10 @@ memory-controller@21b0000 {
 			};
 
 			rngb: rngb@21b4000 {
+				compatible = "fsl,imx6sl-rngb", "fsl,imx25-rngb";
 				reg = <0x021b4000 0x4000>;
 				interrupts = <0 5 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&clks IMX6SL_CLK_DUMMY>;
 			};
 
 			weim: weim@21b8000 {
-- 
2.25.1



