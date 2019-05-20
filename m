Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABC74236D1
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 15:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387416AbfETMQ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:16:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:57708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387413AbfETMQz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:16:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C41A820815;
        Mon, 20 May 2019 12:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558354614;
        bh=sL+t5AjFEQojtzLpmh7ftp1Yt8bKym9IQMcQwFTwJEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TieKIfezVH7EIVwGo5Ui5Csvv2ILE7PuwD78gAN0SoMomt4bHYJwDBWEoJyM20bzV
         ah/7QglKDvbX+pO6Dl+8MAgYjNidPD1FEzv5t1lXeAvGCLWQDXb81N9y/TfsCmG3HP
         HYutiat/OcexqGcosn7qOEKr1MvJDxsw3MlFlOaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 4.9 06/44] objtool: Fix function fallthrough detection
Date:   Mon, 20 May 2019 14:13:55 +0200
Message-Id: <20190520115231.784147525@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115230.720347034@linuxfoundation.org>
References: <20190520115230.720347034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

commit e6f393bc939d566ce3def71232d8013de9aaadde upstream.

When a function falls through to the next function due to a compiler
bug, objtool prints some obscure warnings.  For example:

  drivers/regulator/core.o: warning: objtool: regulator_count_voltages()+0x95: return with modified stack frame
  drivers/regulator/core.o: warning: objtool: regulator_count_voltages()+0x0: stack state mismatch: cfa1=7+32 cfa2=7+8

Instead it should be printing:

  drivers/regulator/core.o: warning: objtool: regulator_supply_is_couple() falls through to next function regulator_count_voltages()

This used to work, but was broken by the following commit:

  13810435b9a7 ("objtool: Support GCC 8's cold subfunctions")

The padding nops at the end of a function aren't actually part of the
function, as defined by the symbol table.  So the 'func' variable in
validate_branch() is getting cleared to NULL when a padding nop is
encountered, breaking the fallthrough detection.

If the current instruction doesn't have a function associated with it,
just consider it to be part of the previously detected function by not
overwriting the previous value of 'func'.

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Fixes: 13810435b9a7 ("objtool: Support GCC 8's cold subfunctions")
Link: http://lkml.kernel.org/r/546d143820cd08a46624ae8440d093dd6c902cae.1557766718.git.jpoimboe@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/objtool/check.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -1779,7 +1779,8 @@ static int validate_branch(struct objtoo
 			return 1;
 		}
 
-		func = insn->func ? insn->func->pfunc : NULL;
+		if (insn->func)
+			func = insn->func->pfunc;
 
 		if (func && insn->ignore) {
 			WARN_FUNC("BUG: why am I validating an ignored function?",


