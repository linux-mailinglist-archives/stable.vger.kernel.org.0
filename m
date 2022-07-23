Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FEB357EDE7
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238045AbiGWKEg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238424AbiGWKEW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:04:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2F438F50F;
        Sat, 23 Jul 2022 02:59:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C55E611BF;
        Sat, 23 Jul 2022 09:59:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B29FC341C7;
        Sat, 23 Jul 2022 09:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570378;
        bh=eFvAyJVDibAY2Sr7A/p+MgTJbLpaK5JM6AIuZ6Yji2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hLdSODmnPLqB2qDcbaPNWuVwQi/NLsqnNblfwcJpM6QjEazrS1jCGwmuYnAKeIljY
         DAOhODYEjV3iDGhyALuXL1MzwiSi2/n/K7rUt18Xyc58JWTSDH44rWVbe4YmSh/iTM
         kA16uJHswUVSS0O4p+iwsX7/tZIA4/Z3JgBIKcEs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 065/148] objtool: Add straight-line-speculation validation
Date:   Sat, 23 Jul 2022 11:54:37 +0200
Message-Id: <20220723095242.497080327@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220723095224.302504400@linuxfoundation.org>
References: <20220723095224.302504400@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 1cc1e4c8aab4213bd4e6353dec2620476a233d6d upstream.

Teach objtool to validate the straight-line-speculation constraints:

 - speculation trap after indirect calls
 - speculation trap after RET

Notable: when an instruction is annotated RETPOLINE_SAFE, indicating
  speculation isn't a problem, also don't care about sls for that
  instruction.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20211204134908.023037659@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 5.10: adjust filenames, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/arch.h            |    1 +
 tools/objtool/arch/x86/decode.c |   13 +++++++++----
 tools/objtool/builtin-check.c   |    4 +++-
 tools/objtool/builtin.h         |    3 ++-
 tools/objtool/check.c           |   14 ++++++++++++++
 5 files changed, 29 insertions(+), 6 deletions(-)

--- a/tools/objtool/arch.h
+++ b/tools/objtool/arch.h
@@ -26,6 +26,7 @@ enum insn_type {
 	INSN_CLAC,
 	INSN_STD,
 	INSN_CLD,
+	INSN_TRAP,
 	INSN_OTHER,
 };
 
--- a/tools/objtool/arch/x86/decode.c
+++ b/tools/objtool/arch/x86/decode.c
@@ -456,6 +456,11 @@ int arch_decode_instruction(const struct
 
 		break;
 
+	case 0xcc:
+		/* int3 */
+		*type = INSN_TRAP;
+		break;
+
 	case 0xe3:
 		/* jecxz/jrcxz */
 		*type = INSN_JUMP_CONDITIONAL;
@@ -592,10 +597,10 @@ const char *arch_ret_insn(int len)
 {
 	static const char ret[5][5] = {
 		{ BYTE_RET },
-		{ BYTE_RET, 0x90 },
-		{ BYTE_RET, 0x66, 0x90 },
-		{ BYTE_RET, 0x0f, 0x1f, 0x00 },
-		{ BYTE_RET, 0x0f, 0x1f, 0x40, 0x00 },
+		{ BYTE_RET, 0xcc },
+		{ BYTE_RET, 0xcc, 0x90 },
+		{ BYTE_RET, 0xcc, 0x66, 0x90 },
+		{ BYTE_RET, 0xcc, 0x0f, 0x1f, 0x00 },
 	};
 
 	if (len < 1 || len > 5) {
--- a/tools/objtool/builtin-check.c
+++ b/tools/objtool/builtin-check.c
@@ -18,7 +18,8 @@
 #include "builtin.h"
 #include "objtool.h"
 
-bool no_fp, no_unreachable, retpoline, module, backtrace, uaccess, stats, validate_dup, vmlinux;
+bool no_fp, no_unreachable, retpoline, module, backtrace, uaccess, stats,
+     validate_dup, vmlinux, sls;
 
 static const char * const check_usage[] = {
 	"objtool check [<options>] file.o",
@@ -35,6 +36,7 @@ const struct option check_options[] = {
 	OPT_BOOLEAN('s', "stats", &stats, "print statistics"),
 	OPT_BOOLEAN('d', "duplicate", &validate_dup, "duplicate validation for vmlinux.o"),
 	OPT_BOOLEAN('l', "vmlinux", &vmlinux, "vmlinux.o validation"),
+	OPT_BOOLEAN('S', "sls", &sls, "validate straight-line-speculation"),
 	OPT_END(),
 };
 
--- a/tools/objtool/builtin.h
+++ b/tools/objtool/builtin.h
@@ -8,7 +8,8 @@
 #include <subcmd/parse-options.h>
 
 extern const struct option check_options[];
-extern bool no_fp, no_unreachable, retpoline, module, backtrace, uaccess, stats, validate_dup, vmlinux;
+extern bool no_fp, no_unreachable, retpoline, module, backtrace, uaccess, stats,
+            validate_dup, vmlinux, sls;
 
 extern int cmd_check(int argc, const char **argv);
 extern int cmd_orc(int argc, const char **argv);
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2775,6 +2775,12 @@ static int validate_branch(struct objtoo
 		switch (insn->type) {
 
 		case INSN_RETURN:
+			if (next_insn && next_insn->type == INSN_TRAP) {
+				next_insn->ignore = true;
+			} else if (sls && !insn->retpoline_safe) {
+				WARN_FUNC("missing int3 after ret",
+					  insn->sec, insn->offset);
+			}
 			return validate_return(func, insn, &state);
 
 		case INSN_CALL:
@@ -2818,6 +2824,14 @@ static int validate_branch(struct objtoo
 			break;
 
 		case INSN_JUMP_DYNAMIC:
+			if (next_insn && next_insn->type == INSN_TRAP) {
+				next_insn->ignore = true;
+			} else if (sls && !insn->retpoline_safe) {
+				WARN_FUNC("missing int3 after indirect jump",
+					  insn->sec, insn->offset);
+			}
+
+			/* fallthrough */
 		case INSN_JUMP_DYNAMIC_CONDITIONAL:
 			if (is_sibling_call(insn)) {
 				ret = validate_sibling_call(insn, &state);


