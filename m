Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB98632F54
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 22:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232059AbiKUVu2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 16:50:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231920AbiKUVuD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 16:50:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6813411168;
        Mon, 21 Nov 2022 13:50:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CB3661482;
        Mon, 21 Nov 2022 21:50:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A566C433C1;
        Mon, 21 Nov 2022 21:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669067400;
        bh=LS2V2EyhPBbSCeCDB5MLHsn3hCkAftB/ZVMjZ/wOTik=;
        h=Date:To:From:Subject:From;
        b=xvzziCKWViZ5Xy3UwK/8pfDYi8/X/8ua/1c0eSjSgjRR/XpsaOoPf1/+oR2R5J4yM
         O6RbrnIwRtPvbnnHP0Fqf5ikuDTdw7h/jHbb6RpBdCi7bc/2aaYfU69GcJeMLs0oKB
         2RHSrkRIwvuSzW5dGeCbIA3R0rNkVp9S1YDUDgfg=
Date:   Mon, 21 Nov 2022 13:49:59 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        revest@chromium.org, peterz@infradead.org, mhiramat@kernel.org,
        mark.rutland@arm.com, kpsingh@kernel.org, keescook@chromium.org,
        jpoimboe@redhat.com, hch@infradead.org, gregkh@linuxfoundation.org,
        bp@suse.de, alexei.starovoitov@gmail.com, rostedt@goodmis.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + error-injection-add-prompt-for-function-error-injection.patch added to mm-hotfixes-unstable branch
Message-Id: <20221121215000.5A566C433C1@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: error-injection: add prompt for function error injection
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     error-injection-add-prompt-for-function-error-injection.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/error-injection-add-prompt-for-function-error-injection.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: error-injection: add prompt for function error injection
Date: Mon, 21 Nov 2022 10:44:03 -0500

The config to be able to inject error codes into any function annotated
with ALLOW_ERROR_INJECTION() is enabled when
CONFIG_FUNCTION_ERROR_INJECTION is enabled.  But unfortunately, this is
always enabled on x86 when KPROBES is enabled, and there's no way to turn
it off.

As kprobes is useful for observability of the kernel, it is useful to have
it enabled in production environments.  But error injection should be
avoided.  Add a prompt to the config to allow it to be disabled even when
kprobes is enabled, and get rid of the "def_bool y".

This is a kernel debug feature (it's in Kconfig.debug), and should have
never been something enabled by default.

Link: https://lkml.kernel.org/r/20221121104403.1545f9b5@gandalf.local.home
Fixes: 540adea3809f6 ("error-injection: Separate error-injection from kprobe")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Acked-by: Borislav Petkov <bp@suse.de>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Florent Revest <revest@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/lib/Kconfig.debug~error-injection-add-prompt-for-function-error-injection
+++ a/lib/Kconfig.debug
@@ -1874,8 +1874,14 @@ config NETDEV_NOTIFIER_ERROR_INJECT
 	  If unsure, say N.
 
 config FUNCTION_ERROR_INJECTION
-	def_bool y
+	bool "Fault-injections of functions"
 	depends on HAVE_FUNCTION_ERROR_INJECTION && KPROBES
+	help
+	  Add fault injections into various functions that are annotated with
+	  ALLOW_ERROR_INJECTION() in the kernel. BPF may also modify the return
+	  value of theses functions. This is useful to test error paths of code.
+
+	  If unsure, say N
 
 config FAULT_INJECTION
 	bool "Fault-injection framework"
_

Patches currently in -mm which might be from rostedt@goodmis.org are

error-injection-add-prompt-for-function-error-injection.patch

