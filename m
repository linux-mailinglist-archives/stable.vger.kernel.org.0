Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7B0119432
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729498AbfLJVN7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:13:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:40990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727376AbfLJVN7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:13:59 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F24E9206EC;
        Tue, 10 Dec 2019 21:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012438;
        bh=LPeNf+C9NhRIiQSMABV1XMqyuVoNoMCQgKrIxBmfE3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N9qfEyl9cVKMwCWRS63Hw89VYgGfTyrd61i4t/3tH70RcedeNQHyGR3cOuGZgwmxu
         3p78RO7CcREwcof+jhpm/eOF+cwOBFGF/G27+lVt0qCqBoEjIDcg7cze7hM0cOWbSc
         RqE45SxtUHdPpzr8OWPz+qGL8qFjGqNzgVTN7P/w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Burton <paul.burton@mips.com>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 350/350] MIPS: futex: Restore \n after sync instructions
Date:   Tue, 10 Dec 2019 16:07:35 -0500
Message-Id: <20191210210735.9077-311-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Burton <paul.burton@mips.com>

[ Upstream commit fd7710cb491f900eb63d2ce5aac0e682003e84e9 ]

Commit 3c1d3f097972 ("MIPS: futex: Emit Loongson3 sync workarounds
within asm") inadvertently removed the newlines following
__WEAK_LLSC_MB, which causes build failures for configurations in which
__WEAK_LLSC_MB expands to a sync instruction:

  {standard input}: Assembler messages:
  {standard input}:9346: Error: symbol `sync3' is already defined
  {standard input}:9380: Error: symbol `sync3' is already defined
  ...

Fix this by restoring the newlines to separate the sync instruction from
anything following it (such as the 3: label), preventing inadvertent
concatenation.

Signed-off-by: Paul Burton <paul.burton@mips.com>
Fixes: 3c1d3f097972 ("MIPS: futex: Emit Loongson3 sync workarounds within asm")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/futex.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/mips/include/asm/futex.h b/arch/mips/include/asm/futex.h
index 54cf205309316..110220705e978 100644
--- a/arch/mips/include/asm/futex.h
+++ b/arch/mips/include/asm/futex.h
@@ -33,7 +33,7 @@
 		"	.set	arch=r4000			\n"	\
 		"2:	sc	$1, %2				\n"	\
 		"	beqzl	$1, 1b				\n"	\
-		__stringify(__WEAK_LLSC_MB)				\
+		__stringify(__WEAK_LLSC_MB) "			\n"	\
 		"3:						\n"	\
 		"	.insn					\n"	\
 		"	.set	pop				\n"	\
@@ -63,7 +63,7 @@
 		"	.set	"MIPS_ISA_ARCH_LEVEL"		\n"	\
 		"2:	"user_sc("$1", "%2")"			\n"	\
 		"	beqz	$1, 1b				\n"	\
-		__stringify(__WEAK_LLSC_MB)				\
+		__stringify(__WEAK_LLSC_MB) "			\n"	\
 		"3:						\n"	\
 		"	.insn					\n"	\
 		"	.set	pop				\n"	\
@@ -148,7 +148,7 @@ futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
 		"	.set	arch=r4000				\n"
 		"2:	sc	$1, %2					\n"
 		"	beqzl	$1, 1b					\n"
-		__stringify(__WEAK_LLSC_MB)
+		__stringify(__WEAK_LLSC_MB) "				\n"
 		"3:							\n"
 		"	.insn						\n"
 		"	.set	pop					\n"
-- 
2.20.1

