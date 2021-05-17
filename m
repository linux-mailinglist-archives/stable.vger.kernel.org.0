Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBB8382E1D
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237606AbhEQOCo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237574AbhEQOCn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 10:02:43 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ACE7C061573;
        Mon, 17 May 2021 07:01:27 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so3765502pjv.1;
        Mon, 17 May 2021 07:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/2GPjTLQ/YR+wnuKsns5/Hi1QLal2y1jDQCRlyJhbRk=;
        b=m78vKY4Ils3Zka2LHxaL7/u8+Ux75+b2P5JcA51NnA/mOemelC6vljDXQ+wiyyhvCj
         JcjTebx//vYgWfEddx+4wvQUX1l7NeyFbhAH3MOb85xrYr/KeMFbUGJY7jhAj3QsUWqa
         Z6idJdQmlCCZ11B9YyUIFVhbybDaPahq0a8NVz/nVkumfpLeikq53mrI198nC7ujuGCT
         Cogu7jTwppj9IZ3sh48PkLyHT+42fOsBnPkjyLMzJmam9bpe9gqLeEqpZ1l08W//h4XJ
         4UAwQtoURr7VZfMLg2KuYO2WNphH7/SD7nw9RoaemRDr4C21vW2+X2i7LfF1/mWAclO7
         qSRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/2GPjTLQ/YR+wnuKsns5/Hi1QLal2y1jDQCRlyJhbRk=;
        b=k6G5HSWZBpeFC3c5o5B8zeDl5S9l3gVnt7spPcyYBMgnbAkksYo43tYzdc2fnfxdn5
         wRWW+CAEacRwk9GDLNlU2E4TLNwk4A3bCz9pCQF6rgjL+25Wm6oWyOl0QxlE2xBO18jX
         TvTEXwTuhneyEjEh3IFvUNVe/2+G9vZr8u9KXCaGOJ4OB9pM2sxys25V1p8zDIOmf4u1
         sM9lSf17x8jZJKbSS5bR3hhXJ5uu3eLxqC8UZhNaTRY37YMx5AtoGH9t+h/cbX3trrA+
         Avusii+NSLMbM0jDNcmI9X6kABaGQzVNyEbu+kX2bZa5rx86cv67nvHDCnpmEK+zfscG
         hwJg==
X-Gm-Message-State: AOAM5333rs8yO9h5ZkTyvepiYM9dfvDFTLP6LYe+80fNK6oOUMY3S9JU
        XrY4ToHGgCk78aouwiUBmW0fMRnO/tM=
X-Google-Smtp-Source: ABdhPJwaT9yOEYd0kc9RCcyNp41kW9zpGoSd03Lqy76hsnwtT1jmF+q8DlO5M2OCw0rdT+rzvYgcMA==
X-Received: by 2002:a17:90a:4a0e:: with SMTP id e14mr58581pjh.209.1621260086511;
        Mon, 17 May 2021 07:01:26 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.61])
        by smtp.googlemail.com with ESMTPSA id k10sm3074229pfu.175.2021.05.17.07.01.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 May 2021 07:01:26 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, stable@vger.kernel.org
Subject: [PATCH v3 3/5] KVM: X86: Fix vCPU preempted state from guest's point of view
Date:   Mon, 17 May 2021 07:00:26 -0700
Message-Id: <1621260028-6467-3-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621260028-6467-1-git-send-email-wanpengli@tencent.com>
References: <1621260028-6467-1-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Commit 66570e966dd9 (kvm: x86: only provide PV features if enabled in guest's
CPUID) avoids to access pv tlb shootdown host side logic when this pv feature
is not exposed to guest, however, kvm_steal_time.preempted not only leveraged
by pv tlb shootdown logic but also mitigate the lock holder preemption issue.
From guest's point of view, vCPU is always preempted since we lose the reset
of kvm_steal_time.preempted before vmentry if pv tlb shootdown feature is not
exposed. This patch fixes it by clearing kvm_steal_time.preempted before
vmentry.

Fixes: 66570e966dd9 (kvm: x86: only provide PV features if enabled in guest's CPUID)
Reviewed-by: Sean Christopherson <seanjc@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v1 -> v2:
 * add curly braces

 arch/x86/kvm/x86.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dfb7c320581f..bed7b5348c0e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3105,6 +3105,8 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 				       st->preempted & KVM_VCPU_FLUSH_TLB);
 		if (xchg(&st->preempted, 0) & KVM_VCPU_FLUSH_TLB)
 			kvm_vcpu_flush_tlb_guest(vcpu);
+	} else {
+		st->preempted = 0;
 	}
 
 	vcpu->arch.st.preempted = 0;
-- 
2.25.1

