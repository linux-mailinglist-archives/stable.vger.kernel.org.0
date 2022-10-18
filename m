Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D58F601F48
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 02:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbiJRARJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 20:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231732AbiJRAPP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 20:15:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD0A89AC1;
        Mon, 17 Oct 2022 17:12:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AEDD261345;
        Tue, 18 Oct 2022 00:11:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35049C433C1;
        Tue, 18 Oct 2022 00:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666051913;
        bh=Rh81RPbhx4/y1NV0oUGFkBZ+zKY1q380V3RQ3dzOUqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JUURDFBxFfqKm5kamFN+OVTJP9RLZIrKR+Za3P7s7Kbf1Z9PyA9hg9h18J9bgyJRJ
         e2Fp91ZXh+/g/iTGhMQpF/yM6AKEOdKMzcI0TsPK7uZjTZFh0Z5PPGGV0LJ8i56+F6
         Jaq23wPR37AkNK8Dydvgx5AoKS6rIdrzHigkl/+BRdCB8KAeYu9tv3HpIhsmXtdjd8
         UMPHUYTGed93NRVpHIHM8MkGEMPXbmj1s+ZsZ3KKnjMnxLJtSFFGdr63Jv9yg6Gmoo
         2Cjc/2sumuk5ccJqibGM/tPVpeawuOCWzTmCTA8gM8/Zq/Mh0ro3a/gAZrBpSblewB
         Cf1vaMY4Rw4RQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Sasha Levin <sashal@kernel.org>, jpoimboe@kernel.org,
        bp@suse.de, fenghua.yu@intel.com, tony.luck@intel.com
Subject: [PATCH AUTOSEL 4.14 2/8] objtool,x86: Teach decode about LOOP* instructions
Date:   Mon, 17 Oct 2022 20:11:41 -0400
Message-Id: <20221018001147.2732350-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221018001147.2732350-1-sashal@kernel.org>
References: <20221018001147.2732350-1-sashal@kernel.org>
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

