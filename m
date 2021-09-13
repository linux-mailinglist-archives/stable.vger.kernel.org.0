Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9A14091AB
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343507AbhIMODa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:03:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:50892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245665AbhIMOB3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:01:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA0F9613A0;
        Mon, 13 Sep 2021 13:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540272;
        bh=7p23jURPt99O791M5Jh+2ov2+GWFBDqZuYrKXjjYaA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xxvlsKnb4HtBHRRRrl3pFaRGEGdCnhUvLYDNClTWG09L8gHcGzX4XvBO8I4fuK9Q3
         R42kRmtOuMcW3kWQHbHCT8OPUm2e93xov1Z2tdASTqFaO3RPniQnWuD9vk65Lu2Oce
         Wi/zrKWjaEOwzfPxbXBmPqbR61zQE04vcG8phJvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Anand Moon <linux.amoon@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 123/300] ARM: dts: meson8b: mxq: Fix the pwm regulator supply properties
Date:   Mon, 13 Sep 2021 15:13:04 +0200
Message-Id: <20210913131113.554716214@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anand Moon <linux.amoon@gmail.com>

[ Upstream commit 632062e540becbbcb067523ec8bcadb1239d9578 ]

After enabling CONFIG_REGULATOR_DEBUG=y we observer below debug logs.
Changes help link VCCK and VDDEE pwm regulator to 5V regulator supply
instead of dummy regulator.
Add missing pwm-supply for regulator-vcck regulator node.

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

Fixes: dee51cd0d2e8 ("ARM: dts: meson8b: mxq: add the VDDEE regulator")
Fixes: d94f60e3dfa0 ("ARM: dts: meson8b: mxq: improve support for the TRONFY MXQ S805")

Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Anand Moon <linux.amoon@gmail.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://lore.kernel.org/r/20210705112358.3554-3-linux.amoon@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/meson8b-mxq.dts | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/meson8b-mxq.dts b/arch/arm/boot/dts/meson8b-mxq.dts
index f3937d55472d..7adedd3258c3 100644
--- a/arch/arm/boot/dts/meson8b-mxq.dts
+++ b/arch/arm/boot/dts/meson8b-mxq.dts
@@ -34,6 +34,8 @@
 		regulator-min-microvolt = <860000>;
 		regulator-max-microvolt = <1140000>;
 
+		pwm-supply = <&vcc_5v>;
+
 		pwms = <&pwm_cd 0 1148 0>;
 		pwm-dutycycle-range = <100 0>;
 
@@ -79,7 +81,7 @@
 		regulator-min-microvolt = <860000>;
 		regulator-max-microvolt = <1140000>;
 
-		vin-supply = <&vcc_5v>;
+		pwm-supply = <&vcc_5v>;
 
 		pwms = <&pwm_cd 1 1148 0>;
 		pwm-dutycycle-range = <100 0>;
-- 
2.30.2



