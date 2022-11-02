Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 569AB6159E0
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbiKBDUO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbiKBDT7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:19:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1836A1B9FA
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:19:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BEB79B82062
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:19:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A79DDC433D6;
        Wed,  2 Nov 2022 03:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667359190;
        bh=SR6wxlow1kMyqFdPSkHrArKVqnvetOh1gYLFtcs5nrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0PBHY07McGYG0zm2Rv+r1sIHV1zfvEoiLY2pFHUle4vJIOJnWCKNydRTmmdq3rbgT
         sgRUuf2Xz+mbfWMYELNUWUYB+YRb88kpIRJh0WGgymhJy0D0PL13Ez2fGqM4eSG+64
         Iemk5xetWvslJmix8nuHdh4KxShb3oUxpLDC87Q4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Daisuke Mizobuchi <mizo@atmark-techno.com>,
        Dominique Martinet <dominique.martinet@atmark-techno.com>
Subject: [PATCH 5.10 90/91] serial: core: move RS485 configuration tasks from drivers into core
Date:   Wed,  2 Nov 2022 03:34:13 +0100
Message-Id: <20221102022057.605226414@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
References: <20221102022055.039689234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lino Sanfilippo <LinoSanfilippo@gmx.de>

commit 0ed12afa5655512ee418047fb3546d229df20aa1 upstream.

Several drivers that support setting the RS485 configuration via userspace
implement one or more of the following tasks:

- in case of an invalid RTS configuration (both RTS after send and RTS on
  send set or both unset) fall back to enable RTS on send and disable RTS
  after send

- nullify the padding field of the returned serial_rs485 struct

- copy the configuration into the uart port struct

- limit RTS delays to 100 ms

Move these tasks into the serial core to make them generic and to provide
a consistent behaviour among all drivers.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Link: https://lore.kernel.org/r/20220410104642.32195-2-LinoSanfilippo@gmx.de
Signed-off-by: Daisuke Mizobuchi <mizo@atmark-techno.com>
Signed-off-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial_core.c |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -42,6 +42,11 @@ static struct lock_class_key port_lock_k
 
 #define HIGH_BITS_OFFSET	((sizeof(long)-sizeof(int))*8)
 
+/*
+ * Max time with active RTS before/after data is sent.
+ */
+#define RS485_MAX_RTS_DELAY	100 /* msecs */
+
 static void uart_change_speed(struct tty_struct *tty, struct uart_state *state,
 					struct ktermios *old_termios);
 static void uart_wait_until_sent(struct tty_struct *tty, int timeout);
@@ -1326,8 +1331,36 @@ static int uart_set_rs485_config(struct
 	if (copy_from_user(&rs485, rs485_user, sizeof(*rs485_user)))
 		return -EFAULT;
 
+	/* pick sane settings if the user hasn't */
+	if (!(rs485.flags & SER_RS485_RTS_ON_SEND) ==
+	    !(rs485.flags & SER_RS485_RTS_AFTER_SEND)) {
+		dev_warn_ratelimited(port->dev,
+			"%s (%d): invalid RTS setting, using RTS_ON_SEND instead\n",
+			port->name, port->line);
+		rs485.flags |= SER_RS485_RTS_ON_SEND;
+		rs485.flags &= ~SER_RS485_RTS_AFTER_SEND;
+	}
+
+	if (rs485.delay_rts_before_send > RS485_MAX_RTS_DELAY) {
+		rs485.delay_rts_before_send = RS485_MAX_RTS_DELAY;
+		dev_warn_ratelimited(port->dev,
+			"%s (%d): RTS delay before sending clamped to %u ms\n",
+			port->name, port->line, rs485.delay_rts_before_send);
+	}
+
+	if (rs485.delay_rts_after_send > RS485_MAX_RTS_DELAY) {
+		rs485.delay_rts_after_send = RS485_MAX_RTS_DELAY;
+		dev_warn_ratelimited(port->dev,
+			"%s (%d): RTS delay after sending clamped to %u ms\n",
+			port->name, port->line, rs485.delay_rts_after_send);
+	}
+	/* Return clean padding area to userspace */
+	memset(rs485.padding, 0, sizeof(rs485.padding));
+
 	spin_lock_irqsave(&port->lock, flags);
 	ret = port->rs485_config(port, &rs485);
+	if (!ret)
+		port->rs485 = rs485;
 	spin_unlock_irqrestore(&port->lock, flags);
 	if (ret)
 		return ret;


