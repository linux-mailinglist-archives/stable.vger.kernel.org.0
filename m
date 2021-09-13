Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5D4B409462
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344521AbhIMObD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:31:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:51398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344913AbhIMO2z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:28:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C052C61222;
        Mon, 13 Sep 2021 13:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541019;
        bh=KWFsqBbIs5pST8Bg0og/xu5TdkZ5tEdPMQEWAV43vV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V8UjSR7m5ppHVkssc3if439cp9FomtY8kOzWnmctHet9yE8LA7BtjJ3G36sU5lCz9
         1jYPr7r7Ox9bxJD4cSzx8mONidBzZ5pEMgz13KEcDh2D9Rpa3lLgHrYT8NagbUn0xI
         Cipntnbkb8DeI+rXmWr/BQTa+E+1IucuN79B+paU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Anand Moon <linux.amoon@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 128/334] ARM: dts: meson8b: odroidc1: Fix the pwm regulator supply properties
Date:   Mon, 13 Sep 2021 15:13:02 +0200
Message-Id: <20210913131117.697027425@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anand Moon <linux.amoon@gmail.com>

[ Upstream commit 876228e9f935f19c7afc7ba394d17e2ec9143b65 ]

After enabling CONFIG_REGULATOR_DEBUG=y we observe below debug logs.
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

Fixes: 524d96083b66 ("ARM: dts: meson8b: odroidc1: add the CPU voltage regulator")
Fixes: 8bdf38be712d ("ARM: dts: meson8b: odroidc1: add the VDDEE regulator")

Tested-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Anand Moon <linux.amoon@gmail.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
[narmstrong: fixed typo in commit s/observer/observe/]
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://lore.kernel.org/r/20210705112358.3554-2-linux.amoon@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/meson8b-odroidc1.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/meson8b-odroidc1.dts b/arch/arm/boot/dts/meson8b-odroidc1.dts
index c440ef94e082..04356bc639fa 100644
--- a/arch/arm/boot/dts/meson8b-odroidc1.dts
+++ b/arch/arm/boot/dts/meson8b-odroidc1.dts
@@ -131,7 +131,7 @@
 		regulator-min-microvolt = <860000>;
 		regulator-max-microvolt = <1140000>;
 
-		vin-supply = <&p5v0>;
+		pwm-supply = <&p5v0>;
 
 		pwms = <&pwm_cd 0 12218 0>;
 		pwm-dutycycle-range = <91 0>;
@@ -163,7 +163,7 @@
 		regulator-min-microvolt = <860000>;
 		regulator-max-microvolt = <1140000>;
 
-		vin-supply = <&p5v0>;
+		pwm-supply = <&p5v0>;
 
 		pwms = <&pwm_cd 1 12218 0>;
 		pwm-dutycycle-range = <91 0>;
-- 
2.30.2



