Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7FA18B69C
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730682AbgCSN1d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:27:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:55822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727977AbgCSN1b (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:27:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4D32208D6;
        Thu, 19 Mar 2020 13:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624450;
        bh=BQ890SzTEouptVcWzFCmIJWKxJvivRGqcLrFbeFHC+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jnSKiJMFggo64i/RmfzTrTruVsF97pvVOQjfadqYAQi6zdSC8Cb8S0zolLR6z6zdv
         +FZnIJzPPy204Amkt4Hc6zof8tHAf4oGlTAxSy4EOsLmV3KhbzppbbaRHi3VA/c/x0
         +zPX1Cz0Tj0Ic5cbWlLAiGWprzvL4SVsrrnQ1oW0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Merlijn Wajer <merlijn@wizzup.org>,
        Tony Lindgren <tony@atomide.com>,
        Kees Cook <keescook@chromium.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 5.5 64/65] ARM: 8961/2: Fix Kbuild issue caused by per-task stack protector GCC plugin
Date:   Thu, 19 Mar 2020 14:04:46 +0100
Message-Id: <20200319123946.468269055@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123926.466988514@linuxfoundation.org>
References: <20200319123926.466988514@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit 89604523a76eb3e13014b2bdab7f8870becee284 upstream.

When using plugins, GCC requires that the -fplugin= options precedes
any of its plugin arguments appearing on the command line as well.
This is usually not a concern, but as it turns out, this requirement
is causing some issues with ARM's per-task stack protector plugin
and Kbuild's implementation of $(cc-option).

When the per-task stack protector plugin is enabled, and we tweak
the implementation of cc-option not to pipe the stderr output of
GCC to /dev/null, the following output is generated when GCC is
executed in the context of cc-option:

  cc1: error: plugin arm_ssp_per_task_plugin should be specified before \
         -fplugin-arg-arm_ssp_per_task_plugin-tso=1 in the command line
  cc1: error: plugin arm_ssp_per_task_plugin should be specified before \
         -fplugin-arg-arm_ssp_per_task_plugin-offset=24 in the command line

These errors will cause any option passed to cc-option to be treated
as unsupported, which is obviously incorrect.

The cause of this issue is the fact that the -fplugin= argument is
added to GCC_PLUGINS_CFLAGS, whereas the arguments above are added
to KBUILD_CFLAGS, and the contents of the former get filtered out of
the latter before being passed to the GCC running the cc-option test,
and so the -fplugin= option does not appear at all on the GCC command
line.

Adding the arguments to GCC_PLUGINS_CFLAGS instead of KBUILD_CFLAGS
would be the correct approach here, if it weren't for the fact that we
are using $(eval) to defer the moment that they are added until after
asm-offsets.h is generated, which is after the point where the contents
of GCC_PLUGINS_CFLAGS are added to KBUILD_CFLAGS. So instead, we have
to add our plugin arguments to both.

For similar reasons, we cannot append DISABLE_ARM_SSP_PER_TASK_PLUGIN
to KBUILD_CFLAGS, as it will be passed to GCC when executing in the
context of cc-option, whereas the other plugin arguments will have
been filtered out, resulting in a similar error and false negative
result as above. So add it to ccflags-y instead.

Fixes: 189af4657186da08 ("ARM: smp: add support for per-task stack canaries")
Reported-by: Merlijn Wajer <merlijn@wizzup.org>
Tested-by: Tony Lindgren <tony@atomide.com>
Acked-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/Makefile                 |    4 +++-
 arch/arm/boot/compressed/Makefile |    4 ++--
 2 files changed, 5 insertions(+), 3 deletions(-)

--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -307,13 +307,15 @@ endif
 ifeq ($(CONFIG_STACKPROTECTOR_PER_TASK),y)
 prepare: stack_protector_prepare
 stack_protector_prepare: prepare0
-	$(eval KBUILD_CFLAGS += \
+	$(eval SSP_PLUGIN_CFLAGS := \
 		-fplugin-arg-arm_ssp_per_task_plugin-tso=$(shell	\
 			awk '{if ($$2 == "THREAD_SZ_ORDER") print $$3;}'\
 				include/generated/asm-offsets.h)	\
 		-fplugin-arg-arm_ssp_per_task_plugin-offset=$(shell	\
 			awk '{if ($$2 == "TI_STACK_CANARY") print $$3;}'\
 				include/generated/asm-offsets.h))
+	$(eval KBUILD_CFLAGS += $(SSP_PLUGIN_CFLAGS))
+	$(eval GCC_PLUGINS_CFLAGS += $(SSP_PLUGIN_CFLAGS))
 endif
 
 all:	$(notdir $(KBUILD_IMAGE))
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -101,7 +101,6 @@ clean-files += piggy_data lib1funcs.S as
 		$(libfdt) $(libfdt_hdrs) hyp-stub.S
 
 KBUILD_CFLAGS += -DDISABLE_BRANCH_PROFILING
-KBUILD_CFLAGS += $(DISABLE_ARM_SSP_PER_TASK_PLUGIN)
 
 ifeq ($(CONFIG_FUNCTION_TRACER),y)
 ORIG_CFLAGS := $(KBUILD_CFLAGS)
@@ -117,7 +116,8 @@ CFLAGS_fdt_ro.o := $(nossp_flags)
 CFLAGS_fdt_rw.o := $(nossp_flags)
 CFLAGS_fdt_wip.o := $(nossp_flags)
 
-ccflags-y := -fpic $(call cc-option,-mno-single-pic-base,) -fno-builtin -I$(obj)
+ccflags-y := -fpic $(call cc-option,-mno-single-pic-base,) -fno-builtin \
+	     -I$(obj) $(DISABLE_ARM_SSP_PER_TASK_PLUGIN)
 asflags-y := -DZIMAGE
 
 # Supply kernel BSS size to the decompressor via a linker symbol.


