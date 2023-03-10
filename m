Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 675316B45D3
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232621AbjCJOhk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:37:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232655AbjCJOhi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:37:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C361204B6
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:37:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 068D9B822E3
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:37:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C2F4C433A0;
        Fri, 10 Mar 2023 14:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459025;
        bh=g1bKCxQu/pjEbppwzQRQCjx3Xpu9L29seE2/Rzfg6Ao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M23heoHcCM1mhSuKY6WxLtdUa1eVJuQAzYmmNioXQ1+kSm2QBMx+YVoLoFCfbNVB4
         UnEpny3asd/bJLrbWqYgJ+lf9DOem+AeAshXVZlF1fNoI5iiRhFllYWvKgrATLFhCS
         nLYb6etmSb1HWu9jDgr/fibZZNYapdOIJHLUvE7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Breno Leitao <leitao@debian.org>,
        "Borislav Petkov (AMD)" <bp@alien8.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 183/357] x86/bugs: Reset speculation control settings on init
Date:   Fri, 10 Mar 2023 14:37:52 +0100
Message-Id: <20230310133742.814665865@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 0125acda7d76b943ca55811df40ed6ec0ecf670f ]

Currently, x86_spec_ctrl_base is read at boot time and speculative bits
are set if Kconfig items are enabled. For example, IBRS is enabled if
CONFIG_CPU_IBRS_ENTRY is configured, etc. These MSR bits are not cleared
if the mitigations are disabled.

This is a problem when kexec-ing a kernel that has the mitigation
disabled from a kernel that has the mitigation enabled. In this case,
the MSR bits are not cleared during the new kernel boot. As a result,
this might have some performance degradation that is hard to pinpoint.

This problem does not happen if the machine is (hard) rebooted because
the bit will be cleared by default.

  [ bp: Massage. ]

Suggested-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20221128153148.1129350-1-leitao@debian.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/msr-index.h |  4 ++++
 arch/x86/kernel/cpu/bugs.c       | 10 +++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 7fa0b213b0079..67d43645a2b6b 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -50,6 +50,10 @@
 #define SPEC_CTRL_RRSBA_DIS_S_SHIFT	6	   /* Disable RRSBA behavior */
 #define SPEC_CTRL_RRSBA_DIS_S		BIT(SPEC_CTRL_RRSBA_DIS_S_SHIFT)
 
+/* A mask for bits which the kernel toggles when controlling mitigations */
+#define SPEC_CTRL_MITIGATIONS_MASK	(SPEC_CTRL_IBRS | SPEC_CTRL_STIBP | SPEC_CTRL_SSBD \
+							| SPEC_CTRL_RRSBA_DIS_S)
+
 #define MSR_IA32_PRED_CMD		0x00000049 /* Prediction Command */
 #define PRED_CMD_IBPB			BIT(0)	   /* Indirect Branch Prediction Barrier */
 
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 8dca326a9e78a..ab5e91700ab7d 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -135,9 +135,17 @@ void __init check_bugs(void)
 	 * have unknown values. AMD64_LS_CFG MSR is cached in the early AMD
 	 * init code as it is not enumerated and depends on the family.
 	 */
-	if (boot_cpu_has(X86_FEATURE_MSR_SPEC_CTRL))
+	if (cpu_feature_enabled(X86_FEATURE_MSR_SPEC_CTRL)) {
 		rdmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
 
+		/*
+		 * Previously running kernel (kexec), may have some controls
+		 * turned ON. Clear them and let the mitigations setup below
+		 * rediscover them based on configuration.
+		 */
+		x86_spec_ctrl_base &= ~SPEC_CTRL_MITIGATIONS_MASK;
+	}
+
 	/* Select the proper CPU mitigations before patching alternatives: */
 	spectre_v1_select_mitigation();
 	spectre_v2_select_mitigation();
-- 
2.39.2



