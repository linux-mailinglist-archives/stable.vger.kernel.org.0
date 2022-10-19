Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88CEB604834
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233706AbiJSNw1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231347AbiJSNv7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:51:59 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C95106930;
        Wed, 19 Oct 2022 06:35:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3BE99CE20ED;
        Wed, 19 Oct 2022 08:41:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A13FC433D6;
        Wed, 19 Oct 2022 08:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666168907;
        bh=KM5aJ8W23YxmKOBqyJnPA3XBpiJZ3LNYv8qiLaoe1eM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PrcnaS1ITy2q32Jr8ey9mH7zDRuZb3tU//5Za3LtbpUd+bn7U2DOvtuZLCFu/dUD+
         0+qJdTwOcb3w8co7N7N6koumnrob4X1lilTzBzQ8fgFhVnjWSj+Sl6f3sVt7/kCHfh
         5eWyWwXCZ2T9m+s3JbdHMekomIUDyaM54ugR4Uy8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anders Blomdell <anders.blomdell@control.lth.se>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: [PATCH 6.0 094/862] serial: 8250: Let drivers request full 16550A feature probing
Date:   Wed, 19 Oct 2022 10:23:01 +0200
Message-Id: <20221019083254.093554124@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
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
@@ -1023,7 +1023,8 @@ static void autoconfig_16550a(struct uar
 	up->port.type = PORT_16550A;
 	up->capabilities |= UART_CAP_FIFO;
 
-	if (!IS_ENABLED(CONFIG_SERIAL_8250_16550A_VARIANTS))
+	if (!IS_ENABLED(CONFIG_SERIAL_8250_16550A_VARIANTS) &&
+	    !(up->port.flags & UPF_FULL_PROBE))
 		return;
 
 	/*
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -422,7 +422,7 @@ struct uart_icount {
 	__u32	buf_overrun;
 };
 
-typedef unsigned int __bitwise upf_t;
+typedef u64 __bitwise upf_t;
 typedef unsigned int __bitwise upstat_t;
 
 struct uart_port {
@@ -530,6 +530,7 @@ struct uart_port {
 #define UPF_FIXED_PORT		((__force upf_t) (1 << 29))
 #define UPF_DEAD		((__force upf_t) (1 << 30))
 #define UPF_IOREMAP		((__force upf_t) (1 << 31))
+#define UPF_FULL_PROBE		((__force upf_t) (1ULL << 32))
 
 #define __UPF_CHANGE_MASK	0x17fff
 #define UPF_CHANGE_MASK		((__force upf_t) __UPF_CHANGE_MASK)


