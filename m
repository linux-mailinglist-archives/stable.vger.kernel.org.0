Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB14582F4C
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241930AbiG0RXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241718AbiG0RVt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:21:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61FE95F112;
        Wed, 27 Jul 2022 09:45:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BB87600BE;
        Wed, 27 Jul 2022 16:45:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E2AC433D6;
        Wed, 27 Jul 2022 16:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940325;
        bh=+uMl4FLl097Loyy9TApm/tAdFNX8flz7zh2/oIFqi54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xo9fmTFqLpx6WqxqinBPhjyK2EfaZdq0upewc9U4io8tEwnw4NsTO1xntMd2pZucx
         a3J+lOAVaCWLbMPg40F5Fyjs7y0CKH2wOXpZfYUCpCEkZakCp8dxMSK/1xWtNWILcz
         17JDwJjEe+4U9zKqiDtI1xWxbvGLIV/chBMdMh3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.15 185/201] x86/amd: Use IBPB for firmware calls
Date:   Wed, 27 Jul 2022 18:11:29 +0200
Message-Id: <20220727161035.433409425@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

commit 28a99e95f55c61855983d36a88c05c178d966bb7 upstream.

On AMD IBRS does not prevent Retbleed; as such use IBPB before a
firmware call to flush the branch history state.

And because in order to do an EFI call, the kernel maps a whole lot of
the kernel page table into the EFI page table, do an IBPB just in case
in order to prevent the scenario of poisoning the BTB and causing an EFI
call using the unprotected RET there.

  [ bp: Massage. ]

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20220715194550.793957-1-cascardo@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpufeatures.h   |    1 +
 arch/x86/include/asm/nospec-branch.h |    2 ++
 arch/x86/kernel/cpu/bugs.c           |   11 ++++++++++-
 3 files changed, 13 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -300,6 +300,7 @@
 #define X86_FEATURE_RETPOLINE_LFENCE	(11*32+13) /* "" Use LFENCE for Spectre variant 2 */
 #define X86_FEATURE_RETHUNK		(11*32+14) /* "" Use REturn THUNK */
 #define X86_FEATURE_UNRET		(11*32+15) /* "" AMD BTB untrain return */
+#define X86_FEATURE_USE_IBPB_FW		(11*32+16) /* "" Use IBPB during runtime firmware calls */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
 #define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* AVX VNNI instructions */
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -298,6 +298,8 @@ do {									\
 	alternative_msr_write(MSR_IA32_SPEC_CTRL,			\
 			      spec_ctrl_current() | SPEC_CTRL_IBRS,	\
 			      X86_FEATURE_USE_IBRS_FW);			\
+	alternative_msr_write(MSR_IA32_PRED_CMD, PRED_CMD_IBPB,		\
+			      X86_FEATURE_USE_IBPB_FW);			\
 } while (0)
 
 #define firmware_restrict_branch_speculation_end()			\
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1512,7 +1512,16 @@ static void __init spectre_v2_select_mit
 	 * the CPU supports Enhanced IBRS, kernel might un-intentionally not
 	 * enable IBRS around firmware calls.
 	 */
-	if (boot_cpu_has(X86_FEATURE_IBRS) && !spectre_v2_in_ibrs_mode(mode)) {
+	if (boot_cpu_has_bug(X86_BUG_RETBLEED) &&
+	    (boot_cpu_data.x86_vendor == X86_VENDOR_AMD ||
+	     boot_cpu_data.x86_vendor == X86_VENDOR_HYGON)) {
+
+		if (retbleed_cmd != RETBLEED_CMD_IBPB) {
+			setup_force_cpu_cap(X86_FEATURE_USE_IBPB_FW);
+			pr_info("Enabling Speculation Barrier for firmware calls\n");
+		}
+
+	} else if (boot_cpu_has(X86_FEATURE_IBRS) && !spectre_v2_in_ibrs_mode(mode)) {
 		setup_force_cpu_cap(X86_FEATURE_USE_IBRS_FW);
 		pr_info("Enabling Restricted Speculation for firmware calls\n");
 	}


