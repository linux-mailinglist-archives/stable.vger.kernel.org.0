Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E625A4BEAF0
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 20:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233228AbiBUSy3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 13:54:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232490AbiBUSwk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 13:52:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 792EAE02F
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 10:51:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09FE8614B7
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 18:51:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF29AC340E9;
        Mon, 21 Feb 2022 18:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645469510;
        bh=xjLvyaGBZiq/b3k2zEg7s81j547b8CcmvjJSQsP0YyA=;
        h=Subject:To:From:Date:From;
        b=BocnByAZY8SVTHZ5WUdnxlvOMFuAKA5ubRyWPlTtHfSPrUOwLd09H/J9qvm5Wk+hg
         FvBdg8TzsbU14t/PlH/ahnMRsR8A0GIC6LLX5k+6A2CJeVL4JcfjuYibZKC5rYjff5
         8kDz2iAatYWpSDywEO7mqQ0+nT8v62U559smx3vs=
Subject: patch "sc16is7xx: Fix for incorrect data being transmitted" added to tty-linus
To:     phil@raspberrypi.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Feb 2022 19:51:47 +0100
Message-ID: <164546950721338@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    sc16is7xx: Fix for incorrect data being transmitted

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From eebb0f4e894f1e9577a56b337693d1051dd6ebfd Mon Sep 17 00:00:00 2001
From: Phil Elwell <phil@raspberrypi.com>
Date: Wed, 16 Feb 2022 16:08:02 +0000
Subject: sc16is7xx: Fix for incorrect data being transmitted

UART drivers are meant to use the port spinlock within certain
methods, to protect against reentrancy. The sc16is7xx driver does
very little locking, presumably because when added it triggers
"scheduling while atomic" errors. This is due to the use of mutexes
within the regmap abstraction layer, and the mutex implementation's
habit of sleeping the current thread while waiting for access.
Unfortunately this lack of interlocking can lead to corruption of
outbound data, which occurs when the buffer used for I2C transmission
is used simultaneously by two threads - a work queue thread running
sc16is7xx_tx_proc, and an IRQ thread in sc16is7xx_port_irq, both
of which can call sc16is7xx_handle_tx.

An earlier patch added efr_lock, a mutex that controls access to the
EFR register. This mutex is already claimed in the IRQ handler, and
all that is required is to claim the same mutex in sc16is7xx_tx_proc.

See: https://github.com/raspberrypi/linux/issues/4885

Fixes: 6393ff1c4435 ("sc16is7xx: Use threaded IRQ")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Phil Elwell <phil@raspberrypi.com>
Link: https://lore.kernel.org/r/20220216160802.1026013-1-phil@raspberrypi.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sc16is7xx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index 64e7e6c8145f..38d1c0748533 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -734,12 +734,15 @@ static irqreturn_t sc16is7xx_irq(int irq, void *dev_id)
 static void sc16is7xx_tx_proc(struct kthread_work *ws)
 {
 	struct uart_port *port = &(to_sc16is7xx_one(ws, tx_work)->port);
+	struct sc16is7xx_port *s = dev_get_drvdata(port->dev);
 
 	if ((port->rs485.flags & SER_RS485_ENABLED) &&
 	    (port->rs485.delay_rts_before_send > 0))
 		msleep(port->rs485.delay_rts_before_send);
 
+	mutex_lock(&s->efr_lock);
 	sc16is7xx_handle_tx(port);
+	mutex_unlock(&s->efr_lock);
 }
 
 static void sc16is7xx_reconf_rs485(struct uart_port *port)
-- 
2.35.1


