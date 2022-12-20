Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F35886524D7
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 17:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiLTQmH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 11:42:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbiLTQlq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 11:41:46 -0500
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D19A17A91
        for <stable@vger.kernel.org>; Tue, 20 Dec 2022 08:41:45 -0800 (PST)
Received: by mail-wr1-x449.google.com with SMTP id t23-20020adfa2d7000000b00269092d6f8dso186786wra.20
        for <stable@vger.kernel.org>; Tue, 20 Dec 2022 08:41:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OTNceY23AA38a0nnsKzPgPMXfy0S7X52/MJzcro4EXc=;
        b=MP6A5o/sswJ8AVbWgBG0Qiw5G/Sd/4XmeRK871/E+itWC425/UWTA+3yF6kdSm+y8V
         CVIMwkHnWvHBP02oJEBGOusy/IimIHMH20oQcvGdaucSMpckrK/S1d18048ion+N8iMa
         0L94kAXC18YKiQ1kbAkxVDSUlL5i+GLOmkR3U5kBpqz5wgDaVzfdvX74/Ev+/FSQ3+fu
         AS8gSxVy1gYemsu0YepZKSSWc2l4dQOL0XoIdA5XUnCT9xGssF2Oq5ETLvKC66AkYE1d
         jH9zjD39wPvfcrfb2JO6psmcYWc150l8BXEMxmIKSKdyi65HIhm1CSan7e6Uto3SlRhH
         ZwrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OTNceY23AA38a0nnsKzPgPMXfy0S7X52/MJzcro4EXc=;
        b=lNG0jic7BP4di2gfwpOSAZtp37xIYI9pQLY2avFDU3XZ4sU8KUw6pULv7ITfaGl6Ky
         cR3/owsFbkYqxqSAM1QGINXGELfg0ZLjS2VE9r4agaBzqldJBc5XEoqQv7zAUHSRAWsl
         c9DYaPZY2UxTZ/G2azSy2CG1DODuBLMFu4vtl+wtnJCt62GN5UxUwAlAVshzEDaLp7AW
         Nmu1UUAMpUTjT0ed1pae8HmBX8VSO/B6U1k8PKy9870BL1PHx3agBsHM0EeONKg/dmmp
         HbTqieNGuLdDuczsk8YaHpAf4vdXOIWXUUt+7qVrmet0GiIN8IqvIUNl5+nHeC/RIIxW
         yVxQ==
X-Gm-Message-State: AFqh2krXJ4tgwpbQdi/PTlQvzWYIRvvmy5gfkcw9AgAkrWihneRDyL+k
        y3pb765pbOPMSlyAwsLY3tw42eJqwoS044dZcA==
X-Google-Smtp-Source: AMrXdXvB8Wyf6pcwsq4X1oo8PHLh1LbYA/KH4Cza2WstD2/dEP9f3qpqfFFvchaiblUbVod5g44Xm8QTQAoeh6nTrQ==
X-Received: from peternewman10.zrh.corp.google.com ([2a00:79e0:9d:6:8175:5362:6754:c66d])
 (user=peternewman job=sendgmr) by 2002:a05:600c:3553:b0:3cf:6f23:a3e3 with
 SMTP id i19-20020a05600c355300b003cf6f23a3e3mr56813wmq.1.1671554503082; Tue,
 20 Dec 2022 08:41:43 -0800 (PST)
Date:   Tue, 20 Dec 2022 17:41:31 +0100
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221220164132.443083-1-peternewman@google.com>
Subject: [PATCH v3 1/2] x86/resctrl: Fix event counts regression in reused RMIDs
From:   Peter Newman <peternewman@google.com>
To:     reinette.chatre@intel.com, fenghua.yu@intel.com
Cc:     Babu.Moger@amd.com, bp@alien8.de, dave.hansen@linux.intel.com,
        eranian@google.com, hpa@zytor.com, james.morse@arm.com,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        quic_jiles@quicinc.com, tan.shaopeng@fujitsu.com,
        tglx@linutronix.de, x86@kernel.org,
        Peter Newman <peternewman@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Cc: stable@vger.kernel.org
---
v3:
 - add changelog
 - CC stable
v2:
 - move error bit processing into __rmid_read()

v1: https://lore.kernel.org/lkml/20221207112924.3602960-1-peternewman@google.com/
v2: https://lore.kernel.org/lkml/20221214160856.2164207-1-peternewman@google.com/
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

base-commit: 830b3c68c1fb1e9176028d02ef86f3cf76aa2476
-- 
2.39.0.314.g84b9a713c41-goog

