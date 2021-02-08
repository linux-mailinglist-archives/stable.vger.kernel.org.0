Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0B4B31376E
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233695AbhBHPZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:25:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:33712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233627AbhBHPTq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:19:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1921B64EE0;
        Mon,  8 Feb 2021 15:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797161;
        bh=OiuszCH8HSrbx2yYbeYbMTnhUR8hI/fj/dtKUvly0bc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XSkUdWEki6bkUALuJHqBLloRDr+sOOt5TwrlVGwIRXle2wIAHWa04SX8hXr8ljv0r
         nRMul9WsqdF+J4Q+zkF4Nl1De0O+lb7lLFRLTKFGM+i5ETRZVmDe6PvWHgY9S4EQiS
         4uHTzpE81la+HilV2HrAxSMcXGHIDTcp9MPQRq3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 014/120] ARM: OMAP1: OSK: fix ohci-omap breakage
Date:   Mon,  8 Feb 2021 16:00:01 +0100
Message-Id: <20210208145818.960942875@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 6efac0173cd15460b48c91e1b0a000379f341f00 ]

Commit 45c5775460f3 ("usb: ohci-omap: Fix descriptor conversion") tried to
fix all issues related to ohci-omap descriptor conversion, but a wrong
patch was applied, and one needed change to the OSK board file is still
missing. Fix that.

Fixes: 45c5775460f3 ("usb: ohci-omap: Fix descriptor conversion")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
[aaro.koskinen@iki.fi: rebased and updated the changelog]
Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap1/board-osk.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-omap1/board-osk.c b/arch/arm/mach-omap1/board-osk.c
index a720259099edf..0a4c9b0b13b0c 100644
--- a/arch/arm/mach-omap1/board-osk.c
+++ b/arch/arm/mach-omap1/board-osk.c
@@ -203,6 +203,8 @@ static int osk_tps_setup(struct i2c_client *client, void *context)
 	 */
 	gpio_request(OSK_TPS_GPIO_USB_PWR_EN, "n_vbus_en");
 	gpio_direction_output(OSK_TPS_GPIO_USB_PWR_EN, 1);
+	/* Free the GPIO again as the driver will request it */
+	gpio_free(OSK_TPS_GPIO_USB_PWR_EN);
 
 	/* Set GPIO 2 high so LED D3 is off by default */
 	tps65010_set_gpio_out_value(GPIO2, HIGH);
-- 
2.27.0



