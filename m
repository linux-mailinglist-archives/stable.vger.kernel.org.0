Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E17A42FA8B0
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 19:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405526AbhARPGq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 10:06:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:37702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390440AbhARLmK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:42:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B236D22C9E;
        Mon, 18 Jan 2021 11:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970089;
        bh=m4ymd2fNxXxFif/SvlMsS4oYWteIPT4NYyORcE9nDo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W/k9d2wcOLf5oPIl8htRBM6NaWRvfRBuice6bSL0o1fDqgSUdUtX3zdoVL8uYE99t
         6DiLi1jGKIL5SKvXkz0cJQ0ud0TWjMMp1jenKUqc/OGNlGWjKxeTwv2RcuV/1s2yDC
         p459PZZT98l2ma/95OvRLRkGvHvB09PlTONFtWs0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.10 031/152] MIPS: boot: Fix unaligned access with CONFIG_MIPS_RAW_APPENDED_DTB
Date:   Mon, 18 Jan 2021 12:33:26 +0100
Message-Id: <20210118113354.271172142@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
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
@@ -117,7 +118,7 @@ void decompress_kernel(unsigned long boo
 		dtb_size = fdt_totalsize((void *)&__appended_dtb);
 
 		/* last four bytes is always image size in little endian */
-		image_size = le32_to_cpup((void *)&__image_end - 4);
+		image_size = get_unaligned_le32((void *)&__image_end - 4);
 
 		/* copy dtb to where the booted kernel will expect it */
 		memcpy((void *)VMLINUX_LOAD_ADDRESS_ULL + image_size,


