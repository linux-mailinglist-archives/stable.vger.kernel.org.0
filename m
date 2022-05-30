Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF57537FA0
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238523AbiE3NwQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239262AbiE3NvZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:51:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC87C8214F;
        Mon, 30 May 2022 06:35:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DB74B80DAD;
        Mon, 30 May 2022 13:35:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEE20C3411C;
        Mon, 30 May 2022 13:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917738;
        bh=sbZJ/EgR/Q6h7bQ8bXYkdHk3sVPiz5d14IrGMh6M1ls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YPHQuukh3CcJ7/EF+LAtw64YoOqXZBodweexv9WU0N3JfHy3oZLavNo6dBdr+SBVU
         Hjz/RV8gwiT25wRHFSlOCbYBzwyntVBBpqfsnyiVYAApliODcgGbTQ4qAuwl20ETkV
         dKlU3tkK3s2Rt4uEA4nOQA9cY5QORQDtZx1ywOrV0xF//el8rl2A1Rpo3hFk6AQSvk
         ihtdWWBmmlR8tUu3gzYdPalUCxhc44FWItfDH45EZeHbvXFUsqH5K36a5n69iyzJTc
         mwd3kSHL3JS3kdBZMw0wGCp2XSHCKNsQVkjIN72SUFp5kWwN2yqvjyfiaThnVL/s4j
         OkjLYXf8pmqbQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ravi Bangoria <ravi.bangoria@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com,
        acme@kernel.org, tglx@linutronix.de, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org,
        linux-perf-users@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 080/135] perf/amd/ibs: Cascade pmu init functions' return value
Date:   Mon, 30 May 2022 09:30:38 -0400
Message-Id: <20220530133133.1931716-80-sashal@kernel.org>
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

From: Ravi Bangoria <ravi.bangoria@amd.com>

[ Upstream commit 39b2ca75eec8a33e2ffdb8aa0c4840ec3e3b472c ]

IBS pmu initialization code ignores return value provided by
callee functions. Fix it.

Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220509044914.1473-2-ravi.bangoria@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/amd/ibs.c | 37 +++++++++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index 9739019d4b67..367ca899e6e8 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -759,9 +759,10 @@ static __init int perf_ibs_pmu_init(struct perf_ibs *perf_ibs, char *name)
 	return ret;
 }
 
-static __init void perf_event_ibs_init(void)
+static __init int perf_event_ibs_init(void)
 {
 	struct attribute **attr = ibs_op_format_attrs;
+	int ret;
 
 	/*
 	 * Some chips fail to reset the fetch count when it is written; instead
@@ -773,7 +774,9 @@ static __init void perf_event_ibs_init(void)
 	if (boot_cpu_data.x86 == 0x19 && boot_cpu_data.x86_model < 0x10)
 		perf_ibs_fetch.fetch_ignore_if_zero_rip = 1;
 
-	perf_ibs_pmu_init(&perf_ibs_fetch, "ibs_fetch");
+	ret = perf_ibs_pmu_init(&perf_ibs_fetch, "ibs_fetch");
+	if (ret)
+		return ret;
 
 	if (ibs_caps & IBS_CAPS_OPCNT) {
 		perf_ibs_op.config_mask |= IBS_OP_CNT_CTL;
@@ -786,15 +789,35 @@ static __init void perf_event_ibs_init(void)
 		perf_ibs_op.cnt_mask    |= IBS_OP_MAX_CNT_EXT_MASK;
 	}
 
-	perf_ibs_pmu_init(&perf_ibs_op, "ibs_op");
+	ret = perf_ibs_pmu_init(&perf_ibs_op, "ibs_op");
+	if (ret)
+		goto err_op;
+
+	ret = register_nmi_handler(NMI_LOCAL, perf_ibs_nmi_handler, 0, "perf_ibs");
+	if (ret)
+		goto err_nmi;
 
-	register_nmi_handler(NMI_LOCAL, perf_ibs_nmi_handler, 0, "perf_ibs");
 	pr_info("perf: AMD IBS detected (0x%08x)\n", ibs_caps);
+	return 0;
+
+err_nmi:
+	perf_pmu_unregister(&perf_ibs_op.pmu);
+	free_percpu(perf_ibs_op.pcpu);
+	perf_ibs_op.pcpu = NULL;
+err_op:
+	perf_pmu_unregister(&perf_ibs_fetch.pmu);
+	free_percpu(perf_ibs_fetch.pcpu);
+	perf_ibs_fetch.pcpu = NULL;
+
+	return ret;
 }
 
 #else /* defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_AMD) */
 
-static __init void perf_event_ibs_init(void) { }
+static __init int perf_event_ibs_init(void)
+{
+	return 0;
+}
 
 #endif
 
@@ -1064,9 +1087,7 @@ static __init int amd_ibs_init(void)
 			  x86_pmu_amd_ibs_starting_cpu,
 			  x86_pmu_amd_ibs_dying_cpu);
 
-	perf_event_ibs_init();
-
-	return 0;
+	return perf_event_ibs_init();
 }
 
 /* Since we need the pci subsystem to init ibs we can't do this earlier: */
-- 
2.35.1

