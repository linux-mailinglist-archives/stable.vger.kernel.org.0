Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE65133437
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbgAGVY2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:24:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:35082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728356AbgAGVAZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:00:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C1D22081E;
        Tue,  7 Jan 2020 21:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430824;
        bh=RBDFzPWJE+6QF8d9Lxn3VwVNF4UjOna3jLcd+hpSyuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K4c4gvc725uh3eJTAv/8kfexis9gKYDcFOjzZR+9qCJC2YJ8CGU1LU88HULNZuHB2
         3XGXHKeMxBdLgepbQ2oNhyccmtDjtkMxaEMnIoYanfCDQGt7huY/1XPaRuqLlI/8+r
         /XchKCkJkhzmjc3EDulbBqOOW5N08BIJE9cuVVDk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 5.4 111/191] gpiolib: fix up emulated open drain outputs
Date:   Tue,  7 Jan 2020 21:53:51 +0100
Message-Id: <20200107205338.925400736@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

commit 256efaea1fdc4e38970489197409a26125ee0aaa upstream.

gpiolib has a corner case with open drain outputs that are emulated.
When such outputs are outputting a logic 1, emulation will set the
hardware to input mode, which will cause gpiod_get_direction() to
report that it is in input mode. This is different from the behaviour
with a true open-drain output.

Unify the semantics here.

Cc: <stable@vger.kernel.org>
Suggested-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpiolib.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -220,6 +220,14 @@ int gpiod_get_direction(struct gpio_desc
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
 		return -ENOTSUPP;
 


