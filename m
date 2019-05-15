Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82BB21EF7F
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732874AbfEOLbR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:31:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:43014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732587AbfEOLbQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:31:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A693C206BF;
        Wed, 15 May 2019 11:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919876;
        bh=oHXUAOsbOGuTuFUb/ynXgCuDOCmUrG66929WmRtc8iw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cuqhsiFC6IMSYw+PGdm1s1/pmycBzdK8HytjeoLFO6YsD9+6KDprG6StQXBlBiXU1
         irxBLsB5zHkrV926XJbbh+5q4CL5x7VUNDBULDTJtYoCgvWMcH+OA9IbgTGLeVErq6
         pJ8yOzRneJpfoRH4TbPfqGHS2AKnGBwfq3y6wBCg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 083/137] ARM: fix function graph tracer and unwinder dependencies
Date:   Wed, 15 May 2019 12:56:04 +0200
Message-Id: <20190515090659.543869830@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 503621628b32782a07b2318e4112bd4372aa3401 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/Kconfig       | 2 +-
 arch/arm/Kconfig.debug | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index e5d56d9b712c2..3b353af9c48dc 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -69,7 +69,7 @@ config ARM
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS if (CPU_V6 || CPU_V6K || CPU_V7) && MMU
 	select HAVE_EXIT_THREAD
 	select HAVE_FTRACE_MCOUNT_RECORD if !XIP_KERNEL
-	select HAVE_FUNCTION_GRAPH_TRACER if !THUMB2_KERNEL
+	select HAVE_FUNCTION_GRAPH_TRACER if !THUMB2_KERNEL && !CC_IS_CLANG
 	select HAVE_FUNCTION_TRACER if !XIP_KERNEL
 	select HAVE_GCC_PLUGINS
 	select HAVE_GENERIC_DMA_COHERENT
diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 6d6e0330930b5..e388af4594a6e 100644
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
-- 
2.20.1



