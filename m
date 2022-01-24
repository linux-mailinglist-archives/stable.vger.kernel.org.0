Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3BF1499255
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347337AbiAXUTG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:19:06 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55932 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380162AbiAXUPt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:15:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95956B8123D;
        Mon, 24 Jan 2022 20:15:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94120C340E5;
        Mon, 24 Jan 2022 20:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055347;
        bh=m1F5fWtgDM8E6XKmaqCuV0mNrGXhTgIpzHKN+ItcTok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tWdd+uw+Knh4IBIHztfb69/O9CH/rbSSDb+kfbxU6jwNQg5vlS6/tY3RIhJbYmbPf
         GDg0q9OXspw87vmcIUt57tTTQL3oJ/V5h6n8nWz8ipBKGwzbk5mLSuQl+SKPwQMsKD
         BHy673oI07pI5Y3VyDndMojN4WsmanuEHPedNz0E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Hewitt <christianshewitt@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 122/846] arm64: dts: meson-gxbb-wetek: fix HDMI in early boot
Date:   Mon, 24 Jan 2022 19:33:59 +0100
Message-Id: <20220124184105.185170577@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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



