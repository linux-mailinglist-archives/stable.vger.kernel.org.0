Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 104576309DD
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 03:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235279AbiKSCUT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 21:20:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235360AbiKSCTs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 21:19:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EEDBBDEF0;
        Fri, 18 Nov 2022 18:14:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 800E56283C;
        Sat, 19 Nov 2022 02:14:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8794EC43470;
        Sat, 19 Nov 2022 02:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668824054;
        bh=N08XjpGNW/3yiI7SIR93MZnAjQYYU/4B7wmQxljEUkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kjXcurfx3vtlgq0dFI1S8qc7qCrWMSF5gXIFDFTJclupTVN2Nqn4R9jpjRQgwxHYW
         4koDJap9GZ08Qiw+w5JqnbfteVeebWc3YoSqSinn83/S2nRhOni28874zbpaLgGfRv
         2Zy5w/4Urn5V3RGadTKn0pcS5it0jr6JKT3aMSJ/hklco5aOZn4FQm32uoWU1wG2vx
         64+ttlzZowD86wEoBP/lsmFvU2wWqBbGDJ09IQ6HBJTbf6Uul1U42lgeJMtKe/eGZU
         qvkc7YDFPeni7nhKJ/KjHiLXbsYvW9Xz/NJVsOVT9/LHW1dh5yTlCgKFkC8tIw49cf
         hM8uvP5Z+mDaA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>,
        kys@microsoft.com, haiyangz@microsoft.com, decui@microsoft.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org,
        linux-hyperv@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 10/27] x86/hyperv: fix invalid writes to MSRs during root partition kexec
Date:   Fri, 18 Nov 2022 21:13:35 -0500
Message-Id: <20221119021352.1774592-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221119021352.1774592-1-sashal@kernel.org>
References: <20221119021352.1774592-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anirudh Rayabharam <anrayabh@linux.microsoft.com>

[ Upstream commit 2982635a0b3d08d6fee2ff05632206286df0e703 ]

hyperv_cleanup resets the hypercall page by setting the MSR to 0. However,
the root partition is not allowed to write to the GPA bits of the MSR.
Instead, it uses the hypercall page provided by the MSR. Similar is the
case with the reference TSC MSR.

Clear only the enable bit instead of zeroing the entire MSR to make
the code valid for root partition too.

Signed-off-by: Anirudh Rayabharam <anrayabh@linux.microsoft.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/20221027095729.1676394-3-anrayabh@linux.microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/hyperv/hv_init.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
index b6d48ca5b0f1..f61f441b5382 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -470,6 +470,7 @@ void __init hyperv_init(void)
 void hyperv_cleanup(void)
 {
 	union hv_x64_msr_hypercall_contents hypercall_msr;
+	union hv_reference_tsc_msr tsc_msr;
 
 	unregister_syscore_ops(&hv_syscore_ops);
 
@@ -484,12 +485,14 @@ void hyperv_cleanup(void)
 	hv_hypercall_pg = NULL;
 
 	/* Reset the hypercall page */
-	hypercall_msr.as_uint64 = 0;
-	wrmsrl(HV_X64_MSR_HYPERCALL, hypercall_msr.as_uint64);
+	hypercall_msr.as_uint64 = hv_get_register(HV_X64_MSR_HYPERCALL);
+	hypercall_msr.enable = 0;
+	hv_set_register(HV_X64_MSR_HYPERCALL, hypercall_msr.as_uint64);
 
 	/* Reset the TSC page */
-	hypercall_msr.as_uint64 = 0;
-	wrmsrl(HV_X64_MSR_REFERENCE_TSC, hypercall_msr.as_uint64);
+	tsc_msr.as_uint64 = hv_get_register(HV_X64_MSR_REFERENCE_TSC);
+	tsc_msr.enable = 0;
+	hv_set_register(HV_X64_MSR_REFERENCE_TSC, tsc_msr.as_uint64);
 }
 
 void hyperv_report_panic(struct pt_regs *regs, long err, bool in_die)
-- 
2.35.1

