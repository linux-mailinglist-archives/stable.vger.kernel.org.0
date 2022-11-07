Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D67B61F7A3
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 16:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232196AbiKGP3M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 10:29:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231742AbiKGP3M (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 10:29:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F85A190
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 07:29:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C32D461191
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 15:29:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB72C433B5;
        Mon,  7 Nov 2022 15:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667834950;
        bh=+k/seCHQelctH96GHZoKCOTlDkGS2mM6pe0GIPoJZ90=;
        h=Subject:To:Cc:From:Date:From;
        b=Xeih9rVwRQWTicNvsiIUzFCJcX+Dk6Uy3L5ZFZA+tllgfjSxOuM7ldAdirePXXf3Q
         03DefsiqU64Tv7VUOphOwZQpi7/n6yYF8gytUWVthIrxPty+wB3y7K7leh/dGAzONV
         bSgEGXyEWkMigmD/7V3wQnkAL3xUH3ZEIEWKHE18=
Subject: FAILED: patch "[PATCH] efi: random: Use 'ACPI reclaim' memory for random seed" failed to apply to 4.14-stable tree
To:     ardb@kernel.org, ilias.apalodimas@linaro.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 07 Nov 2022 16:28:57 +0100
Message-ID: <166783493716843@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

7d866e38c7e9 ("efi: random: Use 'ACPI reclaim' memory for random seed")
966291f6344d ("efi/libstub: Rename efi_call_early/_runtime macros to be more intuitive")
99ea8b1db2d2 ("efi/libstub: Drop 'table' argument from efi_table_attr() macro")
47c0fd39b7b8 ("efi/libstub: Drop protocol argument from efi_call_proto() macro")
cd33a5c1d53e ("efi/libstub: Remove 'sys_table_arg' from all function prototypes")
8173ec7905b5 ("efi/libstub: Drop sys_table_arg from printk routines")
c3710de5065d ("efi/libstub/x86: Drop __efi_early() export and efi_config struct")
dc29da14ed94 ("efi/libstub: Unify the efi_char16_printk implementations")
2fcdad2a80a6 ("efi/libstub: Get rid of 'sys_table_arg' macro parameter")
afc4cc71cf78 ("efi/libstub/x86: Avoid thunking for native firmware calls")
960a8d01834e ("efi/libstub: Use stricter typing for firmware function pointers")
e8bd5ddf60ee ("efi/libstub: Drop explicit 32/64-bit protocol definitions")
f958efe97596 ("efi/libstub: Distinguish between native/mixed not 32/64 bit")
1786e8301164 ("efi/libstub: Extend native protocol definitions with mixed_mode aliases")
2732ea0d5c0a ("efi/libstub: Use a helper to iterate over a EFI handle array")
58ec655a7573 ("efi/libstub: Remove unused __efi_call_early() macro")
8de8788d2182 ("efi/gop: Unify 32/64-bit functions")
44c84b4ada73 ("efi/gop: Convert GOP structures to typedef and clean up some types")
8d62af177812 ("efi/gop: Remove bogus packed attribute from GOP structures")
4911ee401b7c ("x86/efistub: Disable paging at mixed mode entry")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7d866e38c7e9ece8a096d0d098fa9d92b9d4f97e Mon Sep 17 00:00:00 2001
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 20 Oct 2022 10:39:09 +0200
Subject: [PATCH] efi: random: Use 'ACPI reclaim' memory for random seed

EFI runtime services data is guaranteed to be preserved by the OS,
making it a suitable candidate for the EFI random seed table, which may
be passed to kexec kernels as well (after refreshing the seed), and so
we need to ensure that the memory is preserved without support from the
OS itself.

However, runtime services data is intended for allocations that are
relevant to the implementations of the runtime services themselves, and
so they are unmapped from the kernel linear map, and mapped into the EFI
page tables that are active while runtime service invocations are in
progress. None of this is needed for the RNG seed.

So let's switch to EFI 'ACPI reclaim' memory: in spite of the name,
there is nothing exclusively ACPI about it, it is simply a type of
allocation that carries firmware provided data which may or may not be
relevant to the OS, and it is left up to the OS to decide whether to
reclaim it after having consumed its contents.

Given that in Linux, we never reclaim these allocations, it is a good
choice for the EFI RNG seed, as the allocation is guaranteed to survive
kexec reboots.

One additional reason for changing this now is to align it with the
upcoming recommendation for EFI bootloader provided RNG seeds, which
must not use EFI runtime services code/data allocations.

Cc: <stable@vger.kernel.org> # v4.14+
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

diff --git a/drivers/firmware/efi/libstub/random.c b/drivers/firmware/efi/libstub/random.c
index 24aa37535372..33ab56769595 100644
--- a/drivers/firmware/efi/libstub/random.c
+++ b/drivers/firmware/efi/libstub/random.c
@@ -75,7 +75,12 @@ efi_status_t efi_random_get_seed(void)
 	if (status != EFI_SUCCESS)
 		return status;
 
-	status = efi_bs_call(allocate_pool, EFI_RUNTIME_SERVICES_DATA,
+	/*
+	 * Use EFI_ACPI_RECLAIM_MEMORY here so that it is guaranteed that the
+	 * allocation will survive a kexec reboot (although we refresh the seed
+	 * beforehand)
+	 */
+	status = efi_bs_call(allocate_pool, EFI_ACPI_RECLAIM_MEMORY,
 			     sizeof(*seed) + EFI_RANDOM_SEED_SIZE,
 			     (void **)&seed);
 	if (status != EFI_SUCCESS)

