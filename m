Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C02BA292584
	for <lists+stable@lfdr.de>; Mon, 19 Oct 2020 12:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729136AbgJSKSI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Oct 2020 06:18:08 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:58696 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727524AbgJSKSG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Oct 2020 06:18:06 -0400
Message-Id: <20201019101109.603244207@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603102683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=ZKsj80ymynJu9n+vKl8hANyFjBXKxoMgZSnkilPgmtg=;
        b=tl5wef45fNGo5qqku0RXIq+k+/4W5Q5pAIFBbYg5gHeiLz+rmzsYUbEI3sumMndcKnV617
        MFFwqK5RIs3GufNia1xUXF+YC1q1ts4jwtlb7Ua/wwMSvgy7787t31DxiRtl3cCt4/uhKK
        AyYnqXDkGUNL71Ex1qyWaW7moaGiflTzGR9pI75Xrvato+85LDRsR/1vSjNVORVpri1nLK
        kn/ZmQGgHXECgIAq45Z18bsJnOSfgf++dbm9svkITC3qP9gnqllazKhtNB2KZXVIJPxUDO
        oGKr0anhSRYMnEKTbl/+mqUgWEDKmzjj9foPm959CshuqF2iw/vNmXcRd1bVhg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603102683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=ZKsj80ymynJu9n+vKl8hANyFjBXKxoMgZSnkilPgmtg=;
        b=mFdIWnSa3Q+Zc90yiD08Wh2Z/poUmlh/UuAiBa7jk0GT1OVt+U/ksI8/JfrThIju7Jh6Tn
        sviYJm2vlKfOSvDA==
Date:   Mon, 19 Oct 2020 12:06:30 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Thomas Winischhofer <thomas@winischhofer.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, stable@vger.kernel.org,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Johan Hovold <johan@kernel.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-omap@vger.kernel.org, Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Duncan Sands <duncan.sands@free.fr>
Subject: [patch V2 01/13] USB: sisusbvga: Make console support depend on BROKEN
References: <20201019100629.419020859@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The console part of sisusbvga is broken vs. printk(). It uses in_atomic()
to detect contexts in which it cannot sleep despite the big fat comment in
preempt.h which says: Do not use in_atomic() in driver code.

in_atomic() does not work on kernels with CONFIG_PREEMPT_COUNT=n which
means that spin/rw_lock held regions are not detected by it.

There is no way to make this work by handing context information through to
the driver and this only can be solved once the core printk infrastructure
supports sleepable console drivers.

Make it depend on BROKEN for now.

Fixes: 1bbb4f2035d9 ("[PATCH] USB: sisusb[vga] update")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Thomas Winischhofer <thomas@winischhofer.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
Cc: stable@vger.kernel.org
---
 drivers/usb/misc/sisusbvga/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/misc/sisusbvga/Kconfig
+++ b/drivers/usb/misc/sisusbvga/Kconfig
@@ -16,7 +16,7 @@ config USB_SISUSBVGA
 
 config USB_SISUSBVGA_CON
 	bool "Text console and mode switching support" if USB_SISUSBVGA
-	depends on VT
+	depends on VT && BROKEN
 	select FONT_8x16
 	help
 	  Say Y here if you want a VGA text console via the USB dongle or

