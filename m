Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C120F38784A
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 14:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348996AbhERMDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 08:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234375AbhERMC5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 08:02:57 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE98AC061573;
        Tue, 18 May 2021 05:01:38 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id 22so6833731pfv.11;
        Tue, 18 May 2021 05:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/2GPjTLQ/YR+wnuKsns5/Hi1QLal2y1jDQCRlyJhbRk=;
        b=ZeIi/gvUNym2Dd9YiXCf0AJ6fBKidFcXrnjVOMnupLUuz68CdlrtfW7q5h4nJIROaL
         TWXnzoNvpXjL+zgx3xqklTashGR+nM8dtmqHEYd6+4EVF13Cy6ZpX6/tws9rkD7dAlOA
         2O4WmVYoYHPa/5omhQZUAT6lXRCI1IZ6H+QVRm208oFVL0GrXO0ZH5ppfkEV8row5IU4
         2NgnNsAgTs/ITFePFDUNowhYlRCJTeUdjAuadljv0cqV/Kgo3tPXNIqfZOJqhnXgsI89
         aa3jreh6+3yBGZMfNp/PE+zNFSlgy26UHE4lSTuxldVNNuORYEyqfksVeXY4pnHyX0Yc
         lVzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/2GPjTLQ/YR+wnuKsns5/Hi1QLal2y1jDQCRlyJhbRk=;
        b=ediIZu6qNP2n5peNx8wh2jQi3E+pEC7nOGfWCwWUJ0N34LT03dsYq2PQU6kE5ZxeDo
         Fq+kGmdc4vKiHNU+XAMFYfqBuLGutGRuKuFp0GdXEXk4oGUNIWsf45RmWr1uv88L2tiU
         1kDhUkUjo7uU9jOeTpHUMixj55X1tr/dzWYIH9U3TTVr/GwWXiFLUOgQAUnd3gsJ3AcI
         gq99WHtKQvZx/3s19422/lGeXf7lGZFe67fUdBnfcnzNYDKYgdrF9W0m819cEW3ZF7IW
         LzuvX7RQiNcKFs32B6Aq/3kmsA9TL0KUMRj7lDd84i3EVw5U9Zs6k5StRi1pZsqdqWZx
         FfdQ==
X-Gm-Message-State: AOAM531dCO72/icA8o2kYQVRGcszsBHpq8OeoyIDEYI1np6Wpt/dbFso
        LUWyIIjMXeM/ENBvHKqK4pele5X0IDY=
X-Google-Smtp-Source: ABdhPJxcbPclLPPTmDzgEncZEZSD0AaWP/y/J2B3jrqQOaA8ZnYm4qZvxlrmL+hkSI63xUnGUyL7nA==
X-Received: by 2002:a63:4d5c:: with SMTP id n28mr4700618pgl.436.1621339298356;
        Tue, 18 May 2021 05:01:38 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.53])
        by smtp.googlemail.com with ESMTPSA id l20sm12757394pjq.38.2021.05.18.05.01.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 May 2021 05:01:37 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, stable@vger.kernel.org
Subject: [PATCH v4 3/5] KVM: X86: Fix vCPU preempted state from guest's point of view
Date:   Tue, 18 May 2021 05:00:33 -0700
Message-Id: <1621339235-11131-3-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621339235-11131-1-git-send-email-wanpengli@tencent.com>
References: <1621339235-11131-1-git-send-email-wanpengli@tencent.com>
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

