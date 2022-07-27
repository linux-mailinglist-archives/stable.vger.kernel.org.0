Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF86A582F0C
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241832AbiG0RUZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242104AbiG0RTr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:19:47 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 671185247E;
        Wed, 27 Jul 2022 09:45:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 79AEECE2309;
        Wed, 27 Jul 2022 16:44:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C76EC433C1;
        Wed, 27 Jul 2022 16:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940296;
        bh=rOrmLFrxGWYV871MsyQQEIzigWMtnhgSC8ReLXbMgD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GSOjbKE3wU4s/4uEmDrTxwG3K8jSudBzGARySogdGE83epLpnYTM4cW/w/CAsa4/S
         EhhEIf5AtA1IQVcfZSgQhg9WwKFoMNT78yVlrWngb9i0vyZE8OjpB4tIkVUAhGMsxG
         FebxHdrvZct/f4a98IzvROwNZqEV/vIM0SRVhFdI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 143/201] x86/mce: Deduplicate exception handling
Date:   Wed, 27 Jul 2022 18:10:47 +0200
Message-Id: <20220727161033.735314528@linuxfoundation.org>
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

[ Upstream commit e42404afc4ca856c48f1e05752541faa3587c472 ]

Prepare code for further simplification. No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20210908132525.096452100@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mce/core.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 848cfb013f58..d8da3acf1ffd 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -382,13 +382,16 @@ static int msr_to_offset(u32 msr)
 	return -1;
 }
 
-__visible bool ex_handler_rdmsr_fault(const struct exception_table_entry *fixup,
-				      struct pt_regs *regs, int trapnr,
-				      unsigned long error_code,
-				      unsigned long fault_addr)
+static void ex_handler_msr_mce(struct pt_regs *regs, bool wrmsr)
 {
-	pr_emerg("MSR access error: RDMSR from 0x%x at rIP: 0x%lx (%pS)\n",
-		 (unsigned int)regs->cx, regs->ip, (void *)regs->ip);
+	if (wrmsr) {
+		pr_emerg("MSR access error: WRMSR to 0x%x (tried to write 0x%08x%08x) at rIP: 0x%lx (%pS)\n",
+			 (unsigned int)regs->cx, (unsigned int)regs->dx, (unsigned int)regs->ax,
+			 regs->ip, (void *)regs->ip);
+	} else {
+		pr_emerg("MSR access error: RDMSR from 0x%x at rIP: 0x%lx (%pS)\n",
+			 (unsigned int)regs->cx, regs->ip, (void *)regs->ip);
+	}
 
 	show_stack_regs(regs);
 
@@ -396,7 +399,14 @@ __visible bool ex_handler_rdmsr_fault(const struct exception_table_entry *fixup,
 
 	while (true)
 		cpu_relax();
+}
 
+__visible bool ex_handler_rdmsr_fault(const struct exception_table_entry *fixup,
+				      struct pt_regs *regs, int trapnr,
+				      unsigned long error_code,
+				      unsigned long fault_addr)
+{
+	ex_handler_msr_mce(regs, false);
 	return true;
 }
 
@@ -441,17 +451,7 @@ __visible bool ex_handler_wrmsr_fault(const struct exception_table_entry *fixup,
 				      unsigned long error_code,
 				      unsigned long fault_addr)
 {
-	pr_emerg("MSR access error: WRMSR to 0x%x (tried to write 0x%08x%08x) at rIP: 0x%lx (%pS)\n",
-		 (unsigned int)regs->cx, (unsigned int)regs->dx, (unsigned int)regs->ax,
-		  regs->ip, (void *)regs->ip);
-
-	show_stack_regs(regs);
-
-	panic("MCA architectural violation!\n");
-
-	while (true)
-		cpu_relax();
-
+	ex_handler_msr_mce(regs, true);
 	return true;
 }
 
-- 
2.35.1



