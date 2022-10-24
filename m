Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C639760B828
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 21:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231724AbiJXTmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 15:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233460AbiJXTl3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 15:41:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1CF8263F15;
        Mon, 24 Oct 2022 11:11:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1889DB811D8;
        Mon, 24 Oct 2022 11:55:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F5BC433C1;
        Mon, 24 Oct 2022 11:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612515;
        bh=ijZSo/cdeKszAc/rK+X/Vy4APaR0n/bBdD5341uT48Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cbLxqiRytFYmBfMT0SQFBhg0c52p8/tNcljVufLmg5LiJFNMAYpjSJvqJH5HeELSS
         FoHpNFhWB2pTo7Qn+hbV4Qrthd/fholl2W7hn9SC25MtaW4CGZC8kn8nWaSnlNDHwX
         sotujj+18nlNQeVd2sGt2XYyNIAJ98WDinRaAz50=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Danilo Cezar Zanella <danilo.zanella@iag.usp.br>
Subject: [PATCH 4.19 003/229] ARM: fix function graph tracer and unwinder dependencies
Date:   Mon, 24 Oct 2022 13:28:42 +0200
Message-Id: <20221024112959.221989184@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
References: <20221024112959.085534368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

commit 503621628b32782a07b2318e4112bd4372aa3401 upstream.

Naresh Kamboju recently reported that the function-graph tracer crashes
on ARM. The function-graph tracer assumes that the kernel is built with
frame pointers.

We explicitly disabled the function-graph tracer when building Thumb2,
since the Thumb2 ABI doesn't have frame pointers.

We recently changed the way the unwinder method was selected, which
seems to have made it more likely that we can end up with the function-
graph tracer enabled but without the kernel built with frame pointers.

Fix up the function graph tracer dependencies so the option is not
available when we have no possibility of having frame pointers, and
adjust the dependencies on the unwinder option to hide the non-frame
pointer unwinder options if the function-graph tracer is enabled.

Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Tested-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reported-by: Danilo Cezar Zanella <danilo.zanella@iag.usp.br>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/Kconfig       |    2 +-
 arch/arm/Kconfig.debug |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -68,7 +68,7 @@ config ARM
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS if (CPU_V6 || CPU_V6K || CPU_V7) && MMU
 	select HAVE_EXIT_THREAD
 	select HAVE_FTRACE_MCOUNT_RECORD if (!XIP_KERNEL)
-	select HAVE_FUNCTION_GRAPH_TRACER if (!THUMB2_KERNEL)
+	select HAVE_FUNCTION_GRAPH_TRACER if (!THUMB2_KERNEL && !CC_IS_CLANG)
 	select HAVE_FUNCTION_TRACER if (!XIP_KERNEL)
 	select HAVE_FUTEX_CMPXCHG if FUTEX
 	select HAVE_GCC_PLUGINS
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -47,8 +47,8 @@ config DEBUG_WX
 
 choice
 	prompt "Choose kernel unwinder"
-	default UNWINDER_ARM if AEABI && !FUNCTION_GRAPH_TRACER
-	default UNWINDER_FRAME_POINTER if !AEABI || FUNCTION_GRAPH_TRACER
+	default UNWINDER_ARM if AEABI
+	default UNWINDER_FRAME_POINTER if !AEABI
 	help
 	  This determines which method will be used for unwinding kernel stack
 	  traces for panics, oopses, bugs, warnings, perf, /proc/<pid>/stack,
@@ -65,7 +65,7 @@ config UNWINDER_FRAME_POINTER
 
 config UNWINDER_ARM
 	bool "ARM EABI stack unwinder"
-	depends on AEABI
+	depends on AEABI && !FUNCTION_GRAPH_TRACER
 	select ARM_UNWIND
 	help
 	  This option enables stack unwinding support in the kernel


