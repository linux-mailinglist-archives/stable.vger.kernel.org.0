Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEA303D5C1E
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 16:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234584AbhGZOLm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 10:11:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234691AbhGZOLl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 10:11:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14C1660F38;
        Mon, 26 Jul 2021 14:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627311130;
        bh=HmJamR4DF8R3JiOkeQDkQrlPV4QfpmOrQy6gPG/dDX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UXJANHAp6BcHf+FFfyGULRRIcyl6FXBhBoJ84Bb37bXjAQtFqC6qhTTXRaqb9NdMl
         R6q3BWA9Wbgt3LI77WQ1fbe/gmxVo6Dwux07ONqCfnpW6+yiidGfL3YL/q/FFhdWRP
         Z/vZvNjZjHQVbqCrp37ZRs2WPCS1tetb8oQaXz7h5aYkvpOp0lrK8gmK7Itwve1gUR
         oVDdKV+PiGSfyeyLBXkGgSeLqvwvEdmAL2ClJxfUYML4N9nsiw2fchoruopGeSnQNm
         fAHJJhojmY+CGcDTGZmXxmOecDbUq4XJV1fPtnki6mmW8whvb6yAsW0sgAunth0vd7
         4mGodlW+ChwWg==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ardb@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v3 4/4] efi/libstub: arm64: Double check image alignment at entry
Date:   Mon, 26 Jul 2021 16:51:56 +0200
Message-Id: <20210726145156.12006-5-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210726145156.12006-1-ardb@kernel.org>
References: <20210726145156.12006-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/firmware/efi/libstub/arm64-stub.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
index 010564f8bbc4..2363fee9211c 100644
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
-- 
2.20.1

