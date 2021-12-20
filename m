Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15E1247ACDE
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234408AbhLTOrZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:47:25 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51966 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237023AbhLTOpV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:45:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1595AB80EE0;
        Mon, 20 Dec 2021 14:45:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A5F3C36AE9;
        Mon, 20 Dec 2021 14:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011518;
        bh=Vfl2yrApby7IcI+H+BmRslZs2lxYMUFvbIMxurJbrSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gKOlzeZpzcGgkAQiUGwxsu9nYsaWimTHpsXm3JKTVWMjtnxResmKhHj0DPhzWJKvv
         ojuK28bqCTbRW3OsYC8hrEqx0oKnAUkPH5BauUkaFhv0n3wnlRNK86FNK502orR+OU
         xe7k4PjuAUbs4zGUM9ci4fCzCKjxFvPTGFbdk6pE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maarten Brock <m.brock@vanmierlo.com>,
        Karoly Pados <pados@pados.hu>, Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 49/71] USB: serial: cp210x: fix CP2105 GPIO registration
Date:   Mon, 20 Dec 2021 15:34:38 +0100
Message-Id: <20211220143027.333115661@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143025.683747691@linuxfoundation.org>
References: <20211220143025.683747691@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 83b67041f3eaf33f98a075249aa7f4c7617c2f85 upstream.

When generalising GPIO support and adding support for CP2102N, the GPIO
registration for some CP2105 devices accidentally broke. Specifically,
when all the pins of a port are in "modem" mode, and thus unavailable
for GPIO use, the GPIO chip would now be registered without having
initialised the number of GPIO lines. This would in turn be rejected by
gpiolib and some errors messages would be printed (but importantly probe
would still succeed).

Fix this by initialising the number of GPIO lines before registering the
GPIO chip.

Note that as for the other device types, and as when all CP2105 pins are
muxed for LED function, the GPIO chip is registered also when no pins
are available for GPIO use.

Reported-by: Maarten Brock <m.brock@vanmierlo.com>
Link: https://lore.kernel.org/r/5eb560c81d2ea1a2b4602a92d9f48a89@vanmierlo.com
Fixes: c8acfe0aadbe ("USB: serial: cp210x: implement GPIO support for CP2102N")
Cc: stable@vger.kernel.org      # 4.19
Cc: Karoly Pados <pados@pados.hu>
Link: https://lore.kernel.org/r/20211126094348.31698-1-johan@kernel.org
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Tested-by: Maarten Brock <m.brock@vanmierlo.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/cp210x.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -1552,6 +1552,8 @@ static int cp2105_gpioconf_init(struct u
 
 	/*  2 banks of GPIO - One for the pins taken from each serial port */
 	if (intf_num == 0) {
+		priv->gc.ngpio = 2;
+
 		if (mode.eci == CP210X_PIN_MODE_MODEM) {
 			/* mark all GPIOs of this interface as reserved */
 			priv->gpio_altfunc = 0xff;
@@ -1562,8 +1564,9 @@ static int cp2105_gpioconf_init(struct u
 		priv->gpio_pushpull = (u8)((le16_to_cpu(config.gpio_mode) &
 						CP210X_ECI_GPIO_MODE_MASK) >>
 						CP210X_ECI_GPIO_MODE_OFFSET);
-		priv->gc.ngpio = 2;
 	} else if (intf_num == 1) {
+		priv->gc.ngpio = 3;
+
 		if (mode.sci == CP210X_PIN_MODE_MODEM) {
 			/* mark all GPIOs of this interface as reserved */
 			priv->gpio_altfunc = 0xff;
@@ -1574,7 +1577,6 @@ static int cp2105_gpioconf_init(struct u
 		priv->gpio_pushpull = (u8)((le16_to_cpu(config.gpio_mode) &
 						CP210X_SCI_GPIO_MODE_MASK) >>
 						CP210X_SCI_GPIO_MODE_OFFSET);
-		priv->gc.ngpio = 3;
 	} else {
 		return -ENODEV;
 	}


