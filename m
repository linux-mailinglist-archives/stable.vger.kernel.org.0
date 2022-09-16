Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BBFE5BAA61
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbiIPKQY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiIPKPp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:15:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D44FABD4E;
        Fri, 16 Sep 2022 03:11:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDA4962A1E;
        Fri, 16 Sep 2022 10:10:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7FF7C433D6;
        Fri, 16 Sep 2022 10:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663323050;
        bh=QPkXlFw4jUEJ9tUV3f4T+hXWwDo9e77W1WXZOiXTxwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S4fXZS5KjDMdZ8ULlU+h3WTylwYpEcEzYiUSrdHvhdeLHfmfbDvHr9WDgksUwTCN2
         oXZBcJ7OvOQp9kb2byWCnfSXtO0bX2lfRpgFSfCCKtOBA/wbDnH+CHnQRM4uzwIXUA
         qkm/R21TntpGZo8/tgrh2ykip53HQW8nVLZE5iyc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.10 22/24] x86/ftrace: Use alternative RET encoding
Date:   Fri, 16 Sep 2022 12:08:47 +0200
Message-Id: <20220916100446.347142088@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100445.354452396@linuxfoundation.org>
References: <20220916100445.354452396@linuxfoundation.org>
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

commit 1f001e9da6bbf482311e45e48f53c2bd2179e59c upstream.

Use the return thunk in ftrace trampolines, if needed.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
[cascardo: use memcpy(text_gen_insn) as there is no __text_gen_insn]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/ftrace.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -309,7 +309,7 @@ union ftrace_op_code_union {
 	} __attribute__((packed));
 };
 
-#define RET_SIZE		1 + IS_ENABLED(CONFIG_SLS)
+#define RET_SIZE		(IS_ENABLED(CONFIG_RETPOLINE) ? 5 : 1 + IS_ENABLED(CONFIG_SLS))
 
 static unsigned long
 create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
@@ -365,7 +365,12 @@ create_trampoline(struct ftrace_ops *ops
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


