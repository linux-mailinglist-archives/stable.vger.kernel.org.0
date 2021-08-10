Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D09FB3E5537
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 10:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238182AbhHJIbV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 04:31:21 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:41652 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233746AbhHJIbV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Aug 2021 04:31:21 -0400
Date:   Tue, 10 Aug 2021 08:30:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1628584257;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=R3+Z3k4bu+GGLrnbVnnpvaw14kwNMHvJNvXzsr4E370=;
        b=lB02Bwl635FoaRbPQCTFEJcnasX6cewq9UY2SHKeLnX4rv1qoiQYg25X0aqiCUkvbH+Y26
        v5I/ejkdMWfdFSmp3FdXHjGeg3WlJr6g+E0XvXxPrfAgX61iSWIF8kz5L4zkFjwiIWHrdd
        uAXzte7MF/XYL3/uATLwkKZfLNGancqTdY11aLfwpfPJJQsaBW9oSeVbUaHUDvyfCitTFr
        WXANnXG7gUrRXVEmux8AFwdIudYEGzcvntRHSBGiKRFhYFa5/Ru3EO2zeU+dZboHUOIPtX
        4rY5ithqRZHP1Q3coOidmDaB2TCiN2Yb0v6kQROQVdVu4Pcq93qwSKBBkLdpzw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1628584257;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=R3+Z3k4bu+GGLrnbVnnpvaw14kwNMHvJNvXzsr4E370=;
        b=ISUh3DWq+ottC6XRovQ6iO06OZELQivnDuu3XRScqEnc5JPPYMWttNpll+j4ExSxfpdvSF
        FfW+dnHhog02pdCg==
From:   "tip-bot2 for Ard Biesheuvel" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: efi/urgent] efi/libstub: arm64: Double check image alignment at entry
Cc:     <stable@vger.kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-ID: <162858425681.395.14788450101078215076.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the efi/urgent branch of tip:

Commit-ID:     c32ac11da3f83bb42b986702a9b92f0a14ed4182
Gitweb:        https://git.kernel.org/tip/c32ac11da3f83bb42b986702a9b92f0a14ed4182
Author:        Ard Biesheuvel <ardb@kernel.org>
AuthorDate:    Mon, 26 Jul 2021 16:31:44 +02:00
Committer:     Ard Biesheuvel <ardb@kernel.org>
CommitterDate: Tue, 03 Aug 2021 07:43:13 +02:00

efi/libstub: arm64: Double check image alignment at entry

On arm64, the stub only moves the kernel image around in memory if
needed, which is typically only for KASLR, given that relocatable
kernels (which is the default) can run from any 64k aligned address,
which is also the minimum alignment communicated to EFI via the PE/COFF
header.

Unfortunately, some loaders appear to ignore this header, and load the
kernel at some arbitrary offset in memory. We can deal with this, but
let's check for this condition anyway, so non-compliant code can be
spotted and fixed.

Cc: <stable@vger.kernel.org> # v5.10+
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Tested-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 drivers/firmware/efi/libstub/arm64-stub.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
index 010564f..2363fee 100644
--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -119,6 +119,10 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 	if (image->image_base != _text)
 		efi_err("FIRMWARE BUG: efi_loaded_image_t::image_base has bogus value\n");
 
+	if (!IS_ALIGNED((u64)_text, EFI_KIMG_ALIGN))
+		efi_err("FIRMWARE BUG: kernel image not aligned on %ldk boundary\n",
+			EFI_KIMG_ALIGN >> 10);
+
 	kernel_size = _edata - _text;
 	kernel_memsize = kernel_size + (_end - _edata);
 	*reserve_size = kernel_memsize;
