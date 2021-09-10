Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56445406C18
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 14:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234359AbhIJMgs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 08:36:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:53394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233812AbhIJMfr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 08:35:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9362F6120C;
        Fri, 10 Sep 2021 12:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631277276;
        bh=An+Lp+ljJHzr4qbhSJgFcGmghQyzGx5bjkpP6Kj/AsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=luqUOQL2tLNhnIYyIi0nc3Ut98kF9QsEoUn4QTIudfthKDDXWUSK68LjOILlhfh7h
         jlHMLlgYObOGtD9h1C9sY+huQzm7cDC5UbjZIPVia0adr0JOrRSO6kSGJYzc9dcss+
         l4kf7uM6Rv9knNMjp0hJkbFn8yjjtLXFqJG6Xttw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Dooks <ben.dooks@codethink.co.uk>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 5.4 17/37] ARM: 8918/2: only build return_address() if needed
Date:   Fri, 10 Sep 2021 14:30:20 +0200
Message-Id: <20210910122917.737586266@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910122917.149278545@linuxfoundation.org>
References: <20210910122917.149278545@linuxfoundation.org>
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
@@ -17,10 +17,14 @@ CFLAGS_REMOVE_return_address.o = -pg
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
@@ -7,8 +7,6 @@
  */
 #include <linux/export.h>
 #include <linux/ftrace.h>
-
-#if defined(CONFIG_FRAME_POINTER) && !defined(CONFIG_ARM_UNWIND)
 #include <linux/sched.h>
 
 #include <asm/stacktrace.h>
@@ -53,6 +51,4 @@ void *return_address(unsigned int level)
 		return NULL;
 }
 
-#endif /* if defined(CONFIG_FRAME_POINTER) && !defined(CONFIG_ARM_UNWIND) */
-
 EXPORT_SYMBOL_GPL(return_address);


