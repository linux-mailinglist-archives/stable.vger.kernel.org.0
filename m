Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28B5112B8C4
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 18:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727507AbfL0Rlf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 12:41:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:37876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727494AbfL0Rle (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 12:41:34 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC9742464B;
        Fri, 27 Dec 2019 17:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468493;
        bh=pi/P+3pN5Ai8bK46UNHG6DF35AfdvUZ2ZeSdUUks3Pg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V6qwOEKrqoFkvu0gMuY1fqg0dH0Mub3v7pCO1awFWpzKplHVnBF2Rmz4Twy7ZMI6I
         AE9rjB6cskZPmK6czp9qv+Yqe8ize3hrvPsSRAJEQaBO73WuYMWMTLVIH8pI6Waasq
         6trxhHbdUT0GXpL58TARLoMUc4uAF0JTt14bqaPs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Bhupesh Sharma <bhsharma@redhat.com>,
        Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>,
        linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 029/187] efi/earlycon: Remap entire framebuffer after page initialization
Date:   Fri, 27 Dec 2019 12:38:17 -0500
Message-Id: <20191227174055.4923-29-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit b418d660bb9798d2249ac6a46c844389ef50b6a5 ]

When commit:

  69c1f396f25b ("efi/x86: Convert x86 EFI earlyprintk into generic earlycon implementation")

moved the x86 specific EFI earlyprintk implementation to a shared location,
it also tweaked the behaviour. In particular, it dropped a trick with full
framebuffer remapping after page initialization, leading to two regressions:

  1) very slow scrolling after page initialization,
  2) kernel hang when the 'keep_bootcon' command line argument is passed.

Putting the tweak back fixes #2 and mitigates #1, i.e., it limits the slow
behavior to the early boot stages, presumably due to eliminating heavy
map()/unmap() operations per each pixel line on the screen.

 [ ardb: ensure efifb is unmapped again unless keep_bootcon is in effect. ]
 [ mingo: speling fixes. ]

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Cc: Arvind Sankar <nivedita@alum.mit.edu>
Cc: Bhupesh Sharma <bhsharma@redhat.com>
Cc: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Cc: linux-efi@vger.kernel.org
Fixes: 69c1f396f25b ("efi/x86: Convert x86 EFI earlyprintk into generic earlycon implementation")
Link: https://lkml.kernel.org/r/20191206165542.31469-7-ardb@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/earlycon.c | 40 +++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/firmware/efi/earlycon.c b/drivers/firmware/efi/earlycon.c
index c9a0efca17b0..d4077db6dc97 100644
--- a/drivers/firmware/efi/earlycon.c
+++ b/drivers/firmware/efi/earlycon.c
@@ -13,18 +13,57 @@
 
 #include <asm/early_ioremap.h>
 
+static const struct console *earlycon_console __initdata;
 static const struct font_desc *font;
 static u32 efi_x, efi_y;
 static u64 fb_base;
 static pgprot_t fb_prot;
+static void *efi_fb;
+
+/*
+ * EFI earlycon needs to use early_memremap() to map the framebuffer.
+ * But early_memremap() is not usable for 'earlycon=efifb keep_bootcon',
+ * memremap() should be used instead. memremap() will be available after
+ * paging_init() which is earlier than initcall callbacks. Thus adding this
+ * early initcall function early_efi_map_fb() to map the whole EFI framebuffer.
+ */
+static int __init efi_earlycon_remap_fb(void)
+{
+	/* bail if there is no bootconsole or it has been disabled already */
+	if (!earlycon_console || !(earlycon_console->flags & CON_ENABLED))
+		return 0;
+
+	if (pgprot_val(fb_prot) == pgprot_val(PAGE_KERNEL))
+		efi_fb = memremap(fb_base, screen_info.lfb_size, MEMREMAP_WB);
+	else
+		efi_fb = memremap(fb_base, screen_info.lfb_size, MEMREMAP_WC);
+
+	return efi_fb ? 0 : -ENOMEM;
+}
+early_initcall(efi_earlycon_remap_fb);
+
+static int __init efi_earlycon_unmap_fb(void)
+{
+	/* unmap the bootconsole fb unless keep_bootcon has left it enabled */
+	if (efi_fb && !(earlycon_console->flags & CON_ENABLED))
+		memunmap(efi_fb);
+	return 0;
+}
+late_initcall(efi_earlycon_unmap_fb);
 
 static __ref void *efi_earlycon_map(unsigned long start, unsigned long len)
 {
+	if (efi_fb)
+		return efi_fb + start;
+
 	return early_memremap_prot(fb_base + start, len, pgprot_val(fb_prot));
 }
 
 static __ref void efi_earlycon_unmap(void *addr, unsigned long len)
 {
+	if (efi_fb)
+		return;
+
 	early_memunmap(addr, len);
 }
 
@@ -201,6 +240,7 @@ static int __init efi_earlycon_setup(struct earlycon_device *device,
 		efi_earlycon_scroll_up();
 
 	device->con->write = efi_earlycon_write;
+	earlycon_console = device->con;
 	return 0;
 }
 EARLYCON_DECLARE(efifb, efi_earlycon_setup);
-- 
2.20.1

