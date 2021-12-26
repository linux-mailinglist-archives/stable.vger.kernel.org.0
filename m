Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E66647F8C4
	for <lists+stable@lfdr.de>; Sun, 26 Dec 2021 21:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbhLZUI2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Dec 2021 15:08:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbhLZUI2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Dec 2021 15:08:28 -0500
X-Greylist: delayed 733 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 26 Dec 2021 12:08:27 PST
Received: from viti.kaiser.cx (viti.kaiser.cx [IPv6:2a01:238:43fe:e600:cd0c:bd4a:7a3:8e9f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB19C06173E
        for <stable@vger.kernel.org>; Sun, 26 Dec 2021 12:08:27 -0800 (PST)
Received: from dslb-188-097-047-111.188.097.pools.vodafone-ip.de ([188.97.47.111] helo=martin-debian-2.paytec.ch)
        by viti.kaiser.cx with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <martin@kaiser.cx>)
        id 1n1Zcn-0000Fz-MX; Sun, 26 Dec 2021 20:56:09 +0100
From:   Martin Kaiser <martin@kaiser.cx>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Larry Finger <Larry.Finger@lwfinger.net>,
        Phillip Potter <phil@philpotter.co.uk>,
        Michael Straube <straube.linux@gmail.com>,
        linux-staging@lists.linux.dev, linux-kernel@vger.kernel.org,
        Martin Kaiser <martin@kaiser.cx>, stable@vger.kernel.org
Subject: [PATCH 01/21] staging: r8188eu: switch the led off during deinit
Date:   Sun, 26 Dec 2021 20:55:36 +0100
Message-Id: <20211226195556.159471-2-martin@kaiser.cx>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211226195556.159471-1-martin@kaiser.cx>
References: <20211226195556.159471-1-martin@kaiser.cx>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When the driver is unloaded or when the system goes into standby mode,
DeInitLed871x is called to stop the led layer. In this case, we stop
the blinking worker but we do not switch the led off explicitly. On my
system, I can go into standby mode with the LED enabled.

Add a call to SwLedOff to fix this.

Cc: stable@vger.kernel.org
Fixes: 15865124feed ("staging: r8188eu: introduce new core dir for RTL8188eu driver")
Signed-off-by: Martin Kaiser <martin@kaiser.cx>
---
 drivers/staging/r8188eu/core/rtw_led.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/r8188eu/core/rtw_led.c b/drivers/staging/r8188eu/core/rtw_led.c
index e1be1ba189cb..25fab7bce7dc 100644
--- a/drivers/staging/r8188eu/core/rtw_led.c
+++ b/drivers/staging/r8188eu/core/rtw_led.c
@@ -41,6 +41,7 @@ void DeInitLed871x(struct LED_871x *pLed)
 {
 	cancel_delayed_work_sync(&pLed->blink_work);
 	ResetLedStatus(pLed);
+	SwLedOff(pLed->padapter, pLed);
 }
 
 static void SwLedBlink1(struct LED_871x *pLed)
-- 
2.30.2

