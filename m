Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D837A31DDE
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729693AbfFANbf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:31:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:56052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729205AbfFANZm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:25:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7C0B2739A;
        Sat,  1 Jun 2019 13:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395541;
        bh=WbsEjZ01dW2VzUflcPYAWm4rdqD1xl3f+Eh2Tyn2NQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T7BUMHr2QpEPp++OXb74xyz249uGPhgMYaamAnYV4lJ3evHLAY5LQKq+nacxVJaqR
         ygidfae/U0pEMHiB3oSW8rOfiwpk7tpf2dS99OZcUku2jW3BkrUmfXqhSgjsc2Lele
         yk2PMFmu/vuWaV9aYWukIPuAp0BXVi3f33u9SRmU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 18/74] objtool: Don't use ignore flag for fake jumps
Date:   Sat,  1 Jun 2019 09:24:05 -0400
Message-Id: <20190601132501.27021-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601132501.27021-1-sashal@kernel.org>
References: <20190601132501.27021-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

[ Upstream commit e6da9567959e164f82bc81967e0d5b10dee870b4 ]

The ignore flag is set on fake jumps in order to keep
add_jump_destinations() from setting their jump_dest, since it already
got set when the fake jump was created.

But using the ignore flag is a bit of a hack.  It's normally used to
skip validation of an instruction, which doesn't really make sense for
fake jumps.

Also, after the next patch, using the ignore flag for fake jumps can
trigger a false "why am I validating an ignored function?" warning.

Instead just add an explicit check in add_jump_destinations() to skip
fake jumps.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/71abc072ff48b2feccc197723a9c52859476c068.1557766718.git.jpoimboe@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/check.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index ae3446768181f..95326c6a7a249 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -28,6 +28,8 @@
 #include <linux/hashtable.h>
 #include <linux/kernel.h>
 
+#define FAKE_JUMP_OFFSET -1
+
 struct alternative {
 	struct list_head list;
 	struct instruction *insn;
@@ -498,7 +500,7 @@ static int add_jump_destinations(struct objtool_file *file)
 		    insn->type != INSN_JUMP_UNCONDITIONAL)
 			continue;
 
-		if (insn->ignore)
+		if (insn->ignore || insn->offset == FAKE_JUMP_OFFSET)
 			continue;
 
 		rela = find_rela_by_dest_range(insn->sec, insn->offset,
@@ -645,10 +647,10 @@ static int handle_group_alt(struct objtool_file *file,
 		clear_insn_state(&fake_jump->state);
 
 		fake_jump->sec = special_alt->new_sec;
-		fake_jump->offset = -1;
+		fake_jump->offset = FAKE_JUMP_OFFSET;
 		fake_jump->type = INSN_JUMP_UNCONDITIONAL;
 		fake_jump->jump_dest = list_next_entry(last_orig_insn, list);
-		fake_jump->ignore = true;
+		fake_jump->func = orig_insn->func;
 	}
 
 	if (!special_alt->new_len) {
-- 
2.20.1

