Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E99431145C
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231703AbhBEWE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:04:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:44984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232931AbhBEO5T (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:57:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E047765058;
        Fri,  5 Feb 2021 14:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534352;
        bh=sUCSMGgYb319zNRdR6buytA8eu3g59oCfCt50woq2ZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qH+8jweQmF1ScmxlAY4XyZibgZvFvh6Za8CmaxDY5m5k53GVqtyo6hJkgGTwYtb4r
         Hef/+W1mygKMbcaihiaiWNQblNLbMfYBlX0IPwq6oDDano03VzgmgGirO1G5Bt9jtX
         jb4uDWegSlyytFViOghKDY/V7JpfX9GTbYhnYGrM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Will Deacon <will@kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 5.4 07/32] arm64: Do not pass tagged addresses to __is_lm_address()
Date:   Fri,  5 Feb 2021 15:07:22 +0100
Message-Id: <20210205140652.662436384@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140652.348864025@linuxfoundation.org>
References: <20210205140652.348864025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Catalin Marinas <catalin.marinas@arm.com>

commit 91cb2c8b072e00632adf463b78b44f123d46a0fa upstream.

Commit 519ea6f1c82f ("arm64: Fix kernel address detection of
__is_lm_address()") fixed the incorrect validation of addresses below
PAGE_OFFSET. However, it no longer allowed tagged addresses to be passed
to virt_addr_valid().

Fix this by explicitly resetting the pointer tag prior to invoking
__is_lm_address(). This is consistent with the __lm_to_phys() macro.

Fixes: 519ea6f1c82f ("arm64: Fix kernel address detection of __is_lm_address()")
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Cc: <stable@vger.kernel.org> # 5.4.x
Cc: Will Deacon <will@kernel.org>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/r/20210201190634.22942-2-catalin.marinas@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/memory.h |    2 +-
 arch/arm64/mm/physaddr.c        |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -332,7 +332,7 @@ static inline void *phys_to_virt(phys_ad
 #endif /* !CONFIG_SPARSEMEM_VMEMMAP || CONFIG_DEBUG_VIRTUAL */
 
 #define virt_addr_valid(addr)	({					\
-	__typeof__(addr) __addr = addr;					\
+	__typeof__(addr) __addr = __tag_reset(addr);			\
 	__is_lm_address(__addr) && pfn_valid(virt_to_pfn(__addr));	\
 })
 
--- a/arch/arm64/mm/physaddr.c
+++ b/arch/arm64/mm/physaddr.c
@@ -9,7 +9,7 @@
 
 phys_addr_t __virt_to_phys(unsigned long x)
 {
-	WARN(!__is_lm_address(x),
+	WARN(!__is_lm_address(__tag_reset(x)),
 	     "virt_to_phys used for non-linear address: %pK (%pS)\n",
 	      (void *)x,
 	      (void *)x);


