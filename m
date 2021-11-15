Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC7A450BDD
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:28:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237940AbhKORax (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:30:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:53202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238022AbhKOR2m (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:28:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0E2763289;
        Mon, 15 Nov 2021 17:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996773;
        bh=vNLmXhyTLNNbi5Y3dYGCJIfKqv7SnNYDg9AALaHo9SY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EMN+Y9YBg+lpQmF0lRMw6GTtEG1FZJeah9V+qC0nuLg9ba1vryswG4LXrh9tG/4tc
         9Z3Jynj49NsAUWmMV0kQYKo5hMvsSTUhdsjL1ZqEnmeJJkHwjzWx+oiqkZpVjye9ed
         Aftn05n1586tOYK/gs283kN4hGRqLCcDXPKACSKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil Armstrong <narmstrong@baylibre.com>,
        Anand Moon <linux.amoon@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 262/355] arm64: dts: meson-g12a: Fix the pwm regulator supply properties
Date:   Mon, 15 Nov 2021 18:03:06 +0100
Message-Id: <20211115165322.211537512@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anand Moon <linux.amoon@gmail.com>

[ Upstream commit 085675117ecf5e02c4220698fd549024ec64ad2c ]

After enabling CONFIG_REGULATOR_DEBUG=y we observe below debug logs.
Changes help link VDDCPU pwm regulator to 12V regulator supply
instead of dummy regulator.

[   11.602281] pwm-regulator regulator-vddcpu: Looking up pwm-supply property
               in node /regulator-vddcpu failed
[   11.602344] VDDCPU: supplied by regulator-dummy
[   11.602365] regulator-dummy: could not add device link regulator.11: -ENOENT
[   11.602548] VDDCPU: 721 <--> 1022 mV at 1022 mV, enabled

Fixes: e9bc0765cc12 ("arm64: dts: meson-g12a: enable DVFS on G12A boards")

Cc: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Anand Moon <linux.amoon@gmail.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://lore.kernel.org/r/20210919202918.3556-2-linux.amoon@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-g12a-sei510.dts  | 2 +-
 arch/arm64/boot/dts/amlogic/meson-g12a-u200.dts    | 2 +-
 arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12a-sei510.dts b/arch/arm64/boot/dts/amlogic/meson-g12a-sei510.dts
index c9fa23a565624..b8d9e92197ac8 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12a-sei510.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-g12a-sei510.dts
@@ -139,7 +139,7 @@
 		regulator-min-microvolt = <721000>;
 		regulator-max-microvolt = <1022000>;
 
-		vin-supply = <&dc_in>;
+		pwm-supply = <&dc_in>;
 
 		pwms = <&pwm_AO_cd 1 1250 0>;
 		pwm-dutycycle-range = <100 0>;
diff --git a/arch/arm64/boot/dts/amlogic/meson-g12a-u200.dts b/arch/arm64/boot/dts/amlogic/meson-g12a-u200.dts
index 2a324f0136e3f..02ec6eda03b1c 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12a-u200.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-g12a-u200.dts
@@ -139,7 +139,7 @@
 		regulator-min-microvolt = <721000>;
 		regulator-max-microvolt = <1022000>;
 
-		vin-supply = <&main_12v>;
+		pwm-supply = <&main_12v>;
 
 		pwms = <&pwm_AO_cd 1 1250 0>;
 		pwm-dutycycle-range = <100 0>;
diff --git a/arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts b/arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts
index c48125bf9d1e3..5209c44fda01a 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts
@@ -139,7 +139,7 @@
 		regulator-min-microvolt = <721000>;
 		regulator-max-microvolt = <1022000>;
 
-		vin-supply = <&dc_in>;
+		pwm-supply = <&dc_in>;
 
 		pwms = <&pwm_AO_cd 1 1250 0>;
 		pwm-dutycycle-range = <100 0>;
-- 
2.33.0



