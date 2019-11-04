Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9248EEE94
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389747AbfKDWFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:05:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:36332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389801AbfKDWFJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:05:09 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B121421E6F;
        Mon,  4 Nov 2019 22:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905108;
        bh=KDouM1x/ZhUC/AxhtbM10VlvxvdYU4eTIV21usld9RQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZaqydWIBqUX3JD1O8kMnKc96N+185Hc/sk8ZFYmhCi4PaigzrNh2G1y0iS5KXBArT
         p9tUV4cQGmllF18nHLx9OiBodJvudfH3wOZZBRnmGN6cFhp1OmPUUy19huFjjWYSUT
         qlsUyEGiIW5EvOEgg2d2cfpcONem2fobs/cfHNC0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Morse <james.morse@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 031/163] arm64: ftrace: Ensure synchronisation in PLT setup for Neoverse-N1 #1542419
Date:   Mon,  4 Nov 2019 22:43:41 +0100
Message-Id: <20191104212142.544193256@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 1717732579742..06e56b4703153 100644
--- a/arch/arm64/kernel/ftrace.c
+++ b/arch/arm64/kernel/ftrace.c
@@ -121,10 +121,16 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 
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



