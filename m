Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45EB549A026
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1841972AbiAXXA3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:00:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1835837AbiAXWhj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:37:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59DADC054854;
        Mon, 24 Jan 2022 12:59:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 221D8B81243;
        Mon, 24 Jan 2022 20:59:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EEE2C36AE9;
        Mon, 24 Jan 2022 20:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057956;
        bh=m1F5fWtgDM8E6XKmaqCuV0mNrGXhTgIpzHKN+ItcTok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rRtcMcj+ydkrlBppQcJfJa1tdZBAnZGY6/4Tnckg+uypoMOwCn+FZ4wUlHTpfKqeK
         1eqxyaalIh93Bn2nfC4+MIrgKfMd9N37qVk4qbj8l6Clbfvo6sr6YPSIfqQ/FdUAQz
         jtKf7/+KnmY/ovREVzYIHEuIsDDzUn8cYcyFv2eM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Hewitt <christianshewitt@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0135/1039] arm64: dts: meson-gxbb-wetek: fix HDMI in early boot
Date:   Mon, 24 Jan 2022 19:32:04 +0100
Message-Id: <20220124184129.707355171@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Hewitt <christianshewitt@gmail.com>

[ Upstream commit 8182a35868db5f053111d5d9d4da8fcb3f99259d ]

Mark the VDDIO_AO18 regulator always-on and set hdmi-supply for the hdmi_tx
node to ensure HDMI is powered in the early stages of boot.

Fixes: fb72c03e0e32 ("ARM64: dts: meson-gxbb-wetek: add a wetek specific dtsi to cleanup hub and play2")

Signed-off-by: Christian Hewitt <christianshewitt@gmail.com>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://lore.kernel.org/r/20211012052522.30873-2-christianshewitt@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-gxbb-wetek.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb-wetek.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxbb-wetek.dtsi
index a350fee1264d7..8e2af986cebaf 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxbb-wetek.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxbb-wetek.dtsi
@@ -64,6 +64,7 @@
 		regulator-name = "VDDIO_AO18";
 		regulator-min-microvolt = <1800000>;
 		regulator-max-microvolt = <1800000>;
+		regulator-always-on;
 	};
 
 	vcc_3v3: regulator-vcc_3v3 {
@@ -161,6 +162,7 @@
 	status = "okay";
 	pinctrl-0 = <&hdmi_hpd_pins>, <&hdmi_i2c_pins>;
 	pinctrl-names = "default";
+	hdmi-supply = <&vddio_ao18>;
 };
 
 &hdmi_tx_tmds_port {
-- 
2.34.1



