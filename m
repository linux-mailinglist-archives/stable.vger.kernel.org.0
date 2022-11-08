Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D69B662139C
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234758AbiKHNwT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:52:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234772AbiKHNvx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:51:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8ECF60EA8
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:51:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C915615A3
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:51:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 575F5C433C1;
        Tue,  8 Nov 2022 13:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915504;
        bh=4dcZdnYfqRQJcLZXetaJJaZLs8NKBCDFgr9fFyf9EhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KMRSqWVxsPpmbdh4XQk9Rqd/SNavkuDFZc6ViAJlO0772NZb6WWJ1zVYw5NurWfnX
         Xwf2ukagqEYcdv7uaPnAiNh8XjECpHXniQCbaMpM8XoG/Pw/i1KKByFUYRGHH+NbLJ
         NSwj/2RVASaPQCfAXg1duZpyf/oH0gDcwxWjuqV8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Anders Blomdell <anders.blomdell@control.lth.se>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 001/118] serial: 8250: Let drivers request full 16550A feature probing
Date:   Tue,  8 Nov 2022 14:37:59 +0100
Message-Id: <20221108133340.777783271@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
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

From: Maciej W. Rozycki <macro@orcam.me.uk>

[ Upstream commit 9906890c89e4dbd900ed87ad3040080339a7f411 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_port.c | 3 ++-
 include/linux/serial_core.h         | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index 8b3756e4bb05..f648fd1d7548 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -1023,7 +1023,8 @@ static void autoconfig_16550a(struct uart_8250_port *up)
 	up->port.type = PORT_16550A;
 	up->capabilities |= UART_CAP_FIFO;
 
-	if (!IS_ENABLED(CONFIG_SERIAL_8250_16550A_VARIANTS))
+	if (!IS_ENABLED(CONFIG_SERIAL_8250_16550A_VARIANTS) &&
+	    !(up->port.flags & UPF_FULL_PROBE))
 		return;
 
 	/*
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 59a8caf3230a..6df4c3356ae6 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -100,7 +100,7 @@ struct uart_icount {
 	__u32	buf_overrun;
 };
 
-typedef unsigned int __bitwise upf_t;
+typedef u64 __bitwise upf_t;
 typedef unsigned int __bitwise upstat_t;
 
 struct uart_port {
@@ -207,6 +207,7 @@ struct uart_port {
 #define UPF_FIXED_PORT		((__force upf_t) (1 << 29))
 #define UPF_DEAD		((__force upf_t) (1 << 30))
 #define UPF_IOREMAP		((__force upf_t) (1 << 31))
+#define UPF_FULL_PROBE		((__force upf_t) (1ULL << 32))
 
 #define __UPF_CHANGE_MASK	0x17fff
 #define UPF_CHANGE_MASK		((__force upf_t) __UPF_CHANGE_MASK)
-- 
2.35.1



