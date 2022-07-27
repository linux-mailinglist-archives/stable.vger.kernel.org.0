Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74310583104
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243040AbiG0RpP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243318AbiG0Rol (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:44:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E53B8C153;
        Wed, 27 Jul 2022 09:53:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F0DEB821D7;
        Wed, 27 Jul 2022 16:53:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53D6BC433C1;
        Wed, 27 Jul 2022 16:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940798;
        bh=hgedp9WsWU6gyxMX4x+e4LsYusxnvmMwzm2vb72HzhM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SraCPUtZDKSAFdA6sZ517BQ1RPSxQX5Qjt+X0yLA3bK3cIi55RFI1mA3Gb8a131bW
         o1vdOM7Qr69CssgpoxMZZu/eyto8lZWSH3A174dHBm3h+ZMaikmVoHThhwBnQfS0Yx
         WMGAlMnDqUACaCoEIdA8EKWnE9ZEUpl6dxY1QJWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.18 152/158] x86/amd: Use IBPB for firmware calls
Date:   Wed, 27 Jul 2022 18:13:36 +0200
Message-Id: <20220727161027.443092336@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
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
@@ -301,6 +301,7 @@
 #define X86_FEATURE_RETPOLINE_LFENCE	(11*32+13) /* "" Use LFENCE for Spectre variant 2 */
 #define X86_FEATURE_RETHUNK		(11*32+14) /* "" Use REturn THUNK */
 #define X86_FEATURE_UNRET		(11*32+15) /* "" AMD BTB untrain return */
+#define X86_FEATURE_USE_IBPB_FW		(11*32+16) /* "" Use IBPB during runtime firmware calls */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
 #define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* AVX VNNI instructions */
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -297,6 +297,8 @@ do {									\
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


