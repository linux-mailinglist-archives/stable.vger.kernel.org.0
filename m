Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B76B1486D3
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 15:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391031AbgAXOSo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 09:18:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:38420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390998AbgAXOSn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 09:18:43 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89B4B214DB;
        Fri, 24 Jan 2020 14:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875522;
        bh=/0Ksl39P2LVCGJpGFA7i6rnSlgdgbXNvz6q6O1RuE+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kI4djcW4exCiDjImmWiKjhjkXtRsEsx7+w2m++g94/8aZLBF1GPT3xgEkoAh6Bvlw
         c0ryfrv3IBxWIpW1seCbzkWDd0C9l3KqTHngiKC1wTlttxcVOCzu0/wmUJxGtFBSr6
         bl6mLs2fopjfNTT75KGJ0Vtwo8rNNkuPT9JAiwWg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arvind Sankar <nivedita@alum.mit.edu>,
        Ard Biesheuvel <ardb@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 021/107] efi/earlycon: Fix write-combine mapping on x86
Date:   Fri, 24 Jan 2020 09:16:51 -0500
Message-Id: <20200124141817.28793-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124141817.28793-1-sashal@kernel.org>
References: <20200124141817.28793-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arvind Sankar <nivedita@alum.mit.edu>

[ Upstream commit d92b54570d24d017d2630e314b525ed792f5aa6c ]

On x86, until PAT is initialized, WC translates into UC-. Since we
calculate and store pgprot_writecombine(PAGE_KERNEL) when earlycon is
initialized, this means we actually use UC- mappings instead of WC
mappings, which makes scrolling very slow.

Instead store a boolean flag to indicate whether we want to use
writeback or write-combine mappings, and recalculate the actual pgprot_t
we need on every mapping. Once PAT is initialized, we will start using
write-combine mappings, which speeds up the scrolling considerably.

Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org
Fixes: 69c1f396f25b ("efi/x86: Convert x86 EFI earlyprintk into generic earlycon implementation")
Link: https://lkml.kernel.org/r/20191224132909.102540-2-ardb@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/earlycon.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/firmware/efi/earlycon.c b/drivers/firmware/efi/earlycon.c
index d4077db6dc97f..5d4f84781aa03 100644
--- a/drivers/firmware/efi/earlycon.c
+++ b/drivers/firmware/efi/earlycon.c
@@ -17,7 +17,7 @@ static const struct console *earlycon_console __initdata;
 static const struct font_desc *font;
 static u32 efi_x, efi_y;
 static u64 fb_base;
-static pgprot_t fb_prot;
+static bool fb_wb;
 static void *efi_fb;
 
 /*
@@ -33,10 +33,8 @@ static int __init efi_earlycon_remap_fb(void)
 	if (!earlycon_console || !(earlycon_console->flags & CON_ENABLED))
 		return 0;
 
-	if (pgprot_val(fb_prot) == pgprot_val(PAGE_KERNEL))
-		efi_fb = memremap(fb_base, screen_info.lfb_size, MEMREMAP_WB);
-	else
-		efi_fb = memremap(fb_base, screen_info.lfb_size, MEMREMAP_WC);
+	efi_fb = memremap(fb_base, screen_info.lfb_size,
+			  fb_wb ? MEMREMAP_WB : MEMREMAP_WC);
 
 	return efi_fb ? 0 : -ENOMEM;
 }
@@ -53,9 +51,12 @@ late_initcall(efi_earlycon_unmap_fb);
 
 static __ref void *efi_earlycon_map(unsigned long start, unsigned long len)
 {
+	pgprot_t fb_prot;
+
 	if (efi_fb)
 		return efi_fb + start;
 
+	fb_prot = fb_wb ? PAGE_KERNEL : pgprot_writecombine(PAGE_KERNEL);
 	return early_memremap_prot(fb_base + start, len, pgprot_val(fb_prot));
 }
 
@@ -215,10 +216,7 @@ static int __init efi_earlycon_setup(struct earlycon_device *device,
 	if (screen_info.capabilities & VIDEO_CAPABILITY_64BIT_BASE)
 		fb_base |= (u64)screen_info.ext_lfb_base << 32;
 
-	if (opt && !strcmp(opt, "ram"))
-		fb_prot = PAGE_KERNEL;
-	else
-		fb_prot = pgprot_writecombine(PAGE_KERNEL);
+	fb_wb = opt && !strcmp(opt, "ram");
 
 	si = &screen_info;
 	xres = si->lfb_width;
-- 
2.20.1

