Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E91B352648D
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 16:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381490AbiEMOb2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 10:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381057AbiEMOaS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 10:30:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F05998B0AA;
        Fri, 13 May 2022 07:28:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72BBC62100;
        Fri, 13 May 2022 14:28:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D0EC34116;
        Fri, 13 May 2022 14:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652452087;
        bh=IY9684GaV3FAMyB5H9w1Ya/09baI6tKjodMucQO2nSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s5Cl0Ycmm/jofuOOIg5G2WeGdRW3Lne7jCKs6pQ0PQtuJ9u3jAQw4674wWdedBVdf
         AEoE2XnXccl2/RyyR2ruZ+JSjUJQRgQ/9c299oklEtUNT/zQ482pb4ck00xTGTvmcG
         BZhd6QJ6XGBht1OzL4K8i7DgRoBVjz3Z99S5MhzM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 04/21] objtool: Add straight-line-speculation validation
Date:   Fri, 13 May 2022 16:23:46 +0200
Message-Id: <20220513142230.007174110@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220513142229.874949670@linuxfoundation.org>
References: <20220513142229.874949670@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 1cc1e4c8aab4213bd4e6353dec2620476a233d6d ]

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
---
 tools/objtool/arch/x86/decode.c         |   13 +++++++++----
 tools/objtool/builtin-check.c           |    3 ++-
 tools/objtool/check.c                   |   14 ++++++++++++++
 tools/objtool/include/objtool/arch.h    |    1 +
 tools/objtool/include/objtool/builtin.h |    2 +-
 5 files changed, 27 insertions(+), 6 deletions(-)

--- a/tools/objtool/arch/x86/decode.c
+++ b/tools/objtool/arch/x86/decode.c
@@ -529,6 +529,11 @@ int arch_decode_instruction(const struct
 		}
 		break;
 
+	case 0xcc:
+		/* int3 */
+		*type = INSN_TRAP;
+		break;
+
 	case 0xe3:
 		/* jecxz/jrcxz */
 		*type = INSN_JUMP_CONDITIONAL;
@@ -665,10 +670,10 @@ const char *arch_ret_insn(int len)
 {
 	static const char ret[5][5] = {
 		{ BYTE_RET },
-		{ BYTE_RET, BYTES_NOP1 },
-		{ BYTE_RET, BYTES_NOP2 },
-		{ BYTE_RET, BYTES_NOP3 },
-		{ BYTE_RET, BYTES_NOP4 },
+		{ BYTE_RET, 0xcc },
+		{ BYTE_RET, 0xcc, BYTES_NOP1 },
+		{ BYTE_RET, 0xcc, BYTES_NOP2 },
+		{ BYTE_RET, 0xcc, BYTES_NOP3 },
 	};
 
 	if (len < 1 || len > 5) {
--- a/tools/objtool/builtin-check.c
+++ b/tools/objtool/builtin-check.c
@@ -20,7 +20,7 @@
 #include <objtool/objtool.h>
 
 bool no_fp, no_unreachable, retpoline, module, backtrace, uaccess, stats,
-     validate_dup, vmlinux, mcount, noinstr, backup;
+     validate_dup, vmlinux, mcount, noinstr, backup, sls;
 
 static const char * const check_usage[] = {
 	"objtool check [<options>] file.o",
@@ -45,6 +45,7 @@ const struct option check_options[] = {
 	OPT_BOOLEAN('l', "vmlinux", &vmlinux, "vmlinux.o validation"),
 	OPT_BOOLEAN('M', "mcount", &mcount, "generate __mcount_loc"),
 	OPT_BOOLEAN('B', "backup", &backup, "create .orig files before modification"),
+	OPT_BOOLEAN('S', "sls", &sls, "validate straight-line-speculation"),
 	OPT_END(),
 };
 
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2776,6 +2776,12 @@ static int validate_branch(struct objtoo
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
@@ -2819,6 +2825,14 @@ static int validate_branch(struct objtoo
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
--- a/tools/objtool/include/objtool/arch.h
+++ b/tools/objtool/include/objtool/arch.h
@@ -26,6 +26,7 @@ enum insn_type {
 	INSN_CLAC,
 	INSN_STD,
 	INSN_CLD,
+	INSN_TRAP,
 	INSN_OTHER,
 };
 
--- a/tools/objtool/include/objtool/builtin.h
+++ b/tools/objtool/include/objtool/builtin.h
@@ -9,7 +9,7 @@
 
 extern const struct option check_options[];
 extern bool no_fp, no_unreachable, retpoline, module, backtrace, uaccess, stats,
-            validate_dup, vmlinux, mcount, noinstr, backup;
+            validate_dup, vmlinux, mcount, noinstr, backup, sls;
 
 extern int cmd_parse_options(int argc, const char **argv, const char * const usage[]);
 


