Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99EB910170A
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730828AbfKSFqa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:46:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:42604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730837AbfKSFq3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:46:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D917B2071B;
        Tue, 19 Nov 2019 05:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142388;
        bh=wa7YDgehiZ0AGsCxw7mUn8MD6uR/Hfws7/JZg4+w6Mg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mCJacPezY2BLytjf0SLHRY8ehkaJ6Tf++ts7yCInZH4EFYISBqaL5Viu8YlxDlx4J
         Jc/6HQlSVCc0VQpU6w6w9+ViZn5gnbDp+MSSG/+wBq6P1kA2vsPw2kwzxL52K2tPuF
         xTSO/K8QQt9ivb0dJSmFJ7KT9e8UNh1UlYlTStiQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 064/239] ARM: dts: meson8: fix the clock controller register size
Date:   Tue, 19 Nov 2019 06:17:44 +0100
Message-Id: <20191119051311.680220020@linuxfoundation.org>
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

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit f7f9da89bc4f61e33f7b9f5c75c4efdc1f0455d8 ]

The clock controller registers are not 0x460 wide because the reset
controller starts at CBUS 0x4404. This currently overlaps with the
clock controller (which is at CBUS 0x4000).

There is no public documentation available on the actual size of the
clock controller's register area (also called "HHI"). However, in
Amlogic's GPL kernel sources the last "HHI" register is
HHI_HDMI_PHY_CNTL2 at CBUS + 0x43a8. 0x400 was chosen because that size
doesn't seem unlikely.

Fixes: 2c323c43a3d619 ("ARM: dts: meson8: add and use the real clock controller")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/meson8.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/meson8.dtsi b/arch/arm/boot/dts/meson8.dtsi
index b98d44fde6b60..e3ae85d65b39b 100644
--- a/arch/arm/boot/dts/meson8.dtsi
+++ b/arch/arm/boot/dts/meson8.dtsi
@@ -170,7 +170,7 @@
 		#clock-cells = <1>;
 		#reset-cells = <1>;
 		compatible = "amlogic,meson8-clkc";
-		reg = <0x8000 0x4>, <0x4000 0x460>;
+		reg = <0x8000 0x4>, <0x4000 0x400>;
 	};
 
 	pwm_ef: pwm@86c0 {
-- 
2.20.1



