Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3A1950F7CF
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243950AbiDZJMD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346055AbiDZJGn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:06:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D9A116FAFF;
        Tue, 26 Apr 2022 01:48:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D8A2B81A2F;
        Tue, 26 Apr 2022 08:48:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFFAEC385A0;
        Tue, 26 Apr 2022 08:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962882;
        bh=IDqgRNBwGIvtMsmr6/N2J6hYIoYbX/xHkHR82tNbfo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xdsDPAN3arpduJxkTQQA9t2g+N822NjgwiCjL7ApuBtz9HL4E9TDqUeYPOmAAUG9v
         YeCdqUlZi6bU9mtCh7Hsq+aFHbWInyh8zeSRVmrPDveWpSBkVg54mxfsgpuBKaelTU
         /dKjYo0daGnmO8oeB0SMKdBV+lRExIcl6P07u5Yo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mario Limonciello <mario.limonciello@amd.com>,
        Shreeya Patel <shreeya.patel@collabora.com>,
        =?UTF-8?q?Samuel=20=C4=8Cavoj?= <samuel@cavoj.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        lukeluk498@gmail.com, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.17 120/146] gpio: Request interrupts after IRQ is initialized
Date:   Tue, 26 Apr 2022 10:21:55 +0200
Message-Id: <20220426081753.429847995@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

commit 06fb4ecfeac7e00d6704fa5ed19299f2fefb3cc9 upstream.

Commit 5467801f1fcb ("gpio: Restrict usage of GPIO chip irq members
before initialization") attempted to fix a race condition that lead to a
NULL pointer, but in the process caused a regression for _AEI/_EVT
declared GPIOs.

This manifests in messages showing deferred probing while trying to
allocate IRQs like so:

  amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x0000 to IRQ, err -517
  amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x002C to IRQ, err -517
  amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x003D to IRQ, err -517
  [ .. more of the same .. ]

The code for walking _AEI doesn't handle deferred probing and so this
leads to non-functional GPIO interrupts.

Fix this issue by moving the call to `acpi_gpiochip_request_interrupts`
to occur after gc->irc.initialized is set.

Fixes: 5467801f1fcb ("gpio: Restrict usage of GPIO chip irq members before initialization")
Link: https://lore.kernel.org/linux-gpio/BL1PR12MB51577A77F000A008AA694675E2EF9@BL1PR12MB5157.namprd12.prod.outlook.com/
Link: https://bugzilla.suse.com/show_bug.cgi?id=1198697
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215850
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1979
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1976
Reported-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Shreeya Patel <shreeya.patel@collabora.com>
Tested-By: Samuel Čavoj <samuel@cavoj.net>
Tested-By: lukeluk498@gmail.com Link:
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-and-tested-by: Takashi Iwai <tiwai@suse.de>
Cc: Shreeya Patel <shreeya.patel@collabora.com>
Cc: stable@vger.kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1601,8 +1601,6 @@ static int gpiochip_add_irqchip(struct g
 
 	gpiochip_set_irq_hooks(gc);
 
-	acpi_gpiochip_request_interrupts(gc);
-
 	/*
 	 * Using barrier() here to prevent compiler from reordering
 	 * gc->irq.initialized before initialization of above
@@ -1612,6 +1610,8 @@ static int gpiochip_add_irqchip(struct g
 
 	gc->irq.initialized = true;
 
+	acpi_gpiochip_request_interrupts(gc);
+
 	return 0;
 }
 


