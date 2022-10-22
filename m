Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 897C2608BBC
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 12:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbiJVKji (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 06:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbiJVKjQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 06:39:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D97156BBB;
        Sat, 22 Oct 2022 02:56:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B987B82DF4;
        Sat, 22 Oct 2022 07:37:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6EACC433C1;
        Sat, 22 Oct 2022 07:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424272;
        bh=q+8IZv14OH8z7nHWlSQwAYSMLSmzzRxf767zndaIaCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mynq8NWPVt8bXR6JOMsTmXEKSNNR9NumMm4V/U8ErMNo1e0KOyFzCIBD6BAj/d+Dd
         EgX+BSrFsnz57h+ekRORAHU3x5nzWhm5nuPuZAgK4yllbfuq176JQjXODMrQ35gkJ/
         P0LC1JeI/ZrjrPYu4nuy5Jr7pwjL51ysdLibrOJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anders Blomdell <anders.blomdell@control.lth.se>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: [PATCH 5.19 084/717] serial: 8250: Let drivers request full 16550A feature probing
Date:   Sat, 22 Oct 2022 09:19:23 +0200
Message-Id: <20221022072430.217746516@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit 9906890c89e4dbd900ed87ad3040080339a7f411 upstream.

A SERIAL_8250_16550A_VARIANTS configuration option has been recently
defined that lets one request the 8250 driver not to probe for 16550A
device features so as to reduce the driver's device startup time in
virtual machines.

Some actual hardware devices require these features to have been fully
determined however for their driver to work correctly, so define a flag
to let drivers request full 16550A feature probing on a device-by-device
basis if required regardless of the SERIAL_8250_16550A_VARIANTS option
setting chosen.

Fixes: dc56ecb81a0a ("serial: 8250: Support disabling mdelay-filled probes of 16550A variants")
Cc: stable@vger.kernel.org # v5.6+
Reported-by: Anders Blomdell <anders.blomdell@control.lth.se>
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Link: https://lore.kernel.org/r/alpine.DEB.2.21.2209202357520.41633@angie.orcam.me.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_port.c |    3 ++-
 include/linux/serial_core.h         |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -1029,7 +1029,8 @@ static void autoconfig_16550a(struct uar
 	up->port.type = PORT_16550A;
 	up->capabilities |= UART_CAP_FIFO;
 
-	if (!IS_ENABLED(CONFIG_SERIAL_8250_16550A_VARIANTS))
+	if (!IS_ENABLED(CONFIG_SERIAL_8250_16550A_VARIANTS) &&
+	    !(up->port.flags & UPF_FULL_PROBE))
 		return;
 
 	/*
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -101,7 +101,7 @@ struct uart_icount {
 	__u32	buf_overrun;
 };
 
-typedef unsigned int __bitwise upf_t;
+typedef u64 __bitwise upf_t;
 typedef unsigned int __bitwise upstat_t;
 
 struct uart_port {
@@ -208,6 +208,7 @@ struct uart_port {
 #define UPF_FIXED_PORT		((__force upf_t) (1 << 29))
 #define UPF_DEAD		((__force upf_t) (1 << 30))
 #define UPF_IOREMAP		((__force upf_t) (1 << 31))
+#define UPF_FULL_PROBE		((__force upf_t) (1ULL << 32))
 
 #define __UPF_CHANGE_MASK	0x17fff
 #define UPF_CHANGE_MASK		((__force upf_t) __UPF_CHANGE_MASK)


