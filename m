Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 106826355AA
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237557AbiKWJVr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:21:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237458AbiKWJVJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:21:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B7EE2202
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:21:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8E95B81EF2
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:21:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4C99C433B5;
        Wed, 23 Nov 2022 09:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195265;
        bh=c93mihFFCk/q8I+8d5L9x0uJ6GJMkMFPdy+ZXPzqqzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QJ19NGzmI3Jnaa6rt0Aozix65pBdX7rQDBmpoiTJ1wgdH5NzVXsxXpZmmH9csfr0H
         Q0REUelycJgdL4Dgr97krSK4+heMbe7CNCt19YLQDi/MUPZQbJIuRlMAfiCclEfsX+
         CZGvAKGaFM4I63072YOQT+xgdUSxiEdkSheBnyZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 036/149] serial: 8250: Remove serial_rs485 sanitization from em485
Date:   Wed, 23 Nov 2022 09:50:19 +0100
Message-Id: <20221123084559.296988892@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 84f2faa7852e1f55d89bb0c99b3a672b87b11f87 ]

Serial core handles serial_rs485 sanitization.

When em485 init fails, there are two possible paths of entry:

  1) uart_rs485_config (init path) that fully clears port->rs485 on
     error.

  2) ioctl path with a pre-existing, valid port->rs485 unto which the
     kernel falls back on error and port->rs485 should therefore be
     kept untouched. The temporary rs485 struct is not returned to
     userspace in case of error so its flag don't matter.

...Thus SER_RS485_ENABLED clearing on error can/should be dropped.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20220606100433.13793-37-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 93810191f5d2 ("serial: 8250: omap: Fix missing PM runtime calls for omap8250_set_mctrl()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_port.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index f648fd1d7548..7cdfc2458d36 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -661,13 +661,6 @@ int serial8250_em485_config(struct uart_port *port, struct serial_rs485 *rs485)
 		rs485->flags &= ~SER_RS485_RTS_AFTER_SEND;
 	}
 
-	/* clamp the delays to [0, 100ms] */
-	rs485->delay_rts_before_send = min(rs485->delay_rts_before_send, 100U);
-	rs485->delay_rts_after_send  = min(rs485->delay_rts_after_send, 100U);
-
-	memset(rs485->padding, 0, sizeof(rs485->padding));
-	port->rs485 = *rs485;
-
 	gpiod_set_value(port->rs485_term_gpio,
 			rs485->flags & SER_RS485_TERMINATE_BUS);
 
@@ -675,15 +668,8 @@ int serial8250_em485_config(struct uart_port *port, struct serial_rs485 *rs485)
 	 * Both serial8250_em485_init() and serial8250_em485_destroy()
 	 * are idempotent.
 	 */
-	if (rs485->flags & SER_RS485_ENABLED) {
-		int ret = serial8250_em485_init(up);
-
-		if (ret) {
-			rs485->flags &= ~SER_RS485_ENABLED;
-			port->rs485.flags &= ~SER_RS485_ENABLED;
-		}
-		return ret;
-	}
+	if (rs485->flags & SER_RS485_ENABLED)
+		return serial8250_em485_init(up);
 
 	serial8250_em485_destroy(up);
 	return 0;
-- 
2.35.1



