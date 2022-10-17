Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE7D26014B6
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 19:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbiJQRXy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 13:23:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbiJQRXx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 13:23:53 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 770D372691;
        Mon, 17 Oct 2022 10:23:52 -0700 (PDT)
Date:   Mon, 17 Oct 2022 17:23:48 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1666027430;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=BRbMTu/36L2Znt2BCUjwdunc4EtSPmpdclSxtyKDgoc=;
        b=ipRSlwGW40HtQiuEQoUCmySPMEXDHyrGNjyilH5XvDMO0nodkwRIKGeIweXiqVAeJqepU6
        InQm8RHG7Hn3WS/MlfJ9wbJVcjF1jpgPtgf6S33qNolMuXQtljC5B5MTigqUuPA7u8Bc/h
        taD4aahfDNOS6iFYWo+Oy0xoiT64Gx05td5ZhLawCyHUAYgQj+DchUCvqL+7AhxfpBS5pC
        HRfB2WCVVL4PfTjeSh7VZw6aS2s/NH6T1ukhdLcu5CKIfVlEo3QBSH4b5OEhi64SWO7KcV
        Jc0QWhlE0MVFIu4+nBi+xGhBAUgI5e7ihBpblQjMn/gYlDq3+hiiMHqSD95WdA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1666027430;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=BRbMTu/36L2Znt2BCUjwdunc4EtSPmpdclSxtyKDgoc=;
        b=4136tujQu3bAAxUkQGOFDVzNSRW6cGIWd8jF6hPW5IrOKkRhcTEijw8shFHkL+NmGRbeJs
        Kuv9PLg/4Wjr39Bw==
From:   "tip-bot2 for Nathan Chancellor" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/Kconfig: Drop check for -mabi=ms for CONFIG_EFI_STUB
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Borislav Petkov <bp@suse.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-ID: <166602742896.401.9259475718093994169.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     33806e7cb8d50379f55c3e8f335e91e1b359dc7b
Gitweb:        https://git.kernel.org/tip/33806e7cb8d50379f55c3e8f335e91e1b359dc7b
Author:        Nathan Chancellor <nathan@kernel.org>
AuthorDate:    Thu, 29 Sep 2022 08:20:10 -07:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Mon, 17 Oct 2022 19:11:16 +02:00

x86/Kconfig: Drop check for -mabi=ms for CONFIG_EFI_STUB

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
---
 arch/x86/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6d1879e..67745ce 100644
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
