Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 788C91B68C7
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728319AbgDWXRs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:17:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49214 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728303AbgDWXGk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:40 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvP-0004fi-PR; Fri, 24 Apr 2020 00:06:31 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvO-00E6mQ-8u; Fri, 24 Apr 2020 00:06:30 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Bartosz Golaszewski" <bgolaszewski@baylibre.com>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        "Russell King" <rmk+kernel@armlinux.org.uk>
Date:   Fri, 24 Apr 2020 00:05:19 +0100
Message-ID: <lsq.1587683028.908662902@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 092/245] gpiolib: fix up emulated open drain outputs
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@armlinux.org.uk>

commit 256efaea1fdc4e38970489197409a26125ee0aaa upstream.

gpiolib has a corner case with open drain outputs that are emulated.
When such outputs are outputting a logic 1, emulation will set the
hardware to input mode, which will cause gpiod_get_direction() to
report that it is in input mode. This is different from the behaviour
with a true open-drain output.

Unify the semantics here.

Suggested-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpio/gpiolib.c | 8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -273,6 +273,14 @@ int gpiod_get_direction(const struct gpi
 	chip = gpiod_to_chip(desc);
 	offset = gpio_chip_hwgpio(desc);
 
+	/*
+	 * Open drain emulation using input mode may incorrectly report
+	 * input here, fix that up.
+	 */
+	if (test_bit(FLAG_OPEN_DRAIN, &desc->flags) &&
+	    test_bit(FLAG_IS_OUT, &desc->flags))
+		return 0;
+
 	if (!chip->get_direction)
 		return status;
 

