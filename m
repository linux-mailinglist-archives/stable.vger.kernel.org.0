Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44B373283FE
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:29:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232661AbhCAQ2V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:28:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:59970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232326AbhCAQXm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:23:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B2EE64F27;
        Mon,  1 Mar 2021 16:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615585;
        bh=8uAE7Kjr3jKjAAotgeKAhm59IaP0pK281vQmxuvNvXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1cyuPeNkSc23MikAaDJ6os1R4XqOSaOTdepeD2tnofWZL5wYBNMtKYKX/HGdrZTKC
         NDFev3U4tPnB1uIinkjkJq3KzobIIumOnIDm+x0j1BSQUHBdE38y2gnZ1sqIvRYQFU
         LWyEm8J+b8vduhDC2wBMsab7kSzQ7wPU1ONk5/xE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Kiselev <bigunclemax@gmail.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 4.4 82/93] gpio: pcf857x: Fix missing first interrupt
Date:   Mon,  1 Mar 2021 17:13:34 +0100
Message-Id: <20210301161010.908180451@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161006.881950696@linuxfoundation.org>
References: <20210301161006.881950696@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Kiselev <bigunclemax@gmail.com>

commit a8002a35935aaefcd6a42ad3289f62bab947f2ca upstream.

If no n_latch value will be provided at driver probe then all pins will
be used as an input:

    gpio->out = ~n_latch;

In that case initial state for all pins is "one":

    gpio->status = gpio->out;

So if pcf857x IRQ happens with change pin value from "zero" to "one"
then we miss it, because of "one" from IRQ and "one" from initial state
leaves corresponding pin unchanged:
change = (gpio->status ^ status) & gpio->irq_enabled;

The right solution will be to read actual state at driver probe.

Cc: stable@vger.kernel.org
Fixes: 6e20a0a429bd ("gpio: pcf857x: enable gpio_to_irq() support")
Signed-off-by: Maxim Kiselev <bigunclemax@gmail.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-pcf857x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpio/gpio-pcf857x.c
+++ b/drivers/gpio/gpio-pcf857x.c
@@ -370,7 +370,7 @@ static int pcf857x_probe(struct i2c_clie
 	 * reset state.  Otherwise it flags pins to be driven low.
 	 */
 	gpio->out = ~n_latch;
-	gpio->status = gpio->out;
+	gpio->status = gpio->read(gpio->client);
 
 	status = gpiochip_add(&gpio->chip);
 	if (status < 0)


