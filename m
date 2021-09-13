Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F102408CE9
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239126AbhIMNWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:22:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:34852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240569AbhIMNVB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:21:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DFE7610FB;
        Mon, 13 Sep 2021 13:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539170;
        bh=WpWR6Jnd66/Sp0XYW6yeDZUwNDuCp9wHal6LvHwcmeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Dnly+11u7L6rw7uaLYCwmjZ20ZTA1xvmOVvB3raTE5tIkzFayuW1DJnPyTkwS7eT
         sLgpuN6ReM8R9a8dkQTcfaLlRlojqW2ZzJl5qdybLuABG1B3rAjQb3K2o9NCB1dZaJ
         Fi6WlnZ8s0/Jr9UKumCLPmcPDzoCNSCFS6EH4sAI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Anand Moon <linux.amoon@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 068/144] ARM: dts: meson8b: ec100: Fix the pwm regulator supply properties
Date:   Mon, 13 Sep 2021 15:14:09 +0200
Message-Id: <20210913131050.238738622@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131047.974309396@linuxfoundation.org>
References: <20210913131047.974309396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anand Moon <linux.amoon@gmail.com>

[ Upstream commit 72ccc373b064ae3ac0c5b5f2306069b60ca118df ]

After enabling CONFIG_REGULATOR_DEBUG=y we observer below debug logs.
Changes help link VCCK and VDDEE pwm regulator to 5V regulator supply
instead of dummy regulator.

[    7.117140] pwm-regulator regulator-vcck: Looking up pwm-supply from device tree
[    7.117153] pwm-regulator regulator-vcck: Looking up pwm-supply property in node /regulator-vcck failed
[    7.117184] VCCK: supplied by regulator-dummy
[    7.117194] regulator-dummy: could not add device link regulator.8: -ENOENT
[    7.117266] VCCK: 860 <--> 1140 mV at 986 mV, enabled
[    7.118498] VDDEE: will resolve supply early: pwm
[    7.118515] pwm-regulator regulator-vddee: Looking up pwm-supply from device tree
[    7.118526] pwm-regulator regulator-vddee: Looking up pwm-supply property in node /regulator-vddee failed
[    7.118553] VDDEE: supplied by regulator-dummy
[    7.118563] regulator-dummy: could not add device link regulator.9: -ENOENT

Fixes: 087a1d8b4e4c ("ARM: dts: meson8b: ec100: add the VDDEE regulator")
Fixes: 3e7db1c1b7a3 ("ARM: dts: meson8b: ec100: improve the description of the regulators")

Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Anand Moon <linux.amoon@gmail.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://lore.kernel.org/r/20210705112358.3554-4-linux.amoon@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/meson8b-ec100.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/meson8b-ec100.dts b/arch/arm/boot/dts/meson8b-ec100.dts
index bed1dfef1985..32d1c322dbc6 100644
--- a/arch/arm/boot/dts/meson8b-ec100.dts
+++ b/arch/arm/boot/dts/meson8b-ec100.dts
@@ -148,7 +148,7 @@
 		regulator-min-microvolt = <860000>;
 		regulator-max-microvolt = <1140000>;
 
-		vin-supply = <&vcc_5v>;
+		pwm-supply = <&vcc_5v>;
 
 		pwms = <&pwm_cd 0 1148 0>;
 		pwm-dutycycle-range = <100 0>;
@@ -232,7 +232,7 @@
 		regulator-min-microvolt = <860000>;
 		regulator-max-microvolt = <1140000>;
 
-		vin-supply = <&vcc_5v>;
+		pwm-supply = <&vcc_5v>;
 
 		pwms = <&pwm_cd 1 1148 0>;
 		pwm-dutycycle-range = <100 0>;
-- 
2.30.2



