Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC5582642DB
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 11:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730572AbgIJJwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Sep 2020 05:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730418AbgIJJvS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Sep 2020 05:51:18 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B0AC061573;
        Thu, 10 Sep 2020 02:51:17 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id a9so2767626pjg.1;
        Thu, 10 Sep 2020 02:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Blehx/RsCjxhexTNdBAbuV+NrcKDgCDuzEEOkebWnFE=;
        b=dytL7qehQzztnlbUdBSM8T5hf+VxNOCBpL/24z5fs4Kg5gVwvOyEerh/JykbVMXXv0
         tn2DODpVzgu0YUGpAWKe8ATUON1qJzdQAui4lTpWUKwofInyzwM38QOuzvw0L6YJg1bP
         MVrI0CCBWnOJUoHBFq+Spuvz+5ehyQG7A4wbKWIsz5YEgf5weqcwLIy5h9YHj4BIdZte
         i5HVgsh1Ok4N9OGMMT5k8YDlHj6U/iVS8U1hYWGkuEy0eWkeOzj33blIpajczrVEEflB
         SyQ54fiGEPRmC7axVm3rWj0itegV1UObql+KQTgHNfDgE4GLUXWzuoPr8RHDCnXd/E3M
         VAWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Blehx/RsCjxhexTNdBAbuV+NrcKDgCDuzEEOkebWnFE=;
        b=h57be6nbsS8N5yCvInj0Y9rK/HiqpH4Lt0w8RhS1V7MBofeQkdndYJgSWCx8xyogWM
         XeDEbLhQ17Z/Xhb67lPxtCaVG/dQbN1T70Prxp7qBXTEZ8mIuNW3LWlX556BMwGxaM5Z
         4S6cuAeYsEDB0BI+QN3QM2wFNVta1ZhasH7h3hFbaB4989ACCa3tqAV5W1OQwLNOt2uX
         TJAHCzZR8J4jAWq2UlHuIgUmMKR1G6Yz5gEuogDUT5/ReQmRbByJayWpS0zyIjz4sCL/
         cSK7t8tB9JruwMbAW1ercSwDOWFFSh3qElQqNsLnF9mo9ahkaOxcVT8Wanif+LvuwCTl
         DMvg==
X-Gm-Message-State: AOAM5329rHmfJQv0vzx471rdPedvXEnwHFiR2vz+QS17JY0Jc8Q3wcza
        J/phQJoX2FkGTjxqeTkokyvjYVejYMc=
X-Google-Smtp-Source: ABdhPJyQezQj+HJONXN4Ke47XI1Q9agwTLjxeb7n5zht75GG9c5NPJXGphDDb74zuOyJ46e84mNGYg==
X-Received: by 2002:a17:90a:4687:: with SMTP id z7mr4537393pjf.144.1599731476796;
        Thu, 10 Sep 2020 02:51:16 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id e1sm2576534pfl.162.2020.09.10.02.51.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Sep 2020 02:51:16 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Paul K ." <kronenpj@kronenpj.dyndns.org>,
        "# v5 . 8-rc1+" <stable@vger.kernel.org>
Subject: [PATCH v2 7/9] KVM: SVM: Get rid of handle_fastpath_set_msr_irqoff()
Date:   Thu, 10 Sep 2020 17:50:42 +0800
Message-Id: <1599731444-3525-8-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1599731444-3525-1-git-send-email-wanpengli@tencent.com>
References: <1599731444-3525-1-git-send-email-wanpengli@tencent.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Analysis from Sean:

 | svm->next_rip is reset in svm_vcpu_run() only after calling
 | svm_exit_handlers_fastpath(), which will cause SVM's
 | skip_emulated_instruction() to write a stale RIP.

Let's get rid of handle_fastpath_set_msr_irqoff() in svm_exit_handlers_fastpath()
to have a quick fix.

Reported-by: Paul K. <kronenpj@kronenpj.dyndns.org>
Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Paul K. <kronenpj@kronenpj.dyndns.org>
Cc: <stable@vger.kernel.org> # v5.8-rc1+
Fixes: 404d5d7bff0d (KVM: X86: Introduce more exit_fastpath_completion enum values)
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/svm/svm.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 19e622a..c61bc3b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3349,11 +3349,6 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
 
 static fastpath_t svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 {
-	if (!is_guest_mode(vcpu) &&
-	    to_svm(vcpu)->vmcb->control.exit_code == SVM_EXIT_MSR &&
-	    to_svm(vcpu)->vmcb->control.exit_info_1)
-		return handle_fastpath_set_msr_irqoff(vcpu);
-
 	return EXIT_FASTPATH_NONE;
 }
 
-- 
2.7.4

