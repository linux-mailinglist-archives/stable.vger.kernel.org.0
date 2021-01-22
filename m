Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA2B300D37
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 21:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbhAVT7y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 14:59:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:36982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728462AbhAVORg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:17:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77D4A23B16;
        Fri, 22 Jan 2021 14:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324823;
        bh=zaTqVZ8W/xKSP71GjhGxhsY7iZ9tOSob2d8PT2TreXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=azBuPp4kbDxNaH80+ij237R0WZS+DnICYcLVVzIuylgAAZ46GSMfUR24tbb4oyv9B
         WzUaiuV8UJtC9WF+3TOnotsj/XFWH6fnMrqRiWMiBWeHHrCb0MOwbe5fAsXQw2p9ko
         vd38Rszbu6MCyq9LIoM3TuGrKgP7hh1mS4ngvtLY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 4.14 02/50] MIPS: boot: Fix unaligned access with CONFIG_MIPS_RAW_APPENDED_DTB
Date:   Fri, 22 Jan 2021 15:11:43 +0100
Message-Id: <20210122135735.269604654@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.176469491@linuxfoundation.org>
References: <20210122135735.176469491@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

commit 4d4f9c1a17a3480f8fe523673f7232b254d724b7 upstream.

The compressed payload is not necesarily 4-byte aligned, at least when
compiling with Clang. In that case, the 4-byte value appended to the
compressed payload that corresponds to the uncompressed kernel image
size must be read using get_unaligned_le32().

This fixes Clang-built kernels not booting on MIPS (tested on a Ingenic
JZ4770 board).

Fixes: b8f54f2cde78 ("MIPS: ZBOOT: copy appended dtb to the end of the kernel")
Cc: <stable@vger.kernel.org> # v4.7
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/boot/compressed/decompress.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/mips/boot/compressed/decompress.c
+++ b/arch/mips/boot/compressed/decompress.c
@@ -17,6 +17,7 @@
 #include <linux/libfdt.h>
 
 #include <asm/addrspace.h>
+#include <asm/unaligned.h>
 
 /*
  * These two variables specify the free mem region
@@ -124,7 +125,7 @@ void decompress_kernel(unsigned long boo
 		dtb_size = fdt_totalsize((void *)&__appended_dtb);
 
 		/* last four bytes is always image size in little endian */
-		image_size = le32_to_cpup((void *)&__image_end - 4);
+		image_size = get_unaligned_le32((void *)&__image_end - 4);
 
 		/* copy dtb to where the booted kernel will expect it */
 		memcpy((void *)VMLINUX_LOAD_ADDRESS_ULL + image_size,


