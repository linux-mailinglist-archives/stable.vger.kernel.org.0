Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1756D1D865B
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729292AbgERRol (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:44:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:42930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729164AbgERRod (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:44:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 439FA207C4;
        Mon, 18 May 2020 17:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823872;
        bh=YJ+ZL8Gk6sA7MQHo52M5Pih7/8OQABFuySkueOQZfW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Svn5KNGX9Q/G21lydwIy1X+W55yeVXoNm1riLhpp2CBHZDt8nRoo7cwY51Tp33VsJ
         V+udtrLY+kxTtOO732LgTv9UzF3Jj5347U7jEiQ5FfRzsjGmpBS3QrNJv1Kl2kdaFo
         wru5N3yYtOeC7O+F9xRtpSmnYrzShlZJIHEwm+sY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vince Weaver <vincent.weaver@maine.edu>,
        Dave Jones <dsj@fb.com>, Steven Rostedt <rostedt@goodmis.org>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Joe Mario <jmario@redhat.com>, Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Jann Horn <jannh@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4.9 23/90] objtool: Fix stack offset tracking for indirect CFAs
Date:   Mon, 18 May 2020 19:36:01 +0200
Message-Id: <20200518173455.871408373@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.930655662@linuxfoundation.org>
References: <20200518173450.930655662@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

commit d8dd25a461e4eec7190cb9d66616aceacc5110ad upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/objtool/check.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -1264,7 +1264,7 @@ static int update_insn_state_regs(struct
 	struct cfi_reg *cfa = &state->cfa;
 	struct stack_op *op = &insn->stack_op;
 
-	if (cfa->base != CFI_SP)
+	if (cfa->base != CFI_SP && cfa->base != CFI_SP_INDIRECT)
 		return 0;
 
 	/* push */


