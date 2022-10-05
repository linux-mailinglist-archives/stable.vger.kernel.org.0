Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56C385F539C
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 13:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbiJELhK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 07:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbiJELgo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 07:36:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE60C64F9;
        Wed,  5 Oct 2022 04:34:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 740CA6164C;
        Wed,  5 Oct 2022 11:34:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E76C433D6;
        Wed,  5 Oct 2022 11:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664969678;
        bh=IkNFUpN+oIlLLes/MvBToZUHdVJXZqhbvojCrc7rbHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vyAsjQCbO2zbLTEWYN8ynXGLIl4Rgfjb3qhJFxAA2adLr1PjHZtumERjKIGhBGGH+
         iMMDJtCubAbDjZBHOg2n9fDuKzfvQcjwwMtBQmwaPRzauy7EYMV2sPGmgWNNeNsiNK
         8NoMxawe9ClMbj0qW2FzMPPfRmb3TgqLVyi4zsT4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.4 18/51] x86/speculation: Change FILL_RETURN_BUFFER to work with objtool
Date:   Wed,  5 Oct 2022 13:32:06 +0200
Message-Id: <20221005113211.104615605@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221005113210.255710920@linuxfoundation.org>
References: <20221005113210.255710920@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

commit 089dd8e53126ebaf506e2dc0bf89d652c36bfc12 upstream.

Change FILL_RETURN_BUFFER so that objtool groks it and can generate
correct ORC unwind information.

 - Since ORC is alternative invariant; that is, all alternatives
   should have the same ORC entries, the __FILL_RETURN_BUFFER body
   can not be part of an alternative.

   Therefore, move it out of the alternative and keep the alternative
   as a sort of jump_label around it.

 - Use the ANNOTATE_INTRA_FUNCTION_CALL annotation to white-list
   these 'funny' call instructions to nowhere.

 - Use UNWIND_HINT_EMPTY to 'fill' the speculation traps, otherwise
   objtool will consider them unreachable.

 - Move the RSP adjustment into the loop, such that the loop has a
   deterministic stack layout.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Alexandre Chartre <alexandre.chartre@oracle.com>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lkml.kernel.org/r/20200428191700.032079304@infradead.org
[cascardo: fixup because of backport of ba6e31af2be96c4d0536f2152ed6f7b6c11bca47 ("x86/speculation: Add LFENCE to RSB fill sequence")]
[cascardo: no intra-function call validation support]
[cascardo: avoid UNWIND_HINT_EMPTY because of svm]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/nospec-branch.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -4,11 +4,13 @@
 #define _ASM_X86_NOSPEC_BRANCH_H_
 
 #include <linux/static_key.h>
+#include <linux/frame.h>
 
 #include <asm/alternative.h>
 #include <asm/alternative-asm.h>
 #include <asm/cpufeatures.h>
 #include <asm/msr-index.h>
+#include <asm/unwind_hints.h>
 
 /*
  * This should be used immediately before a retpoline alternative. It tells
@@ -60,9 +62,9 @@
 	lfence;					\
 	jmp	775b;				\
 774:						\
+	add	$(BITS_PER_LONG/8) * 2, sp;	\
 	dec	reg;				\
 	jnz	771b;				\
-	add	$(BITS_PER_LONG/8) * nr, sp;	\
 	/* barrier for jnz misprediction */	\
 	lfence;
 #else
@@ -154,10 +156,8 @@
   */
 .macro FILL_RETURN_BUFFER reg:req nr:req ftr:req
 #ifdef CONFIG_RETPOLINE
-	ANNOTATE_NOSPEC_ALTERNATIVE
-	ALTERNATIVE "jmp .Lskip_rsb_\@",				\
-		__stringify(__FILL_RETURN_BUFFER(\reg,\nr,%_ASM_SP))	\
-		\ftr
+	ALTERNATIVE "jmp .Lskip_rsb_\@", "", \ftr
+	__FILL_RETURN_BUFFER(\reg,\nr,%_ASM_SP)
 .Lskip_rsb_\@:
 #endif
 .endm


