Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 324B05BF15E
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 01:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbiITXlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 19:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231468AbiITXlF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 19:41:05 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EE1EB7C76E;
        Tue, 20 Sep 2022 16:38:19 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 9DD599200B3; Wed, 21 Sep 2022 01:35:42 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 9AB3592009B;
        Wed, 21 Sep 2022 00:35:42 +0100 (BST)
Date:   Wed, 21 Sep 2022 00:35:42 +0100 (BST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>
cc:     Josh Triplett <josh@joshtriplett.org>,
        Anders Blomdell <anders.blomdell@control.lth.se>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v2 3/3] serial: 8250: Switch UART port flags to using
 BIT_ULL
In-Reply-To: <alpine.DEB.2.21.2209201659350.41633@angie.orcam.me.uk>
Message-ID: <alpine.DEB.2.21.2209210007030.41633@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2209201659350.41633@angie.orcam.me.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Use BIT_ULL rather than encoding bits explicitly where applicable with 
UART port flags.  This makes a (__force upf_t) cast redundant, but keep 
it for visual consistency with the flags defined in terms of userspace 
macros.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
---
New change in v2.
---
 include/linux/serial_core.h |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

linux-serial-8250-upf-bit-ull.diff
Index: linux-macro/include/linux/serial_core.h
===================================================================
--- linux-macro.orig/include/linux/serial_core.h
+++ linux-macro/include/linux/serial_core.h
@@ -505,24 +505,24 @@ struct uart_port {
 #define UPF_BUGGY_UART		((__force upf_t) ASYNC_BUGGY_UART     /* 14 */ )
 #define UPF_MAGIC_MULTIPLIER	((__force upf_t) ASYNC_MAGIC_MULTIPLIER /* 16 */ )
 
-#define UPF_NO_THRE_TEST	((__force upf_t) (1 << 19))
+#define UPF_NO_THRE_TEST	((__force upf_t) BIT_ULL(19))
 /* Port has hardware-assisted h/w flow control */
-#define UPF_AUTO_CTS		((__force upf_t) (1 << 20))
-#define UPF_AUTO_RTS		((__force upf_t) (1 << 21))
+#define UPF_AUTO_CTS		((__force upf_t) BIT_ULL(20))
+#define UPF_AUTO_RTS		((__force upf_t) BIT_ULL(21))
 #define UPF_HARD_FLOW		((__force upf_t) (UPF_AUTO_CTS | UPF_AUTO_RTS))
 /* Port has hardware-assisted s/w flow control */
-#define UPF_SOFT_FLOW		((__force upf_t) (1 << 22))
-#define UPF_CONS_FLOW		((__force upf_t) (1 << 23))
-#define UPF_SHARE_IRQ		((__force upf_t) (1 << 24))
-#define UPF_EXAR_EFR		((__force upf_t) (1 << 25))
-#define UPF_BUG_THRE		((__force upf_t) (1 << 26))
+#define UPF_SOFT_FLOW		((__force upf_t) BIT_ULL(22))
+#define UPF_CONS_FLOW		((__force upf_t) BIT_ULL(23))
+#define UPF_SHARE_IRQ		((__force upf_t) BIT_ULL(24))
+#define UPF_EXAR_EFR		((__force upf_t) BIT_ULL(25))
+#define UPF_BUG_THRE		((__force upf_t) BIT_ULL(26))
 /* The exact UART type is known and should not be probed.  */
-#define UPF_FIXED_TYPE		((__force upf_t) (1 << 27))
-#define UPF_BOOT_AUTOCONF	((__force upf_t) (1 << 28))
-#define UPF_FIXED_PORT		((__force upf_t) (1 << 29))
-#define UPF_DEAD		((__force upf_t) (1 << 30))
-#define UPF_IOREMAP		((__force upf_t) (1 << 31))
-#define UPF_FULL_PROBE		((__force upf_t) (1ULL << 32))
+#define UPF_FIXED_TYPE		((__force upf_t) BIT_ULL(27))
+#define UPF_BOOT_AUTOCONF	((__force upf_t) BIT_ULL(28))
+#define UPF_FIXED_PORT		((__force upf_t) BIT_ULL(29))
+#define UPF_DEAD		((__force upf_t) BIT_ULL(30))
+#define UPF_IOREMAP		((__force upf_t) BIT_ULL(31))
+#define UPF_FULL_PROBE		((__force upf_t) BIT_ULL(32))
 
 #define __UPF_CHANGE_MASK	0x17fff
 #define UPF_CHANGE_MASK		((__force upf_t) __UPF_CHANGE_MASK)
