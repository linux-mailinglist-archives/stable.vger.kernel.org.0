Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69D506C1791
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232466AbjCTPPE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:15:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232163AbjCTPOs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:14:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7360932E4F
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:09:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC452B80EC4
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:09:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 252C0C43443;
        Mon, 20 Mar 2023 15:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324986;
        bh=6gw84gSUsLBddofxx460m5N7exbcnWCwe16HmDaEgw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NfXkvurxNh2FYgwt3IgG+G+dKKPmFY671xw7btkXY55s7psLh/iQ5hyOCoh3XjEZA
         6PX2OeywRudZ/yNA02KOqPkytrIPoA4ietHUokCynNoIToofqKnjYWv8x3BxO1bK83
         hxlOrvYFq9EQurg4Xc9R1JWRLZ54dKHaDt/mi7b0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 031/198] ftrace,kcfi: Define ftrace_stub_graph conditionally
Date:   Mon, 20 Mar 2023 15:52:49 +0100
Message-Id: <20230320145508.792505331@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit aa69f814920d85a2d4cfd5c294757c3d59d2fba6 ]

When CONFIG_FUNCTION_GRAPH_TRACER is disabled, __kcfi_typeid_ftrace_stub_graph
is missing, causing a link failure:

 ld.lld: error: undefined symbol: __kcfi_typeid_ftrace_stub_graph
 referenced by arch/x86/kernel/ftrace_64.o:(__cfi_ftrace_stub_graph) in archive vmlinux.a

Mark the reference to it as conditional on the same symbol, as
is done on arm64.

Link: https://lore.kernel.org/linux-trace-kernel/20230131093643.3850272-1-arnd@kernel.org

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Fixes: 883bbbffa5a4 ("ftrace,kcfi: Separate ftrace_stub() and ftrace_stub_graph()")
See-also: 2598ac6ec493 ("arm64: ftrace: Define ftrace_stub_graph only with FUNCTION_GRAPH_TRACER")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/ftrace_64.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/ftrace_64.S b/arch/x86/kernel/ftrace_64.S
index 2a4be92fd1444..6233c5b4c10b2 100644
--- a/arch/x86/kernel/ftrace_64.S
+++ b/arch/x86/kernel/ftrace_64.S
@@ -134,9 +134,11 @@ SYM_TYPED_FUNC_START(ftrace_stub)
 	RET
 SYM_FUNC_END(ftrace_stub)
 
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
 SYM_TYPED_FUNC_START(ftrace_stub_graph)
 	RET
 SYM_FUNC_END(ftrace_stub_graph)
+#endif
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 
-- 
2.39.2



