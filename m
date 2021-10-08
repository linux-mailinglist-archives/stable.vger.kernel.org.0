Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 545854269B4
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242727AbhJHLkg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:40:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:39486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243255AbhJHLjG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:39:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFE71615E0;
        Fri,  8 Oct 2021 11:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692797;
        bh=CEQN41l6ZcHJHjaCHHfGMtXSoAkYU/pYnEf/L9HH98w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U/MbRydj3M2mTrCYHQovtNBpdmPRI77IWj+PUEnZhk20IouWej/pUR9kqYLS4O4Jb
         pB1nT5RN4EO6INQ+DnULrFTP88ZD/BCSjwgQ+78KCqTN3S2pdiaJ7hjqXfXIhLq59H
         aLDPAKxyuAWaRYqhVXnDC2Mds2K9HaJj5Y7IOgyY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Numfor Mbiziwo-Tiapo <nums@google.com>,
        Ian Rogers <irogers@google.com>, Borislav Petkov <bp@suse.de>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 35/48] x86/insn, tools/x86: Fix undefined behavior due to potential unaligned accesses
Date:   Fri,  8 Oct 2021 13:28:11 +0200
Message-Id: <20211008112721.194413986@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112720.008415452@linuxfoundation.org>
References: <20211008112720.008415452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



