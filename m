Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5C62ABBA0
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730794AbgKINMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:12:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:38560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732743AbgKINMt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:12:49 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20D3E20789;
        Mon,  9 Nov 2020 13:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927568;
        bh=A4LC5bw4p6M5cWA5uMnFfctzJzFGLqX1q4j8N+8nSaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vtt2aKD9vdYLogEdb3+wwcIQgLozxGx0EkULQTzGWl+IAeX1QoIm7uomuO+3JivFH
         R6TnbMpJwa2kWtDNynL0lxwJVExs+1L+ZT3e7eR0OhpDlk+HIfhEoCTWnpDeqUVww4
         Z+hCxG8iIWvqeaBzUANSJDwueZaBVdtQuZfJjS9I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>,
        Fangrui Song <maskray@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Will Deacon <will@kernel.org>, Jian Cai <jiancai@google.com>
Subject: [PATCH 5.4 08/85] arm64: Change .weak to SYM_FUNC_START_WEAK_PI for arch/arm64/lib/mem*.S
Date:   Mon,  9 Nov 2020 13:55:05 +0100
Message-Id: <20201109125023.001052189@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125022.614792961@linuxfoundation.org>
References: <20201109125022.614792961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fangrui Song <maskray@google.com>

commit ec9d78070de986ecf581ea204fd322af4d2477ec upstream.

Commit 39d114ddc682 ("arm64: add KASAN support") added .weak directives to
arch/arm64/lib/mem*.S instead of changing the existing SYM_FUNC_START_PI
macros. This can lead to the assembly snippet `.weak memcpy ... .globl
memcpy` which will produce a STB_WEAK memcpy with GNU as but STB_GLOBAL
memcpy with LLVM's integrated assembler before LLVM 12. LLVM 12 (since
https://reviews.llvm.org/D90108) will error on such an overridden symbol
binding.

Use the appropriate SYM_FUNC_START_WEAK_PI instead.

Fixes: 39d114ddc682 ("arm64: add KASAN support")
Reported-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Fangrui Song <maskray@google.com>
Tested-by: Sami Tolvanen <samitolvanen@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201029181951.1866093-1-maskray@google.com
Signed-off-by: Will Deacon <will@kernel.org>
Cc: Jian Cai <jiancai@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/lib/memcpy.S  |    3 +--
 arch/arm64/lib/memmove.S |    3 +--
 arch/arm64/lib/memset.S  |    3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

--- a/arch/arm64/lib/memcpy.S
+++ b/arch/arm64/lib/memcpy.S
@@ -56,9 +56,8 @@
 	stp \ptr, \regB, [\regC], \val
 	.endm
 
-	.weak memcpy
 SYM_FUNC_START_ALIAS(__memcpy)
-SYM_FUNC_START_PI(memcpy)
+SYM_FUNC_START_WEAK_PI(memcpy)
 #include "copy_template.S"
 	ret
 SYM_FUNC_END_PI(memcpy)
--- a/arch/arm64/lib/memmove.S
+++ b/arch/arm64/lib/memmove.S
@@ -45,9 +45,8 @@ C_h	.req	x12
 D_l	.req	x13
 D_h	.req	x14
 
-	.weak memmove
 SYM_FUNC_START_ALIAS(__memmove)
-SYM_FUNC_START_PI(memmove)
+SYM_FUNC_START_WEAK_PI(memmove)
 	cmp	dstin, src
 	b.lo	__memcpy
 	add	tmp1, src, count
--- a/arch/arm64/lib/memset.S
+++ b/arch/arm64/lib/memset.S
@@ -42,9 +42,8 @@ dst		.req	x8
 tmp3w		.req	w9
 tmp3		.req	x9
 
-	.weak memset
 SYM_FUNC_START_ALIAS(__memset)
-SYM_FUNC_START_PI(memset)
+SYM_FUNC_START_WEAK_PI(memset)
 	mov	dst, dstin	/* Preserve return value.  */
 	and	A_lw, val, #255
 	orr	A_lw, A_lw, A_lw, lsl #8


