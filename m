Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 973F244187E
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbhKAJtK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:49:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:51098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233097AbhKAJpA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:45:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7317961214;
        Mon,  1 Nov 2021 09:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758993;
        bh=hvf9WUay1vG06lWoffWSQQ6t8GUUl6hLhQjvz5AZYwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UTtb3sZftVjyG/5SAa72vhvayc6nW9AYgdaNjzWqLo15uaD73ZnI+XK9slsjOUUmK
         2tDMYbf4tE/KWgre0JxY/cAl+afBgNRazUoyW2AjBZ+xrwASI+fjrKzQHCDQqp6SoM
         Z6ppzx4r4ilEL9/DXdQhgUo3lFTzrrKzuWR2PX1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.14 037/125] arm64: dts: imx8mm-kontron: Fix polarity of reg_rst_eth2
Date:   Mon,  1 Nov 2021 10:16:50 +0100
Message-Id: <20211101082540.197063990@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frieder Schrempf <frieder.schrempf@kontron.de>

commit 6562d6e350284307e33ea10c7f46a6661ff22770 upstream.

The regulator reg_rst_eth2 should keep the reset signal of the USB ethernet
adapter deasserted anytime. Fix the polarity and mark it as always-on.

Anyway, using the regulator is only a workaround for the missing support of
specifying a reset GPIO for USB devices in a generic way. As we don't
have a solution for this at the moment, at least fix the current
workaround.

Fixes: 8668d8b2e67f ("arm64: dts: Add the Kontron i.MX8M Mini SoMs and baseboards")
Cc: stable@vger.kernel.org
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
@@ -70,7 +70,9 @@
 		regulator-name = "rst-usb-eth2";
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_usb_eth2>;
-		gpio = <&gpio3 2 GPIO_ACTIVE_LOW>;
+		gpio = <&gpio3 2 GPIO_ACTIVE_HIGH>;
+		enable-active-high;
+		regulator-always-on;
 	};
 
 	reg_vdd_5v: regulator-5v {


