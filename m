Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA9D4582F16
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241813AbiG0RUm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242133AbiG0RTu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:19:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D99F5244F;
        Wed, 27 Jul 2022 09:45:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E94860D3B;
        Wed, 27 Jul 2022 16:45:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D4AC433C1;
        Wed, 27 Jul 2022 16:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940302;
        bh=gKdiTShjdV4qFP0ikFKCW4jh3SAdJPkniJlckYo/GPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vLXBbmnupgUSEeMSOFFFELWDmipgUZwxBe0ej3kvBczLa/7PcyDMMOf0QozCE7L/K
         XWfs7glOCjFvuLgKMJ4wixQQspL5vEnIcfKp1UODcbLAY2Ax74nDhilFIlWi4NqKuy
         lUwdaIC7L/cvJvUsNWi5POkx8RAYSylSPaHEHcnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 145/201] x86/extable: Provide EX_TYPE_DEFAULT_MCE_SAFE and EX_TYPE_FAULT_MCE_SAFE
Date:   Wed, 27 Jul 2022 18:10:49 +0200
Message-Id: <20220727161033.823638585@linuxfoundation.org>
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

[ Upstream commit 2cadf5248b9316d3c8af876e795d61c55476f6e9 ]

Provide exception fixup types which can be used to identify fixups which
allow in kernel #MC recovery and make them invoke the existing handlers.

These will be used at places where #MC recovery is handled correctly by the
caller.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20210908132525.269689153@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/extable_fixup_types.h | 3 +++
 arch/x86/kernel/cpu/mce/severity.c         | 2 ++
 arch/x86/mm/extable.c                      | 2 ++
 3 files changed, 7 insertions(+)

diff --git a/arch/x86/include/asm/extable_fixup_types.h b/arch/x86/include/asm/extable_fixup_types.h
index 0adc117618e6..409524d5d2eb 100644
--- a/arch/x86/include/asm/extable_fixup_types.h
+++ b/arch/x86/include/asm/extable_fixup_types.h
@@ -16,4 +16,7 @@
 #define	EX_TYPE_WRMSR_IN_MCE		10
 #define	EX_TYPE_RDMSR_IN_MCE		11
 
+#define	EX_TYPE_DEFAULT_MCE_SAFE	12
+#define	EX_TYPE_FAULT_MCE_SAFE		13
+
 #endif
diff --git a/arch/x86/kernel/cpu/mce/severity.c b/arch/x86/kernel/cpu/mce/severity.c
index 74fe763bffda..d9b77a74f8d2 100644
--- a/arch/x86/kernel/cpu/mce/severity.c
+++ b/arch/x86/kernel/cpu/mce/severity.c
@@ -278,6 +278,8 @@ static int error_context(struct mce *m, struct pt_regs *regs)
 		m->kflags |= MCE_IN_KERNEL_COPYIN;
 		fallthrough;
 	case EX_TYPE_FAULT:
+	case EX_TYPE_FAULT_MCE_SAFE:
+	case EX_TYPE_DEFAULT_MCE_SAFE:
 		m->kflags |= MCE_IN_KERNEL_RECOV;
 		return IN_KERNEL_RECOV;
 	default:
diff --git a/arch/x86/mm/extable.c b/arch/x86/mm/extable.c
index 5db46df409b5..f37e290e6d0a 100644
--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -131,8 +131,10 @@ int fixup_exception(struct pt_regs *regs, int trapnr, unsigned long error_code,
 
 	switch (e->type) {
 	case EX_TYPE_DEFAULT:
+	case EX_TYPE_DEFAULT_MCE_SAFE:
 		return ex_handler_default(e, regs);
 	case EX_TYPE_FAULT:
+	case EX_TYPE_FAULT_MCE_SAFE:
 		return ex_handler_fault(e, regs, trapnr);
 	case EX_TYPE_UACCESS:
 		return ex_handler_uaccess(e, regs, trapnr);
-- 
2.35.1



