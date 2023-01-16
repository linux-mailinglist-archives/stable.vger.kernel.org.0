Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97F9E66C4C5
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbjAPP6L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:58:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbjAPP55 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:57:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4FD822782
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:57:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 708E761030
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:57:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C39C433EF;
        Mon, 16 Jan 2023 15:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884675;
        bh=/tp09Mprw1lIGcAX+snDZSpQYhuyWsel8eUaqvMOAwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OgRFQHvtUpabj/ciYaBC5/Jj3e0218Xbfu6zA8ccvmc3ov4jLckP/siMxyQB4lDvP
         mKMuFpTejIBJdgetqLUZip5MM8SaHN39hiKQPQexP+iLOOHiUHY7j/zdOQjAOs+L/l
         GwfuxWcD1cVnRZB7ohC5qBQyIhOBq0DLcbu8IODM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peter Newman <peternewman@google.com>,
        "Borislav Petkov (AMD)" <bp@alien8.de>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Babu Moger <babu.moger@amd.com>
Subject: [PATCH 6.1 096/183] x86/resctrl: Fix event counts regression in reused RMIDs
Date:   Mon, 16 Jan 2023 16:50:19 +0100
Message-Id: <20230116154807.457630188@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

From: Peter Newman <peternewman@google.com>

commit 2a81160d29d65b5876ab3f824fda99ae0219f05e upstream.

When creating a new monitoring group, the RMID allocated for it may have
been used by a group which was previously removed. In this case, the
hardware counters will have non-zero values which should be deducted
from what is reported in the new group's counts.

resctrl_arch_reset_rmid() initializes the prev_msr value for counters to
0, causing the initial count to be charged to the new group. Resurrect
__rmid_read() and use it to initialize prev_msr correctly.

Unlike before, __rmid_read() checks for error bits in the MSR read so
that callers don't need to.

Fixes: 1d81d15db39c ("x86/resctrl: Move mbm_overflow_count() into resctrl_arch_rmid_read()")
Signed-off-by: Peter Newman <peternewman@google.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Tested-by: Babu Moger <babu.moger@amd.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221220164132.443083-1-peternewman@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/resctrl/monitor.c | 49 ++++++++++++++++++---------
 1 file changed, 33 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index efe0c30d3a12..77538abeb72a 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -146,6 +146,30 @@ static inline struct rmid_entry *__rmid_entry(u32 rmid)
 	return entry;
 }
 
+static int __rmid_read(u32 rmid, enum resctrl_event_id eventid, u64 *val)
+{
+	u64 msr_val;
+
+	/*
+	 * As per the SDM, when IA32_QM_EVTSEL.EvtID (bits 7:0) is configured
+	 * with a valid event code for supported resource type and the bits
+	 * IA32_QM_EVTSEL.RMID (bits 41:32) are configured with valid RMID,
+	 * IA32_QM_CTR.data (bits 61:0) reports the monitored data.
+	 * IA32_QM_CTR.Error (bit 63) and IA32_QM_CTR.Unavailable (bit 62)
+	 * are error bits.
+	 */
+	wrmsr(MSR_IA32_QM_EVTSEL, eventid, rmid);
+	rdmsrl(MSR_IA32_QM_CTR, msr_val);
+
+	if (msr_val & RMID_VAL_ERROR)
+		return -EIO;
+	if (msr_val & RMID_VAL_UNAVAIL)
+		return -EINVAL;
+
+	*val = msr_val;
+	return 0;
+}
+
 static struct arch_mbm_state *get_arch_mbm_state(struct rdt_hw_domain *hw_dom,
 						 u32 rmid,
 						 enum resctrl_event_id eventid)
@@ -172,8 +196,12 @@ void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_domain *d,
 	struct arch_mbm_state *am;
 
 	am = get_arch_mbm_state(hw_dom, rmid, eventid);
-	if (am)
+	if (am) {
 		memset(am, 0, sizeof(*am));
+
+		/* Record any initial, non-zero count value. */
+		__rmid_read(rmid, eventid, &am->prev_msr);
+	}
 }
 
 static u64 mbm_overflow_count(u64 prev_msr, u64 cur_msr, unsigned int width)
@@ -191,25 +219,14 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain *d,
 	struct rdt_hw_domain *hw_dom = resctrl_to_arch_dom(d);
 	struct arch_mbm_state *am;
 	u64 msr_val, chunks;
+	int ret;
 
 	if (!cpumask_test_cpu(smp_processor_id(), &d->cpu_mask))
 		return -EINVAL;
 
-	/*
-	 * As per the SDM, when IA32_QM_EVTSEL.EvtID (bits 7:0) is configured
-	 * with a valid event code for supported resource type and the bits
-	 * IA32_QM_EVTSEL.RMID (bits 41:32) are configured with valid RMID,
-	 * IA32_QM_CTR.data (bits 61:0) reports the monitored data.
-	 * IA32_QM_CTR.Error (bit 63) and IA32_QM_CTR.Unavailable (bit 62)
-	 * are error bits.
-	 */
-	wrmsr(MSR_IA32_QM_EVTSEL, eventid, rmid);
-	rdmsrl(MSR_IA32_QM_CTR, msr_val);
-
-	if (msr_val & RMID_VAL_ERROR)
-		return -EIO;
-	if (msr_val & RMID_VAL_UNAVAIL)
-		return -EINVAL;
+	ret = __rmid_read(rmid, eventid, &msr_val);
+	if (ret)
+		return ret;
 
 	am = get_arch_mbm_state(hw_dom, rmid, eventid);
 	if (am) {
-- 
2.39.0



