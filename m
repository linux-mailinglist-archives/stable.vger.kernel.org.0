Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E385D594C7A
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344351AbiHPBF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 21:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245543AbiHPBDx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 21:03:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC49B9FA6;
        Mon, 15 Aug 2022 13:50:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6FD560FC4;
        Mon, 15 Aug 2022 20:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96CFFC433C1;
        Mon, 15 Aug 2022 20:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596620;
        bh=7IaIZ4zaLvoKeOMBxaLtJMWadgo5fogwtZKLGA8pVfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B/ASc+n22QEf0YSW1m+dlI93UWDkEIjoxqpc6CJia19y4db1gWpbAd39FvaK4Qu08
         Qm1cBH/DgRuMb6A0O2jBxZU9QywrLRlzkj47xMXOEuxmC1OLroOC7eynLz0AxXlWyy
         HjGBhcFnu2+0G06VVcF5axLOJRRfjbBxO9FInik0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Ondrej Mosnacek <omosnacek@gmail.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.19 1137/1157] powerpc64/ftrace: Fix ftrace for clang builds
Date:   Mon, 15 Aug 2022 20:08:13 +0200
Message-Id: <20220815180525.929733456@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>

commit cb928ac192128c842f4c1cfc8b6780b95719d65f upstream.

Clang doesn't support -mprofile-kernel ABI, so guard the checks against
CONFIG_DYNAMIC_FTRACE_WITH_REGS, rather than the elf ABI version.

Fixes: 23b44fc248f4 ("powerpc/ftrace: Make __ftrace_make_{nop/call}() common to PPC32 and PPC64")
Cc: stable@vger.kernel.org # v5.19+
Reported-by: Nick Desaulniers <ndesaulniers@google.com>
Reported-by: Ondrej Mosnacek <omosnacek@gmail.com>
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Tested-by: Ondrej Mosnacek <omosnacek@gmail.com>
Acked-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://github.com/llvm/llvm-project/issues/57031
Link: https://github.com/ClangBuiltLinux/linux/issues/1682
Link: https://lore.kernel.org/r/20220809095907.418764-1-naveen.n.rao@linux.vnet.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/trace/ftrace.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/powerpc/kernel/trace/ftrace.c
+++ b/arch/powerpc/kernel/trace/ftrace.c
@@ -392,11 +392,11 @@ int ftrace_make_nop(struct module *mod,
  */
 static bool expected_nop_sequence(void *ip, ppc_inst_t op0, ppc_inst_t op1)
 {
-	if (IS_ENABLED(CONFIG_PPC64_ELF_ABI_V1))
+	if (IS_ENABLED(CONFIG_DYNAMIC_FTRACE_WITH_REGS))
+		return ppc_inst_equal(op0, ppc_inst(PPC_RAW_NOP()));
+	else
 		return ppc_inst_equal(op0, ppc_inst(PPC_RAW_BRANCH(8))) &&
 		       ppc_inst_equal(op1, ppc_inst(PPC_INST_LD_TOC));
-	else
-		return ppc_inst_equal(op0, ppc_inst(PPC_RAW_NOP()));
 }
 
 static int
@@ -411,7 +411,7 @@ __ftrace_make_call(struct dyn_ftrace *re
 	if (copy_inst_from_kernel_nofault(op, ip))
 		return -EFAULT;
 
-	if (IS_ENABLED(CONFIG_PPC64_ELF_ABI_V1) &&
+	if (!IS_ENABLED(CONFIG_DYNAMIC_FTRACE_WITH_REGS) &&
 	    copy_inst_from_kernel_nofault(op + 1, ip + 4))
 		return -EFAULT;
 


