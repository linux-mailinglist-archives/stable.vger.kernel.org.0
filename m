Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27B0D37F10F
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 04:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbhEMCBK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 22:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbhEMCBJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 22:01:09 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80928C06174A;
        Wed, 12 May 2021 19:00:00 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id h16so7502056pfk.0;
        Wed, 12 May 2021 19:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=W9hpVFpi8lwf9SqKI5HARO8wMQK/aDl0gDMEpsYbJt8=;
        b=nN9R6JjpxFHuWERf3D2ZBdy/KquinnB5sABS71UZnjOhUadfs+C9oixNxUmCWxcepR
         HlOXjpDyzxOdhMflcz5nRPEKHPnglF8qSB3suRtdiRmjmfrpFJXeEMxYw0tOFKc1YVFJ
         FvFG5vIyrV6HOr/Zkd9nOriLaqTFpEqTNtiqMtOmSiEEhzB2vaAFkgQPb4AeJqhUcYXQ
         G3NtBu1LOLUhS7oyrWM2Px9Vmvgj1I3c9sBnKBIqanBNqpphVRm/Amhs2uuiVjVflkxc
         2Q8LAl/nMTkpooNQbfuZfcbsabf+5V+OIQMs+QuaG46LR6LA4BgO4cX54ImlqchwEY3Y
         fzDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=W9hpVFpi8lwf9SqKI5HARO8wMQK/aDl0gDMEpsYbJt8=;
        b=E49DOX3/BqqsuQJ5iLS1VH8/C/TdF1+C7PFlHWFiSUEpAmt4LUJ0W5xScuN954zmM4
         BxZ9/HTevEFulgVeiuAoWjuGaE5j31bFnvHsKbR89r8loUojg1rrSMcDXLelXQTDOVQV
         qQ04aoP9jvIn5dnjeigmDl99fzDqI3Jpw3CEHW0RAmfTek++pvyVxCR792YecxlbbJAk
         Iyr+MqHZj1pnRSIP8Y+FfYjjUPg3q8Skf7VCzCJDyDB+Gk8G0MXFqLfBs9whCeHoRtbF
         X3k58bQ9U5PoQvJpTg1ygg5tehbBPzbjFtuDiyKqg2dG96eAcFUAdhkWXBgDyaaxYLEK
         r4Bw==
X-Gm-Message-State: AOAM533zv6RZTug9k2i/9vyntAr0OpNioVIaLu4XSbGMfeFxHLvhbe7k
        c8HdV5RrT2AEc6zlpK7+Z3iRftrvAmc=
X-Google-Smtp-Source: ABdhPJyVB12fxqbj8tMsEQ5JE8fYb2V5ReeY929IikgIjcLJadMH2Oj6HHbLF/rwR3cmrEw0l1XQyw==
X-Received: by 2002:a62:754b:0:b029:28e:e78:d752 with SMTP id q72-20020a62754b0000b029028e0e78d752mr37880892pfc.76.1620871199895;
        Wed, 12 May 2021 18:59:59 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id w123sm812742pfw.151.2021.05.12.18.59.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 May 2021 18:59:59 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, stable@vger.kernel.org
Subject: [PATCH v2 3/4] KVM: X86: Fix vCPU preempted state from guest's point of view
Date:   Thu, 13 May 2021 09:59:48 +0800
Message-Id: <1620871189-4763-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1620871189-4763-1-git-send-email-wanpengli@tencent.com>
References: <1620871189-4763-1-git-send-email-wanpengli@tencent.com>
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
 arch/x86/kvm/x86.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dfb7c32..bed7b53 100644
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
2.7.4

