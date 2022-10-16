Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6E26000CE
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 17:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiJPPnm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 11:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiJPPnk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 11:43:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF752FFD6
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 08:43:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D09360B65
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 15:43:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F08FC433C1;
        Sun, 16 Oct 2022 15:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665935018;
        bh=0GajU0z5XGNUeEfj1XfkEzLrnIUMSCjX6mfNY/jUHTo=;
        h=Subject:To:Cc:From:Date:From;
        b=GxBzcF2SlWOywl0vkKK6hjahlq0ZKz0eum8lLby0hkvlB8JGXKpUlFLY1FR/LxvBd
         30bxU+f5yX3ulLQw66eKNAQGfL2cMV0K3BoQxQnMX3MOmy1SeTNfo/4s9Fv8q4CoNm
         3VbU8Tx7sEqcc46Os30eOu1awWwVFPQrs3YgI0I0=
Subject: FAILED: patch "[PATCH] efi: libstub: drop pointless get_memory_map() call" failed to apply to 4.19-stable tree
To:     ardb@kernel.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 17:44:16 +0200
Message-ID: <16659350567346@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

d80ca810f096 ("efi: libstub: drop pointless get_memory_map() call")
cd33a5c1d53e ("efi/libstub: Remove 'sys_table_arg' from all function prototypes")
8173ec7905b5 ("efi/libstub: Drop sys_table_arg from printk routines")
c3710de5065d ("efi/libstub/x86: Drop __efi_early() export and efi_config struct")
dc29da14ed94 ("efi/libstub: Unify the efi_char16_printk implementations")
2fcdad2a80a6 ("efi/libstub: Get rid of 'sys_table_arg' macro parameter")
afc4cc71cf78 ("efi/libstub/x86: Avoid thunking for native firmware calls")
f958efe97596 ("efi/libstub: Distinguish between native/mixed not 32/64 bit")
1786e8301164 ("efi/libstub: Extend native protocol definitions with mixed_mode aliases")
2732ea0d5c0a ("efi/libstub: Use a helper to iterate over a EFI handle array")
58ec655a7573 ("efi/libstub: Remove unused __efi_call_early() macro")
8de8788d2182 ("efi/gop: Unify 32/64-bit functions")
44c84b4ada73 ("efi/gop: Convert GOP structures to typedef and clean up some types")
8d62af177812 ("efi/gop: Remove bogus packed attribute from GOP structures")
4911ee401b7c ("x86/efistub: Disable paging at mixed mode entry")
818c7ce72477 ("efi/libstub/random: Initialize pointer variables to zero for mixed mode")
9fa76ca7b8bd ("efi: Fix efi_loaded_image_t::unload type")
ff397be685e4 ("efi/gop: Fix memory leak in __gop_query32/64()")
dbd89c303b44 ("efi/gop: Return EFI_SUCCESS if a usable GOP was found")
6fc3cec30dfe ("efi/gop: Return EFI_NOT_FOUND if there are no usable GOPs")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d80ca810f096ff66f451e7a3ed2f0cd9ef1ff519 Mon Sep 17 00:00:00 2001
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 15 Sep 2022 19:00:24 +0200
Subject: [PATCH] efi: libstub: drop pointless get_memory_map() call

Currently, the non-x86 stub code calls get_memory_map() redundantly,
given that the data it returns is never used anywhere. So drop the call.

Cc: <stable@vger.kernel.org> # v4.14+
Fixes: 24d7c494ce46 ("efi/arm-stub: Round up FDT allocation to mapping size")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
index fe567be0f118..804f542be3f2 100644
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -280,14 +280,6 @@ efi_status_t allocate_new_fdt_and_exit_boot(void *handle,
 		goto fail;
 	}
 
-	/*
-	 * Now that we have done our final memory allocation (and free)
-	 * we can get the memory map key needed for exit_boot_services().
-	 */
-	status = efi_get_memory_map(&map);
-	if (status != EFI_SUCCESS)
-		goto fail_free_new_fdt;
-
 	status = update_fdt((void *)fdt_addr, fdt_size,
 			    (void *)*new_fdt_addr, MAX_FDT_SIZE, cmdline_ptr,
 			    initrd_addr, initrd_size);

