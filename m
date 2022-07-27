Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 117D8582EEE
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbiG0RTw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242019AbiG0RTf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:19:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F295C9C1;
        Wed, 27 Jul 2022 09:44:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0301461479;
        Wed, 27 Jul 2022 16:44:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1322FC433B5;
        Wed, 27 Jul 2022 16:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940291;
        bh=LaAiy6oA8wRBDndG/jd576RVds9v/VmyZte9tl5TmaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JU8227mjhqPSOSgldRhf8+wRZGMTlCCvztAPqhh7Qnme6FzHt4P6QJFzPo4W48Ci+
         6B5+l0f0YHgbYCGSp5j9Lk1dBzm+AO7GW2+uIRZVI/Uuhr50Xw7TaRiG+ZYvuqAW3u
         jqCPu2Vh4eEi3EnWqviEVGgoL3kcqx4BIvy79EyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 141/201] x86/extable: Tidy up redundant handler functions
Date:   Wed, 27 Jul 2022 18:10:45 +0200
Message-Id: <20220727161033.656172234@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 326b567f82df0c4c8f50092b9af9a3014616fb3c ]

No need to have the same code all over the place.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20210908132524.963232825@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/extable.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/x86/mm/extable.c b/arch/x86/mm/extable.c
index e1664e9f969c..d9a1046f3a98 100644
--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -39,9 +39,8 @@ __visible bool ex_handler_fault(const struct exception_table_entry *fixup,
 				unsigned long error_code,
 				unsigned long fault_addr)
 {
-	regs->ip = ex_fixup_addr(fixup);
 	regs->ax = trapnr;
-	return true;
+	return ex_handler_default(fixup, regs, trapnr, error_code, fault_addr);
 }
 EXPORT_SYMBOL_GPL(ex_handler_fault);
 
@@ -76,8 +75,7 @@ __visible bool ex_handler_uaccess(const struct exception_table_entry *fixup,
 				  unsigned long fault_addr)
 {
 	WARN_ONCE(trapnr == X86_TRAP_GP, "General protection fault in user access. Non-canonical address?");
-	regs->ip = ex_fixup_addr(fixup);
-	return true;
+	return ex_handler_default(fixup, regs, trapnr, error_code, fault_addr);
 }
 EXPORT_SYMBOL(ex_handler_uaccess);
 
@@ -87,9 +85,7 @@ __visible bool ex_handler_copy(const struct exception_table_entry *fixup,
 			       unsigned long fault_addr)
 {
 	WARN_ONCE(trapnr == X86_TRAP_GP, "General protection fault in user access. Non-canonical address?");
-	regs->ip = ex_fixup_addr(fixup);
-	regs->ax = trapnr;
-	return true;
+	return ex_handler_fault(fixup, regs, trapnr, error_code, fault_addr);
 }
 EXPORT_SYMBOL(ex_handler_copy);
 
@@ -103,10 +99,9 @@ __visible bool ex_handler_rdmsr_unsafe(const struct exception_table_entry *fixup
 		show_stack_regs(regs);
 
 	/* Pretend that the read succeeded and returned 0. */
-	regs->ip = ex_fixup_addr(fixup);
 	regs->ax = 0;
 	regs->dx = 0;
-	return true;
+	return ex_handler_default(fixup, regs, trapnr, error_code, fault_addr);
 }
 EXPORT_SYMBOL(ex_handler_rdmsr_unsafe);
 
@@ -121,8 +116,7 @@ __visible bool ex_handler_wrmsr_unsafe(const struct exception_table_entry *fixup
 		show_stack_regs(regs);
 
 	/* Pretend that the write succeeded. */
-	regs->ip = ex_fixup_addr(fixup);
-	return true;
+	return ex_handler_default(fixup, regs, trapnr, error_code, fault_addr);
 }
 EXPORT_SYMBOL(ex_handler_wrmsr_unsafe);
 
-- 
2.35.1



