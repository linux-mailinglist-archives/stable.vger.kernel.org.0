Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E643427286C
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 16:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727759AbgIUOnL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 10:43:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:49588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727696AbgIUOkv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 10:40:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4032A23719;
        Mon, 21 Sep 2020 14:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600699250;
        bh=puesQLL1vTui9u2CuuuBOVYfBiDNpon7FKU4BmliOZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r+r9xlfIhnq7bE0dECxqV8AH70RvFe8larUYuo6rsmUWgPOICeL5VLjKwu04tuJtP
         In2aXBeVgcuTN6eZeHlFvetqOe19dLYzoIopwHTgXrjICzpA74WefiBm/mEmB6/p6V
         NemA9UuzBgP7cFLcXYbjvp03iXVgBQ/XOTSU7MVM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.8 18/20] objtool: Fix noreturn detection for ignored functions
Date:   Mon, 21 Sep 2020 10:40:25 -0400
Message-Id: <20200921144027.2135390-18-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200921144027.2135390-1-sashal@kernel.org>
References: <20200921144027.2135390-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

[ Upstream commit db6c6a0df840e3f52c84cc302cc1a08ba11a4416 ]

When a function is annotated with STACK_FRAME_NON_STANDARD, objtool
doesn't validate its code paths.  It also skips sibling call detection
within the function.

But sibling call detection is actually needed for the case where the
ignored function doesn't have any return instructions.  Otherwise
objtool naively marks the function as implicit static noreturn, which
affects the reachability of its callers, resulting in "unreachable
instruction" warnings.

Fix it by just enabling sibling call detection for ignored functions.
The 'insn->ignore' check in add_jump_destinations() is no longer needed
after

  e6da9567959e ("objtool: Don't use ignore flag for fake jumps").

Fixes the following warning:

  arch/x86/kvm/vmx/vmx.o: warning: objtool: vmx_handle_exit_irqoff()+0x142: unreachable instruction

which triggers on an allmodconfig with CONFIG_GCOV_KERNEL unset.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lkml.kernel.org/r/5b1e2536cdbaa5246b60d7791b76130a74082c62.1599751464.git.jpoimboe@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/check.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 5e0d70a89fb87..773e6c7ee5f93 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -619,7 +619,7 @@ static int add_jump_destinations(struct objtool_file *file)
 		if (!is_static_jump(insn))
 			continue;
 
-		if (insn->ignore || insn->offset == FAKE_JUMP_OFFSET)
+		if (insn->offset == FAKE_JUMP_OFFSET)
 			continue;
 
 		rela = find_rela_by_dest_range(file->elf, insn->sec,
-- 
2.25.1

