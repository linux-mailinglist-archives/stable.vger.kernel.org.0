Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F381BEA026
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 16:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728256AbfJ3Px6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:53:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:55314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728255AbfJ3Px5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:53:57 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B472208C0;
        Wed, 30 Oct 2019 15:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450837;
        bh=E3vOxg8kySeuRFePBSSnqG+X2RodkIAx0DqkS8qfbuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mZiQP7R5gt4XxMdspHK+JSyzSn5gjSZYkkzATZboeLo/ODwmV3joCUBULKca0hZ6D
         W1G9kMSKuHEkTcka2wKBStQdmdHQDHzj4tcl7HSi4WO4i7LnkxbDjpGsS6+OCY3W8h
         UXmyjgrbggBASrus/FFCvaafDZqsb7tFGBdV3w18=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefan Wahren <wahrenst@gmx.net>,
        Fredrik Yhlen <fredrik.yhlen@endian.se>,
        Linus Walleij <linus.walleij@linaro.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 62/81] ARM: dts: bcm2837-rpi-cm3: Avoid leds-gpio probing issue
Date:   Wed, 30 Oct 2019 11:49:08 -0400
Message-Id: <20191030154928.9432-62-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030154928.9432-1-sashal@kernel.org>
References: <20191030154928.9432-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit 626c45d223e22090511acbfb481e0ece1de1356d ]

bcm2835-rpi.dtsi defines the behavior of the ACT LED, which is available
on all Raspberry Pi boards. But there is no driver for this particual
GPIO on CM3 in mainline yet, so this node was left incomplete without
the actual GPIO definition. Since commit 025bf37725f1 ("gpio: Fix return
value mismatch of function gpiod_get_from_of_node()") this causing probe
issues of the leds-gpio driver for users of the CM3 dtsi file.

  leds-gpio: probe of leds failed with error -2

Until we have the necessary GPIO driver hide the ACT node for CM3
to avoid this.

Reported-by: Fredrik Yhlen <fredrik.yhlen@endian.se>
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Fixes: a54fe8a6cf66 ("ARM: dts: add Raspberry Pi Compute Module 3 and IO board")
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm2837-rpi-cm3.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/bcm2837-rpi-cm3.dtsi b/arch/arm/boot/dts/bcm2837-rpi-cm3.dtsi
index 81399b2c5af9e..d4f0e455612d4 100644
--- a/arch/arm/boot/dts/bcm2837-rpi-cm3.dtsi
+++ b/arch/arm/boot/dts/bcm2837-rpi-cm3.dtsi
@@ -8,6 +8,14 @@
 		reg = <0 0x40000000>;
 	};
 
+	leds {
+		/*
+		 * Since there is no upstream GPIO driver yet,
+		 * remove the incomplete node.
+		 */
+		/delete-node/ act;
+	};
+
 	reg_3v3: fixed-regulator {
 		compatible = "regulator-fixed";
 		regulator-name = "3V3";
-- 
2.20.1

