Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7386E64EE
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbjDRMxl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232250AbjDRMxj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:53:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F6C16FBE
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:53:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE41F6344E
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:53:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2134C433D2;
        Tue, 18 Apr 2023 12:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822402;
        bh=L2qpSYZN89yg6JT/x90oJp6boUmemheD0VU0QcLFxgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dysTxIqqTqPwiicPjsE12T3q6vBHKBNA0q3FSENFIIEqokTnpSJhvPrJCj6or+/2r
         7yLp88ZjZVZpFNo8GXXriwaHycBIblum3VM/KCw8WnhgCXsB95MC0vTrbjCyp0zS2H
         Xnov6Fy9MgfSOvNMT707jKZJpS9/XK7fhp6KhX64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mathis Salmen <mathis.salmen@matsal.de>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.2 106/139] riscv: add icache flush for nommu sigreturn trampoline
Date:   Tue, 18 Apr 2023 14:22:51 +0200
Message-Id: <20230418120317.776104085@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathis Salmen <mathis.salmen@matsal.de>

commit 8d736482749f6d350892ef83a7a11d43cd49981e upstream.

In a NOMMU kernel, sigreturn trampolines are generated on the user
stack by setup_rt_frame. Currently, these trampolines are not instruction
fenced, thus their visibility to ifetch is not guaranteed.

This patch adds a flush_icache_range in setup_rt_frame to fix this
problem.

Signed-off-by: Mathis Salmen <mathis.salmen@matsal.de>
Fixes: 6bd33e1ece52 ("riscv: add nommu support")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230406101130.82304-1-mathis.salmen@matsal.de
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/signal.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/arch/riscv/kernel/signal.c
+++ b/arch/riscv/kernel/signal.c
@@ -19,6 +19,7 @@
 #include <asm/signal32.h>
 #include <asm/switch_to.h>
 #include <asm/csr.h>
+#include <asm/cacheflush.h>
 
 extern u32 __user_rt_sigreturn[2];
 
@@ -181,6 +182,7 @@ static int setup_rt_frame(struct ksignal
 {
 	struct rt_sigframe __user *frame;
 	long err = 0;
+	unsigned long __maybe_unused addr;
 
 	frame = get_sigframe(ksig, regs, sizeof(*frame));
 	if (!access_ok(frame, sizeof(*frame)))
@@ -209,7 +211,12 @@ static int setup_rt_frame(struct ksignal
 	if (copy_to_user(&frame->sigreturn_code, __user_rt_sigreturn,
 			 sizeof(frame->sigreturn_code)))
 		return -EFAULT;
-	regs->ra = (unsigned long)&frame->sigreturn_code;
+
+	addr = (unsigned long)&frame->sigreturn_code;
+	/* Make sure the two instructions are pushed to icache. */
+	flush_icache_range(addr, addr + sizeof(frame->sigreturn_code));
+
+	regs->ra = addr;
 #endif /* CONFIG_MMU */
 
 	/*


