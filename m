Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70655595812
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 12:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234447AbiHPKXH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 06:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234439AbiHPKWu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 06:22:50 -0400
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706B774DE4
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 01:28:32 -0700 (PDT)
Received: from localhost.localdomain (1.general.cascardo.us.vpn [10.172.70.58])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 221ED402AE;
        Tue, 16 Aug 2022 08:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1660638510;
        bh=zoZc4wM6gYqksvqiasF2Owo7H3ZBJqONzW7n7y/TTYk=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=lrPnB9t06Xscwwvh2+WwCRmkNz7olZiizO2aAsjj+tnUvDQNBuqBjT0keCxO4OXQV
         riaeTgiBOW/fAwe5RcouDz55qC++lOpMLcycVrXmb0G1pX0khjy/BnBwbQ/PV2dCvy
         kQktvVSHfFogGCeltZVAJOLtgzIlZjzTgPoUeBQPAkSxdwxUv4HrJAG2TMyrzhP6qR
         40LS+DEJy3oyxWoW8SmAFKIgnp2xesJedNL1eUXLe19obxR1KRCmsGd8l18F4EgUM0
         7imqTkiBIgM+Mvwl5VYokcCzOZo5mWFTvO9X3OQkSwmWv26xpguITzpTxpZdEdjUVo
         f0wToG8JEMXwA==
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     stable@vger.kernel.org
Cc:     paul.gortmaker@windriver.com, gregkh@linuxfoundation.org,
        peterz@infradead.org, bp@suse.de, jpoimboe@kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 3/3] x86/ftrace: Use alternative RET encoding
Date:   Tue, 16 Aug 2022 05:26:58 -0300
Message-Id: <20220816082658.172387-3-cascardo@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220816082658.172387-1-cascardo@canonical.com>
References: <20220816041224.GE73154@windriver.com>
 <20220816082658.172387-1-cascardo@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 1f001e9da6bbf482311e45e48f53c2bd2179e59c upstream.

Use the return thunk in ftrace trampolines, if needed.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
[cascardo: use memcpy(text_gen_insn) as there is no __text_gen_insn]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
---
 arch/x86/kernel/ftrace.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 8160d1dc6ed3..b3c9ef01d6c0 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -309,7 +309,7 @@ union ftrace_op_code_union {
 	} __attribute__((packed));
 };
 
-#define RET_SIZE		1 + IS_ENABLED(CONFIG_SLS)
+#define RET_SIZE		(IS_ENABLED(CONFIG_RETPOLINE) ? 5 : 1 + IS_ENABLED(CONFIG_SLS))
 
 static unsigned long
 create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
@@ -365,7 +365,12 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
 		goto fail;
 
 	ip = trampoline + size;
-	memcpy(ip, retq, RET_SIZE);
+
+	/* The trampoline ends with ret(q) */
+	if (cpu_feature_enabled(X86_FEATURE_RETHUNK))
+		memcpy(ip, text_gen_insn(JMP32_INSN_OPCODE, ip, &__x86_return_thunk), JMP32_INSN_SIZE);
+	else
+		memcpy(ip, retq, sizeof(retq));
 
 	/* No need to test direct calls on created trampolines */
 	if (ops->flags & FTRACE_OPS_FL_SAVE_REGS) {
-- 
2.34.1

