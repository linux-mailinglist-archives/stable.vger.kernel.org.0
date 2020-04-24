Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA74F1B7549
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 14:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbgDXMcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 08:32:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:52390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727781AbgDXMXA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 08:23:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B61A6215A4;
        Fri, 24 Apr 2020 12:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587730979;
        bh=f5gA1/aIFeOtSaG/MyaRYS8peF9JIhvDtG2xbcm4O/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MLe3RMcVtsKRqeIjgM9+AemRRvSxmiIH2QVLhIFA/8e3QJ44mE6VHz0MDyc6Bf+o3
         oxey8TVOsHa0OElroGC+Q/+EF4K1oK0Kfji+tz1cmaZIYMKfjG1ysAR+ERWrugoKsI
         4oTlKz+e/JNlMpfst3do8XafGyqvXGoc5QQ1fz9c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Kees Cook <keescook@chromium.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.6 19/38] objtool: Fix CONFIG_UBSAN_TRAP unreachable warnings
Date:   Fri, 24 Apr 2020 08:22:17 -0400
Message-Id: <20200424122237.9831-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200424122237.9831-1-sashal@kernel.org>
References: <20200424122237.9831-1-sashal@kernel.org>
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
index 2b765bbbef922..95c485d3d4d83 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2307,14 +2307,27 @@ static bool ignore_unreachable_insn(struct instruction *insn)
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

