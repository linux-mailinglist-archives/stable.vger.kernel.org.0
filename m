Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1F7537F01
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238531AbiE3Nyf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238803AbiE3Nxq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:53:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D4C8939FA;
        Mon, 30 May 2022 06:37:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 805F9B80D84;
        Mon, 30 May 2022 13:37:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36277C3411E;
        Mon, 30 May 2022 13:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917863;
        bh=dLL/mOAB4T3gsc0LMPrI/8vzxFAxEm2zNTvqPqGxrqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MpA5F3TCFsWnT4PU/KJnkL7JdwESpaee6DKSy6UPwmv+mvT6cwlQtHiY07m/fbKHw
         0cdis2Pw59EMZ75wbGQlcYg+QutRMSbNi6kqZACu1t+A8ho7+BYgOjeRfxN5yPRKsx
         SdcJHAdZM+iYZ3i/Cmwq3D2NjefV12NIgqUpInH86bvBPjeqBjgxP7CquG05iqCMvB
         15pbZYuYSm5Dgg2njIZh2zt00wYVCvnDnRJ9XdnSvDlwKES9Cxi7+1dCcK+j6Unk2b
         JVJpXd59QhQGs4IriDqpCXmLmYiXw/67sbvBr0YtRinrtTR+XPbvOf3sTcChzvS+j+
         VsAUuL92K95VQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre Gondois <Pierre.Gondois@arm.com>,
        Pierre Gondois <pierre.gondois@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 120/135] ACPI: CPPC: Assume no transition latency if no PCCT
Date:   Mon, 30 May 2022 09:31:18 -0400
Message-Id: <20220530133133.1931716-120-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133133.1931716-1-sashal@kernel.org>
References: <20220530133133.1931716-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre Gondois <Pierre.Gondois@arm.com>

[ Upstream commit 6380b7b2b29da9d9c5ab2d4a265901cd93ba3696 ]

The transition_delay_us (struct cpufreq_policy) is currently defined
as:
  Preferred average time interval between consecutive invocations of
  the driver to set the frequency for this policy.  To be set by the
  scaling driver (0, which is the default, means no preference).
The transition_latency represents the amount of time necessary for a
CPU to change its frequency.

A PCCT table advertises mutliple values:
- pcc_nominal: Expected latency to process a command, in microseconds
- pcc_mpar: The maximum number of periodic requests that the subspace
  channel can support, reported in commands per minute. 0 indicates no
  limitation.
- pcc_mrtt: The minimum amount of time that OSPM must wait after the
  completion of a command before issuing the next command,
  in microseconds.
cppc_get_transition_latency() allows to get the max of them.

commit d4f3388afd48 ("cpufreq / CPPC: Set platform specific
transition_delay_us") allows to select transition_delay_us based on
the platform, and fallbacks to cppc_get_transition_latency()
otherwise.

If _CPC objects are not using PCC channels (no PPCT table), the
transition_delay_us is set to CPUFREQ_ETERNAL, leading to really long
periods between frequency updates (~4s).

If the desired_reg, where performance requests are written, is in
SystemMemory or SystemIo ACPI address space, there is no delay
in requests. So return 0 instead of CPUFREQ_ETERNAL, leading to
transition_delay_us being set to LATENCY_MULTIPLIER us (1000 us).

This patch also adds two macros to check the address spaces.

Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/cppc_acpi.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
index 123e98a765de..a7facd4b4ca8 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -100,6 +100,16 @@ static DEFINE_PER_CPU(struct cpc_desc *, cpc_desc_ptr);
 				(cpc)->cpc_entry.reg.space_id ==	\
 				ACPI_ADR_SPACE_PLATFORM_COMM)
 
+/* Check if a CPC register is in SystemMemory */
+#define CPC_IN_SYSTEM_MEMORY(cpc) ((cpc)->type == ACPI_TYPE_BUFFER &&	\
+				(cpc)->cpc_entry.reg.space_id ==	\
+				ACPI_ADR_SPACE_SYSTEM_MEMORY)
+
+/* Check if a CPC register is in SystemIo */
+#define CPC_IN_SYSTEM_IO(cpc) ((cpc)->type == ACPI_TYPE_BUFFER &&	\
+				(cpc)->cpc_entry.reg.space_id ==	\
+				ACPI_ADR_SPACE_SYSTEM_IO)
+
 /* Evaluates to True if reg is a NULL register descriptor */
 #define IS_NULL_REG(reg) ((reg)->space_id ==  ACPI_ADR_SPACE_SYSTEM_MEMORY && \
 				(reg)->address == 0 &&			\
@@ -1441,6 +1451,9 @@ EXPORT_SYMBOL_GPL(cppc_set_perf);
  * transition latency for performance change requests. The closest we have
  * is the timing information from the PCCT tables which provides the info
  * on the number and frequency of PCC commands the platform can handle.
+ *
+ * If desired_reg is in the SystemMemory or SystemIo ACPI address space,
+ * then assume there is no latency.
  */
 unsigned int cppc_get_transition_latency(int cpu_num)
 {
@@ -1466,7 +1479,9 @@ unsigned int cppc_get_transition_latency(int cpu_num)
 		return CPUFREQ_ETERNAL;
 
 	desired_reg = &cpc_desc->cpc_regs[DESIRED_PERF];
-	if (!CPC_IN_PCC(desired_reg))
+	if (CPC_IN_SYSTEM_MEMORY(desired_reg) || CPC_IN_SYSTEM_IO(desired_reg))
+		return 0;
+	else if (!CPC_IN_PCC(desired_reg))
 		return CPUFREQ_ETERNAL;
 
 	if (pcc_ss_id < 0)
-- 
2.35.1

