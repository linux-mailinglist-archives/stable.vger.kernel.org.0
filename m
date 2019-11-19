Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B06110159D
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729316AbfKSFpm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:45:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:41390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730501AbfKSFpi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:45:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7539222A4;
        Tue, 19 Nov 2019 05:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142338;
        bh=aluBxgyG66rH0miEhxbojvxTsEkxqtA5iSpzk78LF4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xaujtmYxCHDOS6LtxC4H0PfgEdq02lCe3+vGT/54/fhhGxEZgwWD/AFlfXNQM45u7
         tXjlWadTh5TfhwUQRU+npHCAZjSTtcJZTPJkeSGyfio3uuoE/TIxU9ZyS//YIc+Tke
         YpRAHhu4QoEQFljhbgrMVTGCcALrJxfCq3CZUrR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 048/239] ARM: dts: exynos: Fix sound in Snow-rev5 Chromebook
Date:   Tue, 19 Nov 2019 06:17:28 +0100
Message-Id: <20191119051306.840109440@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 64858773d78e820003a94e5a7179d368213655d6 ]

This patch adds missing properties to the CODEC and sound nodes, so the
audio will work also on Snow rev5 Chromebook. This patch is an extension
to the commit e9eefc3f8ce0 ("ARM: dts: exynos: Add missing clock and
DAI properties to the max98095 node in Snow Chromebook")
and commit 6ab569936d60 ("ARM: dts: exynos: Enable HDMI audio on Snow
Chromebook").  It has been reported that such changes work fine on the
rev5 board too.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
[krzk: Fixed typo in phandle to &max98090]
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos5250-snow-rev5.dts | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5250-snow-rev5.dts b/arch/arm/boot/dts/exynos5250-snow-rev5.dts
index 90560c316f644..cb986175b69b4 100644
--- a/arch/arm/boot/dts/exynos5250-snow-rev5.dts
+++ b/arch/arm/boot/dts/exynos5250-snow-rev5.dts
@@ -23,6 +23,14 @@
 
 		samsung,model = "Snow-I2S-MAX98090";
 		samsung,audio-codec = <&max98090>;
+
+		cpu {
+			sound-dai = <&i2s0 0>;
+		};
+
+		codec {
+			sound-dai = <&max98090 0>, <&hdmi>;
+		};
 	};
 };
 
@@ -34,6 +42,9 @@
 		interrupt-parent = <&gpx0>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&max98090_irq>;
+		clocks = <&pmu_system_controller 0>;
+		clock-names = "mclk";
+		#sound-dai-cells = <1>;
 	};
 };
 
-- 
2.20.1



