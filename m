Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03E3A41A7E1
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 07:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239196AbhI1F7t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 01:59:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239192AbhI1F6k (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 01:58:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCA596108F;
        Tue, 28 Sep 2021 05:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808599;
        bh=CEQN41l6ZcHJHjaCHHfGMtXSoAkYU/pYnEf/L9HH98w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dru+FTIHskHbnFcvqQb/pNleD/F/DmIHUe1V7qnrywmFw9FQSA510NOimkjH/SiN+
         qYGIU2TJkx+M3oDBQItvsvpYQDsQ60iaahWBTUl5ZGhvIpsFvliwv/4Y9+2A9L5jJC
         jdHTSEGaZ6fM987Nhkel1Z6c3k6Fp2QlBJpkszQx7Bl4SoMNhDYkirkFWv8YkpEOZa
         S7Y7K2+m6ebh++0aN49OIiEMGPU8vEbFQZ3xStTOminS7Ek/tqlQYEuoKe4217alEf
         Uup4gQdFnbqToVm/aVVMI3vJrESoFVOWNqAIf947o9fGqy4E6Bleoe44CpHkeWCtPy
         7psbaq2DlLVrw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Numfor Mbiziwo-Tiapo <nums@google.com>,
        Ian Rogers <irogers@google.com>, Borislav Petkov <bp@suse.de>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, gor@linux.ibm.com,
        jpoimboe@redhat.com, schwidefsky@de.ibm.com, peterz@infradead.org
Subject: [PATCH AUTOSEL 5.14 36/40] x86/insn, tools/x86: Fix undefined behavior due to potential unaligned accesses
Date:   Tue, 28 Sep 2021 01:55:20 -0400
Message-Id: <20210928055524.172051-36-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055524.172051-1-sashal@kernel.org>
References: <20210928055524.172051-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Numfor Mbiziwo-Tiapo <nums@google.com>

[ Upstream commit 5ba1071f7554c4027bdbd712a146111de57918de ]

Don't perform unaligned loads in __get_next() and __peek_nbyte_next() as
these are forms of undefined behavior:

"A pointer to an object or incomplete type may be converted to a pointer
to a different object or incomplete type. If the resulting pointer
is not correctly aligned for the pointed-to type, the behavior is
undefined."

(from http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf)

These problems were identified using the undefined behavior sanitizer
(ubsan) with the tools version of the code and perf test.

 [ bp: Massage commit message. ]

Signed-off-by: Numfor Mbiziwo-Tiapo <nums@google.com>
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Link: https://lkml.kernel.org/r/20210923161843.751834-1-irogers@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/lib/insn.c       | 4 ++--
 tools/arch/x86/lib/insn.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/lib/insn.c b/arch/x86/lib/insn.c
index 058f19b20465..c565def611e2 100644
--- a/arch/x86/lib/insn.c
+++ b/arch/x86/lib/insn.c
@@ -37,10 +37,10 @@
 	((insn)->next_byte + sizeof(t) + n <= (insn)->end_kaddr)
 
 #define __get_next(t, insn)	\
-	({ t r = *(t*)insn->next_byte; insn->next_byte += sizeof(t); leXX_to_cpu(t, r); })
+	({ t r; memcpy(&r, insn->next_byte, sizeof(t)); insn->next_byte += sizeof(t); leXX_to_cpu(t, r); })
 
 #define __peek_nbyte_next(t, insn, n)	\
-	({ t r = *(t*)((insn)->next_byte + n); leXX_to_cpu(t, r); })
+	({ t r; memcpy(&r, (insn)->next_byte + n, sizeof(t)); leXX_to_cpu(t, r); })
 
 #define get_next(t, insn)	\
 	({ if (unlikely(!validate_next(t, insn, 0))) goto err_out; __get_next(t, insn); })
diff --git a/tools/arch/x86/lib/insn.c b/tools/arch/x86/lib/insn.c
index c41f95815480..797699462cd8 100644
--- a/tools/arch/x86/lib/insn.c
+++ b/tools/arch/x86/lib/insn.c
@@ -37,10 +37,10 @@
 	((insn)->next_byte + sizeof(t) + n <= (insn)->end_kaddr)
 
 #define __get_next(t, insn)	\
-	({ t r = *(t*)insn->next_byte; insn->next_byte += sizeof(t); leXX_to_cpu(t, r); })
+	({ t r; memcpy(&r, insn->next_byte, sizeof(t)); insn->next_byte += sizeof(t); leXX_to_cpu(t, r); })
 
 #define __peek_nbyte_next(t, insn, n)	\
-	({ t r = *(t*)((insn)->next_byte + n); leXX_to_cpu(t, r); })
+	({ t r; memcpy(&r, (insn)->next_byte + n, sizeof(t)); leXX_to_cpu(t, r); })
 
 #define get_next(t, insn)	\
 	({ if (unlikely(!validate_next(t, insn, 0))) goto err_out; __get_next(t, insn); })
-- 
2.33.0

