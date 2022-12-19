Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 874A6650E54
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 16:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232693AbiLSPJu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 10:09:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232700AbiLSPJr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 10:09:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E2E626F
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 07:09:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7EE760FA8
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 15:09:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB119C433EF;
        Mon, 19 Dec 2022 15:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671462585;
        bh=rOMQyFL2a+B+0GEqQ1aZk4qF4P4itYxi8zPBVV0i2LY=;
        h=Subject:To:Cc:From:Date:From;
        b=n8DKkjiloej0lpSazLbsfbGvjoBuHvwzy/ZK+CimLQiyBfm/3r/74KajSeLiO4oof
         QU81rQR6K2szUcEDk0UR+Bk0Yn4FVPwjWn2+8inp3iUM6VeO4ZFXRzu+CUW+hRl269
         BWD53UAD7yvbwdlABdVyMPn0va2SwcM9EwwY6N9o=
Subject: FAILED: patch "[PATCH] staging: r8188eu: fix led register settings" failed to apply to 6.0-stable tree
To:     martin@kaiser.cx, gregkh@linuxfoundation.org,
        philipp.g.hortmann@gmail.com, straube.linux@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 19 Dec 2022 16:09:42 +0100
Message-ID: <1671462582158228@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

12c6223fc180 ("staging: r8188eu: fix led register settings")
647085006beb ("staging: r8188eu: don't check bSurpriseRemoved in SwLedOff")
8f60cb9534e4 ("staging: r8188eu: remove duplicate bSurpriseRemoved check")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 12c6223fc1804fd9295dc50d358294539b4a4184 Mon Sep 17 00:00:00 2001
From: Martin Kaiser <martin@kaiser.cx>
Date: Sat, 15 Oct 2022 17:11:06 +0200
Subject: [PATCH] staging: r8188eu: fix led register settings

Using an InterTech DMG-02 dongle, the led remains on when the system goes
into standby mode. After wakeup, it's no longer possible to control the
led.

It turned out that the register settings to enable or disable the led were
not correct. They worked for some dongles like the Edimax V2 but not for
others like the InterTech DMG-02.

This patch fixes the register settings. Bit 3 in the led_cfg2 register
controls the led status, bit 5 must always be set to be able to control
the led, bit 6 has no influence on the led. Setting the mac_pinmux_cfg
register is not necessary.

These settings were tested with Edimax V2 and InterTech DMG-02.

Cc: stable@vger.kernel.org
Fixes: 8cd574e6af54 ("staging: r8188eu: introduce new hal dir for RTL8188eu driver")
Suggested-by: Michael Straube <straube.linux@gmail.com>
Signed-off-by: Martin Kaiser <martin@kaiser.cx>
Tested-by: Michael Straube <straube.linux@gmail.com> # InterTech DMG-02,
Tested-by: Philipp Hortmann <philipp.g.hortmann@gmail.com> # Edimax N150
Link: https://lore.kernel.org/r/20221015151115.232095-2-martin@kaiser.cx
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/staging/r8188eu/core/rtw_led.c b/drivers/staging/r8188eu/core/rtw_led.c
index 2527c252c3e9..5b214488571b 100644
--- a/drivers/staging/r8188eu/core/rtw_led.c
+++ b/drivers/staging/r8188eu/core/rtw_led.c
@@ -31,40 +31,19 @@ static void ResetLedStatus(struct led_priv *pLed)
 
 static void SwLedOn(struct adapter *padapter, struct led_priv *pLed)
 {
-	u8	LedCfg;
-	int res;
-
 	if (padapter->bDriverStopped)
 		return;
 
-	res = rtw_read8(padapter, REG_LEDCFG2, &LedCfg);
-	if (res)
-		return;
-
-	rtw_write8(padapter, REG_LEDCFG2, (LedCfg & 0xf0) | BIT(5) | BIT(6)); /*  SW control led0 on. */
+	rtw_write8(padapter, REG_LEDCFG2, BIT(5)); /*  SW control led0 on. */
 	pLed->bLedOn = true;
 }
 
 static void SwLedOff(struct adapter *padapter, struct led_priv *pLed)
 {
-	u8	LedCfg;
-	int res;
-
 	if (padapter->bDriverStopped)
 		goto exit;
 
-	res = rtw_read8(padapter, REG_LEDCFG2, &LedCfg);/* 0x4E */
-	if (res)
-		goto exit;
-
-	LedCfg &= 0x90; /*  Set to software control. */
-	rtw_write8(padapter, REG_LEDCFG2, (LedCfg | BIT(3)));
-	res = rtw_read8(padapter, REG_MAC_PINMUX_CFG, &LedCfg);
-	if (res)
-		goto exit;
-
-	LedCfg &= 0xFE;
-	rtw_write8(padapter, REG_MAC_PINMUX_CFG, LedCfg);
+	rtw_write8(padapter, REG_LEDCFG2, BIT(5) | BIT(3));
 exit:
 	pLed->bLedOn = false;
 }

