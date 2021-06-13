Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0FB43A5851
	for <lists+stable@lfdr.de>; Sun, 13 Jun 2021 14:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbhFMMjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Jun 2021 08:39:01 -0400
Received: from mail-lf1-f43.google.com ([209.85.167.43]:38858 "EHLO
        mail-lf1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231733AbhFMMjA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Jun 2021 08:39:00 -0400
Received: by mail-lf1-f43.google.com with SMTP id r5so16283155lfr.5
        for <stable@vger.kernel.org>; Sun, 13 Jun 2021 05:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=psREgUUJe6MVeVSfHryr4eKsn7I0gsCysICo1D9MNkY=;
        b=JH5wSKWmYb5fhVe1bG/uxfKqWA1UBPjNfABzxFY9tykLp+HWJfq4Vr1hAYPH/aYn6f
         YwTmnfuyth8/GYhWrOTeajOxfHNh4O13WY99kvCh1HiLXmWyPb2lpvvWmprwFTwszuLE
         JxfIoPSwmQ2YpGdIMnjA5gqQwymWYM0AiBHmkqgIK4K5QAJdmUkxKzVRanFTnOrWzW/i
         PbWNSpNUzx3YEYGOXc8beqwY5ew1z952lAHLFaD/SjWiMYf4ZG7Znxn+EUpcWMJt+EJ7
         zVcW9hy9u5YUtNc5S+D83fGhOM+pRZoU7+coKulknXfcuXlZmp3mDMGPPJUEbu1W3osD
         FtUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=psREgUUJe6MVeVSfHryr4eKsn7I0gsCysICo1D9MNkY=;
        b=iagSLr3C+L2FMSCu3X8T2VbhI0hFuOuJY/oBG3uLA6cWD7lcLMNUB2X164ip08Exld
         d1OHb1g9id1Gz9jEKFin1Hp9kuWiA+hshCPbCLJCd46raYc8isTAz3ulHh+zqCqd1gv7
         MEVQO+5Vk8k2t/vRQWpQE0Ob80yAbjo94nd4W35JECMUEIrXBAqPN3fV5xuyogtT0nCM
         IoMkWsGc4UfOMRYi0fAbEhZac5TkK1l1LD4Sai7MA3dg2HuNrBUlAZ8/y1tH00foiCKg
         ykYjaX8C3bknik0qXlbbWB+cAAiDHJHf3Y0bLAJhD4czEvdDuPQ/jktggqqJ1C+i7sd4
         HZjg==
X-Gm-Message-State: AOAM531wmS4yVnCE0yVECmzlYxx6TeEEhpWUu+DcbMSuYDgI5tsn5SFe
        2iEWLpW9Bolo9CgadnrNKFxLzmm2sSVVPg==
X-Google-Smtp-Source: ABdhPJz2Y0JbGMbYbE/+wXn426tO3m18cLMYU082mkchHyLAcHeaTkSdSY0jLpX4Sk5Af+TcdGBQVw==
X-Received: by 2002:a05:6512:16a6:: with SMTP id bu38mr8659619lfb.92.1623587758885;
        Sun, 13 Jun 2021 05:35:58 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id u12sm1437103ljo.37.2021.06.13.05.35.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Jun 2021 05:35:58 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     arm@kernel.org, soc@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        stable@vger.kernel.org, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH] ARM: dts: ux500: Fix LED probing
Date:   Sun, 13 Jun 2021 14:33:56 +0200
Message-Id: <20210613123356.880933-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The Ux500 HREF LEDs have not been probing properly for a
while as this was introduce:

     ret = of_property_read_u32(np, "color", &led_color);
     if (ret)
             return ret;

Since the device tree did not define the new invented color
attribute, probe was failing.

Define color attributes for the LEDs so they work again.

Fixes: 92a81562e695 ("leds: lp55xx: Add multicolor framework support to lp55xx")
Cc: stable@vger.kernel.org
Cc: Dan Murphy <dmurphy@ti.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
SoC maintainers: please apply this directly for fixes.
---
 arch/arm/boot/dts/ste-href.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/ste-href.dtsi b/arch/arm/boot/dts/ste-href.dtsi
index 00e7d76e8656..48408fd391d6 100644
--- a/arch/arm/boot/dts/ste-href.dtsi
+++ b/arch/arm/boot/dts/ste-href.dtsi
@@ -4,6 +4,7 @@
  */
 
 #include <dt-bindings/interrupt-controller/irq.h>
+#include <dt-bindings/leds/common.h>
 #include "ste-href-family-pinctrl.dtsi"
 
 / {
@@ -69,17 +70,20 @@ chan@0 {
 					reg = <0>;
 					led-cur = /bits/ 8 <0x2f>;
 					max-cur = /bits/ 8 <0x5f>;
+					color = <LED_COLOR_ID_BLUE>;
 					linux,default-trigger = "heartbeat";
 				};
 				chan@1 {
 					reg = <1>;
 					led-cur = /bits/ 8 <0x2f>;
 					max-cur = /bits/ 8 <0x5f>;
+					color = <LED_COLOR_ID_BLUE>;
 				};
 				chan@2 {
 					reg = <2>;
 					led-cur = /bits/ 8 <0x2f>;
 					max-cur = /bits/ 8 <0x5f>;
+					color = <LED_COLOR_ID_BLUE>;
 				};
 			};
 			lp5521@34 {
@@ -93,16 +97,19 @@ chan@0 {
 					reg = <0>;
 					led-cur = /bits/ 8 <0x2f>;
 					max-cur = /bits/ 8 <0x5f>;
+					color = <LED_COLOR_ID_BLUE>;
 				};
 				chan@1 {
 					reg = <1>;
 					led-cur = /bits/ 8 <0x2f>;
 					max-cur = /bits/ 8 <0x5f>;
+					color = <LED_COLOR_ID_BLUE>;
 				};
 				chan@2 {
 					reg = <2>;
 					led-cur = /bits/ 8 <0x2f>;
 					max-cur = /bits/ 8 <0x5f>;
+					color = <LED_COLOR_ID_BLUE>;
 				};
 			};
 			bh1780@29 {
-- 
2.31.1

