Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 637FF4488C
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 19:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732326AbfFMRIi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 13:08:38 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39777 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404509AbfFMRDv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 13:03:51 -0400
Received: by mail-wr1-f66.google.com with SMTP id x4so18927473wrt.6;
        Thu, 13 Jun 2019 10:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=iL3ed930x0D+TziQC6+xetmar4f3T1IsE4OpsaxxcFs=;
        b=c1xCWly942UXSryXlOz5iT1jEy36ylhHSlzH81RIvUtag8K0znbW35aCuQomcjbqNH
         nXS3rGRq+mOISRD54nxGjod/ZCiHWBMLw1f7+wLeg4CH4+zc4jeDXgaBEku6iu1RbpUO
         g1LoKMVuo48y/qFyxQR8JkjlIsI6R2UXbGY4r45BL+ZUsSCamzXbALzOVwv3NRFzl8eF
         mYMFNt/Lvk07AYTVU5kfq6tb0oP/fglB/dfIEcDQQ35KTqKu5nc6vdEKYgxIND3VkEwz
         rqCuq6K8u2ttF4YFe6eTW8EXrWljmBnWhVeEhN8Qp80Ck3uRgN1fm0jYF+XPQR5q+NRX
         Jyrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=iL3ed930x0D+TziQC6+xetmar4f3T1IsE4OpsaxxcFs=;
        b=GIC53XHL0yErjrYv26nii4842cUJZuNX7LgZ4RI884Jj68aEKGMZGFWwA6G0E0iUtx
         xMNEZKUoZkCiXYbweZojejxXbIwKdQHQ/BPDID4hpgAbxhE0NfjEq/1X6uOzctkgYTT3
         v0p+IjFNRodk7rb+Xi+McDjMErnS0BqB3f7/no2igmvu3lfL/SAB27xigFVx6fqHq+8t
         VXrzUDTT6tRATaMV09qFQpxGAd6yksH9t3Rl3Rref58+RmEi3eaTJGoagMt9W3TU77AK
         SU2NOlGVKuvh34ZpwA8Kl4BvpEPtfvDNLnZpNgCuzsHt1mhKiV4ZmQurrOyw6E57ipW7
         BqVw==
X-Gm-Message-State: APjAAAVCd7Us+2KSzjsUkBLRuqArakJAKi3LfVbj3+O6FPuof4O+1DlQ
        itJM5Op45zcC/0x8fBiZNyIjQruK
X-Google-Smtp-Source: APXvYqz4vmVDAfBHp5UUc1FZnr0ZUs0ObS8arcU71G3SuT0Lv5eW3VZ+/RV/5nK6QGf7RqeKCHPH/g==
X-Received: by 2002:adf:fe08:: with SMTP id n8mr7694401wrr.140.1560445429854;
        Thu, 13 Jun 2019 10:03:49 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a10sm341856wrx.17.2019.06.13.10.03.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:03:49 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        vkuznets@redhat.com, stable@vger.kernel.org,
        Nadav Amit <nadav.amit@gmail.com>
Subject: [PATCH 15/43] KVM: VMX: Always signal #GP on WRMSR to MSR_IA32_CR_PAT with bad value
Date:   Thu, 13 Jun 2019 19:03:01 +0200
Message-Id: <1560445409-17363-16-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

The behavior of WRMSR is in no way dependent on whether or not KVM
consumes the value.

Fixes: 4566654bb9be9 ("KVM: vmx: Inject #GP on invalid PAT CR")
Cc: stable@vger.kernel.org
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1a87a91e98dc..091610684d28 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1894,9 +1894,10 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 					      MSR_TYPE_W);
 		break;
 	case MSR_IA32_CR_PAT:
+		if (!kvm_pat_valid(data))
+			return 1;
+
 		if (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PAT) {
-			if (!kvm_pat_valid(data))
-				return 1;
 			vmcs_write64(GUEST_IA32_PAT, data);
 			vcpu->arch.pat = data;
 			break;
-- 
1.8.3.1


