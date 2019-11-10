Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8D5F6521
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727654AbfKJDEl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 22:04:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:51020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729167AbfKJCqr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:46:47 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DEC12184C;
        Sun, 10 Nov 2019 02:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354006;
        bh=5UlIQR2DCq+pOvDPurmJbhIK5FNedXV0/VZEjZx8hAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D3g/gIeOLJQbSyK632lPjok8x4o4AB7GRqdhLhNwrPs63bs+6Is8pE8hnoR351TSM
         C4hc/F/rCkQpwr6DcHPM9rNYWD/xdRPkgIuONMGcEnJaGbVn7yzwYgwozMGql6bXw1
         QHauj68ogxGk9E+3HOA9LyKhohF3xML2IqW8NkPM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 033/109] ARM: dts: ux500: Fix LCDA clock line muxing
Date:   Sat,  9 Nov 2019 21:44:25 -0500
Message-Id: <20191110024541.31567-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024541.31567-1-sashal@kernel.org>
References: <20191110024541.31567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit ecde29569e3484e1d0a032bf4074449bce4d4a03 ]

The "lcdaclk_b_1" group is muxed with the function "lcd"
but needs a separate entry to be muxed in with "lcda"
rather than "lcd".

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ste-href-family-pinctrl.dtsi | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/ste-href-family-pinctrl.dtsi b/arch/arm/boot/dts/ste-href-family-pinctrl.dtsi
index 5c5cea232743d..1ec193b0c5065 100644
--- a/arch/arm/boot/dts/ste-href-family-pinctrl.dtsi
+++ b/arch/arm/boot/dts/ste-href-family-pinctrl.dtsi
@@ -607,16 +607,20 @@
 
 			mcde {
 				lcd_default_mode: lcd_default {
-					default_mux {
+					default_mux1 {
 						/* Mux in VSI0 and all the data lines */
 						function = "lcd";
 						groups =
 						"lcdvsi0_a_1", /* VSI0 for LCD */
 						"lcd_d0_d7_a_1", /* Data lines */
 						"lcd_d8_d11_a_1", /* TV-out */
-						"lcdaclk_b_1", /* Clock line for TV-out */
 						"lcdvsi1_a_1"; /* VSI1 for HDMI */
 					};
+					default_mux2 {
+						function = "lcda";
+						groups =
+						"lcdaclk_b_1"; /* Clock line for TV-out */
+					};
 					default_cfg1 {
 						pins =
 						"GPIO68_E1", /* VSI0 */
-- 
2.20.1

