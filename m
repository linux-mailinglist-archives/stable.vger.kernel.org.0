Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71ACF283ABB
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728455AbgJEPgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:36:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:59894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727986AbgJEPcX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:32:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD2DC207BC;
        Mon,  5 Oct 2020 15:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911943;
        bh=qOQeV9RGEa4LUUa7YjUZi3sJdySKG8IIz7seCuhc5jI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h04Hrz2AgBHixvFKIIKOZo7v0UYqBm/eVOgds6827V1RGz8Na/xKfcXNrx56EdXX0
         xZWOlU0Lx2EBZtJir+EObUzGwnNigsp7SN2bqD5ce91GK2e17vsDpzniKhbB0PJ2jC
         xiRUMr8djPwClQs+tMpROV+hj/rBg17qSo6ODN6E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, u.kleine-koenig@pengutronix.de,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 5.8 09/85] gpio: siox: explicitly support only threaded irqs
Date:   Mon,  5 Oct 2020 17:26:05 +0200
Message-Id: <20201005142115.185201364@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ahmad Fatoum <a.fatoum@pengutronix.de>

commit 45ccf6556720293323c20cda717756014ff63007 upstream.

The gpio-siox driver uses handle_nested_irq() to implement its
interrupt support. This is only capable of handling threaded irq
actions. For a hardirq action it triggers a NULL pointer oops.
(It calls action->thread_fn which is NULL then.)

Prevent registration of a hardirq action by setting
gpio_irq_chip::threaded to true.

Cc: u.kleine-koenig@pengutronix.de
Fixes: be8c8facc707 ("gpio: new driver to work with a 8x12 siox")
Cc: stable@vger.kernel.org
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpio-siox.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpio/gpio-siox.c
+++ b/drivers/gpio/gpio-siox.c
@@ -245,6 +245,7 @@ static int gpio_siox_probe(struct siox_d
 	girq->chip = &ddata->ichip;
 	girq->default_type = IRQ_TYPE_NONE;
 	girq->handler = handle_level_irq;
+	girq->threaded = true;
 
 	ret = devm_gpiochip_add_data(dev, &ddata->gchip, NULL);
 	if (ret)


