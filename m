Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7FC1540922
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350061AbiFGSFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:05:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347964AbiFGSCn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:02:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB83910173A;
        Tue,  7 Jun 2022 10:47:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27C8FB82340;
        Tue,  7 Jun 2022 17:47:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FDA1C36B01;
        Tue,  7 Jun 2022 17:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624018;
        bh=k0V0CGh24QZpI6yNSYhiwQtHgkrRzv0OACgWzWYIktE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n/sutQSg1tAjTrBPOvZPM/VXnPd05/a/ejSEXoAuIhugEzAseY2dL7quTIZ24kS3c
         6aoZLVCR1+6paxaKdIWSX9wic6X2AeQgqFvSzAqiUY4i7gvW6jEJvLfn1o9pxhTXZZ
         26Fmlcg//LdQBDvb0gI6Hrcekjn3mTndcQlhZK9I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pierre Gondois <pierre.gondois@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 134/667] ACPI: CPPC: Assume no transition latency if no PCCT
Date:   Tue,  7 Jun 2022 18:56:39 +0200
Message-Id: <20220607164938.841664272@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 71b87c16f92d..ed1341030684 100644
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
@@ -1378,6 +1388,9 @@ EXPORT_SYMBOL_GPL(cppc_set_perf);
  * transition latency for performance change requests. The closest we have
  * is the timing information from the PCCT tables which provides the info
  * on the number and frequency of PCC commands the platform can handle.
+ *
+ * If desired_reg is in the SystemMemory or SystemIo ACPI address space,
+ * then assume there is no latency.
  */
 unsigned int cppc_get_transition_latency(int cpu_num)
 {
@@ -1403,7 +1416,9 @@ unsigned int cppc_get_transition_latency(int cpu_num)
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



