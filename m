Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6249D65D8D4
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239901AbjADQTA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:19:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239905AbjADQSh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:18:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7313B8FFA
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:18:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29559B817AE
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:18:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84DB6C43396;
        Wed,  4 Jan 2023 16:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849113;
        bh=Shpcuz+N78hWLl6cfi9aW9DgtYZPVLJ7BAA8JqbfG2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WougLCpXt4Qb9cnfAcbXcdWfVXB12Hb6LaGJjihhhMDKthZmoEQcarFaF1B9cI7/T
         kET7Xe2vXDlvbVNu2k5XbQ0cHvhfN2LMduTTME5UiwvqRFCBM0m4v8tL0DLkOLZu3l
         Rz2bXcBXbLsHqfVSWWRDer58jyp7zjGX4Av1VxNs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.0 065/177] x86/kprobes: Fix kprobes instruction boudary check with CONFIG_RETHUNK
Date:   Wed,  4 Jan 2023 17:05:56 +0100
Message-Id: <20230104160509.625774247@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit 1993bf97992df2d560287f3c4120eda57426843d upstream.

Since the CONFIG_RETHUNK and CONFIG_SLS will use INT3 for stopping
speculative execution after RET instruction, kprobes always failes to
check the probed instruction boundary by decoding the function body if
the probed address is after such sequence. (Note that some conditional
code blocks will be placed after function return, if compiler decides
it is not on the hot path.)

This is because kprobes expects kgdb puts the INT3 as a software
breakpoint and it will replace the original instruction.
But these INT3 are not such purpose, it doesn't need to recover the
original instruction.

To avoid this issue, kprobes checks whether the INT3 is owned by
kgdb or not, and if so, stop decoding and make it fail. The other
INT3 will come from CONFIG_RETHUNK/CONFIG_SLS and those can be
treated as a one-byte instruction.

Fixes: e463a09af2f0 ("x86: Add straight-line-speculation mitigation")
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/167146051026.1374301.392728975473572291.stgit@devnote3
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/kprobes/core.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -37,6 +37,7 @@
 #include <linux/extable.h>
 #include <linux/kdebug.h>
 #include <linux/kallsyms.h>
+#include <linux/kgdb.h>
 #include <linux/ftrace.h>
 #include <linux/kasan.h>
 #include <linux/moduleloader.h>
@@ -283,12 +284,15 @@ static int can_probe(unsigned long paddr
 		if (ret < 0)
 			return 0;
 
+#ifdef CONFIG_KGDB
 		/*
-		 * Another debugging subsystem might insert this breakpoint.
-		 * In that case, we can't recover it.
+		 * If there is a dynamically installed kgdb sw breakpoint,
+		 * this function should not be probed.
 		 */
-		if (insn.opcode.bytes[0] == INT3_INSN_OPCODE)
+		if (insn.opcode.bytes[0] == INT3_INSN_OPCODE &&
+		    kgdb_has_hit_break(addr))
 			return 0;
+#endif
 		addr += insn.length;
 	}
 


