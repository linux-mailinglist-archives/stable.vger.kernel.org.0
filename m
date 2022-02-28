Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE564C7570
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234340AbiB1RzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:55:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239611AbiB1RxO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:53:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED6DAA012;
        Mon, 28 Feb 2022 09:40:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 411BBB815BA;
        Mon, 28 Feb 2022 17:40:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC9DC340E7;
        Mon, 28 Feb 2022 17:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070036;
        bh=5uF6y4pkw02E5d5b+6ZDIAcWCGP3fx5/Fm1OO0TLlEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LITZ/A7vTYp45O5NF4E5SixxUsumwBvJ6/4DmyDWpxspTrDq+/D7kbYNfzmAx2i6n
         zUPO+kKBzUcNUQInDuCfNJ1e0MQ71U2MvRjpwESlCP5SruYFb6NzfsG0AhYQE1YHxd
         1XNO35fRfDyHW+rpXyImPR9tERj/q50+A+Ul5c0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Elwell <phil@raspberrypi.com>
Subject: [PATCH 5.15 103/139] sc16is7xx: Fix for incorrect data being transmitted
Date:   Mon, 28 Feb 2022 18:24:37 +0100
Message-Id: <20220228172358.504935085@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phil Elwell <phil@raspberrypi.com>

commit eebb0f4e894f1e9577a56b337693d1051dd6ebfd upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sc16is7xx.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -734,12 +734,15 @@ static irqreturn_t sc16is7xx_irq(int irq
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


