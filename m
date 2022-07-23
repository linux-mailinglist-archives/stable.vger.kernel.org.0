Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2D357EDB4
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237962AbiGWKBQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:01:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237888AbiGWKAX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:00:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 197AE785B1;
        Sat, 23 Jul 2022 02:58:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5764C611BD;
        Sat, 23 Jul 2022 09:58:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 690C5C341C0;
        Sat, 23 Jul 2022 09:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570303;
        bh=b3T8UY6FZP2wcxf8N/fTReXZewBuYrszqPfDeP+Iw4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YKTx3NReB94/BFtQmE/WZ7MMImvZ48fBtQCmwNnd69Tzea9tbbHKU4zLw7t3QuP4/
         3fL/n6S8HHhkXu3N4KVy/kWv660iZlxthlp49c/GQohjNgxkrqXn78cIH1pWLsw9Ol
         5RLMqecUuwcaQOxDJgsl2or59OdaMTKWgweMCYSc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 039/148] objtool/x86: Ignore __x86_indirect_alt_* symbols
Date:   Sat, 23 Jul 2022 11:54:11 +0200
Message-Id: <20220723095235.268633228@linuxfoundation.org>
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

commit 31197d3a0f1caeb60fb01f6755e28347e4f44037 upstream.

Because the __x86_indirect_alt* symbols are just that, objtool will
try and validate them as regular symbols, instead of the alternative
replacements that they are.

This goes sideways for FRAME_POINTER=y builds; which generate a fair
amount of warnings.

Fixes: 9bc0bb50727c ("objtool/x86: Rewrite retpoline thunk calls")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/YNCgxwLBiK9wclYJ@hirez.programming.kicks-ass.net
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/lib/retpoline.S |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/x86/lib/retpoline.S
+++ b/arch/x86/lib/retpoline.S
@@ -58,12 +58,16 @@ SYM_FUNC_START_NOALIGN(__x86_indirect_al
 2:	.skip	5-(2b-1b), 0x90
 SYM_FUNC_END(__x86_indirect_alt_call_\reg)
 
+STACK_FRAME_NON_STANDARD(__x86_indirect_alt_call_\reg)
+
 SYM_FUNC_START_NOALIGN(__x86_indirect_alt_jmp_\reg)
 	ANNOTATE_RETPOLINE_SAFE
 1:	jmp	*%\reg
 2:	.skip	5-(2b-1b), 0x90
 SYM_FUNC_END(__x86_indirect_alt_jmp_\reg)
 
+STACK_FRAME_NON_STANDARD(__x86_indirect_alt_jmp_\reg)
+
 .endm
 
 /*


