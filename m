Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71C3D259405
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729580AbgIAPeu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:34:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:39970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728058AbgIAPeq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:34:46 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16B7D21548;
        Tue,  1 Sep 2020 15:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974485;
        bh=lMCz7shUEGYmhFpPBbA9bvISxtpCW3iyb3Uv1DC/0k0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qr9bBI6hHe4rxk4wEpt0pWr+WRdzb+dIWlBBPlZyktbquO2Kytl9KlsqQHCjM16Lp
         +lnMtC6YmaoTjMTfnCdadfcwk7XciaMBkCSGCSItWvlZe4g11iEnJ79US66chW+iTP
         iBWH1E8aHj36IPdwFvTRGf8+j+bWGJi+pcwFBmCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Holger Assmann <h.assmann@pengutronix.de>
Subject: [PATCH 5.4 164/214] serial: stm32: avoid kernel warning on absence of optional IRQ
Date:   Tue,  1 Sep 2020 17:10:44 +0200
Message-Id: <20200901151000.835096270@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Holger Assmann <h.assmann@pengutronix.de>

commit fdf16d78941b4f380753053d229955baddd00712 upstream.

stm32_init_port() of the stm32-usart may trigger a warning in
platform_get_irq() when the device tree specifies no wakeup interrupt.

The wakeup interrupt is usually a board-specific GPIO and the driver
functions correctly in its absence. The mainline stm32mp151.dtsi does
not specify it, so all mainline device trees trigger an unnecessary
kernel warning. Use of platform_get_irq_optional() avoids this.

Fixes: 2c58e56096dd ("serial: stm32: fix the get_irq error case")
Signed-off-by: Holger Assmann <h.assmann@pengutronix.de>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200813152757.32751-1-h.assmann@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/stm32-usart.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -937,7 +937,7 @@ static int stm32_init_port(struct stm32_
 	stm32_init_rs485(port, pdev);
 
 	if (stm32port->info->cfg.has_wakeup) {
-		stm32port->wakeirq = platform_get_irq(pdev, 1);
+		stm32port->wakeirq = platform_get_irq_optional(pdev, 1);
 		if (stm32port->wakeirq <= 0 && stm32port->wakeirq != -ENXIO)
 			return stm32port->wakeirq ? : -ENODEV;
 	}


