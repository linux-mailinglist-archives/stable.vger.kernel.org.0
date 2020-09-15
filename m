Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA2F526B536
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbgIOXjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:39:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:46442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727131AbgIOOfX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:35:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E943D2078D;
        Tue, 15 Sep 2020 14:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179336;
        bh=JOBJM7SW+9TZf13C2E70WE7Rn7eaY1DjfzTGwbJpfq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZqY53vx9nXi6cJQ+y8m3uN9QzJdLHu3smv93X6WT6M5StDxa9EeyxS63Vq3uLohuy
         OWZS88CN4E6kHX1pUjXb0UXLBhRaeWEzBm6hD8IEtc5tLxvWXYN4gcW0mi5DNdPouG
         czF7vEaKibocEW4VIxHY0D5LLQUI7FXno/hyqrUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Ford <aford173@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 02/78] ARM: dts: logicpd-som-lv-baseboard: Fix broken audio
Date:   Tue, 15 Sep 2020 16:12:27 +0200
Message-Id: <20200915140633.661511379@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140633.552502750@linuxfoundation.org>
References: <20200915140633.552502750@linuxfoundation.org>
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
index 3e39b9a1f35d0..0093548d50ff8 100644
--- a/arch/arm/boot/dts/logicpd-som-lv-baseboard.dtsi
+++ b/arch/arm/boot/dts/logicpd-som-lv-baseboard.dtsi
@@ -55,6 +55,8 @@
 
 &mcbsp2 {
 	status = "okay";
+	pinctrl-names = "default";
+	pinctrl-0 = <&mcbsp2_pins>;
 };
 
 &charger {
-- 
2.25.1



