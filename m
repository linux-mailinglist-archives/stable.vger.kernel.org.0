Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89F531EE7C
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728793AbfEOLWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:22:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:60528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730989AbfEOLWS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:22:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D2C320862;
        Wed, 15 May 2019 11:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919338;
        bh=GQkRRwBK3pgeAjujmgIV//akJ5BglEb3ko8fSZgeWuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iKQPhPXfITUOYvs4Wkmy5dM2rK6tBGaEq89//YwY/3MJKzZ0nTMfQ7R7LpN76HgnB
         m9ggy/Sc1RqM1iVF7V5EymUTSkuPwfOEy7M8HF97pVy0eFXlXFjG4HgCgS9cRAlF0z
         Zczi4Z1vtXyzyAIVIq6D1USlL2ycqx2RX2lv/puk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Kees Cook <keescook@chromium.org>,
        Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 036/113] x86/build/lto: Fix truncated .bss with -fdata-sections
Date:   Wed, 15 May 2019 12:55:27 +0200
Message-Id: <20190515090656.348155201@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090652.640988966@linuxfoundation.org>
References: <20190515090652.640988966@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 6a03469a1edc94da52b65478f1e00837add869a3 ]

With CONFIG_LD_DEAD_CODE_DATA_ELIMINATION=y, we compile the kernel with
-fdata-sections, which also splits the .bss section.

The new section, with a new .bss.* name, which pattern gets missed by the
main x86 linker script which only expects the '.bss' name. This results
in the discarding of the second part and a too small, truncated .bss
section and an unhappy, non-working kernel.

Use the common BSS_MAIN macro in the linker script to properly capture
and merge all the generated BSS sections.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20190415164956.124067-1-samitolvanen@google.com
[ Extended the changelog. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/vmlinux.lds.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index c63bab98780cf..85e6d5620188e 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -372,7 +372,7 @@ SECTIONS
 	.bss : AT(ADDR(.bss) - LOAD_OFFSET) {
 		__bss_start = .;
 		*(.bss..page_aligned)
-		*(.bss)
+		*(BSS_MAIN)
 		BSS_DECRYPTED
 		. = ALIGN(PAGE_SIZE);
 		__bss_stop = .;
-- 
2.20.1



