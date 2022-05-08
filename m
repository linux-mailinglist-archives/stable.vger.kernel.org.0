Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74DF151EF89
	for <lists+stable@lfdr.de>; Sun,  8 May 2022 21:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235758AbiEHSGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 May 2022 14:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236041AbiEHQ62 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 May 2022 12:58:28 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6782EE018
        for <stable@vger.kernel.org>; Sun,  8 May 2022 09:54:37 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id qe3-20020a17090b4f8300b001dc24e4da73so10731287pjb.1
        for <stable@vger.kernel.org>; Sun, 08 May 2022 09:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kylehuey.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FaypoxjtFMSM2gt1fFhanoHs2x7WcJ7SqgxjCER5mjQ=;
        b=kL7AmVBf8sgfDvjYOeNUu6VJjUx+oMNBgyR14X6Fb2mpRzGN3ZfHUBw6Hywwtvcmz+
         DPCvpFCmab1w8m95OC3CLWlFSebfDM69tOXdxztFrK1uhwVHFRNcnD6emVF4BvLlUfio
         779EVkmb7xjwEuYKvB6siD7QhorK0Pac71nyGzBYD6nLU6GS63gV0Yid//uGG2oJWawt
         v54PeDueVhw0MtoaC4YWTVH6CZugwXwDFTW0xTrsC3fWdSNdQhOuxHDWkUlfu+1tsnXx
         9PD3VBrebTfuK5h7XOpikbtpB1eSyN896Auzu3+rCMCHEPOVEW3s6iPLOADJ3bnB1oxt
         WnpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FaypoxjtFMSM2gt1fFhanoHs2x7WcJ7SqgxjCER5mjQ=;
        b=tVWpWSoV+XP2PNF8xzW56tiX+iyC5wet/EhmC/rjd7YdnA4Vl12uF+yLWUST1FYJUn
         iVtGfI3V08r6jVxvuX1l8QEUl8zPd+T2Tk50K7ZTF1B7VsHcOqJ0EsaIt69z2yOKJ8sl
         xozbBUB5LWrMj/Sv8Y/QywhYw4YA9zacXbAEmOyGaDBJXUP0Y0nezU0pMywdzdMuvDf1
         gJ986x+YYzk6GE8m+zQ2HEuFX3//UZOF4Vel5ZARLM1v+HbDfDDJPGTjeZiIEsyN7E2I
         ftF7msHIzoxpeKDD2yGSyVvw3Y3HelwjVxEiCBRWWe029UXGDJDYPzGnyz5Fn8cJNVQH
         7ITQ==
X-Gm-Message-State: AOAM532PCym8Yi3D+XAOsPhT28P3u+JQPwfzNpDvocTO+FoHDmQ26T7i
        eCYutSav2g2vEi3lgFxqnDxi4eDDgszfV34x
X-Google-Smtp-Source: ABdhPJzxy35YNJDzBiw+i85/Vn8HdW2ttoMl53XOcXUSBUxihtIgI3O6QHXTRtIGzHdv0iku2IuILw==
X-Received: by 2002:a17:90b:1e49:b0:1dc:81d9:2d97 with SMTP id pi9-20020a17090b1e4900b001dc81d92d97mr22536299pjb.221.1652028876557;
        Sun, 08 May 2022 09:54:36 -0700 (PDT)
Received: from minbar.home.kylehuey.com (c-71-198-251-229.hsd1.ca.comcast.net. [71.198.251.229])
        by smtp.gmail.com with ESMTPSA id q27-20020a056a0002bb00b0050dc76281ebsm6838436pfs.197.2022.05.08.09.54.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 May 2022 09:54:35 -0700 (PDT)
From:   Kyle Huey <me@kylehuey.com>
X-Google-Original-From: Kyle Huey <khuey@kylehuey.com>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        Robert O'Callahan <robert@ocallahan.org>,
        Keno Fischer <keno@juliacomputing.com>,
        Kyle Huey <me@kylehuey.com>
Subject: [PATCH 5.4] KVM: x86/svm: Account for family 17h event renumberings in amd_pmc_perf_hw_id
Date:   Sun,  8 May 2022 09:54:34 -0700
Message-Id: <20220508165434.119000-1-khuey@kylehuey.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kyle Huey <me@kylehuey.com>

commit 5eb849322d7f7ae9d5c587c7bc3b4f7c6872cd2f upstream

Zen renumbered some of the performance counters that correspond to the
well known events in perf_hw_id. This code in KVM was never updated for
that, so guest that attempt to use counters on Zen that correspond to the
pre-Zen perf_hw_id values will silently receive the wrong values.

This has been observed in the wild with rr[0] when running in Zen 3
guests. rr uses the retired conditional branch counter 00d1 which is
incorrectly recognized by KVM as PERF_COUNT_HW_STALLED_CYCLES_BACKEND.

[0] https://rr-project.org/

Signed-off-by: Kyle Huey <me@kylehuey.com>
Message-Id: <20220503050136.86298-1-khuey@kylehuey.com>
Cc: stable@vger.kernel.org
[Check guest family, not host. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[Backport to 5.4: adjusted context]
Signed-off-by: Kyle Huey <me@kylehuey.com>
---
 arch/x86/kvm/pmu_amd.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/pmu_amd.c b/arch/x86/kvm/pmu_amd.c
index 6bc656abbe66..3ccfd1abcbad 100644
--- a/arch/x86/kvm/pmu_amd.c
+++ b/arch/x86/kvm/pmu_amd.c
@@ -44,6 +44,22 @@ static struct kvm_event_hw_type_mapping amd_event_mapping[] = {
 	[7] = { 0xd1, 0x00, PERF_COUNT_HW_STALLED_CYCLES_BACKEND },
 };
 
+/* duplicated from amd_f17h_perfmon_event_map. */
+static struct kvm_event_hw_type_mapping amd_f17h_event_mapping[] = {
+	[0] = { 0x76, 0x00, PERF_COUNT_HW_CPU_CYCLES },
+	[1] = { 0xc0, 0x00, PERF_COUNT_HW_INSTRUCTIONS },
+	[2] = { 0x60, 0xff, PERF_COUNT_HW_CACHE_REFERENCES },
+	[3] = { 0x64, 0x09, PERF_COUNT_HW_CACHE_MISSES },
+	[4] = { 0xc2, 0x00, PERF_COUNT_HW_BRANCH_INSTRUCTIONS },
+	[5] = { 0xc3, 0x00, PERF_COUNT_HW_BRANCH_MISSES },
+	[6] = { 0x87, 0x02, PERF_COUNT_HW_STALLED_CYCLES_FRONTEND },
+	[7] = { 0x87, 0x01, PERF_COUNT_HW_STALLED_CYCLES_BACKEND },
+};
+
+/* amd_pmc_perf_hw_id depends on these being the same size */
+static_assert(ARRAY_SIZE(amd_event_mapping) ==
+	     ARRAY_SIZE(amd_f17h_event_mapping));
+
 static unsigned int get_msr_base(struct kvm_pmu *pmu, enum pmu_type type)
 {
 	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
@@ -130,17 +146,23 @@ static unsigned amd_find_arch_event(struct kvm_pmu *pmu,
 				    u8 event_select,
 				    u8 unit_mask)
 {
+	struct kvm_event_hw_type_mapping *event_mapping;
 	int i;
 
+	if (guest_cpuid_family(pmc->vcpu) >= 0x17)
+		event_mapping = amd_f17h_event_mapping;
+	else
+		event_mapping = amd_event_mapping;
+
 	for (i = 0; i < ARRAY_SIZE(amd_event_mapping); i++)
-		if (amd_event_mapping[i].eventsel == event_select
-		    && amd_event_mapping[i].unit_mask == unit_mask)
+		if (event_mapping[i].eventsel == event_select
+		    && event_mapping[i].unit_mask == unit_mask)
 			break;
 
 	if (i == ARRAY_SIZE(amd_event_mapping))
 		return PERF_COUNT_HW_MAX;
 
-	return amd_event_mapping[i].event_type;
+	return event_mapping[i].event_type;
 }
 
 /* return PERF_COUNT_HW_MAX as AMD doesn't have fixed events */
-- 
2.36.0

