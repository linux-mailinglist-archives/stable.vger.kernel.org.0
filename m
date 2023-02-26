Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB016A31F7
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 16:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbjBZPMR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 10:12:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231789AbjBZPMC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 10:12:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C042597D;
        Sun, 26 Feb 2023 07:01:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 637A5B80BFF;
        Sun, 26 Feb 2023 14:50:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77653C433D2;
        Sun, 26 Feb 2023 14:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677423040;
        bh=hHjXwmYNWF17QFaj/TO411O6qn5XU1g5i5QGoO22UKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jeEmNktaIV3AqCuB666a14Y3V07BudAQ9HketCniPMoM446O+O4sS8XDTOZC4RpQQ
         VlMIQEYguzTnk54azDijH38qgTtldSJBdK9TcmbupKOudx+CIndDZxWfMSV720Y1eZ
         aKhBXklKrVVWumMXDTOhgaMG+wOU8ypTo/5uDH7y+htEtekopjGCP2I6v8g8fBbIs+
         bfPSDyoSG+xvl8jRkquiOzGM+2bs1nbpt4G953FDq/3LSJKTkNYjDrFdk5sGXbXWby
         FhAwOH0t6tmeeehgZpn3CdZ1fUb8osMQAKkrHaUu4CC1nuTINM+HiX+KdqyDsYxkdn
         T4p6SZD5LOL/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Breno Leitao <leitao@debian.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
        peterz@infradead.org, daniel.sneddon@linux.intel.com,
        sandipan.das@amd.com, nikunj@amd.com, jpoimboe@kernel.org,
        kim.phillips@amd.com, alexandre.chartre@oracle.com
Subject: [PATCH AUTOSEL 5.10 09/27] x86/bugs: Reset speculation control settings on init
Date:   Sun, 26 Feb 2023 09:49:56 -0500
Message-Id: <20230226145014.828855-9-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226145014.828855-1-sashal@kernel.org>
References: <20230226145014.828855-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
index 5a8ee3b83af2a..f71a177b6b185 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -54,6 +54,10 @@
 #define SPEC_CTRL_RRSBA_DIS_S_SHIFT	6	   /* Disable RRSBA behavior */
 #define SPEC_CTRL_RRSBA_DIS_S		BIT(SPEC_CTRL_RRSBA_DIS_S_SHIFT)
 
+/* A mask for bits which the kernel toggles when controlling mitigations */
+#define SPEC_CTRL_MITIGATIONS_MASK	(SPEC_CTRL_IBRS | SPEC_CTRL_STIBP | SPEC_CTRL_SSBD \
+							| SPEC_CTRL_RRSBA_DIS_S)
+
 #define MSR_IA32_PRED_CMD		0x00000049 /* Prediction Command */
 #define PRED_CMD_IBPB			BIT(0)	   /* Indirect Branch Prediction Barrier */
 
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index a2a087a797ae5..c5034986ea444 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -136,9 +136,17 @@ void __init check_bugs(void)
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
2.39.0

