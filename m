Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBBB41D3B73
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 21:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729984AbgENTCV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 15:02:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:55494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729318AbgENSzK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 14:55:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A78820767;
        Thu, 14 May 2020 18:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482510;
        bh=3e7nlEZf4wtghonZNXnreoWirReVHuM9IZL5Wh0xp/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1B26N3A77WedwB3CGNueqSweF2DYC/duhb/TsJVTIRoaZK7/4yORPHsmdy4QkDBrC
         IM4A8WQ1DXDfohwfksV2q7lEgxa7+1NWpByxuzcKJ1Z06N0WF7ueTa47Ds1LnHIA+a
         kAReV7mNiAreB9Pumbsi1JIlqQrgkYLk5/GNc3F4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Dave Jones <dsj@fb.com>, Steven Rostedt <rostedt@goodmis.org>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Joe Mario <jmario@redhat.com>, Miroslav Benes <mbenes@suse.cz>,
        Ingo Molnar <mingo@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Jann Horn <jannh@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 10/39] objtool: Fix stack offset tracking for indirect CFAs
Date:   Thu, 14 May 2020 14:54:27 -0400
Message-Id: <20200514185456.21060-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185456.21060-1-sashal@kernel.org>
References: <20200514185456.21060-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

[ Upstream commit d8dd25a461e4eec7190cb9d66616aceacc5110ad ]

When the current frame address (CFA) is stored on the stack (i.e.,
cfa->base == CFI_SP_INDIRECT), objtool neglects to adjust the stack
offset when there are subsequent pushes or pops.  This results in bad
ORC data at the end of the ENTER_IRQ_STACK macro, when it puts the
previous stack pointer on the stack and does a subsequent push.

This fixes the following unwinder warning:

  WARNING: can't dereference registers at 00000000f0a6bdba for ip interrupt_entry+0x9f/0xa0

Fixes: 627fce14809b ("objtool: Add ORC unwind table generation")
Reported-by: Vince Weaver <vincent.weaver@maine.edu>
Reported-by: Dave Jones <dsj@fb.com>
Reported-by: Steven Rostedt <rostedt@goodmis.org>
Reported-by: Vegard Nossum <vegard.nossum@oracle.com>
Reported-by: Joe Mario <jmario@redhat.com>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/853d5d691b29e250333332f09b8e27410b2d9924.1587808742.git.jpoimboe@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/check.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 04fc04b4ab67e..5685fe2c7a7d3 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -1291,7 +1291,7 @@ static int update_insn_state_regs(struct instruction *insn, struct insn_state *s
 	struct cfi_reg *cfa = &state->cfa;
 	struct stack_op *op = &insn->stack_op;
 
-	if (cfa->base != CFI_SP)
+	if (cfa->base != CFI_SP && cfa->base != CFI_SP_INDIRECT)
 		return 0;
 
 	/* push */
-- 
2.20.1

