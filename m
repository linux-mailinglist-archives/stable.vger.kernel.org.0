Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C71A659581A
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 12:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234449AbiHPKZF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 06:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234515AbiHPKYg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 06:24:36 -0400
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B2101156CB
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 01:27:56 -0700 (PDT)
Received: from localhost.localdomain (1.general.cascardo.us.vpn [10.172.70.58])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 139EC3F0DE;
        Tue, 16 Aug 2022 08:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1660638474;
        bh=R0STn02R0RG/5zJ0DKN7m6knvL8/kjNu8kjNo/IsvBI=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=fP47BSqLhOB3Se/tjAr10bFzT2hkGRkdvioVpV6iFL9+bh+cfedK/35W/gmk7wxSw
         W/SvV7hIwQW+np9t+wogUXiFfAHT6xKANAVm47+NrYwDi/HRXeqLYseRPImAX7UGd6
         /Q2j0jAN7u0ivBe10whIuLkjEnMfd5ARjqeZ+wfPCxJzat1RMs9YmX0d/H7cO5sdeM
         yx9EJW8sDva8uq8kjUOJlZqTuGAexoVD75H837+kP0zdfUYxIwgoWBIGN7CYqJmby7
         gZppk1GdYecoCWK+sX/WHxlGS+Fa5LN9gZzQA6oarmqoW1c2z4B5sx33AFBtGA73cF
         FkJVA0Vt+k+Rw==
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     stable@vger.kernel.org
Cc:     paul.gortmaker@windriver.com, gregkh@linuxfoundation.org,
        peterz@infradead.org, bp@suse.de, jpoimboe@kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 1/3] Revert "x86/ftrace: Use alternative RET encoding"
Date:   Tue, 16 Aug 2022 05:26:56 -0300
Message-Id: <20220816082658.172387-1-cascardo@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220816041224.GE73154@windriver.com>
References: <20220816041224.GE73154@windriver.com>
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

This reverts commit 3af2ebf798c52b20de827b9dfec13472ab4a7964.

This temporarily reverts the backport of upstream commit
1f001e9da6bbf482311e45e48f53c2bd2179e59c. It was not correct to copy the
ftrace stub as it would contain a relative jump to the return thunk which
would not apply to the context where it was being copied to, leading to
ftrace support to be broken.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
---
 arch/x86/kernel/ftrace.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index ceab28277546..5080f578236a 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -309,7 +309,7 @@ union ftrace_op_code_union {
 	} __attribute__((packed));
 };
 
-#define RET_SIZE		(IS_ENABLED(CONFIG_RETPOLINE) ? 5 : 1 + IS_ENABLED(CONFIG_SLS))
+#define RET_SIZE		1 + IS_ENABLED(CONFIG_SLS)
 
 static unsigned long
 create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
@@ -368,10 +368,7 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
 
 	/* The trampoline ends with ret(q) */
 	retq = (unsigned long)ftrace_stub;
-	if (cpu_feature_enabled(X86_FEATURE_RETHUNK))
-		memcpy(ip, text_gen_insn(JMP32_INSN_OPCODE, ip, &__x86_return_thunk), JMP32_INSN_SIZE);
-	else
-		ret = copy_from_kernel_nofault(ip, (void *)retq, RET_SIZE);
+	ret = copy_from_kernel_nofault(ip, (void *)retq, RET_SIZE);
 	if (WARN_ON(ret < 0))
 		goto fail;
 
-- 
2.34.1

