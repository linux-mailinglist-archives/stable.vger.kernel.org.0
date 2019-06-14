Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFFF845281
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 05:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbfFNDNU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 23:13:20 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45428 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfFNDNT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 23:13:19 -0400
Received: by mail-pg1-f195.google.com with SMTP id s21so656344pga.12
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 20:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=++nRQWY/k4E+AlroFqtDd4Bo37FS6L7rS4A4U1awWIw=;
        b=vjjNcN5lkAA8AQ/hNlVDweJ2UuEWkofszzzfBowAhwDsqV9CQvglj0JeO4aOtGO6rK
         rZfFNmqiTqHjqKwK6+Wd4nO1EWwWeUDPFAnn8nUFpiwHAS6jyJQZB35sx2wNuCurZ/QJ
         3nTkZAHmXgD3bjUPHhDQweFFZ4zV4ESCgWtIU0UwzBMUn9EguMCIfVYwpgQSxqague1/
         U+qWkH711QbVlbQ/NlJ8itHP1rleWpQbLRsdoXFa+i9bQea1ct5JFDzvtKfICdBix/DI
         qHTar8YR1uVuI+cSGqkV5MNom4CWBrukDUS/rEzf/jHIJE1Bgcy0B7XF2nQ2h+6M4Wyv
         PJkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=++nRQWY/k4E+AlroFqtDd4Bo37FS6L7rS4A4U1awWIw=;
        b=qL3vn5Y/7juR/v0FtVvVpWuIGFPwFSO5LuYtsHgshg3xt1CKrb1boLQ1TVNAgNsaSI
         pLA7fR1IsHvx7ZJNE/+pQ+I6uZjrXfPkroWwV4BuUKcl1sKn7pTvOOAGPS/FD6EDIRDC
         BEgnPcsa0kxtQkpQ+8apOJm9UwWBOYtEGbYVdLsbU9T8vjYf90HTyGxFmLi9/LaK5a0F
         48XWK1bGZNr30PwLPQWTX2ZSiTZ+9aHLkZ6Keyvz2G3B2nqZoxf2g1SRo1CBlgZnr3U9
         54apfJP+Lzn1ggOXaZyfIDxiDcQrePAVXcDZx5hHt3wS+PAt6VKXMd6FVV0KpfX0jI5l
         83jQ==
X-Gm-Message-State: APjAAAWtuWuFYzwNNHjyPJM9HRKJKVWVIU6FFMY+agescOGrxTj3n5ZH
        oz1OCS+l8Qlwz4UN/+IFSAl5Zg==
X-Google-Smtp-Source: APXvYqx4u8/bz5CLdCqQygxAXwJhEyRPT820sErKnl5w+twEyU3DGYqIGjp3qtI8aoA9SO0Ar1FaWg==
X-Received: by 2002:a17:90a:8d0c:: with SMTP id c12mr8434015pjo.140.1560481998784;
        Thu, 13 Jun 2019 20:13:18 -0700 (PDT)
Received: from localhost ([122.172.66.84])
        by smtp.gmail.com with ESMTPSA id 3sm1003574pfp.114.2019.06.13.20.13.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 20:13:18 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     linux-arm-kernel@lists.infradead.org,
        Julien Thierry <Julien.Thierry@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH v4.4 32/45] arm/arm64: KVM: Add smccc accessors to PSCI code
Date:   Fri, 14 Jun 2019 08:38:15 +0530
Message-Id: <95a76d0ffea5ef13e92b1ce8b1ada85e530133ff.1560480942.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1560480942.git.viresh.kumar@linaro.org>
References: <cover.1560480942.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <marc.zyngier@arm.com>

commit 84684fecd7ea381824a96634a027b7719587fb77 upstream.

Instead of open coding the accesses to the various registers,
let's add explicit SMCCC accessors.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ v4.4: account for files moved to virt/ upstream ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/kvm/psci.c | 52 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 42 insertions(+), 10 deletions(-)

diff --git a/arch/arm/kvm/psci.c b/arch/arm/kvm/psci.c
index edf3d7fdcbdb..7ef6cdd22163 100644
--- a/arch/arm/kvm/psci.c
+++ b/arch/arm/kvm/psci.c
@@ -32,6 +32,38 @@
 
 #define AFFINITY_MASK(level)	~((0x1UL << ((level) * MPIDR_LEVEL_BITS)) - 1)
 
+static u32 smccc_get_function(struct kvm_vcpu *vcpu)
+{
+	return vcpu_get_reg(vcpu, 0);
+}
+
+static unsigned long smccc_get_arg1(struct kvm_vcpu *vcpu)
+{
+	return vcpu_get_reg(vcpu, 1);
+}
+
+static unsigned long smccc_get_arg2(struct kvm_vcpu *vcpu)
+{
+	return vcpu_get_reg(vcpu, 2);
+}
+
+static unsigned long smccc_get_arg3(struct kvm_vcpu *vcpu)
+{
+	return vcpu_get_reg(vcpu, 3);
+}
+
+static void smccc_set_retval(struct kvm_vcpu *vcpu,
+			     unsigned long a0,
+			     unsigned long a1,
+			     unsigned long a2,
+			     unsigned long a3)
+{
+	vcpu_set_reg(vcpu, 0, a0);
+	vcpu_set_reg(vcpu, 1, a1);
+	vcpu_set_reg(vcpu, 2, a2);
+	vcpu_set_reg(vcpu, 3, a3);
+}
+
 static unsigned long psci_affinity_mask(unsigned long affinity_level)
 {
 	if (affinity_level <= 3)
@@ -74,7 +106,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	unsigned long context_id;
 	phys_addr_t target_pc;
 
-	cpu_id = vcpu_get_reg(source_vcpu, 1) & MPIDR_HWID_BITMASK;
+	cpu_id = smccc_get_arg1(source_vcpu) & MPIDR_HWID_BITMASK;
 	if (vcpu_mode_is_32bit(source_vcpu))
 		cpu_id &= ~((u32) 0);
 
@@ -93,8 +125,8 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 			return PSCI_RET_INVALID_PARAMS;
 	}
 
-	target_pc = vcpu_get_reg(source_vcpu, 2);
-	context_id = vcpu_get_reg(source_vcpu, 3);
+	target_pc = smccc_get_arg2(source_vcpu);
+	context_id = smccc_get_arg3(source_vcpu);
 
 	kvm_reset_vcpu(vcpu);
 
@@ -113,7 +145,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	 * NOTE: We always update r0 (or x0) because for PSCI v0.1
 	 * the general puspose registers are undefined upon CPU_ON.
 	 */
-	vcpu_set_reg(vcpu, 0, context_id);
+	smccc_set_retval(vcpu, context_id, 0, 0, 0);
 	vcpu->arch.power_off = false;
 	smp_mb();		/* Make sure the above is visible */
 
@@ -133,8 +165,8 @@ static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_vcpu *tmp;
 
-	target_affinity = vcpu_get_reg(vcpu, 1);
-	lowest_affinity_level = vcpu_get_reg(vcpu, 2);
+	target_affinity = smccc_get_arg1(vcpu);
+	lowest_affinity_level = smccc_get_arg2(vcpu);
 
 	/* Determine target affinity mask */
 	target_affinity_mask = psci_affinity_mask(lowest_affinity_level);
@@ -208,7 +240,7 @@ int kvm_psci_version(struct kvm_vcpu *vcpu)
 static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
-	unsigned long psci_fn = vcpu_get_reg(vcpu, 0) & ~((u32) 0);
+	unsigned long psci_fn = smccc_get_function(vcpu);
 	unsigned long val;
 	int ret = 1;
 
@@ -275,14 +307,14 @@ static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
 		break;
 	}
 
-	vcpu_set_reg(vcpu, 0, val);
+	smccc_set_retval(vcpu, val, 0, 0, 0);
 	return ret;
 }
 
 static int kvm_psci_0_1_call(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
-	unsigned long psci_fn = vcpu_get_reg(vcpu, 0) & ~((u32) 0);
+	unsigned long psci_fn = smccc_get_function(vcpu);
 	unsigned long val;
 
 	switch (psci_fn) {
@@ -300,7 +332,7 @@ static int kvm_psci_0_1_call(struct kvm_vcpu *vcpu)
 		break;
 	}
 
-	vcpu_set_reg(vcpu, 0, val);
+	smccc_set_retval(vcpu, val, 0, 0, 0);
 	return 1;
 }
 
-- 
2.21.0.rc0.269.g1a574e7a288b

