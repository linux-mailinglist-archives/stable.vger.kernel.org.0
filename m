Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CEAC1B74A7
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 14:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728434AbgDXMYa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 08:24:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:55082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728431AbgDXMY3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 08:24:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A1FA2166E;
        Fri, 24 Apr 2020 12:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587731069;
        bh=qpdI4aiqQcl64WibJl9H84JtNJ2lNsNd1RCV0TpJOKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HA4yvy9E2ixq176t1fF8Khz8D0w0tArK3tvAXBZGE+QHYs17pY2SDAF0LuDXM0ADc
         MkgfsH/NGrp1T2VxSJ9xGulX2nOnb91ubPL6cQi2WN99/UBca7qytrr5n2kBYDqlL5
         aITewPMVmrxC78trn8DfPbbEeCdahhpP07ljweS8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Kees Cook <keescook@chromium.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 07/21] objtool: Fix CONFIG_UBSAN_TRAP unreachable warnings
Date:   Fri, 24 Apr 2020 08:24:05 -0400
Message-Id: <20200424122419.10648-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200424122419.10648-1-sashal@kernel.org>
References: <20200424122419.10648-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

[ Upstream commit bd841d6154f5f41f8a32d3c1b0bc229e326e640a ]

CONFIG_UBSAN_TRAP causes GCC to emit a UD2 whenever it encounters an
unreachable code path.  This includes __builtin_unreachable().  Because
the BUG() macro uses __builtin_unreachable() after it emits its own UD2,
this results in a double UD2.  In this case objtool rightfully detects
that the second UD2 is unreachable:

  init/main.o: warning: objtool: repair_env_string()+0x1c8: unreachable instruction

We weren't able to figure out a way to get rid of the double UD2s, so
just silence the warning.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/6653ad73c6b59c049211bd7c11ed3809c20ee9f5.1585761021.git.jpoimboe@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/check.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 5422543faff85..b8ee6ee9b8947 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2065,14 +2065,27 @@ static bool ignore_unreachable_insn(struct instruction *insn)
 	    !strcmp(insn->sec->name, ".altinstr_aux"))
 		return true;
 
+	if (!insn->func)
+		return false;
+
+	/*
+	 * CONFIG_UBSAN_TRAP inserts a UD2 when it sees
+	 * __builtin_unreachable().  The BUG() macro has an unreachable() after
+	 * the UD2, which causes GCC's undefined trap logic to emit another UD2
+	 * (or occasionally a JMP to UD2).
+	 */
+	if (list_prev_entry(insn, list)->dead_end &&
+	    (insn->type == INSN_BUG ||
+	     (insn->type == INSN_JUMP_UNCONDITIONAL &&
+	      insn->jump_dest && insn->jump_dest->type == INSN_BUG)))
+		return true;
+
 	/*
 	 * Check if this (or a subsequent) instruction is related to
 	 * CONFIG_UBSAN or CONFIG_KASAN.
 	 *
 	 * End the search at 5 instructions to avoid going into the weeds.
 	 */
-	if (!insn->func)
-		return false;
 	for (i = 0; i < 5; i++) {
 
 		if (is_kasan_insn(insn) || is_ubsan_insn(insn))
-- 
2.20.1

