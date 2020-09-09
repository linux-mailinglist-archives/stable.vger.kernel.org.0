Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2018262576
	for <lists+stable@lfdr.de>; Wed,  9 Sep 2020 04:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728617AbgIIC5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 22:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgIIC53 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 22:57:29 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3389C061573;
        Tue,  8 Sep 2020 19:57:28 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id o20so841936pfp.11;
        Tue, 08 Sep 2020 19:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=vXOzzvFu8SFrA4CAW0a5T7SuJva0VHxNKr87gI4K2Fc=;
        b=DIqZrTRZTRJ1OQx/gOPEn4+bM4FE3kN3Pg7Y1cIbESXDVl3/dT6jxYK0HBucFeO7OH
         9PSAaZa8eQSzRVcIL5+Ti9OGTR5SPfbeEbFL2y64trz9pbdzgrKLarv7T2yVUfzPIQtm
         Oe5WA+z6Fzt/n3M3l+rqemMeFMcbeP+rpqKIsRUXxu9QZDj2UMYDWG8k4uRGEzEJU8Xv
         YwvqLqFh/gNUVkflSITbzA2H17NXytY7SP/0IA8+G7gvpkB0eDY3bOHA+b8Dhpdfb86M
         vH/1th6Vo61XWN543f7kXUFP0yIhCdGka9tASpxUWYyHZLEstsfkR1DhwqHGzsrlUWqn
         3xMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=vXOzzvFu8SFrA4CAW0a5T7SuJva0VHxNKr87gI4K2Fc=;
        b=heVHNII4dqZFJ1m4XFt3iW0qK7iXw/XLmHTRoOfcPmSXQ4/+o/zt45OlPoq+tGsEnk
         1ZZkBBwsVBayiYmyW+De3K0QfmI0Fmd8rE/21CNNcb8OZvobWshRZTzV0NOh+Qi8ZJpe
         xwmisH3NJYpgHYxlpc2sUAOtb4vjTY7v9T24rafK2CK6cEoaUAZYNj5bpT8x1MGStOng
         amcJamK8Qb6rDE66zVnDKsQVIkj4Oh6xPmWW7KIAu7+L2arYVvJrjdmUjKZkzaELvGCj
         49grEGXSWEn5he/0nwlW8y6VKu6/yOhmawzJ2csgbJi1F3/97cr/Z58B8gd0+nlgOWvf
         qcHQ==
X-Gm-Message-State: AOAM532nzteqJryRFhiCcleu5c10/6vFI6dm3sX4taKDHa33GbS18GOo
        IYp/81PqTGnvY/hfxMBbQ8oy/21hlsA=
X-Google-Smtp-Source: ABdhPJzGpaGuJQnM7F8oIR4SzaXXvnjaLCqKupxziP9tdtgxwwwc5Vq+NYKCHC3fSRB3Ihot2TIN9w==
X-Received: by 2002:a63:c64c:: with SMTP id x12mr1341486pgg.433.1599620247986;
        Tue, 08 Sep 2020 19:57:27 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id l9sm556063pgg.29.2020.09.08.19.57.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Sep 2020 19:57:27 -0700 (PDT)
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
Subject: [PATCH RESEND 1/3] KVM: SVM: Get rid of handle_fastpath_set_msr_irqoff()
Date:   Wed,  9 Sep 2020 10:57:15 +0800
Message-Id: <1599620237-13156-1-git-send-email-wanpengli@tencent.com>
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

