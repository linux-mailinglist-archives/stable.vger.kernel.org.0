Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F159D26256A
	for <lists+stable@lfdr.de>; Wed,  9 Sep 2020 04:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgIICyU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 22:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbgIICyU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 22:54:20 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38363C061573;
        Tue,  8 Sep 2020 19:54:20 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id o68so983296pfg.2;
        Tue, 08 Sep 2020 19:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=vXOzzvFu8SFrA4CAW0a5T7SuJva0VHxNKr87gI4K2Fc=;
        b=CwBN50eN7o0q7KiTBQZvxw5uvd8HjF6WD82DNjv3bwUJuYulRVSgV+qRsMk4V+GepA
         nHobjfDBdNcOC2CulA06+2Hosqa4zymYH8uz9bB9Vn+7TEGxu50ttHQSWj7ljUdNHOn3
         RnxKKaCpfqVzVV6xjKql7RYlKWFwCV8PhBmsiO3lq7CJKXWkl+IfN4D+2VEr9sgNKTHT
         jofbSOD1kbC/gOfW2P8AJGq4RMHEF3ujcXPVu8wjbYaK2z98bVER1/tcB3hSOFILZsZc
         FelekrZ+C7xfR0I/0IV86P4hluoCUDRMPs+VKSdVITRCfe9m2rcqlDMIX1IPFCtWXHx4
         P86Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=vXOzzvFu8SFrA4CAW0a5T7SuJva0VHxNKr87gI4K2Fc=;
        b=oAuDk+5gnk9jlOrRbT9BeIa8Jn+lYs2JSfPsubhgYurf/JgRfkv6wthFiYG12oNehP
         LPAln6rnE/MRKtMjhXWZphBCySmWb/8hGMGpGoRP4P5NwF2DN+aKrWcyhyPdd8W5nRoS
         SF6D/x0a0A0H97jBzhHWFEqC5pC0ORlrqfW5oct0tOyg6Tgp+SRHVDR1QgXnJEclzpus
         ww0yssy70MroGf1x7gtBnbR6Tg6GfOPSK0LxqVagRCC1hBBWREW/q+bAzNYGxAdMwubT
         8WvxNXrgjYNieItn2g0JDIyk1kSg2VRzOFnRys1cjBjUeog9k0PpX5qpBNVowuvsXH0u
         ykvA==
X-Gm-Message-State: AOAM530jmYLY4Po9+mgP02KOmX6DBepy2GrhaJXPIt/c11xnjFRd7qQU
        rfVG8es4EwDQQQkInLQi7XX6aNQKvNw=
X-Google-Smtp-Source: ABdhPJwfjhhVWsy0V0vhZW43FiuW5FnfCQPx25is8fPCLesvGC6gJ+WVWSl0DV5dnZNVvRPNIGa6Iw==
X-Received: by 2002:a62:5f02:0:b029:13c:1611:6536 with SMTP id t2-20020a625f020000b029013c16116536mr1925839pfb.8.1599620059482;
        Tue, 08 Sep 2020 19:54:19 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id p68sm739865pfb.40.2020.09.08.19.54.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Sep 2020 19:54:18 -0700 (PDT)
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
Subject: [PATCH 1/3] KVM: SVM: Get rid of handle_fastpath_set_msr_irqoff()
Date:   Wed,  9 Sep 2020 10:54:03 +0800
Message-Id: <1599620043-12908-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
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

