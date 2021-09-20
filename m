Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B928E411B7A
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241962AbhITQ65 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:58:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:45190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343694AbhITQ4n (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:56:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D40161359;
        Mon, 20 Sep 2021 16:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156689;
        bh=QEIpEauqMVQHTTKwPThLQMQF/ItxHwVo6fas/4hyDyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BQono5Ct6rwfLp4DhqquO+37aQcLUSxOOslbiiPk2aknS1yWt9LQPwWjQcx9jHdXO
         BdK7Q+eGIYotEIGFvzcCDOl0xsHUgytfCgUstmRz0gtdYJewzAuuFpwWfFtA/KBTdP
         hTPdJrkkvvmKTBZodZmCmNLyJJbExz1eEU2N16RM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Dooks <ben.dooks@codethink.co.uk>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 4.9 008/175] ARM: 8918/2: only build return_address() if needed
Date:   Mon, 20 Sep 2021 18:40:57 +0200
Message-Id: <20210920163918.339840582@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Dooks <ben-linux@fluff.org>

commit fb033c95c94ca1ee3d16e04ebdb85d65fb55fff8 upstream.

The system currently warns if the config conditions for
building return_address in arch/arm/kernel/return_address.c
are not met, leaving just an EXPORT_SYMBOL_GPL(return_address)
of a function defined to be 'static linline'.
This is a result of aeea3592a13b ("ARM: 8158/1: LLVMLinux: use static inline in ARM ftrace.h").

Since we're not going to build anything other than an exported
symbol for something that is already being defined to be an
inline-able return of NULL, just avoid building the code to
remove the following warning:

Fixes: aeea3592a13b ("ARM: 8158/1: LLVMLinux: use static inline in ARM ftrace.h")
Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/kernel/Makefile         |    6 +++++-
 arch/arm/kernel/return_address.c |    4 ----
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -16,10 +16,14 @@ CFLAGS_REMOVE_return_address.o = -pg
 # Object file lists.
 
 obj-y		:= elf.o entry-common.o irq.o opcodes.o \
-		   process.o ptrace.o reboot.o return_address.o \
+		   process.o ptrace.o reboot.o \
 		   setup.o signal.o sigreturn_codes.o \
 		   stacktrace.o sys_arm.o time.o traps.o
 
+ifneq ($(CONFIG_ARM_UNWIND),y)
+obj-$(CONFIG_FRAME_POINTER)	+= return_address.o
+endif
+
 obj-$(CONFIG_ATAGS)		+= atags_parse.o
 obj-$(CONFIG_ATAGS_PROC)	+= atags_proc.o
 obj-$(CONFIG_DEPRECATED_PARAM_STRUCT) += atags_compat.o
--- a/arch/arm/kernel/return_address.c
+++ b/arch/arm/kernel/return_address.c
@@ -10,8 +10,6 @@
  */
 #include <linux/export.h>
 #include <linux/ftrace.h>
-
-#if defined(CONFIG_FRAME_POINTER) && !defined(CONFIG_ARM_UNWIND)
 #include <linux/sched.h>
 
 #include <asm/stacktrace.h>
@@ -56,6 +54,4 @@ void *return_address(unsigned int level)
 		return NULL;
 }
 
-#endif /* if defined(CONFIG_FRAME_POINTER) && !defined(CONFIG_ARM_UNWIND) */
-
 EXPORT_SYMBOL_GPL(return_address);


