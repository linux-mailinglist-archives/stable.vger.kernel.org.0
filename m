Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4EF4592472
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242526AbiHNQce (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242531AbiHNQam (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:30:42 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0006F2665;
        Sun, 14 Aug 2022 09:25:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 49381CE0B12;
        Sun, 14 Aug 2022 16:25:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3FE1C433C1;
        Sun, 14 Aug 2022 16:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660494316;
        bh=V+ENuY92A0wmHDlcl6RZEmcFDNBsdEAFSOMvhdQxeGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H8Z13GEKfe8Su1oM6tB4RZMeOLqCS0sYgQaAI5Ml77VQSMtv/mmiei+bd3oCPpt7A
         2HVX0xgR59nYIoOemteNFul8J0Sx3ELUgXtB3di93zTGJ7apbKmwtllKCYn7DXUpbD
         nGrWKljroiu2Q8FCviZyaL9aFIGVM7GXRUat2lzTWsyT8sxo+9CY1geJI1w+h8hp8T
         3dyjwQELH3LBKqAUsOVoPfBm5xFPA76ZA+qlkry6K8QBn9LaOg0UqQHjWQ9msxtV0j
         pULlhCAYLEPOW9/z+pcBPt2f0UVpjjAXj9bqpVK2wOrnylfyFSsImeeUCcWauT2vgo
         09Q1tT5VzCfLg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laurent Dufour <ldufour@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, corbet@lwn.net,
        akpm@linux-foundation.org, Jason@zx2c4.com, feng.tang@intel.com,
        ying.huang@intel.com, gpiccoli@igalia.com,
        mchehab+huawei@kernel.org, robh@kernel.org, jsavitz@redhat.com,
        nathanl@linux.ibm.com, haren@linux.ibm.com,
        linux-doc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.18 23/39] powerpc/pseries/mobility: set NMI watchdog factor during an LPM
Date:   Sun, 14 Aug 2022 12:23:12 -0400
Message-Id: <20220814162332.2396012-23-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814162332.2396012-1-sashal@kernel.org>
References: <20220814162332.2396012-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Dufour <ldufour@linux.ibm.com>

[ Upstream commit 118b1366930c8c833b8b36abef657f40d4e26610 ]

During an LPM, while the memory transfer is in progress on the arrival
side, some latencies are generated when accessing not yet transferred
pages on the arrival side. Thus, the NMI watchdog may be triggered too
frequently, which increases the risk to hit an NMI interrupt in a bad
place in the kernel, leading to a kernel panic.

Disabling the Hard Lockup Watchdog until the memory transfer could be a
too strong work around, some users would want this timeout to be
eventually triggered if the system is hanging even during an LPM.

Introduce a new sysctl variable nmi_watchdog_factor. It allows to apply
a factor to the NMI watchdog timeout during an LPM. Just before the CPUs
are stopped for the switchover sequence, the NMI watchdog timer is set
to watchdog_thresh + factor%

A value of 0 has no effect. The default value is 200, meaning that the
NMI watchdog is set to 30s during LPM (based on a 10s watchdog_thresh
value). Once the memory transfer is achieved, the factor is reset to 0.

Setting this value to a high number is like disabling the NMI watchdog
during an LPM.

Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220713154729.80789-5-ldufour@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/sysctl/kernel.rst | 12 ++++++
 arch/powerpc/platforms/pseries/mobility.c   | 43 +++++++++++++++++++++
 2 files changed, 55 insertions(+)

diff --git a/Documentation/admin-guide/sysctl/kernel.rst b/Documentation/admin-guide/sysctl/kernel.rst
index e9c18dabc552..fc9e6565ced0 100644
--- a/Documentation/admin-guide/sysctl/kernel.rst
+++ b/Documentation/admin-guide/sysctl/kernel.rst
@@ -592,6 +592,18 @@ to the guest kernel command line (see
 Documentation/admin-guide/kernel-parameters.rst).
 
 
+nmi_wd_lpm_factor (PPC only)
+============================
+
+Factor to apply to the NMI watchdog timeout (only when ``nmi_watchdog`` is
+set to 1). This factor represents the percentage added to
+``watchdog_thresh`` when calculating the NMI watchdog timeout during an
+LPM. The soft lockup timeout is not impacted.
+
+A value of 0 means no change. The default value is 200 meaning the NMI
+watchdog is set to 30s (based on ``watchdog_thresh`` equal to 10).
+
+
 numa_balancing
 ==============
 
diff --git a/arch/powerpc/platforms/pseries/mobility.c b/arch/powerpc/platforms/pseries/mobility.c
index 78f3f74c7056..cbe0989239bf 100644
--- a/arch/powerpc/platforms/pseries/mobility.c
+++ b/arch/powerpc/platforms/pseries/mobility.c
@@ -48,6 +48,39 @@ struct update_props_workarea {
 #define MIGRATION_SCOPE	(1)
 #define PRRN_SCOPE -2
 
+#ifdef CONFIG_PPC_WATCHDOG
+static unsigned int nmi_wd_lpm_factor = 200;
+
+#ifdef CONFIG_SYSCTL
+static struct ctl_table nmi_wd_lpm_factor_ctl_table[] = {
+	{
+		.procname	= "nmi_wd_lpm_factor",
+		.data		= &nmi_wd_lpm_factor,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_douintvec_minmax,
+	},
+	{}
+};
+static struct ctl_table nmi_wd_lpm_factor_sysctl_root[] = {
+	{
+		.procname       = "kernel",
+		.mode           = 0555,
+		.child          = nmi_wd_lpm_factor_ctl_table,
+	},
+	{}
+};
+
+static int __init register_nmi_wd_lpm_factor_sysctl(void)
+{
+	register_sysctl_table(nmi_wd_lpm_factor_sysctl_root);
+
+	return 0;
+}
+device_initcall(register_nmi_wd_lpm_factor_sysctl);
+#endif /* CONFIG_SYSCTL */
+#endif /* CONFIG_PPC_WATCHDOG */
+
 static int mobility_rtas_call(int token, char *buf, s32 scope)
 {
 	int rc;
@@ -665,19 +698,29 @@ static int pseries_suspend(u64 handle)
 static int pseries_migrate_partition(u64 handle)
 {
 	int ret;
+	unsigned int factor = 0;
 
+#ifdef CONFIG_PPC_WATCHDOG
+	factor = nmi_wd_lpm_factor;
+#endif
 	ret = wait_for_vasi_session_suspending(handle);
 	if (ret)
 		return ret;
 
 	vas_migration_handler(VAS_SUSPEND);
 
+	if (factor)
+		watchdog_nmi_set_timeout_pct(factor);
+
 	ret = pseries_suspend(handle);
 	if (ret == 0)
 		post_mobility_fixup();
 	else
 		pseries_cancel_migration(handle, ret);
 
+	if (factor)
+		watchdog_nmi_set_timeout_pct(0);
+
 	vas_migration_handler(VAS_RESUME);
 
 	return ret;
-- 
2.35.1

