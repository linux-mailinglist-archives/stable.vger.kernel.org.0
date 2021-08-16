Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41EDC3ED697
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239563AbhHPNWZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:22:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:44416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240939AbhHPNUY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:20:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B10BA63304;
        Mon, 16 Aug 2021 13:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119734;
        bh=RpW2zC9BPsC3SH+gJglb1jVNby7j7xJJFJpo7r9P9DQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ABfWbGetGlZO/EO1i/GwpAdOPRKhssu76fiH+FELjdzn+uqfUgRZUyJCyboAy6kEZ
         ZezQQiuio2dLOfX/BhN8nj9paeN4UukkNqp4iSjkVJngI0a+iWxEQy4pJKvbHJLTXm
         wo5DjAJhPhSa9gJ2N0qB2i74o6wjwp6RAo/ByywM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 5.13 142/151] efi/libstub: arm64: Double check image alignment at entry
Date:   Mon, 16 Aug 2021 15:02:52 +0200
Message-Id: <20210816125448.749919880@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit c32ac11da3f83bb42b986702a9b92f0a14ed4182 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/libstub/arm64-stub.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -119,6 +119,10 @@ efi_status_t handle_kernel_image(unsigne
 	if (image->image_base != _text)
 		efi_err("FIRMWARE BUG: efi_loaded_image_t::image_base has bogus value\n");
 
+	if (!IS_ALIGNED((u64)_text, EFI_KIMG_ALIGN))
+		efi_err("FIRMWARE BUG: kernel image not aligned on %ldk boundary\n",
+			EFI_KIMG_ALIGN >> 10);
+
 	kernel_size = _edata - _text;
 	kernel_memsize = kernel_size + (_end - _edata);
 	*reserve_size = kernel_memsize;


