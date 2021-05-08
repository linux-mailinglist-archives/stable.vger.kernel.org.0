Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF813770EC
	for <lists+stable@lfdr.de>; Sat,  8 May 2021 11:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbhEHJdM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 May 2021 05:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbhEHJdM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 May 2021 05:33:12 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98132C061756;
        Sat,  8 May 2021 02:32:10 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id b21so6498435plz.0;
        Sat, 08 May 2021 02:32:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1CGHW9g1U7mxu/mVGb43UumaGiz2ve3vaE4gPvsroXY=;
        b=pbDNw1Fx99ba7QrZGEIm3/SSQPA+bqJOrtp8ZLb9V73V8MxilDw19X7PFvb6cmZHlr
         tWsyk85UfQdF1vdn/Gzb1CZITBpP0i/KxS2W/2wEL9L+l2I1kUagiHakVRr2SaxxnbEm
         QTu2kzhqPT6bab/UqOaOoLw4vMasOeqqHD7kX4VfKoZ1iM0xlIEsyO+L+Xsz4+0TiEKg
         8YQhDFEbjSbSfWzYzsCfUkybNrPTk5djolvDN2iWu1z+nll5XaU+/17OvAjhbfTA62+v
         Hl5LOzFPTW0bvHLcqWx+SMDAVN1rasBs3Q5jSaJp/lbeclLW4QFCxLzvrFuKu+r3O7sM
         SI6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1CGHW9g1U7mxu/mVGb43UumaGiz2ve3vaE4gPvsroXY=;
        b=nx8kNBusuWfeiTqbEqLZ+J4E9UnFXKc95WDiOdop1r5NQhRmAwawxGDi6RuoUmmWd3
         LUzV5w8/5lwEnBQsV0CK+mbtdjIUxx0sVfU5t3LpHTPG/LQbKCLv7/ENjHZNNAEW9GTj
         uK8818l/yQvKPxH4daMW6yJmJkO7/ZQRxObEB0W1FreSkkEQgBZMKHoIW3grDvp6DbWa
         oLKOdn4Txe9o0IMhT9prveN44ZrpOXDwFQfT9k7k5NlGm1ntfVFfDotbe6iPMWpOL1L3
         Xg4LL1u9K6YPGVMjnKjKvsQzPtVHLpwGlX+oWhXg+gdpiLNIt6GhuBDEYCk6pSPZjFke
         /JDA==
X-Gm-Message-State: AOAM530ndE7Xt/iTv/EeSdX5MI29FInSofknkn+YerdDL3Gaci5NJaAp
        9qfSo+GxSV704inmSFxBtgO0wRR3Vq0=
X-Google-Smtp-Source: ABdhPJy//+f7HmIzch4pMQ1TT6uDnh5IuVL+45PNnmpu/8oWSEAXNCv0ga9U3CCfGHrHzyAqD2BfwA==
X-Received: by 2002:a17:902:bc88:b029:ee:7ef1:e770 with SMTP id bb8-20020a170902bc88b02900ee7ef1e770mr14621444plb.19.1620466329986;
        Sat, 08 May 2021 02:32:09 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id f3sm40437765pjo.3.2021.05.08.02.32.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 May 2021 02:32:09 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, stable@vger.kernel.org
Subject: [PATCH 3/3] KVM: X86: Fix vCPU preempted state from guest point of view
Date:   Sat,  8 May 2021 17:31:50 +0800
Message-Id: <1620466310-8428-3-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1620466310-8428-1-git-send-email-wanpengli@tencent.com>
References: <1620466310-8428-1-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Commit 66570e966dd9 (kvm: x86: only provide PV features if enabled in guest's 
CPUID) avoids to access pv tlb shootdown host side logic when this pv feature 
is not exposed to guest, however, kvm_steal_time.preempted not only leveraged 
by pv tlb shootdown logic but also mitigate the lock holder preemption issue. 
From guest point of view, vCPU is always preempted since we lose the reset of
kvm_steal_time.preempted before vmentry if pv tlb shootdown feature is not 
exposed. This patch fixes it by clearing kvm_steal_time.preempted before 
vmentry.

Fixes: 66570e966dd9 (kvm: x86: only provide PV features if enabled in guest's CPUID)
Cc: stable@vger.kernel.org
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c0244a6..c38e990 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3105,7 +3105,8 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 				       st->preempted & KVM_VCPU_FLUSH_TLB);
 		if (xchg(&st->preempted, 0) & KVM_VCPU_FLUSH_TLB)
 			kvm_vcpu_flush_tlb_guest(vcpu);
-	}
+	} else
+		st->preempted = 0;
 
 	vcpu->arch.st.preempted = 0;
 
-- 
2.7.4

