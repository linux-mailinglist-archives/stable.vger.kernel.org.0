Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1265F49E9DE
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 19:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245120AbiA0SKd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 13:10:33 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47406 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244907AbiA0SKJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 13:10:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7B7661CFD;
        Thu, 27 Jan 2022 18:10:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F8BC340E8;
        Thu, 27 Jan 2022 18:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643307008;
        bh=EFpcAwDpY+fz2EowNsF/nN0eEBu6yVeazj+LOb5Thsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vgr4O2upQp31dSJL0JUoIDY5GHljGkINR3tZxX8f1cWEtWExVasP9VIy5ULG2Bgj3
         zcy/juzXbCUiaTy+5NWHcgG220gzpMAUqHGSWzOhapbtPDwgxpOhmvaFsboMywDfyN
         eXb98HGG4Rx8LtwbLW9Rk24T9z9LcHy5xa9Z2oD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jan Kiszka <jan.kiszka@web.de>,
        Phil Elwell <phil@raspberrypi.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH 5.4 09/11] ARM: dts: gpio-ranges property is now required
Date:   Thu, 27 Jan 2022 19:09:10 +0100
Message-Id: <20220127180258.672040734@linuxfoundation.org>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220127180258.362000607@linuxfoundation.org>
References: <20220127180258.362000607@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phil Elwell <phil@raspberrypi.com>

commit c8013355ead68dce152cf426686f8a5f80d88b40 upstream

Since [1], added in 5.7, the absence of a gpio-ranges property has
prevented GPIOs from being restored to inputs when released.
Add those properties for BCM283x and BCM2711 devices.

[1] commit 2ab73c6d8323 ("gpio: Support GPIO controllers without
    pin-ranges")

Link: https://lore.kernel.org/r/20220104170247.956760-1-linus.walleij@linaro.org
Fixes: 2ab73c6d8323 ("gpio: Support GPIO controllers without pin-ranges")
Fixes: 266423e60ea1 ("pinctrl: bcm2835: Change init order for gpio hogs")
Reported-by: Stefan Wahren <stefan.wahren@i2se.com>
Reported-by: Florian Fainelli <f.fainelli@gmail.com>
Reported-by: Jan Kiszka <jan.kiszka@web.de>
Signed-off-by: Phil Elwell <phil@raspberrypi.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20211206092237.4105895-3-phil@raspberrypi.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Olof Johansson <olof@lixom.net>
[florian: Remove bcm2711.dtsi hunk which does not exist in 5.4]
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/bcm283x.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/boot/dts/bcm283x.dtsi
+++ b/arch/arm/boot/dts/bcm283x.dtsi
@@ -183,6 +183,7 @@
 
 			interrupt-controller;
 			#interrupt-cells = <2>;
+			gpio-ranges = <&gpio 0 0 54>;
 
 			/* Defines pin muxing groups according to
 			 * BCM2835-ARM-Peripherals.pdf page 102.


