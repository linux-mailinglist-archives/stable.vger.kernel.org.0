Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94C4A233D95
	for <lists+stable@lfdr.de>; Fri, 31 Jul 2020 05:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731261AbgGaDMj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 23:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730820AbgGaDMi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jul 2020 23:12:38 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBC49C061574;
        Thu, 30 Jul 2020 20:12:37 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id c10so3273825pjn.1;
        Thu, 30 Jul 2020 20:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=CmJxc+XhZero9r+6q4uoOOTuXV90dMxdt2faOFzAcdY=;
        b=UOtVTTaOgPUCZucic0rjP7R/0UCYE1hGM2DtZQAZkSvbYgH4aiIUe1RSWRYIuyiPRr
         1bjNKVcYR6t8wIGGP/Yd/KsB1QZyAdmvYo0cxzRSMrXDs1YqOhOHbszlIls2r9wHBuqm
         93NrCV2rM6xN8UyPzE8Qyf0Bx6nQY1MNffIHzBovXdY2TQDIg4GI12h1d6+iML5KcjEc
         IR6NmTB0skdQ5226ijlQvdU+e6j1Q7U9hJT+3pFOMQ/r+xuWBOo82Ak0Pu/KE8JwXbuv
         VaBybxme7S/k31A/nOZGHtsu2TOdc4PE+fOcNNiEqpF2TVCZmNdXOZzB8GxX0I10/tN0
         HOyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=CmJxc+XhZero9r+6q4uoOOTuXV90dMxdt2faOFzAcdY=;
        b=LZbVc3r/pC2rAT2cG/Y4aHtjMCjDvcz/+jIUraNlQ2HT4QFEoxQYfph8FLrnVir/lJ
         8n5SFPWj0o3I461k/U+S5GWc2y4D1VevynqJpbVyTG/JzPzInzhtTwUgN8DuE2fxOJvg
         D41Q5jnhxByC+qCVzZAJYFPJ1IzaeFoDAZQXJFQAbK+hHa/sl47poSNurskfgFsXC4hR
         jl0JEhagxs+wQSuh1qWMGoay2MZ5zXHpWXNqLbPT/E3M6iBi3Kr19kWmL/+QPgg6Ow8/
         1WSIVbBggEwbshKQcD0mGTomjTOtQV/WaZ+hsIhwgN97S/AiknuL+bGBia5TrBLs/ah4
         kjvg==
X-Gm-Message-State: AOAM532vhBTM9ZIaDzm6XOBoF52OZSuOBZ+pkn8NU3Tl3D86RCBHZ4WI
        owGiVrglF/kEKDN38WctJe7ef5wy
X-Google-Smtp-Source: ABdhPJxh16+judrCc9+W6BGiAb8rYYh+q1qUJ3nANGdE5Ei1cEQokwGhGm9lfoBfIcMMCZ8hy4g3dQ==
X-Received: by 2002:a63:d446:: with SMTP id i6mr1696694pgj.438.1596165157234;
        Thu, 30 Jul 2020 20:12:37 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id t19sm8221961pfq.179.2020.07.30.20.12.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Jul 2020 20:12:36 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, stable@vger.kernel.org
Subject: [PATCH v3 1/3] KVM: LAPIC: Prevent setting the tscdeadline timer if the lapic is hw disabled
Date:   Fri, 31 Jul 2020 11:12:19 +0800
Message-Id: <1596165141-28874-1-git-send-email-wanpengli@tencent.com>
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
v1 -> v2:
 * add Fixes tag and cc stable

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

