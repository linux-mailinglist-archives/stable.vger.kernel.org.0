Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C04A3FD604
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 07:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727339AbfKOGVk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 01:21:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:50574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727387AbfKOGVk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Nov 2019 01:21:40 -0500
Received: from localhost (unknown [104.132.150.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3F2D2053B;
        Fri, 15 Nov 2019 06:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573798899;
        bh=Lzo/2fcFnObehszJJ05vKGc6TU4nb2GN4c4SDiqw27w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FLQXkKXU2H80mbTHC7gtY2RD6w1pXbSbVuMMvpzPchA7k5HvckPVFnRdp23DqSNKV
         4cKqdV+G3dqRiuY3lJ9cB/AvasWQ/wIlacNIepmbN8JqKp/HxCAXrwC0hAKBw5bZow
         h1q4HJhJwycXF7k7SE+7ZTadZv25281pVlmB3Zio=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Andrew Donnellan <ajd@linux.ibm.com>
Subject: [PATCH 4.4 04/20] powerpc: Fix compiling a BE kernel with a powerpc64le toolchain
Date:   Fri, 15 Nov 2019 14:20:33 +0800
Message-Id: <20191115062009.322973021@linuxfoundation.org>
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

From: Nicholas Piggin <npiggin@gmail.com>

commit 4dc831aa88132f835cefe876aa0206977c4d7710 upstream.

GCC can compile with either endian, but the default ABI version is set
based on the default endianness of the toolchain. Alan Modra says:

  you need both -mbig and -mabi=elfv1 to make a powerpc64le gcc
  generate powerpc64 code

The opposite is true for powerpc64 when generating -mlittle it
requires -mabi=elfv2 to generate v2 ABI, which we were already doing.

This change adds ABI annotations together with endianness for all cases,
LE and BE. This fixes the case of building a BE kernel with a toolchain
that is LE by default.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Tested-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Andrew Donnellan <ajd@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/Makefile |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -79,8 +79,15 @@ GNUTARGET	:= powerpc
 MULTIPLEWORD	:= -mmultiple
 endif
 
-cflags-$(CONFIG_CPU_BIG_ENDIAN)		+= $(call cc-option,-mbig-endian)
+ifdef CONFIG_PPC64
+cflags-$(CONFIG_CPU_BIG_ENDIAN)		+= $(call cc-option,-mabi=elfv1)
+cflags-$(CONFIG_CPU_BIG_ENDIAN)		+= $(call cc-option,-mcall-aixdesc)
+aflags-$(CONFIG_CPU_BIG_ENDIAN)		+= $(call cc-option,-mabi=elfv1)
+aflags-$(CONFIG_CPU_LITTLE_ENDIAN)	+= -mabi=elfv2
+endif
+
 cflags-$(CONFIG_CPU_LITTLE_ENDIAN)	+= -mlittle-endian
+cflags-$(CONFIG_CPU_BIG_ENDIAN)		+= $(call cc-option,-mbig-endian)
 ifneq ($(cc-name),clang)
   cflags-$(CONFIG_CPU_LITTLE_ENDIAN)	+= -mno-strict-align
 endif
@@ -120,7 +127,9 @@ ifeq ($(CONFIG_CPU_LITTLE_ENDIAN),y)
 CFLAGS-$(CONFIG_PPC64)	+= $(call cc-option,-mabi=elfv2,$(call cc-option,-mcall-aixdesc))
 AFLAGS-$(CONFIG_PPC64)	+= $(call cc-option,-mabi=elfv2)
 else
+CFLAGS-$(CONFIG_PPC64)	+= $(call cc-option,-mabi=elfv1)
 CFLAGS-$(CONFIG_PPC64)	+= $(call cc-option,-mcall-aixdesc)
+AFLAGS-$(CONFIG_PPC64)	+= $(call cc-option,-mabi=elfv1)
 endif
 CFLAGS-$(CONFIG_PPC64)	+= $(call cc-option,-mcmodel=medium,$(call cc-option,-mminimal-toc))
 CFLAGS-$(CONFIG_PPC64)	+= $(call cc-option,-mno-pointers-to-nested-functions)


