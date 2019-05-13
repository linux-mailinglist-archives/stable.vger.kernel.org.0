Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2499F1BD35
	for <lists+stable@lfdr.de>; Mon, 13 May 2019 20:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726728AbfEMSfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 May 2019 14:35:09 -0400
Received: from terminus.zytor.com ([198.137.202.136]:49575 "EHLO
        terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbfEMSfJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 May 2019 14:35:09 -0400
Received: from terminus.zytor.com (localhost [127.0.0.1])
        by terminus.zytor.com (8.15.2/8.15.2) with ESMTPS id x4DIYjI03649489
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Mon, 13 May 2019 11:34:45 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 terminus.zytor.com x4DIYjI03649489
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2019041745; t=1557772485;
        bh=SOzzQJcYo51zQC+3BSfdHvIPa2/VPPcwOb5ONMErzm4=;
        h=Date:From:Cc:Reply-To:In-Reply-To:References:To:Subject:From;
        b=a77cpkDgAHv1CwSbe8+zwqYD2ClbkVEWJ+f6agXrhg1YhCUt5kbOTT6r8j8gCuIwC
         qTLu9EViny/0pi45DRqLqgv6jL4EnV/eoOP+85skhZ56ul7C0i2mv/y2H7JKbl0SXo
         hsWNynWNpH18vKug7/zOPMME04qA3PVo+WUKwgQjN/zuuwpWiyYEmLvUi0qGaHU3+a
         +n77VtSXiniqAzuJcS7PnQMTH8sAnT8LswCl3OZ/I4jylFXUAfch8vOV61YkkghVlD
         X9MAUCkXzPlXsxqePbBCabk2T9I7LzuCnKXYAtqNFpZdYCzD7iMuVzIpLjQlOBsSOQ
         PA/QWzlSqs00g==
Received: (from tipbot@localhost)
        by terminus.zytor.com (8.15.2/8.15.2/Submit) id x4DIYiEp3649486;
        Mon, 13 May 2019 11:34:44 -0700
Date:   Mon, 13 May 2019 11:34:44 -0700
X-Authentication-Warning: terminus.zytor.com: tipbot set sender to tipbot@zytor.com using -f
From:   tip-bot for Josh Poimboeuf <tipbot@zytor.com>
Message-ID: <tip-e6f393bc939d566ce3def71232d8013de9aaadde@git.kernel.org>
Cc:     jpoimboe@redhat.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@kernel.org, stable@vger.kernel.org,
        lkp@intel.com, torvalds@linux-foundation.org, hpa@zytor.com,
        peterz@infradead.org
Reply-To: jpoimboe@redhat.com, mingo@kernel.org, tglx@linutronix.de,
          linux-kernel@vger.kernel.org, stable@vger.kernel.org,
          lkp@intel.com, torvalds@linux-foundation.org,
          peterz@infradead.org, hpa@zytor.com
In-Reply-To: <546d143820cd08a46624ae8440d093dd6c902cae.1557766718.git.jpoimboe@redhat.com>
References: <546d143820cd08a46624ae8440d093dd6c902cae.1557766718.git.jpoimboe@redhat.com>
To:     linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] objtool: Fix function fallthrough detection
Git-Commit-ID: e6f393bc939d566ce3def71232d8013de9aaadde
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from
 these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Spam-Status: No, score=-3.1 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        T_DATE_IN_FUTURE_96_Q autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on terminus.zytor.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit-ID:  e6f393bc939d566ce3def71232d8013de9aaadde
Gitweb:     https://git.kernel.org/tip/e6f393bc939d566ce3def71232d8013de9aaadde
Author:     Josh Poimboeuf <jpoimboe@redhat.com>
AuthorDate: Mon, 13 May 2019 12:01:32 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 13 May 2019 20:31:17 +0200

objtool: Fix function fallthrough detection

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
---
 tools/objtool/check.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 90226791df6b..7325d89ccad9 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -1959,7 +1959,8 @@ static int validate_branch(struct objtool_file *file, struct instruction *first,
 			return 1;
 		}
 
-		func = insn->func ? insn->func->pfunc : NULL;
+		if (insn->func)
+			func = insn->func->pfunc;
 
 		if (func && insn->ignore) {
 			WARN_FUNC("BUG: why am I validating an ignored function?",
