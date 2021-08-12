Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41AAF3E9BD6
	for <lists+stable@lfdr.de>; Thu, 12 Aug 2021 03:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233243AbhHLBOY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 21:14:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:38078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233117AbhHLBOY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Aug 2021 21:14:24 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6106060187;
        Thu, 12 Aug 2021 01:13:56 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@goodmis.org>)
        id 1mDzIB-003pHU-D1; Wed, 11 Aug 2021 21:13:55 -0400
Message-ID: <20210812011355.235381081@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 11 Aug 2021 21:12:55 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Miroslav Benes <mbenes@suse.cz>, stable@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [for-linus][PATCH 5/7] tracing: define needed config DYNAMIC_FTRACE_WITH_ARGS
References: <20210812011250.954353252@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Bulwahn <lukas.bulwahn@gmail.com>

Commit 2860cd8a2353 ("livepatch: Use the default ftrace_ops instead of
REGS when ARGS is available") intends to enable config LIVEPATCH when
ftrace with ARGS is available. However, the chain of configs to enable
LIVEPATCH is incomplete, as HAVE_DYNAMIC_FTRACE_WITH_ARGS is available,
but the definition of DYNAMIC_FTRACE_WITH_ARGS, combining DYNAMIC_FTRACE
and HAVE_DYNAMIC_FTRACE_WITH_ARGS, needed to enable LIVEPATCH, is missing
in the commit.

Fortunately, ./scripts/checkkconfigsymbols.py detects this and warns:

DYNAMIC_FTRACE_WITH_ARGS
Referencing files: kernel/livepatch/Kconfig

So, define the config DYNAMIC_FTRACE_WITH_ARGS analogously to the already
existing similar configs, DYNAMIC_FTRACE_WITH_REGS and
DYNAMIC_FTRACE_WITH_DIRECT_CALLS, in ./kernel/trace/Kconfig to connect the
chain of configs.

Link: https://lore.kernel.org/kernel-janitors/CAKXUXMwT2zS9fgyQHKUUiqo8ynZBdx2UEUu1WnV_q0OCmknqhw@mail.gmail.com/
Link: https://lkml.kernel.org/r/20210806195027.16808-1-lukas.bulwahn@gmail.com

Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: stable@vger.kernel.org
Fixes: 2860cd8a2353 ("livepatch: Use the default ftrace_ops instead of REGS when ARGS is available")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/Kconfig | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index d567b1717c4c..3ee23f4d437f 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -219,6 +219,11 @@ config DYNAMIC_FTRACE_WITH_DIRECT_CALLS
 	depends on DYNAMIC_FTRACE_WITH_REGS
 	depends on HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
 
+config DYNAMIC_FTRACE_WITH_ARGS
+	def_bool y
+	depends on DYNAMIC_FTRACE
+	depends on HAVE_DYNAMIC_FTRACE_WITH_ARGS
+
 config FUNCTION_PROFILER
 	bool "Kernel function profiler"
 	depends on FUNCTION_TRACER
-- 
2.30.2
