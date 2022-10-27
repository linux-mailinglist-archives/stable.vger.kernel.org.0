Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EBD460FDBA
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 18:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235132AbiJ0Q61 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 12:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236558AbiJ0Q60 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 12:58:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701ED17E216
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 09:58:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CEE2623EC
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 16:58:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A14C433D6;
        Thu, 27 Oct 2022 16:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666889904;
        bh=suR+d0Q/QGyUkrj6UHhd1WGcCQjcje5D9XyNM6et5wg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RIGmTgRD8G9Z3RNxYWsUg/dB5t2A9T/qwJkhpwAw/cxvnfS29TjkYqpT9sI9YnW5I
         2rwNp3hR7jZbzvaziX/jR0mzVX/8NSVihyYELIGqbs/jWceS40AjB9wTEIn2tg23Up
         2m6S4LtZ6/+oCf/yKYydX7U59z1zphIbOjFuA+cU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        Borislav Petkov <bp@suse.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.0 25/94] x86/Kconfig: Drop check for -mabi=ms for CONFIG_EFI_STUB
Date:   Thu, 27 Oct 2022 18:54:27 +0200
Message-Id: <20221027165058.078376077@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

commit 33806e7cb8d50379f55c3e8f335e91e1b359dc7b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1961,7 +1961,6 @@ config EFI
 config EFI_STUB
 	bool "EFI stub support"
 	depends on EFI
-	depends on $(cc-option,-mabi=ms) || X86_32
 	select RELOCATABLE
 	help
 	  This kernel feature allows a bzImage to be loaded directly


