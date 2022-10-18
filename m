Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D69FD601F01
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 02:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbiJRAPR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 20:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231804AbiJRAOX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 20:14:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D8489ACC;
        Mon, 17 Oct 2022 17:11:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8619061348;
        Tue, 18 Oct 2022 00:11:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00720C433D7;
        Tue, 18 Oct 2022 00:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666051872;
        bh=s+K9wJScfNERIDs7MapJXz8te1pff7k7NPx9WY6kqb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kXNtGP47q6P3/J2HsXvDsMV3EPwq7feO2Vx326P2RXbOiCRfdoW+yh9CxA+wrn/K6
         Q3Axq0yEEJFxruDgt+hR8kh8MRkb5jw3z5uKGYpokn7URXJmoepCFJQ0DAfRrqfuRI
         kMRhaG3OOSSi9Hioz5it4eBZjhRasMO2uemewVN+rCDOI8mGl8vAfpEZfMVKvcnDo1
         zWjUAtSM3577zLlOfepBpsdWBd5N7vCAdGhDbTinpRNgXod3MdhOm5dF4viIgdU7LL
         DQCqsT37Wlng/8rWWdaaBbElKOQ0M8z/uGVBflf52Azi+WQra06PldCDXud3fxl0K6
         LIMEcdfP7CZrQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Sasha Levin <sashal@kernel.org>, jpoimboe@kernel.org,
        bp@suse.de, tony.luck@intel.com, fenghua.yu@intel.com
Subject: [PATCH AUTOSEL 5.4 05/13] objtool,x86: Teach decode about LOOP* instructions
Date:   Mon, 17 Oct 2022 20:10:54 -0400
Message-Id: <20221018001102.2731930-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221018001102.2731930-1-sashal@kernel.org>
References: <20221018001102.2731930-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 7a7621dfa417aa3715d2a3bd1bdd6cf5018274d0 ]

When 'discussing' control flow Masami mentioned the LOOP* instructions
and I realized objtool doesn't decode them properly.

As it turns out, these instructions are somewhat inefficient and as
such unlikely to be emitted by the compiler (a few vmlinux.o checks
can't find a single one) so this isn't critical, but still, best to
decode them properly.

Reported-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/Yxhd4EMKyoFoH9y4@hirez.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/arch/x86/decode.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/objtool/arch/x86/decode.c b/tools/objtool/arch/x86/decode.c
index a62e032863a8..4a7652719130 100644
--- a/tools/objtool/arch/x86/decode.c
+++ b/tools/objtool/arch/x86/decode.c
@@ -435,6 +435,12 @@ int arch_decode_instruction(struct elf *elf, struct section *sec,
 		*type = INSN_CONTEXT_SWITCH;
 		break;
 
+	case 0xe0: /* loopne */
+	case 0xe1: /* loope */
+	case 0xe2: /* loop */
+		*type = INSN_JUMP_CONDITIONAL;
+		break;
+
 	case 0xe8:
 		*type = INSN_CALL;
 		break;
-- 
2.35.1

