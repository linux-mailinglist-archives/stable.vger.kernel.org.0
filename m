Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96E292306CD
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 11:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728550AbgG1JpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jul 2020 05:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728197AbgG1JpR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jul 2020 05:45:17 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79CD0C061794;
        Tue, 28 Jul 2020 02:45:16 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id u10so108778plr.7;
        Tue, 28 Jul 2020 02:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=YW61uT4gs7NLfpC0VAfH7u18rjoR4roJ54bakldbt1o=;
        b=RfYnzTVaaiIcgr+9v6Qpt+9Sn4A6BP7Q9yIcBs4oG6bfhviw+3JSTCk5bxF1v0Q9VP
         CUq/x8J/Q5xlyidW5jaxO5+QUJ1nIMYZT95rI6r8HwIvVYcixErDeg97g06HHpbEo/7F
         LwwNFv4NhVm7TKSdT4zHjQsYvZhtIh6u86VYKcMqCJCod6yK6Tl5nqYYVoMm8ubtdCGH
         quJmKGjBIogttIL6DsrSLmV1jPalEf2Fq+43Dty6I0iwCNBjfVc23hz+lt+1g9YQV+SJ
         3TP1vfw0eBPVO9iLug6dQSoZVxRimiRsV98IQ6Ahh8vFpJK16eXVvpLLG6ndwl95wNg4
         mHkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=YW61uT4gs7NLfpC0VAfH7u18rjoR4roJ54bakldbt1o=;
        b=S/277hyXeTjAkmgbQCqdwINDdJJWLN12opdg270kTVxjc18S4U4LlQqtNRp3h6DoqW
         hmfJBS0E/2aPOY8u+8/FBpk4qCPhilA6K8/8PPfbDTvB6bcbrTgDSwqpgtlFPEWBG7qy
         BhTPoxjwZO7hFV4s8dIuJweqwNCoyUm6dM+SSC74myDwWkaxja6c7KWPozLWrkSzSneB
         2VwBSSpbBL6P9S0Q1b1+rt53FtcW1BbtDGRh1knnfbDHtAoIrnagK3F1lOqhOW/TnZcy
         zCzjj15FAQ+mc7hPYH1bESIMp0kvcH9oSeew5I0/a65t/VTQIaLakn+SXfHAhIY8tF2W
         +3DA==
X-Gm-Message-State: AOAM5321UOlqULWQu45mXdZcC5m+wpiwPbc8Zadf7gKr3JvTSPkbg53F
        EroCfbUVz8I7Xqe4xn3dT4mrm2Nc
X-Google-Smtp-Source: ABdhPJxD6tzllfcRVDmb1xoKhd2jMzTzXphKdkN4ooTcK2t2IBIzxcYpjGFm4Em3KQhe2BXXOgUfSA==
X-Received: by 2002:a17:90a:d30c:: with SMTP id p12mr3843893pju.4.1595929515664;
        Tue, 28 Jul 2020 02:45:15 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id r17sm17969173pfg.62.2020.07.28.02.45.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jul 2020 02:45:15 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, stable@vger.kernel.org
Subject: [PATCH v2 1/3] KVM: LAPIC: Prevent setting the tscdeadline timer if the lapic is hw disabled
Date:   Tue, 28 Jul 2020 17:45:04 +0800
Message-Id: <1595929506-9203-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Prevent setting the tscdeadline timer if the lapic is hw disabled.

Fixes: bce87cce88 (KVM: x86: consolidate different ways to test for in-kernel LAPIC)
Cc: <stable@vger.kernel.org>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 5bf72fc..4ce2ddd 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2195,7 +2195,7 @@ void kvm_set_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu, u64 data)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
-	if (!lapic_in_kernel(vcpu) || apic_lvtt_oneshot(apic) ||
+	if (!kvm_apic_present(vcpu) || apic_lvtt_oneshot(apic) ||
 			apic_lvtt_period(apic))
 		return;
 
-- 
2.7.4

