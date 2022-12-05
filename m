Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84F7C6431F9
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233802AbiLETWr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:22:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234092AbiLETW0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:22:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E3552717E
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:18:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 627A961321
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:18:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74178C433C1;
        Mon,  5 Dec 2022 19:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670267880;
        bh=Mrix7/j/6eZQwvME9Qds8VSsuJdCk4YMlc8YOXlucHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BbU2oFp1j36m7j23Qb5wkQp/+YJEhZQDiU4jfJT80Xm9xJyxmklvSqMhbJIvL3Ujz
         8zeezTsUTjWmjC1WxCyuqn9DUD3h27MFQqSLYZFinLSGXazLU5bdvk+85Quh4a7EkG
         0JEwtpw+nWBGm8nvBWjylGCTfyLhaaCapxRey/lE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andrew Cooper <andrew.cooper3@citrix.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, stable@kernel.org
Subject: [PATCH 4.14 72/77] x86/tsx: Add a feature bit for TSX control MSR support
Date:   Mon,  5 Dec 2022 20:10:03 +0100
Message-Id: <20221205190803.403192945@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190800.868551051@linuxfoundation.org>
References: <20221205190800.868551051@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit aaa65d17eec372c6a9756833f3964ba05b05ea14 upstream.

Support for the TSX control MSR is enumerated in MSR_IA32_ARCH_CAPABILITIES.
This is different from how other CPU features are enumerated i.e. via
CPUID. Currently, a call to tsx_ctrl_is_supported() is required for
enumerating the feature. In the absence of a feature bit for TSX control,
any code that relies on checking feature bits directly will not work.

In preparation for adding a feature bit check in MSR save/restore
during suspend/resume, set a new feature bit X86_FEATURE_TSX_CTRL when
MSR_IA32_TSX_CTRL is present.

  [ bp: Remove tsx_ctrl_is_supported()]

  [Pawan: Resolved conflicts in backport; Removed parts of commit message
          referring to removed function tsx_ctrl_is_supported()]

Suggested-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/de619764e1d98afbb7a5fa58424f1278ede37b45.1668539735.git.pawan.kumar.gupta@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpufeatures.h |    1 +
 arch/x86/kernel/cpu/tsx.c          |   33 ++++++++++++++-------------------
 2 files changed, 15 insertions(+), 19 deletions(-)

--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -292,6 +292,7 @@
 #define X86_FEATURE_RETPOLINE		(11*32+12) /* "" Generic Retpoline mitigation for Spectre variant 2 */
 #define X86_FEATURE_RETPOLINE_LFENCE	(11*32+13) /* "" Use LFENCE for Spectre variant 2 */
 #define X86_FEATURE_RSB_VMEXIT_LITE	(11*32+17) /* "" Fill RSB on VM exit when EIBRS is enabled */
+#define X86_FEATURE_MSR_TSX_CTRL	(11*32+18) /* "" MSR IA32_TSX_CTRL (Intel) implemented */
 
 /* AMD-defined CPU features, CPUID level 0x80000008 (EBX), word 13 */
 #define X86_FEATURE_CLZERO		(13*32+ 0) /* CLZERO instruction */
--- a/arch/x86/kernel/cpu/tsx.c
+++ b/arch/x86/kernel/cpu/tsx.c
@@ -55,24 +55,6 @@ void tsx_enable(void)
 	wrmsrl(MSR_IA32_TSX_CTRL, tsx);
 }
 
-static bool __init tsx_ctrl_is_supported(void)
-{
-	u64 ia32_cap = x86_read_arch_cap_msr();
-
-	/*
-	 * TSX is controlled via MSR_IA32_TSX_CTRL.  However, support for this
-	 * MSR is enumerated by ARCH_CAP_TSX_MSR bit in MSR_IA32_ARCH_CAPABILITIES.
-	 *
-	 * TSX control (aka MSR_IA32_TSX_CTRL) is only available after a
-	 * microcode update on CPUs that have their MSR_IA32_ARCH_CAPABILITIES
-	 * bit MDS_NO=1. CPUs with MDS_NO=0 are not planned to get
-	 * MSR_IA32_TSX_CTRL support even after a microcode update. Thus,
-	 * tsx= cmdline requests will do nothing on CPUs without
-	 * MSR_IA32_TSX_CTRL support.
-	 */
-	return !!(ia32_cap & ARCH_CAP_TSX_CTRL_MSR);
-}
-
 static enum tsx_ctrl_states x86_get_tsx_auto_mode(void)
 {
 	if (boot_cpu_has_bug(X86_BUG_TAA))
@@ -86,9 +68,22 @@ void __init tsx_init(void)
 	char arg[5] = {};
 	int ret;
 
-	if (!tsx_ctrl_is_supported())
+	/*
+	 * TSX is controlled via MSR_IA32_TSX_CTRL.  However, support for this
+	 * MSR is enumerated by ARCH_CAP_TSX_MSR bit in MSR_IA32_ARCH_CAPABILITIES.
+	 *
+	 * TSX control (aka MSR_IA32_TSX_CTRL) is only available after a
+	 * microcode update on CPUs that have their MSR_IA32_ARCH_CAPABILITIES
+	 * bit MDS_NO=1. CPUs with MDS_NO=0 are not planned to get
+	 * MSR_IA32_TSX_CTRL support even after a microcode update. Thus,
+	 * tsx= cmdline requests will do nothing on CPUs without
+	 * MSR_IA32_TSX_CTRL support.
+	 */
+	if (!(x86_read_arch_cap_msr() & ARCH_CAP_TSX_CTRL_MSR))
 		return;
 
+	setup_force_cpu_cap(X86_FEATURE_MSR_TSX_CTRL);
+
 	ret = cmdline_find_option(boot_command_line, "tsx", arg, sizeof(arg));
 	if (ret >= 0) {
 		if (!strcmp(arg, "on")) {


