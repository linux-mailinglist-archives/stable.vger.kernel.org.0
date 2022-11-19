Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8C963095C
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 03:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232251AbiKSCNK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 21:13:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232415AbiKSCMQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 21:12:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D16CD74624;
        Fri, 18 Nov 2022 18:11:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C90CB8267A;
        Sat, 19 Nov 2022 02:11:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44F7C43145;
        Sat, 19 Nov 2022 02:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668823915;
        bh=89NZ+b2pH+skYaseszJKoCWnVZFggVGno7do8/hEutQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SCPzTOoDvp2ep+p3fdKl7nvdsSWZ07Vh4Ajh+pHqSR+eB0R/tV8KzpS1Qikoly6EC
         g0oedY6BSjWSC8NnmAtHVpgVEHmLWP4Fl3fqd2s3dMMg6iglb01aNdtzV1EhaAuhev
         OYiW/lP7bv8VLJ9VQKaOO7iNh9Kl1udLumWOTExa+aHVebPxW3r77f8CyDJHxuH0cc
         No0rBQ3MS3JwZDKeyhqsPpXoi5WphTOJYIOme6a2LxQ0gK/0bjzUe7XY9TMJWZ9P3U
         WyLZ6bSbiXygOJ+RpemmuzafQsMTPM50QpGFNdEbC7ulikws0S6zI4z0ehOvN1lx2l
         UxPMk47I3VvmQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>,
        kys@microsoft.com, haiyangz@microsoft.com, decui@microsoft.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org,
        linux-hyperv@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 14/44] x86/hyperv: fix invalid writes to MSRs during root partition kexec
Date:   Fri, 18 Nov 2022 21:10:54 -0500
Message-Id: <20221119021124.1773699-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221119021124.1773699-1-sashal@kernel.org>
References: <20221119021124.1773699-1-sashal@kernel.org>
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
index 3de6d8b53367..10186bd6d67e 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -537,6 +537,7 @@ void __init hyperv_init(void)
 void hyperv_cleanup(void)
 {
 	union hv_x64_msr_hypercall_contents hypercall_msr;
+	union hv_reference_tsc_msr tsc_msr;
 
 	unregister_syscore_ops(&hv_syscore_ops);
 
@@ -552,12 +553,14 @@ void hyperv_cleanup(void)
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

