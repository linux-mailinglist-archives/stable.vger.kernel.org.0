Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8AAB26B6F9
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbgIPAOh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:14:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:37093 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726923AbgIOOYz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:24:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5622A223FB;
        Tue, 15 Sep 2020 14:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179536;
        bh=bVSvRP7SZUwKmiBBHeXufbbS6lduYbTr2ANmIMAqUXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dN5heVvos9fmof90pioaIVwkD1TVugZATYZ86nJLLwjJi0aPL1k8lGUogygmtyvF0
         FEkNSJrxevPHe6Tu/rilOEUF9+eVfMp2XZomDK47Ht5LKNXUfYdlvtqc/cSaucRdg4
         rBOqr9iOBWiQhBTNi4In+IzqyhLjEYGYZ7JZkmwY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Ford <aford173@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 002/132] ARM: dts: logicpd-som-lv-baseboard: Fix broken audio
Date:   Tue, 15 Sep 2020 16:11:44 +0200
Message-Id: <20200915140644.197061703@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140644.037604909@linuxfoundation.org>
References: <20200915140644.037604909@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Ford <aford173@gmail.com>

[ Upstream commit 4d26e9a028e3d88223e06fa133c3d55af7ddbceb ]

Older versions of U-Boot would pinmux the whole board, but as
the bootloader got updated, it started to only pinmux the pins
it needed, and expected Linux to configure what it needed.

Unfortunately this caused an issue with the audio, because the
mcbsp2 pins were configured in the device tree but never
referenced by the driver. When U-Boot stopped muxing the audio
pins, the audio died.

This patch adds the references to the associate the pin controller
with the mcbsp2 driver which makes audio operate again.

Fixes: 5cb8b0fa55a9 ("ARM: dts: Move most of logicpd-som-lv-37xx-devkit.dts to logicpd-som-lv-baseboard.dtsi")

Signed-off-by: Adam Ford <aford173@gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/logicpd-som-lv-baseboard.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/logicpd-som-lv-baseboard.dtsi b/arch/arm/boot/dts/logicpd-som-lv-baseboard.dtsi
index 100396f6c2feb..c310c33ca6f3f 100644
--- a/arch/arm/boot/dts/logicpd-som-lv-baseboard.dtsi
+++ b/arch/arm/boot/dts/logicpd-som-lv-baseboard.dtsi
@@ -51,6 +51,8 @@
 
 &mcbsp2 {
 	status = "okay";
+	pinctrl-names = "default";
+	pinctrl-0 = <&mcbsp2_pins>;
 };
 
 &charger {
-- 
2.25.1



