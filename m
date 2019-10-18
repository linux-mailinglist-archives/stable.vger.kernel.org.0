Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDECADD368
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732455AbfJRWHH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:07:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:39214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732432AbfJRWHH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:07:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD4BF22466;
        Fri, 18 Oct 2019 22:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436426;
        bh=g01Pj0tf7hlnryPghFku7R8JDx+a9JzwcwCkVwtqZnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ts4nMQxnDiJP0pt3aMG5qaXn8lwKRMvCJ32OP36BagXGy/O5Ujprr8VSDsCUwTP8B
         dvsPzNdzjRhScfXzfNfiKi2+FAOSytPXYJTycG0HoI/6dooQkgrpOMeUx2EDCoQi5E
         M1QjWCrebj+8z4rOR/Taqkhc0L4+WOoXtyAXYbpg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 068/100] arm64: ftrace: Ensure synchronisation in PLT setup for Neoverse-N1 #1542419
Date:   Fri, 18 Oct 2019 18:04:53 -0400
Message-Id: <20191018220525.9042-68-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220525.9042-1-sashal@kernel.org>
References: <20191018220525.9042-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

[ Upstream commit dd8a1f13488438c6c220b7cafa500baaf21a6e53 ]

CPUs affected by Neoverse-N1 #1542419 may execute a stale instruction if
it was recently modified. The affected sequence requires freshly written
instructions to be executable before a branch to them is updated.

There are very few places in the kernel that modify executable text,
all but one come with sufficient synchronisation:
 * The module loader's flush_module_icache() calls flush_icache_range(),
   which does a kick_all_cpus_sync()
 * bpf_int_jit_compile() calls flush_icache_range().
 * Kprobes calls aarch64_insn_patch_text(), which does its work in
   stop_machine().
 * static keys and ftrace both patch between nops and branches to
   existing kernel code (not generated code).

The affected sequence is the interaction between ftrace and modules.
The module PLT is cleaned using __flush_icache_range() as the trampoline
shouldn't be executable until we update the branch to it.

Drop the double-underscore so that this path runs kick_all_cpus_sync()
too.

Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/ftrace.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/ftrace.c b/arch/arm64/kernel/ftrace.c
index 7eff8afa035fd..b6618391be8c6 100644
--- a/arch/arm64/kernel/ftrace.c
+++ b/arch/arm64/kernel/ftrace.c
@@ -119,10 +119,16 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 
 			/*
 			 * Ensure updated trampoline is visible to instruction
-			 * fetch before we patch in the branch.
+			 * fetch before we patch in the branch. Although the
+			 * architecture doesn't require an IPI in this case,
+			 * Neoverse-N1 erratum #1542419 does require one
+			 * if the TLB maintenance in module_enable_ro() is
+			 * skipped due to rodata_enabled. It doesn't seem worth
+			 * it to make it conditional given that this is
+			 * certainly not a fast-path.
 			 */
-			__flush_icache_range((unsigned long)&dst[0],
-					     (unsigned long)&dst[1]);
+			flush_icache_range((unsigned long)&dst[0],
+					   (unsigned long)&dst[1]);
 		}
 		addr = (unsigned long)dst;
 #else /* CONFIG_ARM64_MODULE_PLTS */
-- 
2.20.1

