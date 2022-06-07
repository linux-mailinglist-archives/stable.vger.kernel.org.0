Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 340F1540552
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346175AbiFGRYV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346347AbiFGRXn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:23:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02EF210A639;
        Tue,  7 Jun 2022 10:21:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 931746009B;
        Tue,  7 Jun 2022 17:21:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B0FC385A5;
        Tue,  7 Jun 2022 17:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622517;
        bh=lnFWTkPmB85aDeslaT/hBp9DroN6KQakjVzon6SCK3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uVBLFLBaNNvTELkyYmhF7aJMb/Jo6Oq98CXq64QxPBIIYFL623fp1RjUBpQS1niQK
         fJohdb8/NpFd+fCAbWDCfADZkJ7b9VblYVhtGgIAjLMzCsc9/jO3jPtssaWVz0Yej6
         6gXxruNoNz2Wi57qeFjkDVG/upI/cCyCPkwNn9h0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ravi Bangoria <ravi.bangoria@amd.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 070/452] perf/amd/ibs: Cascade pmu init functions return value
Date:   Tue,  7 Jun 2022 18:58:47 +0200
Message-Id: <20220607164910.635944015@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
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
index ccc9ee1971e8..780d89d2ae32 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -764,9 +764,10 @@ static __init int perf_ibs_pmu_init(struct perf_ibs *perf_ibs, char *name)
 	return ret;
 }
 
-static __init void perf_event_ibs_init(void)
+static __init int perf_event_ibs_init(void)
 {
 	struct attribute **attr = ibs_op_format_attrs;
+	int ret;
 
 	/*
 	 * Some chips fail to reset the fetch count when it is written; instead
@@ -778,7 +779,9 @@ static __init void perf_event_ibs_init(void)
 	if (boot_cpu_data.x86 == 0x19 && boot_cpu_data.x86_model < 0x10)
 		perf_ibs_fetch.fetch_ignore_if_zero_rip = 1;
 
-	perf_ibs_pmu_init(&perf_ibs_fetch, "ibs_fetch");
+	ret = perf_ibs_pmu_init(&perf_ibs_fetch, "ibs_fetch");
+	if (ret)
+		return ret;
 
 	if (ibs_caps & IBS_CAPS_OPCNT) {
 		perf_ibs_op.config_mask |= IBS_OP_CNT_CTL;
@@ -791,15 +794,35 @@ static __init void perf_event_ibs_init(void)
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
 
@@ -1069,9 +1092,7 @@ static __init int amd_ibs_init(void)
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



