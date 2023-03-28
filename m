Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7F606CC305
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233438AbjC1Oup (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233437AbjC1Oub (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:50:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9926DCDE6
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:49:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7942C6181A
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:49:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87702C433EF;
        Tue, 28 Mar 2023 14:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680014993;
        bh=pSMiX2rHKJCPkFdCK4tKUID+GbpZO3gXUGYAUf+VHHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n31paQuYxMs83ZOrakJuTevJTKGBbhXNwnDM+o0GQCP6jGG0LbyuaPhAefpAFFZjV
         21Q/1N1j2qyiSAEvtBneNMzRYd6QaYlFJ0jfPZOQyUfFiVxUNTUQyHA7a/VdYp1RmL
         8Mp41+ud+QccXro9pnjreUMTwJNI2OtLaB3LypiM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Huacai Chen <chenhuacai@loongson.cn>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 100/240] efi/libstub: Use relocated version of kernels struct screen_info
Date:   Tue, 28 Mar 2023 16:41:03 +0200
Message-Id: <20230328142623.936352253@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit fc3608aaa5751318837e4bbe0282b3836bca5080 ]

In some cases, we expose the kernel's struct screen_info to the EFI stub
directly, so it gets populated before even entering the kernel.  This
means the early console is available as soon as the early param parsing
happens, which is nice. It also means we need two different ways to pass
this information, as this trick only works if the EFI stub is baked into
the core kernel image, which is not always the case.

Huacai reports that the preparatory refactoring that was needed to
implement this alternative method for zboot resulted in a non-functional
efifb earlycon for other cases as well, due to the reordering of the
kernel image relocation with the population of the screen_info struct,
and the latter now takes place after copying the image to its new
location, which means we copy the old, uninitialized state.

So let's ensure that the same-image version of alloc_screen_info()
produces the correct screen_info pointer, by taking the displacement of
the loaded image into account.

Reported-by: Huacai Chen <chenhuacai@loongson.cn>
Tested-by: Huacai Chen <chenhuacai@loongson.cn>
Link: https://lore.kernel.org/linux-efi/20230310021749.921041-1-chenhuacai@loongson.cn/
Fixes: 42c8ea3dca094ab8 ("efi: libstub: Factor out EFI stub entrypoint into separate file")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/arm64-stub.c     |  4 +++-
 drivers/firmware/efi/libstub/efi-stub-entry.c | 11 +++++++++++
 drivers/firmware/efi/libstub/efi-stub.c       |  5 -----
 drivers/firmware/efi/libstub/efistub.h        |  1 +
 drivers/firmware/efi/libstub/screen_info.c    |  9 +--------
 drivers/firmware/efi/libstub/zboot.c          |  5 +++++
 6 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
index 7327b98d8e3fe..7c502dafe6f91 100644
--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -85,8 +85,10 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 		}
 	}
 
-	if (image->image_base != _text)
+	if (image->image_base != _text) {
 		efi_err("FIRMWARE BUG: efi_loaded_image_t::image_base has bogus value\n");
+		image->image_base = _text;
+	}
 
 	if (!IS_ALIGNED((u64)_text, SEGMENT_ALIGN))
 		efi_err("FIRMWARE BUG: kernel image not aligned on %dk boundary\n",
diff --git a/drivers/firmware/efi/libstub/efi-stub-entry.c b/drivers/firmware/efi/libstub/efi-stub-entry.c
index 5245c4f031c0a..cc4dcaea67fa6 100644
--- a/drivers/firmware/efi/libstub/efi-stub-entry.c
+++ b/drivers/firmware/efi/libstub/efi-stub-entry.c
@@ -5,6 +5,15 @@
 
 #include "efistub.h"
 
+static unsigned long screen_info_offset;
+
+struct screen_info *alloc_screen_info(void)
+{
+	if (IS_ENABLED(CONFIG_ARM))
+		return __alloc_screen_info();
+	return (void *)&screen_info + screen_info_offset;
+}
+
 /*
  * EFI entry point for the generic EFI stub used by ARM, arm64, RISC-V and
  * LoongArch. This is the entrypoint that is described in the PE/COFF header
@@ -56,6 +65,8 @@ efi_status_t __efiapi efi_pe_entry(efi_handle_t handle,
 		return status;
 	}
 
+	screen_info_offset = image_addr - (unsigned long)image->image_base;
+
 	status = efi_stub_common(handle, image, image_addr, cmdline_ptr);
 
 	efi_free(image_size, image_addr);
diff --git a/drivers/firmware/efi/libstub/efi-stub.c b/drivers/firmware/efi/libstub/efi-stub.c
index 2955c1ac6a36e..f9c1e8a2bd1d3 100644
--- a/drivers/firmware/efi/libstub/efi-stub.c
+++ b/drivers/firmware/efi/libstub/efi-stub.c
@@ -47,11 +47,6 @@
 static u64 virtmap_base = EFI_RT_VIRTUAL_BASE;
 static bool flat_va_mapping = (EFI_RT_VIRTUAL_OFFSET != 0);
 
-struct screen_info * __weak alloc_screen_info(void)
-{
-	return &screen_info;
-}
-
 void __weak free_screen_info(struct screen_info *si)
 {
 }
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index f527816abab3e..1926644b43dea 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -1042,6 +1042,7 @@ efi_enable_reset_attack_mitigation(void) { }
 void efi_retrieve_tpm2_eventlog(void);
 
 struct screen_info *alloc_screen_info(void);
+struct screen_info *__alloc_screen_info(void);
 void free_screen_info(struct screen_info *si);
 
 void efi_cache_sync_image(unsigned long image_base,
diff --git a/drivers/firmware/efi/libstub/screen_info.c b/drivers/firmware/efi/libstub/screen_info.c
index 8e76a8b384ba1..4be1c4d1f922b 100644
--- a/drivers/firmware/efi/libstub/screen_info.c
+++ b/drivers/firmware/efi/libstub/screen_info.c
@@ -15,18 +15,11 @@
  * early, but it only works if the EFI stub is part of the core kernel image
  * itself. The zboot decompressor can only use the configuration table
  * approach.
- *
- * In order to support both methods from the same build of the EFI stub
- * library, provide this dummy global definition of struct screen_info. If it
- * is required to satisfy a link dependency, it means we need to override the
- * __weak alloc and free methods with the ones below, and those will be pulled
- * in as well.
  */
-struct screen_info screen_info;
 
 static efi_guid_t screen_info_guid = LINUX_EFI_SCREEN_INFO_TABLE_GUID;
 
-struct screen_info *alloc_screen_info(void)
+struct screen_info *__alloc_screen_info(void)
 {
 	struct screen_info *si;
 	efi_status_t status;
diff --git a/drivers/firmware/efi/libstub/zboot.c b/drivers/firmware/efi/libstub/zboot.c
index 66be5fdc6b588..22c2cf38ccc20 100644
--- a/drivers/firmware/efi/libstub/zboot.c
+++ b/drivers/firmware/efi/libstub/zboot.c
@@ -57,6 +57,11 @@ void __weak efi_cache_sync_image(unsigned long image_base,
 	// executable code loaded into memory to be safe for execution.
 }
 
+struct screen_info *alloc_screen_info(void)
+{
+	return __alloc_screen_info();
+}
+
 asmlinkage efi_status_t __efiapi
 efi_zboot_entry(efi_handle_t handle, efi_system_table_t *systab)
 {
-- 
2.39.2



