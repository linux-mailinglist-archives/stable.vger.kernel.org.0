Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D99D83E8080
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbhHJRum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:50:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:34572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233035AbhHJRrZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:47:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2772260243;
        Tue, 10 Aug 2021 17:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617256;
        bh=EpQXItnnKfAiIbmbeGSU6rhyO++6V+o/V39Qx5+LndE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XWHt/uSvGF+5jXhMMNyAVKudrtWXQrDC+TXOPX+7E9pDrjRax9hn5dxMQHAgTZM//
         bUqpCVV7GCSxyj7AycmuoyJKqizk0gB9MFBkIc/UIWBTExo02NZbYJJGr7A1XvgDaA
         36ZUslib+WI0f3OgJY9o+az0Eo4HWz3YT3O7jHDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 5.10 107/135] Revert "gpio: mpc8xxx: change the gpio interrupt flags."
Date:   Tue, 10 Aug 2021 19:30:41 +0200
Message-Id: <20210810172959.397392587@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>

commit ec7099fdea8025988710ee6fecfd4e4210c29ab5 upstream.

This reverts commit 3d5bfbd9716318b1ca5c38488aa69f64d38a9aa5.

When booting with threadirqs, it causes a splat

  WARNING: CPU: 0 PID: 29 at kernel/irq/handle.c:159 __handle_irq_event_percpu+0x1ec/0x27c
  irq 66 handler irq_default_primary_handler+0x0/0x1c enabled interrupts

That splat later went away with commit 81e2073c175b ("genirq: Disable
interrupts for force threaded handlers"), which got backported to
-stable. However, when running an -rt kernel, the splat still
exists. Moreover, quoting Thomas Gleixner [1]

  But 3d5bfbd97163 ("gpio: mpc8xxx: change the gpio interrupt flags.")
  has nothing to do with that:

      "Delete the interrupt IRQF_NO_THREAD flags in order to gpio interrupts
       can be threaded to allow high-priority processes to preempt."

  This changelog is blatantly wrong. In mainline forced irq threads
  have always been invoked with softirqs disabled, which obviously
  makes them non-preemptible.

So the patch didn't even do what its commit log said.

[1] https://lore.kernel.org/lkml/871r8zey88.ffs@nanos.tec.linutronix.de/

Cc: stable@vger.kernel.org # v5.9+
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-mpc8xxx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpio/gpio-mpc8xxx.c
+++ b/drivers/gpio/gpio-mpc8xxx.c
@@ -396,7 +396,7 @@ static int mpc8xxx_probe(struct platform
 
 	ret = devm_request_irq(&pdev->dev, mpc8xxx_gc->irqn,
 			       mpc8xxx_gpio_irq_cascade,
-			       IRQF_SHARED, "gpio-cascade",
+			       IRQF_NO_THREAD | IRQF_SHARED, "gpio-cascade",
 			       mpc8xxx_gc);
 	if (ret) {
 		dev_err(&pdev->dev, "%s: failed to devm_request_irq(%d), ret = %d\n",


