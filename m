Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4FF1328C84
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240702AbhCASx1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:53:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:54122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239641AbhCASq4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:46:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB02264F26;
        Mon,  1 Mar 2021 17:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619883;
        bh=dHdMdb2Q5nAIHdKg/y+iCYs6IMF9fJtrPXAU+A2gvWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UAtjAAtUD56WzeqpgbKy5v69Kq81YnWIH/jRFLjmIdvTD/uNJZeuDWmjttXE0X+9G
         rriorKXv4o0Rm8drT0fL5k5LbekIDwTvyqt2UrZOWHCEdh3jf0fwsrM+TczNM5C0PN
         02SLXF2/lRGnA1wfQsvnNvGRVLwh0w+mR070HNPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Kiselev <bigunclemax@gmail.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 5.10 615/663] gpio: pcf857x: Fix missing first interrupt
Date:   Mon,  1 Mar 2021 17:14:23 +0100
Message-Id: <20210301161212.275038104@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
@@ -332,7 +332,7 @@ static int pcf857x_probe(struct i2c_clie
 	 * reset state.  Otherwise it flags pins to be driven low.
 	 */
 	gpio->out = ~n_latch;
-	gpio->status = gpio->out;
+	gpio->status = gpio->read(gpio->client);
 
 	/* Enable irqchip if we have an interrupt */
 	if (client->irq) {


