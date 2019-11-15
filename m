Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33FF8FD661
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 07:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725848AbfKOGYR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 01:24:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:50550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727192AbfKOGVh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Nov 2019 01:21:37 -0500
Received: from localhost (unknown [104.132.150.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B52A420815;
        Fri, 15 Nov 2019 06:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573798897;
        bh=CkL0tDFA+Apaq1emDTVz2gK/dfHItz5GIQYcLZnx45g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=clQw6Ick6MsAp4t8G62IZcobDuqogIuSqfYwh1Ttt2nDzFt8kydGMKWX4vlhS+abL
         Eh3Pf23z9kYSKGmxijq1pIA7F/eLmAWsx/fSm3yEr73e52YKc6sKaDC6mYT5fBHlAv
         hjTo2RnIKsiDX8MsK8ggKshW3j37vaLLBBQTpcnY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Andrew Donnellan <ajd@linux.ibm.com>
Subject: [PATCH 4.4 03/20] powerpc/Makefile: Use cflags-y/aflags-y for setting endian options
Date:   Fri, 15 Nov 2019 14:20:32 +0800
Message-Id: <20191115062008.666712711@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191115062006.854443935@linuxfoundation.org>
References: <20191115062006.854443935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit 164af597ce945751e2dcd53d0a86e84203a6d117 upstream.

When we introduced the little endian support, we added the endian flags
to CC directly using override. I don't know the history of why we did
that, I suspect no one does.

Although this mostly works, it has one bug, which is that CROSS32CC
doesn't get -mbig-endian. That means when the compiler is little endian
by default and the user is building big endian, vdso32 is incorrectly
compiled as little endian and the kernel fails to build.

Instead we can add the endian flags to cflags-y/aflags-y, and then
append those to KBUILD_CFLAGS/KBUILD_AFLAGS.

This has the advantage of being 1) less ugly, 2) the documented way of
adding flags in the arch Makefile and 3) it fixes building vdso32 with a
LE toolchain.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Andrew Donnellan <ajd@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/Makefile |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -66,29 +66,28 @@ endif
 UTS_MACHINE := $(OLDARCH)
 
 ifeq ($(CONFIG_CPU_LITTLE_ENDIAN),y)
-override CC	+= -mlittle-endian
-ifneq ($(cc-name),clang)
-override CC	+= -mno-strict-align
-endif
-override AS	+= -mlittle-endian
 override LD	+= -EL
-override CROSS32CC += -mlittle-endian
 override CROSS32AS += -mlittle-endian
 LDEMULATION	:= lppc
 GNUTARGET	:= powerpcle
 MULTIPLEWORD	:= -mno-multiple
 KBUILD_CFLAGS_MODULE += $(call cc-option,-mno-save-toc-indirect)
 else
-ifeq ($(call cc-option-yn,-mbig-endian),y)
-override CC	+= -mbig-endian
-override AS	+= -mbig-endian
-endif
 override LD	+= -EB
 LDEMULATION	:= ppc
 GNUTARGET	:= powerpc
 MULTIPLEWORD	:= -mmultiple
 endif
 
+cflags-$(CONFIG_CPU_BIG_ENDIAN)		+= $(call cc-option,-mbig-endian)
+cflags-$(CONFIG_CPU_LITTLE_ENDIAN)	+= -mlittle-endian
+ifneq ($(cc-name),clang)
+  cflags-$(CONFIG_CPU_LITTLE_ENDIAN)	+= -mno-strict-align
+endif
+
+aflags-$(CONFIG_CPU_BIG_ENDIAN)		+= $(call cc-option,-mbig-endian)
+aflags-$(CONFIG_CPU_LITTLE_ENDIAN)	+= -mlittle-endian
+
 ifeq ($(HAS_BIARCH),y)
 override AS	+= -a$(CONFIG_WORD_SIZE)
 override LD	+= -m elf$(CONFIG_WORD_SIZE)$(LDEMULATION)
@@ -212,6 +211,9 @@ cpu-as-$(CONFIG_E200)		+= -Wa,-me200
 KBUILD_AFLAGS += $(cpu-as-y)
 KBUILD_CFLAGS += $(cpu-as-y)
 
+KBUILD_AFLAGS += $(aflags-y)
+KBUILD_CFLAGS += $(cflags-y)
+
 head-y				:= arch/powerpc/kernel/head_$(CONFIG_WORD_SIZE).o
 head-$(CONFIG_8xx)		:= arch/powerpc/kernel/head_8xx.o
 head-$(CONFIG_40x)		:= arch/powerpc/kernel/head_40x.o


