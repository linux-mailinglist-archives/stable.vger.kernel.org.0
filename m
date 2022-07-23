Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A08B57ED8E
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 11:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237403AbiGWJ7Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 05:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237530AbiGWJ6l (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 05:58:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD5043F32F;
        Sat, 23 Jul 2022 02:57:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CB07611BF;
        Sat, 23 Jul 2022 09:57:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD52C341C0;
        Sat, 23 Jul 2022 09:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570252;
        bh=U0FSku5Q4Vl2EtM25WEcra7RlQWFvp8fSemwdMB1/5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YTOLFjfIhE/ggkQI0QKqeRgXR1mB2l38W2FKT3S7RLziKxO4d9zD6Js9adNGdYr6G
         Dxd8GqEiIEG7kWpCsOrcUNBEbNqlBMBR8OqGbnrlvPAA55IxX1ZHvy4YwyfwYOtHWs
         OFsRTZpgqEQuGi0gKttaW19RxWLVZF8Wt9igS+AI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 024/148] objtool: Handle per arch retpoline naming
Date:   Sat, 23 Jul 2022 11:53:56 +0200
Message-Id: <20220723095231.169139222@linuxfoundation.org>
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

commit 530b4ddd9dd92b263081f5c7786d39a8129c8b2d upstream.

The __x86_indirect_ naming is obviously not generic. Shorten to allow
matching some additional magic names later.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Link: https://lkml.kernel.org/r/20210326151259.630296706@infradead.org
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/arch.h            |    2 ++
 tools/objtool/arch/x86/decode.c |    5 +++++
 tools/objtool/check.c           |    9 +++++++--
 3 files changed, 14 insertions(+), 2 deletions(-)

--- a/tools/objtool/arch.h
+++ b/tools/objtool/arch.h
@@ -86,4 +86,6 @@ const char *arch_nop_insn(int len);
 
 int arch_decode_hint_reg(struct instruction *insn, u8 sp_reg);
 
+bool arch_is_retpoline(struct symbol *sym);
+
 #endif /* _ARCH_H */
--- a/tools/objtool/arch/x86/decode.c
+++ b/tools/objtool/arch/x86/decode.c
@@ -620,3 +620,8 @@ int arch_decode_hint_reg(struct instruct
 
 	return 0;
 }
+
+bool arch_is_retpoline(struct symbol *sym)
+{
+	return !strncmp(sym->name, "__x86_indirect_", 15);
+}
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -778,6 +778,11 @@ static int add_ignore_alternatives(struc
 	return 0;
 }
 
+__weak bool arch_is_retpoline(struct symbol *sym)
+{
+	return false;
+}
+
 /*
  * Find the destination instructions for all jumps.
  */
@@ -800,7 +805,7 @@ static int add_jump_destinations(struct
 		} else if (reloc->sym->type == STT_SECTION) {
 			dest_sec = reloc->sym->sec;
 			dest_off = arch_dest_reloc_offset(reloc->addend);
-		} else if (!strncmp(reloc->sym->name, "__x86_indirect_thunk_", 21)) {
+		} else if (arch_is_retpoline(reloc->sym)) {
 			/*
 			 * Retpoline jumps are really dynamic jumps in
 			 * disguise, so convert them accordingly.
@@ -954,7 +959,7 @@ static int add_call_destinations(struct
 				return -1;
 			}
 
-		} else if (!strncmp(reloc->sym->name, "__x86_indirect_thunk_", 21)) {
+		} else if (arch_is_retpoline(reloc->sym)) {
 			/*
 			 * Retpoline calls are really dynamic calls in
 			 * disguise, so convert them accordingly.


