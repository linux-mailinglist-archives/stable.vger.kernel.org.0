Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63EB348009B
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239632AbhL0Prc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:47:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240664AbhL0Ppa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:45:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2672C08EA37;
        Mon, 27 Dec 2021 07:42:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C3FAB810C5;
        Mon, 27 Dec 2021 15:42:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA8C6C36AE7;
        Mon, 27 Dec 2021 15:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619759;
        bh=5Q/hHZCeTD17+mmxxLZ4p7yInX3ens9vN2u4mq/6DTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=soyFvyLlSiIAiPSRSp4Q5wy2ee89cooXKJsH4cR/qNjCaYmJAxCTU9PMov7zVHOYi
         eOgiB2iUaOUH12XNp70qkFF5+gIGP4ZXvL/hc7YmISePwuvafuFvSOR8V0VZvMX56k
         B6ZHsn9pbMA+bchUpk93rtnrsa2xDQEJ++8xdHlI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        Vasily Gorbik <gor@linux.ibm.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 060/128] compiler.h: Fix annotation macro misplacement with Clang
Date:   Mon, 27 Dec 2021 16:30:35 +0100
Message-Id: <20211227151333.508277236@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

[ Upstream commit dcce50e6cc4d86a63dc0a9a6ee7d4f948ccd53a1 ]

When building with Clang and CONFIG_TRACE_BRANCH_PROFILING, there are a
lot of unreachable warnings, like:

  arch/x86/kernel/traps.o: warning: objtool: handle_xfd_event()+0x134: unreachable instruction

Without an input to the inline asm, 'volatile' is ignored for some
reason and Clang feels free to move the reachable() annotation away from
its intended location.

Fix that by re-adding the counter value to the inputs.

Fixes: f1069a8756b9 ("compiler.h: Avoid using inline asm operand modifiers")
Fixes: c199f64ff93c ("instrumentation.h: Avoid using inline asm operand modifiers")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lore.kernel.org/r/0417e96909b97a406323409210de7bf13df0b170.1636410380.git.jpoimboe@redhat.com
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/compiler.h        | 4 ++--
 include/linux/instrumentation.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 3d5af56337bdb..429dcebe2b992 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -121,7 +121,7 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
 	asm volatile(__stringify_label(c) ":\n\t"			\
 		     ".pushsection .discard.reachable\n\t"		\
 		     ".long " __stringify_label(c) "b - .\n\t"		\
-		     ".popsection\n\t");				\
+		     ".popsection\n\t" : : "i" (c));			\
 })
 #define annotate_reachable() __annotate_reachable(__COUNTER__)
 
@@ -129,7 +129,7 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
 	asm volatile(__stringify_label(c) ":\n\t"			\
 		     ".pushsection .discard.unreachable\n\t"		\
 		     ".long " __stringify_label(c) "b - .\n\t"		\
-		     ".popsection\n\t");				\
+		     ".popsection\n\t" : : "i" (c));			\
 })
 #define annotate_unreachable() __annotate_unreachable(__COUNTER__)
 
diff --git a/include/linux/instrumentation.h b/include/linux/instrumentation.h
index fa2cd8c63dcc9..24359b4a96053 100644
--- a/include/linux/instrumentation.h
+++ b/include/linux/instrumentation.h
@@ -11,7 +11,7 @@
 	asm volatile(__stringify(c) ": nop\n\t"				\
 		     ".pushsection .discard.instr_begin\n\t"		\
 		     ".long " __stringify(c) "b - .\n\t"		\
-		     ".popsection\n\t");				\
+		     ".popsection\n\t" : : "i" (c));			\
 })
 #define instrumentation_begin() __instrumentation_begin(__COUNTER__)
 
@@ -50,7 +50,7 @@
 	asm volatile(__stringify(c) ": nop\n\t"				\
 		     ".pushsection .discard.instr_end\n\t"		\
 		     ".long " __stringify(c) "b - .\n\t"		\
-		     ".popsection\n\t");				\
+		     ".popsection\n\t" : : "i" (c));			\
 })
 #define instrumentation_end() __instrumentation_end(__COUNTER__)
 #else
-- 
2.34.1



