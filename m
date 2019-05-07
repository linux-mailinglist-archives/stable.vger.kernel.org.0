Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8A215CAF
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 08:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727365AbfEGFdx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:33:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:53744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727357AbfEGFdx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:33:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF4C4206A3;
        Tue,  7 May 2019 05:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207233;
        bh=1by+GoL9pOxiZZ6k7a2kqSUKTIfStabNYt7FXouFx5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xmc+BhhKed8yCeGlp+QFKM6KlIxenMuONF5pEW37Sdf0/QqdBCt7kzuAf+yu0Pazv
         +RHQ5Io+T9ZMQGSX5M5q0H599LGaDwloQe48oj8GfrLw4AauqKi2ArTyshPC0ZeUG9
         /omAt18tCARTalZzsPseNnJA77pW2eybarWuVC+s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sami Tolvanen <samitolvanen@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Kees Cook <keescook@chromium.org>,
        Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.0 40/99] x86/build/lto: Fix truncated .bss with -fdata-sections
Date:   Tue,  7 May 2019 01:31:34 -0400
Message-Id: <20190507053235.29900-40-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053235.29900-1-sashal@kernel.org>
References: <20190507053235.29900-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sami Tolvanen <samitolvanen@google.com>

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
index ee3b5c7d662e..c45214c44e61 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -362,7 +362,7 @@ SECTIONS
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

