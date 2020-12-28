Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9C02E4129
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439906AbgL1OMh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:12:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:46870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439901AbgL1OMg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:12:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5410207B2;
        Mon, 28 Dec 2020 14:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164741;
        bh=xkVwTlQKoeBRjRMfMVMMsBVDaghygZpptWfyJFmZItM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UXsr3rrD3pJfr99yI9O3QNwBYM27nsGOqt6W4YihfjvOQ7vb+/kvLsmTQndCBbE0h
         HbBbBiOPSazzQqSGr+XbLBCKXYRo2sP2SjBUvp17eNqvzbzziAKi3btC6fcfzAxjC2
         nTDtyrdluiBle8lMGLA45RKeuJ6QQV4+vP4eTBv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 250/717] ARM: dts: at91: at91sam9rl: fix ADC triggers
Date:   Mon, 28 Dec 2020 13:44:08 +0100
Message-Id: <20201228125032.965028511@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit 851a95da583c26e2ddeb7281e9b61f0d76ea5aba ]

The triggers for the ADC were taken from at91sam9260 dtsi but are not
correct.

Fixes: a4c1d6c75822 ("ARM: at91/dt: sam9rl: add lcd, adc, usb gadget and pwm support")
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20201128222818.1910764-10-alexandre.belloni@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/at91sam9rl.dtsi | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9rl.dtsi b/arch/arm/boot/dts/at91sam9rl.dtsi
index 5653e70c84b4b..36a42a9fe1957 100644
--- a/arch/arm/boot/dts/at91sam9rl.dtsi
+++ b/arch/arm/boot/dts/at91sam9rl.dtsi
@@ -282,23 +282,26 @@
 				atmel,adc-use-res = "highres";
 
 				trigger0 {
-					trigger-name = "timer-counter-0";
+					trigger-name = "external-rising";
 					trigger-value = <0x1>;
+					trigger-external;
 				};
+
 				trigger1 {
-					trigger-name = "timer-counter-1";
-					trigger-value = <0x3>;
+					trigger-name = "external-falling";
+					trigger-value = <0x2>;
+					trigger-external;
 				};
 
 				trigger2 {
-					trigger-name = "timer-counter-2";
-					trigger-value = <0x5>;
+					trigger-name = "external-any";
+					trigger-value = <0x3>;
+					trigger-external;
 				};
 
 				trigger3 {
-					trigger-name = "external";
-					trigger-value = <0x13>;
-					trigger-external;
+					trigger-name = "continuous";
+					trigger-value = <0x6>;
 				};
 			};
 
-- 
2.27.0



