Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9587760E474
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 17:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234527AbiJZP2Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 11:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234274AbiJZP2P (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 11:28:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51C23130D50
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 08:28:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E65AB82302
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 15:28:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F056C433C1;
        Wed, 26 Oct 2022 15:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666798091;
        bh=3QHn/LK8+qOcnoAd3hwjhWQS83nHpnEgZ6GvLn+/fcQ=;
        h=Subject:To:Cc:From:Date:From;
        b=frFlIKGU1JVmd+ZmHvn/lTPHA8BqFPOMFRLE24zrUCFDVsqZ3mPIpbRN7YmQCGJqN
         8PO6UgHS7R+iGXqbdrc0hGyDHcxUhsypmOa8Rt3HgRngV/IO6YjDGVqBJI3IQPuaRR
         90DDGBq1DbLYCMnm2YieqSDAk/kxHqRGgWEzrMf4=
Subject: FAILED: patch "[PATCH] x86/Kconfig: Drop check for -mabi=ms for CONFIG_EFI_STUB" failed to apply to 5.10-stable tree
To:     nathan@kernel.org, ardb@kernel.org, bp@suse.de,
        ndesaulniers@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 26 Oct 2022 17:28:08 +0200
Message-ID: <1666798088213136@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

33806e7cb8d5 ("x86/Kconfig: Drop check for -mabi=ms for CONFIG_EFI_STUB")
c6dbd3e5e69c ("x86/mmx_32: Remove X86_USE_3DNOW")
6bf8a55d8344 ("x86: Fix misspelled Kconfig symbols")
d9f6e12fb0b7 ("x86: Fix various typos in comments")
29c395c77a9a ("Merge tag 'x86-entry-2021-02-24' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 33806e7cb8d50379f55c3e8f335e91e1b359dc7b Mon Sep 17 00:00:00 2001
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 29 Sep 2022 08:20:10 -0700
Subject: [PATCH] x86/Kconfig: Drop check for -mabi=ms for CONFIG_EFI_STUB

A recent change in LLVM made CONFIG_EFI_STUB unselectable because it no
longer pretends to support -mabi=ms, breaking the dependency in
Kconfig. Lack of CONFIG_EFI_STUB can prevent kernels from booting via
EFI in certain circumstances.

This check was added by

  8f24f8c2fc82 ("efi/libstub: Annotate firmware routines as __efiapi")

to ensure that __attribute__((ms_abi)) was available, as -mabi=ms is
not actually used in any cflags.

According to the GCC documentation, this attribute has been supported
since GCC 4.4.7. The kernel currently requires GCC 5.1 so this check is
not necessary; even when that change landed in 5.6, the kernel required
GCC 4.9 so it was unnecessary then as well.

Clang supports __attribute__((ms_abi)) for all versions that are
supported for building the kernel so no additional check is needed.
Remove the 'depends on' line altogether to allow CONFIG_EFI_STUB to be
selected when CONFIG_EFI is enabled, regardless of compiler.

Fixes: 8f24f8c2fc82 ("efi/libstub: Annotate firmware routines as __efiapi")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Cc: stable@vger.kernel.org
Link: https://github.com/llvm/llvm-project/commit/d1ad006a8f64bdc17f618deffa9e7c91d82c444d

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6d1879ef933a..67745ceab0db 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1973,7 +1973,6 @@ config EFI
 config EFI_STUB
 	bool "EFI stub support"
 	depends on EFI
-	depends on $(cc-option,-mabi=ms) || X86_32
 	select RELOCATABLE
 	help
 	  This kernel feature allows a bzImage to be loaded directly

