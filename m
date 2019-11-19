Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68AF91017E6
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbfKSFhe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:37:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:59370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729163AbfKSFhb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:37:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8302821783;
        Tue, 19 Nov 2019 05:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141851;
        bh=5UlIQR2DCq+pOvDPurmJbhIK5FNedXV0/VZEjZx8hAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rhzauzkDPLi8fSoKziZfusqjjZBX1+Xq0tgdqf1zJC8vkZ3l9oXTY2wqZXNcyZYTJ
         ZgS5IFI1nyyrmppjwIoFdjUs4bSnIWMSY9EH+sPTygBcMPgM+aAGdpVf2ddrTiOYT0
         1bXsZy4i2NsmeCj5wOkQj26Ql8dNaMHVU7TCpXho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 301/422] ARM: dts: ux500: Fix LCDA clock line muxing
Date:   Tue, 19 Nov 2019 06:18:18 +0100
Message-Id: <20191119051418.506508118@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



