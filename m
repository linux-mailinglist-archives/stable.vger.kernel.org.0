Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1536F5629
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731291AbfKHTHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:07:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:37702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391386AbfKHTHE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:07:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B68422087E;
        Fri,  8 Nov 2019 19:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573240023;
        bh=E3vOxg8kySeuRFePBSSnqG+X2RodkIAx0DqkS8qfbuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qiZJUYVZt3IqE3DbiWbE1dLwHB6P42A6eLKFsb8gA9uYgqysLH6IH/V4Ezdw14vY8
         FNE2AdU2HNV5tif8NvF06EHmdAUYmRlKjv9l3cmUKQtvz1iD44EbX3mOK2t3GU3kPX
         NVo6wsgRRLWQZ77dgi06/7cHagXWu8+TpVfKQ3Ps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fredrik Yhlen <fredrik.yhlen@endian.se>,
        Stefan Wahren <wahrenst@gmx.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 061/140] ARM: dts: bcm2837-rpi-cm3: Avoid leds-gpio probing issue
Date:   Fri,  8 Nov 2019 19:49:49 +0100
Message-Id: <20191108174909.098848717@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



