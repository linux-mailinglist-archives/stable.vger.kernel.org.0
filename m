Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66B6460A376
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 13:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231752AbiJXL4D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 07:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231975AbiJXLzT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:55:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 228AA79EF9;
        Mon, 24 Oct 2022 04:46:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F01AB8117D;
        Mon, 24 Oct 2022 11:46:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2046C43470;
        Mon, 24 Oct 2022 11:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611975;
        bh=+900UaONJT/K41STI5zOtc2KJLQApWN4BewdicxVIWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S/0eHq+sc1C25YI39pQL88TUpI9M+eeaTC1M929JcCVw3oJBpzBGIKDOYmO1HXmSp
         yRH6E9zgUlJTpoZsOXYcDk3gxp8dq1kcZwUehRkeh9khRcXNlGPx4rD80K8qW6xLqf
         2iFpbHLFhOn8If8By2kStQy1/hOa+OH2a2y97IYA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Danilo Cezar Zanella <danilo.zanella@iag.usp.br>
Subject: [PATCH 4.14 022/210] ARM: fix function graph tracer and unwinder dependencies
Date:   Mon, 24 Oct 2022 13:28:59 +0200
Message-Id: <20221024112957.688929913@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
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
@@ -63,7 +63,7 @@ config ARM
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
@@ -18,8 +18,8 @@ config ARM_PTDUMP
 
 choice
 	prompt "Choose kernel unwinder"
-	default UNWINDER_ARM if AEABI && !FUNCTION_GRAPH_TRACER
-	default UNWINDER_FRAME_POINTER if !AEABI || FUNCTION_GRAPH_TRACER
+	default UNWINDER_ARM if AEABI
+	default UNWINDER_FRAME_POINTER if !AEABI
 	help
 	  This determines which method will be used for unwinding kernel stack
 	  traces for panics, oopses, bugs, warnings, perf, /proc/<pid>/stack,
@@ -36,7 +36,7 @@ config UNWINDER_FRAME_POINTER
 
 config UNWINDER_ARM
 	bool "ARM EABI stack unwinder"
-	depends on AEABI
+	depends on AEABI && !FUNCTION_GRAPH_TRACER
 	select ARM_UNWIND
 	help
 	  This option enables stack unwinding support in the kernel


