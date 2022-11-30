Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE0963DE0A
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbiK3SdN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:33:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbiK3SdG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:33:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37ECB26545
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:33:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE0A4B81CA4
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:33:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C8C9C433D7;
        Wed, 30 Nov 2022 18:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833181;
        bh=Hkcp8xg1UcYtoHvl6vXfQ0Vdx6Qor5VWkONlaoPZwPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kN6nzpPi1r8ZCCACwIuuY8VenO89+R8iltJg1M9vCVnCei5qalzeawuhwRUbD2l8/
         RXF0B85TSzukEGVlmBbmvbQZLdiM1KNxS+5NC5mR0CIqUkOZBSBWD7bybVsB5FVmlL
         lXV/YY4hsm9dHkX+uD6fXZ0M5Us3KYNpmIlzGypc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 003/206] serial: Add rs485_supported to uart_port
Date:   Wed, 30 Nov 2022 19:20:55 +0100
Message-Id: <20221130180533.069929301@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
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

[ Upstream commit 8925c31c1ac2f1e05da988581f2a70a2a8c4d638 ]

Preparing to move serial_rs485 struct sanitization into serial core,
each driver has to provide what fields/flags it supports. This
information is pointed into by rs485_supported.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20220606100433.13793-4-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 76bad3f88750 ("tty: serial: fsl_lpuart: don't break the on-going transfer when global reset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_core.c | 1 +
 include/linux/serial_core.h         | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index c3348d5af922..f3bfaa1a794b 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -1016,6 +1016,7 @@ int serial8250_register_8250_port(const struct uart_8250_port *up)
 		uart->port.throttle	= up->port.throttle;
 		uart->port.unthrottle	= up->port.unthrottle;
 		uart->port.rs485_config	= up->port.rs485_config;
+		uart->port.rs485_supported = up->port.rs485_supported;
 		uart->port.rs485	= up->port.rs485;
 		uart->rs485_start_tx	= up->rs485_start_tx;
 		uart->rs485_stop_tx	= up->rs485_stop_tx;
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 86fa187f6d65..d5b6b1550d59 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -254,6 +254,7 @@ struct uart_port {
 	struct attribute_group	*attr_group;		/* port specific attributes */
 	const struct attribute_group **tty_groups;	/* all attributes (serial core use only) */
 	struct serial_rs485     rs485;
+	const struct serial_rs485	*rs485_supported;	/* Supported mask for serial_rs485 */
 	struct gpio_desc	*rs485_term_gpio;	/* enable RS485 bus termination */
 	struct serial_iso7816   iso7816;
 	void			*private_data;		/* generic platform data pointer */
-- 
2.35.1



