Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1C81E458E
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 16:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388949AbgE0ORC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 10:17:02 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:42241 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388141AbgE0ORC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 May 2020 10:17:02 -0400
Received: from threadripper.lan ([149.172.98.151]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MPK73-1jNdyb1lNN-00PfUR; Wed, 27 May 2020 16:15:56 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Jiri Slaby <jslaby@suse.cz>,
        Juergen Gross <jgross@suse.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH] x86: fix clang integrated assembler build
Date:   Wed, 27 May 2020 16:15:39 +0200
Message-Id: <20200527141553.1768675-1-arnd@arndb.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:Uosxpj6yvjMCuoWo+Rtov8UwzN5IwYem5nwdvTWLIAVID8yaP/W
 x7ewGXWq/QM+I7P3RCxJYWFjpDQalR+YODvDhjI71RN1tJZP8geV47TJs5LVSF7p7vmPoXm
 qImyMgJGjmDeyS2NV4hdWnbJNcpxvHX0/3b8jp2OkQ3phuf5uluN+BUE0FMfsSyprNtQvnL
 fV00HYQaumDJaxj6QfpPg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:GWnMZ0bR6yk=:0Y1nTwmFteYTcoIjQ40K3U
 cSlDlIO2MaEl7ZntvxtB1FiwS6sZj5h2Wg+YeSVHJJWLZhQIXpLujXfFgeCsDJdPdP4zf/tG+
 z3vjludYoIj/dSsu1DCKX7HKRRlmKIYylGoLzlP+MuZ1sPFCoUCafKtwamLGglgNZGGinSGGq
 L1vbbWJd6f1WpNSR9ORdxgFwNQHhK+uo6AllztWK76vGCAc/j8lXxkbtC3qKrPo2P1WpptWk5
 jkygJhIWjdiF2fLcgxOlge0rwyvXcUz5tTe+FrKYGH6yCfJREI3SqSKE3wQEuiTszKc8+xfvv
 MR6S28MzU+i5B7xWNneS8ed+VX4lLIaLNvTivoT5KkFO9oIed/dWF36QK6Mr/B18X0K7mXnCF
 A8C7hWSLo719jVIGoCZ5nmx4JUnICaW0NSFhkF108Ehn5KD31jXfYJ31FYtY2bvjz/GGRA31N
 rttY0nXn/FFJwP0pcT7RuYmHs4+WWv/3BqwURQa7ZNAoTvUtaXq0PcDwtxkLJVj3rnCsJQMAR
 Kuu5E+fWt5jFkCon4fRjZdu3DtMEKsSA23jsUwCLQHMPsNY7/qJ80O05GoPp8Uf69m6BiPVVi
 qggmvA7zKgPx6+pGVf2xZ4C+nsrulbKXXSdaycw9B56m9yssXSeKhVkx+np51y9bMD7jl+DAH
 qMPVpL/RBQBiU8cg20vCC+dyI5xv3jEQbdBbFg6r5fCtjqawk1CF9NgDV1Mo3nzu+bxn9Wicf
 LbA+0fiJ611f2RojqKBaHeqabSDVpZUeKPIF6dANGh7KANO3z2xyKj5HsQgPsLrk2VQi0rbrR
 LNUvfiZ7HNzDzeYD4csCPzFo1Q0czax1TFof2QNccYY3Pxn0+Y=
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

clang and gas seem to interpret the symbols in memmove_64.S and
memset_64.S differently, such that clang does not make them
'weak' as expected, which leads to a linker error, with both
ld.bfd and ld.lld:

ld.lld: error: duplicate symbol: memmove
>>> defined at common.c
>>>            kasan/common.o:(memmove) in archive mm/built-in.a
>>> defined at memmove.o:(__memmove) in archive arch/arm64/lib/lib.a

ld.lld: error: duplicate symbol: memset
>>> defined at common.c
>>>            kasan/common.o:(memset) in archive mm/built-in.a
>>> defined at memset.o:(__memset) in archive arch/arm64/lib/lib.a

Copy the exact way these are written in memcpy_64.S, which does
not have the same problem.

I don't know why this makes a difference, and it would be good
to have someone with a better understanding of assembler internals
review it.

It might be either a bug in the kernel or a bug in the assembler,
no idea which one. My patch makes it work with all versions of
clang and gcc, which is probably helpful even if it's a workaround
for a clang bug.

Cc: stable@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/x86/lib/memmove_64.S | 4 ++--
 arch/x86/lib/memset_64.S  | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/lib/memmove_64.S b/arch/x86/lib/memmove_64.S
index 7ff00ea64e4f..dcca01434be8 100644
--- a/arch/x86/lib/memmove_64.S
+++ b/arch/x86/lib/memmove_64.S
@@ -26,8 +26,8 @@
  */
 .weak memmove
 
-SYM_FUNC_START_ALIAS(memmove)
-SYM_FUNC_START(__memmove)
+SYM_FUNC_START_ALIAS(__memmove)
+SYM_FUNC_START_LOCAL(memmove)
 
 	mov %rdi, %rax
 
diff --git a/arch/x86/lib/memset_64.S b/arch/x86/lib/memset_64.S
index 9ff15ee404a4..a97f2ea4e0b2 100644
--- a/arch/x86/lib/memset_64.S
+++ b/arch/x86/lib/memset_64.S
@@ -19,8 +19,8 @@
  *
  * rax   original destination
  */
-SYM_FUNC_START_ALIAS(memset)
-SYM_FUNC_START(__memset)
+SYM_FUNC_START_ALIAS(__memset)
+SYM_FUNC_START_LOCAL(memset)
 	/*
 	 * Some CPUs support enhanced REP MOVSB/STOSB feature. It is recommended
 	 * to use it when possible. If not available, use fast string instructions.
-- 
2.26.2

