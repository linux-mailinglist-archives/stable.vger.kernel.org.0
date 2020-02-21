Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A230F167462
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387975AbgBUIU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:20:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:60180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387967AbgBUIUy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:20:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9618206ED;
        Fri, 21 Feb 2020 08:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582273254;
        bh=XqHntQ68nAA1PkhJZLhzZ1cKTnOr9ceFKNXlAqKnqBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gEOy13192lyh9+TbIRqma+c03kp9wrd5NHQ0IiHdgoIofYJ6JnQcAQDJ2YZn79WfN
         CeoaJrW4MFCEI/FltOCZieiSHXbdd5hGlypXNuVTjw8AUcfSvMuc8p1752YjrZvG1b
         SlImB8knrHMib2GvxaDBTmBhpx0Z7ANMjopipI0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 103/191] ARM: dts: stm32: Add power-supply for DSI panel on stm32f469-disco
Date:   Fri, 21 Feb 2020 08:41:16 +0100
Message-Id: <20200221072303.347219469@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072250.732482588@linuxfoundation.org>
References: <20200221072250.732482588@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Gaignard <benjamin.gaignard@st.com>

[ Upstream commit 0ff15a86d0c5a3f004fee2e92d65b88e56a3bc58 ]

Add a fixed regulator and use it as power supply for DSI panel.

Fixes: 18c8866266 ("ARM: dts: stm32: Add display support on stm32f469-disco")

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@st.com>
Signed-off-by: Alexandre Torgue <alexandre.torgue@st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32f469-disco.dts | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/stm32f469-disco.dts b/arch/arm/boot/dts/stm32f469-disco.dts
index 3ee768cb86fc9..eea979ef5512f 100644
--- a/arch/arm/boot/dts/stm32f469-disco.dts
+++ b/arch/arm/boot/dts/stm32f469-disco.dts
@@ -75,6 +75,13 @@
 		regulator-max-microvolt = <3300000>;
 	};
 
+	vdd_dsi: vdd-dsi {
+		compatible = "regulator-fixed";
+		regulator-name = "vdd_dsi";
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+	};
+
 	soc {
 		dma-ranges = <0xc0000000 0x0 0x10000000>;
 	};
@@ -154,6 +161,7 @@
 		compatible = "orisetech,otm8009a";
 		reg = <0>; /* dsi virtual channel (0..3) */
 		reset-gpios = <&gpioh 7 GPIO_ACTIVE_LOW>;
+		power-supply = <&vdd_dsi>;
 		status = "okay";
 
 		port {
-- 
2.20.1



