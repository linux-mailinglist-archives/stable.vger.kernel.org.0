Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFDF935186A
	for <lists+stable@lfdr.de>; Thu,  1 Apr 2021 19:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234847AbhDARpt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Apr 2021 13:45:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234596AbhDARiS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Apr 2021 13:38:18 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE2BC03116D
        for <stable@vger.kernel.org>; Thu,  1 Apr 2021 09:55:53 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id l83so6332421ybf.22
        for <stable@vger.kernel.org>; Thu, 01 Apr 2021 09:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=RQdEbh2S4Ikdo2tTc3Res9TZJ3yFT7BUQh31RjAuPqg=;
        b=CALYKhrxJjWJP8sFYt0s/yxzJCaCukUGaVQlMLwXDWPcnb+sLMJeSEkGatZGslHt2q
         GR4MDCwp3/uwZyxLDOsd/PrcE0604MH4oiRrhDmxy62D1W4eM0CcxXNmG5IynKj4oJIg
         9PU6qGigRQrQ8UHfgrvVSISnuu9Es/6c1dp26wRSS4iJaD30FxZl5tkfDwwPB1OmYxED
         O5h/KqjWUO5oPWMAEAYQV4ZwM6f0boVUI57DLBtWqg2tkLMaYmpQFHk6sx5DassXcYQf
         Szz1bD5vyFl68ADuvUaZ9/5+S64/KseH+42c/MFtjYBloOHDi7G8x58wbk0SD0zyrv5T
         o07Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=RQdEbh2S4Ikdo2tTc3Res9TZJ3yFT7BUQh31RjAuPqg=;
        b=c+Wi9W/II3cant4jcEIYHoHErpNXtuV5k+Fa/1U+9OpI6N28GbzvW7MhIl7OA77p4c
         WKbKOm/19/LEInMbz+J90n1FRZxEOtQObUjawPGu0+1GH8Oy4fp1bdaXjXtA5jAy1pSI
         ztDsF5iDh3At6BwtJ/u3N/iA3PHR4QvZo0/n0oqjlBArJY+dUIVPbXagG6lcNOdQlS0b
         opoKnuXcqAiEnxZ1PBMqXHT8JRRbhJzzfog/P8qftvmxbyfp6HeEcZWdtsx1H6HQrVYE
         HOBRq3RRsNjupVNVzEOlc7F/CNwWAdA+DnnN2rkR27pr5pAh0tDNPBQwfdEmEv/V1HiK
         bB4g==
X-Gm-Message-State: AOAM531DVEzYo/FhRi6n66e81DNa82k5vmKBb5YIxX+lCXSB3sKzwIql
        7hMn/faduOjohNomUpOCpY7mE4E=
X-Google-Smtp-Source: ABdhPJxJvADz7idTF/W9m3puCNj2TDmDarfYaBdV32v9uHC35+vNowGdE7DMS/+hzV6sZz0PQby50B4=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:0:3dc0:b59f:6f36:16d2])
 (user=pcc job=sendgmr) by 2002:a25:4dc4:: with SMTP id a187mr13337921ybb.78.1617296152778;
 Thu, 01 Apr 2021 09:55:52 -0700 (PDT)
Date:   Thu,  1 Apr 2021 09:55:43 -0700
Message-Id: <20210401165543.3957816-1-pcc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH] arm: fix inline asm in load_unaligned_zeropad()
From:   Peter Collingbourne <pcc@google.com>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Cc:     Peter Collingbourne <pcc@google.com>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The inline asm's addr operand is marked as input-only, however in
the case where an exception is taken it may be modified by the BIC
instruction on the exception path. Fix the problem by using a temporary
register as the destination register for the BIC instruction.

Signed-off-by: Peter Collingbourne <pcc@google.com>
Cc: stable@vger.kernel.org
Link: https://linux-review.googlesource.com/id/I0f9ad1682821f874fb9b47e1279721943b2e5325
---
 arch/arm/include/asm/word-at-a-time.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/word-at-a-time.h b/arch/arm/include/asm/word-at-a-time.h
index 352ab213520d..2e6d0b4349f4 100644
--- a/arch/arm/include/asm/word-at-a-time.h
+++ b/arch/arm/include/asm/word-at-a-time.h
@@ -66,7 +66,7 @@ static inline unsigned long find_zero(unsigned long mask)
  */
 static inline unsigned long load_unaligned_zeropad(const void *addr)
 {
-	unsigned long ret, offset;
+	unsigned long ret, tmp;
 
 	/* Load word from unaligned pointer addr */
 	asm(
@@ -74,9 +74,9 @@ static inline unsigned long load_unaligned_zeropad(const void *addr)
 	"2:\n"
 	"	.pushsection .text.fixup,\"ax\"\n"
 	"	.align 2\n"
-	"3:	and	%1, %2, #0x3\n"
-	"	bic	%2, %2, #0x3\n"
-	"	ldr	%0, [%2]\n"
+	"3:	bic	%1, %2, #0x3\n"
+	"	ldr	%0, [%1]\n"
+	"	and	%1, %2, #0x3\n"
 	"	lsl	%1, %1, #0x3\n"
 #ifndef __ARMEB__
 	"	lsr	%0, %0, %1\n"
@@ -89,7 +89,7 @@ static inline unsigned long load_unaligned_zeropad(const void *addr)
 	"	.align	3\n"
 	"	.long	1b, 3b\n"
 	"	.popsection"
-	: "=&r" (ret), "=&r" (offset)
+	: "=&r" (ret), "=&r" (tmp)
 	: "r" (addr), "Qo" (*(unsigned long *)addr));
 
 	return ret;
-- 
2.31.0.291.g576ba9dcdaf-goog

