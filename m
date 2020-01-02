Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D141A12F132
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbgABWPM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:15:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:55882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727156AbgABWPM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:15:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9A7A21582;
        Thu,  2 Jan 2020 22:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003311;
        bh=Ntjc8Wl3a9ScWfKbBQt5/x2fazMxvzR850E7vCqoHKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N6Ek2+yuMSwCBhnF1fr5Cvq8dJqpVseNyGS9RVzakPbm+gVJm7Mnbl14DlGnSh5d1
         JxdDToZa2Tqx04mgWixwt0hYUz2vBaWYR0Wc9AXfbnWG++VBIK4pDCBYXj6cuCxn3l
         iVKV7+WCYvtT3+6aBER1bOHLIycExPebxF52GdZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Axtens <dja@axtens.net>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 107/191] powerpc: Dont add -mabi= flags when building with Clang
Date:   Thu,  2 Jan 2020 23:06:29 +0100
Message-Id: <20200102215841.382299263@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit 465bfd9c44dea6b55962b5788a23ac87a467c923 ]

When building pseries_defconfig, building vdso32 errors out:

  error: unknown target ABI 'elfv1'

This happens because -m32 in clang changes the target to 32-bit,
which does not allow the ABI to be changed.

Commit 4dc831aa8813 ("powerpc: Fix compiling a BE kernel with a
powerpc64le toolchain") added these flags to fix building big endian
kernels with a little endian GCC.

Clang doesn't need -mabi because the target triple controls the
default value. -mlittle-endian and -mbig-endian manipulate the triple
into either powerpc64-* or powerpc64le-*, which properly sets the
default ABI.

Adding a debug print out in the PPC64TargetInfo constructor after line
383 above shows this:

  $ echo | ./clang -E --target=powerpc64-linux -mbig-endian -o /dev/null -
  Default ABI: elfv1

  $ echo | ./clang -E --target=powerpc64-linux -mlittle-endian -o /dev/null -
  Default ABI: elfv2

  $ echo | ./clang -E --target=powerpc64le-linux -mbig-endian -o /dev/null -
  Default ABI: elfv1

  $ echo | ./clang -E --target=powerpc64le-linux -mlittle-endian -o /dev/null -
  Default ABI: elfv2

Don't specify -mabi when building with clang to avoid the build error
with -m32 and not change any code generation.

-mcall-aixdesc is not an implemented flag in clang so it can be safely
excluded as well, see commit 238abecde8ad ("powerpc: Don't use gcc
specific options on clang").

pseries_defconfig successfully builds after this patch and
powernv_defconfig and ppc44x_defconfig don't regress.

Reviewed-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
[mpe: Trim clang links in change log]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20191119045712.39633-2-natechancellor@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index 83522c9fc7b6..37ac731a556b 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -91,11 +91,13 @@ MULTIPLEWORD	:= -mmultiple
 endif
 
 ifdef CONFIG_PPC64
+ifndef CONFIG_CC_IS_CLANG
 cflags-$(CONFIG_CPU_BIG_ENDIAN)		+= $(call cc-option,-mabi=elfv1)
 cflags-$(CONFIG_CPU_BIG_ENDIAN)		+= $(call cc-option,-mcall-aixdesc)
 aflags-$(CONFIG_CPU_BIG_ENDIAN)		+= $(call cc-option,-mabi=elfv1)
 aflags-$(CONFIG_CPU_LITTLE_ENDIAN)	+= -mabi=elfv2
 endif
+endif
 
 ifndef CONFIG_CC_IS_CLANG
   cflags-$(CONFIG_CPU_LITTLE_ENDIAN)	+= -mno-strict-align
@@ -141,6 +143,7 @@ endif
 endif
 
 CFLAGS-$(CONFIG_PPC64)	:= $(call cc-option,-mtraceback=no)
+ifndef CONFIG_CC_IS_CLANG
 ifdef CONFIG_CPU_LITTLE_ENDIAN
 CFLAGS-$(CONFIG_PPC64)	+= $(call cc-option,-mabi=elfv2,$(call cc-option,-mcall-aixdesc))
 AFLAGS-$(CONFIG_PPC64)	+= $(call cc-option,-mabi=elfv2)
@@ -149,6 +152,7 @@ CFLAGS-$(CONFIG_PPC64)	+= $(call cc-option,-mabi=elfv1)
 CFLAGS-$(CONFIG_PPC64)	+= $(call cc-option,-mcall-aixdesc)
 AFLAGS-$(CONFIG_PPC64)	+= $(call cc-option,-mabi=elfv1)
 endif
+endif
 CFLAGS-$(CONFIG_PPC64)	+= $(call cc-option,-mcmodel=medium,$(call cc-option,-mminimal-toc))
 CFLAGS-$(CONFIG_PPC64)	+= $(call cc-option,-mno-pointers-to-nested-functions)
 
-- 
2.20.1



