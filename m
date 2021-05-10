Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2936378727
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233329AbhEJLOK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:14:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:46276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236067AbhEJLH0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:07:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45E9961879;
        Mon, 10 May 2021 10:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644281;
        bh=kJO0w40sNUtr5q/Az8f+/hezjDjBwSk+Ec38AWFnsf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m/kw7L7plqCLIdldcpiOJzv8nGRo4B7mmReQj6WafHQb9lpJZSIItSWSsW1/eKeb2
         ntd8WVjed7FRYAmhTHrC4qGYhShph0N8RU5FQV/TBRP5hik3Ej3O9gKTK1CUdE2ZD/
         Uu5hWOg2+x+BKSUSRnwoQP9Ls1yXD0jq7atckzb0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Guillaume Tucker <guillaume.tucker@collabora.com>,
        "kernelci.org bot" <bot@kernelci.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 5.12 019/384] ARM: 9056/1: decompressor: fix BSS size calculation for LLVM ld.lld
Date:   Mon, 10 May 2021 12:16:48 +0200
Message-Id: <20210510102015.510617789@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit c4e792d1acce31c2eb7b9193ab06ab94de05bf42 upstream.

The LLVM ld.lld linker uses a different symbol type for __bss_start,
resulting in the calculation of KBSS_SZ to be thrown off. Up until now,
this has gone unnoticed as it only affects the appended DTB case, but
pending changes for ARM in the way the decompressed kernel is cleaned
from the caches has uncovered this problem.

On a ld.lld build:

  $ nm vmlinux |grep bss_
  c1c22034 D __bss_start
  c1c86e98 B __bss_stop

resulting in

  $ readelf -s arch/arm/boot/compressed/vmlinux | grep bss_size
  433: c1c86e98     0 NOTYPE  GLOBAL DEFAULT  ABS _kernel_bss_size

which is obviously incorrect, and may cause the cache clean to access
unmapped memory, or cause the size calculation to wrap, resulting in no
cache clean to be performed at all.

Fix this by updating the sed regex to take D type symbols into account.

Link: https://lore.kernel.org/linux-arm-kernel/6c65bcef-d4e7-25fa-43cf-2c435bb61bb9@collabora.com/
Link: https://lore.kernel.org/linux-arm-kernel/20210205085220.31232-1-ardb@kernel.org/

Cc: <stable@vger.kernel.org> # v4.19+
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Reported-by: Guillaume Tucker <guillaume.tucker@collabora.com>
Reported-by: "kernelci.org bot" <bot@kernelci.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/compressed/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -118,8 +118,8 @@ asflags-y := -DZIMAGE
 
 # Supply kernel BSS size to the decompressor via a linker symbol.
 KBSS_SZ = $(shell echo $$(($$($(NM) $(obj)/../../../../vmlinux | \
-		sed -n -e 's/^\([^ ]*\) [AB] __bss_start$$/-0x\1/p' \
-		       -e 's/^\([^ ]*\) [AB] __bss_stop$$/+0x\1/p') )) )
+		sed -n -e 's/^\([^ ]*\) [ABD] __bss_start$$/-0x\1/p' \
+		       -e 's/^\([^ ]*\) [ABD] __bss_stop$$/+0x\1/p') )) )
 LDFLAGS_vmlinux = --defsym _kernel_bss_size=$(KBSS_SZ)
 # Supply ZRELADDR to the decompressor via a linker symbol.
 ifneq ($(CONFIG_AUTO_ZRELADDR),y)


