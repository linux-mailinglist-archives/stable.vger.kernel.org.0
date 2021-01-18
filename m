Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB442FA9E0
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 20:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437094AbhARTP0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 14:15:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:34192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390493AbhARLiq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:38:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0871922BF3;
        Mon, 18 Jan 2021 11:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969896;
        bh=lFwsnm6VZ1NTDGlIOKOsw/Ujr1KFH8X9VxiwdJCOhyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gBH0ezUf0tgrqpA7lwaiLVwSF+CNONgNSQA9dlyGd2549If3cYxgyXiirQx+pxmM+
         HjjoIiWPdt2aPWeS3nw2efYB0CezgLn+0J7Dt+bSBNMMyXDEmPNKHhBU1NQ6OKEGGH
         nie8NBJr9/QSdoCpSpZJli0UdhNJ00XSw8iAnBpU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.4 08/76] MIPS: boot: Fix unaligned access with CONFIG_MIPS_RAW_APPENDED_DTB
Date:   Mon, 18 Jan 2021 12:34:08 +0100
Message-Id: <20210118113341.383702001@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113340.984217512@linuxfoundation.org>
References: <20210118113340.984217512@linuxfoundation.org>
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
@@ -13,6 +13,7 @@
 #include <linux/libfdt.h>
 
 #include <asm/addrspace.h>
+#include <asm/unaligned.h>
 
 /*
  * These two variables specify the free mem region
@@ -113,7 +114,7 @@ void decompress_kernel(unsigned long boo
 		dtb_size = fdt_totalsize((void *)&__appended_dtb);
 
 		/* last four bytes is always image size in little endian */
-		image_size = le32_to_cpup((void *)&__image_end - 4);
+		image_size = get_unaligned_le32((void *)&__image_end - 4);
 
 		/* copy dtb to where the booted kernel will expect it */
 		memcpy((void *)VMLINUX_LOAD_ADDRESS_ULL + image_size,


