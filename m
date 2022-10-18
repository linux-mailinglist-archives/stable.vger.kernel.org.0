Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ECC2601FD8
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 02:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbiJRAvM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 20:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiJRAvJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 20:51:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC74379A52;
        Mon, 17 Oct 2022 17:51:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39CDCB81BE1;
        Tue, 18 Oct 2022 00:12:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06F87C43142;
        Tue, 18 Oct 2022 00:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666051928;
        bh=Rh81RPbhx4/y1NV0oUGFkBZ+zKY1q380V3RQ3dzOUqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eWdqEjXUqfJnKiEntEjsontxLwwetEitqSJpLfTCv66oIIhKpfZ4X35l9asXPbzkr
         6yQ+yrLiCft6mD1ikd10gbdQUgkHQVZwEoRyGPFzteybc8MoVfk/nM2prMPpPmpzrh
         hnKZpnfL7DY+jzJHQPIEXhbkc7djnVC9z1WcA45H+vLrb64AEjdJlC88ivnaVx/rLn
         kDvwgdIf0LzlTnHmVbEEyvKl2jAJgv2YX1xvlbgNHo83QL72k8meYH8/9JMpLUr/7L
         b8E+A718sQ/Q2Y3/93ZsoFP+UcpGkwzL6UJ2kpwroUEN0Ip1xx9CsS8KeS+GkM/QZz
         TTXbxHAKb8cBg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Sasha Levin <sashal@kernel.org>, jpoimboe@kernel.org,
        bp@suse.de, tony.luck@intel.com, fenghua.yu@intel.com
Subject: [PATCH AUTOSEL 4.9 2/8] objtool,x86: Teach decode about LOOP* instructions
Date:   Mon, 17 Oct 2022 20:11:56 -0400
Message-Id: <20221018001202.2732458-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221018001202.2732458-1-sashal@kernel.org>
References: <20221018001202.2732458-1-sashal@kernel.org>
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
index 540a209b78ab..faaf2820e932 100644
--- a/tools/objtool/arch/x86/decode.c
+++ b/tools/objtool/arch/x86/decode.c
@@ -440,6 +440,12 @@ int arch_decode_instruction(struct elf *elf, struct section *sec,
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

