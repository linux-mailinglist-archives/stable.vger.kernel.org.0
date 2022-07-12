Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 344AF5722EF
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234025AbiGLSlz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233738AbiGLSl3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:41:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2690D31C2;
        Tue, 12 Jul 2022 11:41:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0EF8DB81BAC;
        Tue, 12 Jul 2022 18:41:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FCE6C3411C;
        Tue, 12 Jul 2022 18:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651264;
        bh=U0FSku5Q4Vl2EtM25WEcra7RlQWFvp8fSemwdMB1/5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VMgCZfPBbrcLUTSkdwNI/7godl2RENgOITHhLa1Ep1Wqmy1qRKKUnBLogK/ovDD7m
         7sMwjufTvVOSK+mjhRd/RE4ibA0iGBvmo+K3TD7cpvcUPmp4s2RUeOFk4u2O197qmf
         uRp8kfHtnwP/NOqkAegnZeUTIzwNFX+GG9he2CTo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 024/130] objtool: Handle per arch retpoline naming
Date:   Tue, 12 Jul 2022 20:37:50 +0200
Message-Id: <20220712183247.500066581@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220712183246.394947160@linuxfoundation.org>
References: <20220712183246.394947160@linuxfoundation.org>
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


