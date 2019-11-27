Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E60A010BB07
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727579AbfK0VIz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:08:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:35392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732805AbfK0VIw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:08:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E70092154A;
        Wed, 27 Nov 2019 21:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888931;
        bh=rf5bjiNK4RmwS7yA3hm0aVHNlwwrZDILECWu2L2WWfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hvruRD8/YEGYpXRob+u8wQhigZ71uYmO0Asw+72/B2PRu5adtxN4PxsYNupTXXyb9
         ujfyIKEz5EUxfht3Ygb7lsUPUBQqrn33GYNbZ69pS/jsYwqOWrMOvxprZmC/2wXMIP
         GZd+cJ+Rru1KG7+BnMLlU3ICuOSBJXqjabG32Z9U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Machek <pavel@denx.de>,
        Thierry Reding <treding@nvidia.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 5.3 19/95] gpio: max77620: Fixup debounce delays
Date:   Wed, 27 Nov 2019 21:31:36 +0100
Message-Id: <20191127202850.399983484@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202845.651587549@linuxfoundation.org>
References: <20191127202845.651587549@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

commit b0391479ae04dfcbd208b9571c375064caad9a57 upstream.

When converting milliseconds to microseconds in commit fffa6af94894
("gpio: max77620: Use correct unit for debounce times") some ~1 ms gaps
were introduced between the various ranges supported by the controller.
Fix this by changing the start of each range to the value immediately
following the end of the previous range. This way a debounce time of,
say 8250 us will translate into 16 ms instead of returning an -EINVAL
error.

Typically the debounce delay is only ever set through device tree and
specified in milliseconds, so we can never really hit this issue because
debounce times are always a multiple of 1000 us.

The only notable exception for this is drivers/mmc/host/mmc-spi.c where
the CD GPIO is requested, which passes a 1 us debounce time. According
to a comment preceeding that code this should actually be 1 ms (i.e.
1000 us).

Reported-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Acked-by: Pavel Machek <pavel@denx.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpio-max77620.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpio/gpio-max77620.c
+++ b/drivers/gpio/gpio-max77620.c
@@ -192,13 +192,13 @@ static int max77620_gpio_set_debounce(st
 	case 0:
 		val = MAX77620_CNFG_GPIO_DBNC_None;
 		break;
-	case 1000 ... 8000:
+	case 1 ... 8000:
 		val = MAX77620_CNFG_GPIO_DBNC_8ms;
 		break;
-	case 9000 ... 16000:
+	case 8001 ... 16000:
 		val = MAX77620_CNFG_GPIO_DBNC_16ms;
 		break;
-	case 17000 ... 32000:
+	case 16001 ... 32000:
 		val = MAX77620_CNFG_GPIO_DBNC_32ms;
 		break;
 	default:


