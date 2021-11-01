Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAA1944167F
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbhKAJ0K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:26:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:58178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231942AbhKAJYI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:24:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFBDE61166;
        Mon,  1 Nov 2021 09:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758464;
        bh=Zu5p4uxDIl5m/X9HW0eQ9FLRaaTlxFkMRAKD9IvQLKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gIOQbj7QhIq4Po2htFH/OZEQBXULIBzSH2yzg1tZ9XZH+9T6ExBDEgPaK5alRCBxA
         P9CCck2m8psssySIq/PwySNHTs7cxxWTAQl+xYskpF8jCqGVyFe0qrfvwOEg5KUDp6
         6zdqpxiEh7Su5rrJq39J7QptG3kLL/7nVfxkHOWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH 4.19 01/35] ARM: 9133/1: mm: proc-macros: ensure *_tlb_fns are 4B aligned
Date:   Mon,  1 Nov 2021 10:17:13 +0100
Message-Id: <20211101082451.831165264@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082451.430720900@linuxfoundation.org>
References: <20211101082451.430720900@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>

commit e6a0c958bdf9b2e1b57501fc9433a461f0a6aadd upstream.

A kernel built with CONFIG_THUMB2_KERNEL=y and using clang as the
assembler could generate non-naturally-aligned v7wbi_tlb_fns which
results in a boot failure. The original commit adding the macro missed
the .align directive on this data.

Link: https://github.com/ClangBuiltLinux/linux/issues/1447
Link: https://lore.kernel.org/all/0699da7b-354f-aecc-a62f-e25693209af4@linaro.org/
Debugged-by: Ard Biesheuvel <ardb@kernel.org>
Debugged-by: Nathan Chancellor <nathan@kernel.org>
Debugged-by: Richard Henderson <richard.henderson@linaro.org>

Fixes: 66a625a88174 ("ARM: mm: proc-macros: Add generic proc/cache/tlb struct definition macros")
Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mm/proc-macros.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/mm/proc-macros.S
+++ b/arch/arm/mm/proc-macros.S
@@ -342,6 +342,7 @@ ENTRY(\name\()_cache_fns)
 
 .macro define_tlb_functions name:req, flags_up:req, flags_smp
 	.type	\name\()_tlb_fns, #object
+	.align 2
 ENTRY(\name\()_tlb_fns)
 	.long	\name\()_flush_user_tlb_range
 	.long	\name\()_flush_kern_tlb_range


