Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A81614E06D
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727539AbgA3SCI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:02:08 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36807 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727728AbgA3SCH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jan 2020 13:02:07 -0500
Received: by mail-wm1-f66.google.com with SMTP id p17so5410468wma.1;
        Thu, 30 Jan 2020 10:02:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Kj0vyrXH7QR7unCChoOZszZJi2rlsZtvdnmK5XaO1uo=;
        b=eWM7AMTNMqhErTPIy9xpuR5NXPXz9OsQrL3YwHB+DudINSvFdE2QMWMCfbEY7H73A9
         x2xntrvzwkyoFqnpvSPAscjxb47flhcS5GYhORnD4yeOXSV1VjNzLZGITsH90eAqnKE5
         NIcXuZzb+a2Ax1liUUjUGs9FydjQ1FMJXbqW7QC9NS7X+rnqjDvct8S2a+ma2aC/xxa+
         LzquKB/Z/vexxC5CAlliTbP5we9gFKF+mQLu/DVwCqKvyvIgp3kQ+XwC3qOoIFTRlyxf
         cbetoVw7xRn8/y6Np2hLljYc1wMOfRSlW0VZh1/8Zc5Z2IZ7Yks1qM94lFa2WREGpd1J
         35UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=Kj0vyrXH7QR7unCChoOZszZJi2rlsZtvdnmK5XaO1uo=;
        b=VOvzQDw9WomOaiWEoV/FI1hdCAnyJSeBPkOt2CH11Qeh7qMGpcVZeKL//gm6qmkJ/O
         TuOOxtP4uBbfgEMyApGIVB7WzdoB07xefrAfqtPjHO5uZtox21WeLs/RCoGiw4IjRzVR
         RGVXw5Fo49HMFRK9J/zHUYnNlI3uqXH5asQbhdttQYJJdGI9HJiieeVuV6EMBoCrlN/1
         eAxW8LKNI5g3FtrefugaJ53n8W9bxpjnYTQ4+ZpeqR4iLuYKDvRTOk1i370z+i8TEHOe
         fPGO+kaAMdHfUYSOwdQlbEfdnwJh1jW480F590qBHqQq34ZyTAVQxb6qYn/MoPWGJ0bN
         Xzzg==
X-Gm-Message-State: APjAAAWHTcpxlEU7B590tyEkPdCB476cL4kX/Wi7xEkqWZZY+r4vwVx6
        yOaCw7BcKoBGl7hNpUh7RtFR4/5iC6Q=
X-Google-Smtp-Source: APXvYqwB2jmuxzyKr2zpDGIIjLZzOU+UOq7DdE8OxcYPU6Vw+/KqPaKy9LUMuEqhjbfpyAxBW/KVHQ==
X-Received: by 2002:a7b:c258:: with SMTP id b24mr7155543wmj.140.1580407325310;
        Thu, 30 Jan 2020 10:02:05 -0800 (PST)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id w19sm6956878wmc.22.2020.01.30.10.02.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Jan 2020 10:02:04 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        stable@vger.kernel.org
Subject: [FYI PATCH 5/5] x86/KVM: Clean up host's steal time structure
Date:   Thu, 30 Jan 2020 19:01:56 +0100
Message-Id: <1580407316-11391-6-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1580407316-11391-1-git-send-email-pbonzini@redhat.com>
References: <1580407316-11391-1-git-send-email-pbonzini@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Ostrovsky <boris.ostrovsky@oracle.com>

Now that we are mapping kvm_steal_time from the guest directly we
don't need keep a copy of it in kvm_vcpu_arch.st. The same is true
for the stime field.

This is part of CVE-2019-3016.

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +--
 arch/x86/kvm/x86.c              | 11 +++--------
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f48a306e..4925bdb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -685,10 +685,9 @@ struct kvm_vcpu_arch {
 	bool pvclock_set_guest_stopped_request;
 
 	struct {
+		u8 preempted;
 		u64 msr_val;
 		u64 last_steal;
-		struct gfn_to_hva_cache stime;
-		struct kvm_steal_time steal;
 		struct gfn_to_pfn_cache cache;
 	} st;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f1845df..a0381ec 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2604,7 +2604,7 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 	if (xchg(&st->preempted, 0) & KVM_VCPU_FLUSH_TLB)
 		kvm_vcpu_flush_tlb(vcpu, false);
 
-	vcpu->arch.st.steal.preempted = 0;
+	vcpu->arch.st.preempted = 0;
 
 	if (st->version & 1)
 		st->version += 1;  /* first time write, random junk */
@@ -2788,11 +2788,6 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (data & KVM_STEAL_RESERVED_MASK)
 			return 1;
 
-		if (kvm_gfn_to_hva_cache_init(vcpu->kvm, &vcpu->arch.st.stime,
-						data & KVM_STEAL_VALID_BITS,
-						sizeof(struct kvm_steal_time)))
-			return 1;
-
 		vcpu->arch.st.msr_val = data;
 
 		if (!(data & KVM_MSR_ENABLED))
@@ -3509,7 +3504,7 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 	if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
 		return;
 
-	if (vcpu->arch.st.steal.preempted)
+	if (vcpu->arch.st.preempted)
 		return;
 
 	if (kvm_map_gfn(vcpu, vcpu->arch.st.msr_val >> PAGE_SHIFT, &map,
@@ -3519,7 +3514,7 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 	st = map.hva +
 		offset_in_page(vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS);
 
-	st->preempted = vcpu->arch.st.steal.preempted = KVM_VCPU_PREEMPTED;
+	st->preempted = vcpu->arch.st.preempted = KVM_VCPU_PREEMPTED;
 
 	kvm_unmap_gfn(vcpu, &map, &vcpu->arch.st.cache, true, true);
 }
-- 
1.8.3.1

