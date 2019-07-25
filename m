Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E429774C13
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 12:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728354AbfGYKqv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 06:46:51 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43405 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728429AbfGYKqu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jul 2019 06:46:50 -0400
Received: by mail-wr1-f66.google.com with SMTP id p13so50202243wru.10
        for <stable@vger.kernel.org>; Thu, 25 Jul 2019 03:46:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fP/uxcOzwVHr7L9oUh6zQGOUjqLibLxYvQKPmz0udDQ=;
        b=nM1YiACct6OHtgsel8yP2kcKRXo4VkUtM+xsdHyluCBmmQbVirdr4uay7giQs0JpW8
         gu3rdAbGcKVIP+QO2WkmgYwASR/LFBbZ/pZIdPjPhYOaFTsHVlwqVYXBXcWBy2jRkkpu
         KdnntbisMOQ+xpk+VhIQWB3i+EvUvb5Fe3wSZotJ2d5a1sv9WR4BG31KBOxbgtLsG3Ku
         AQqr+VE2S2jd2AwC/LWzOu0Ad/8A6lC96yyUS2kRi0u7oS5YECiaOm0UfpYdWKtWJAA2
         oFCQbPhx9q/c6wHI+jmEwGSIYeQowFMLQZWaIWkwGYnKQ/VSPBd8O/M7H6n5bZlXI4Wg
         ntxA==
X-Gm-Message-State: APjAAAXqLWIDCXDWuiNm9KJyQAm2op+tMsR+GkO5fkglOArPDi76422n
        wPp2tswd+VG5eZg5NG7tvI7sc3aeB70=
X-Google-Smtp-Source: APXvYqy3zERLDjp6rqsxeS4vm7dBxqmTcEoy3J0oIY9E8QqB0xucZLj5joCQPA0shmqmsQdzg1hLFw==
X-Received: by 2002:adf:b1d1:: with SMTP id r17mr94675892wra.273.1564051608781;
        Thu, 25 Jul 2019 03:46:48 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id f204sm72042696wme.18.2019.07.25.03.46.47
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 25 Jul 2019 03:46:48 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     stable@vger.kernel.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH stable-4.19 1/2] KVM: nVMX: do not use dangling shadow VMCS after guest reset
Date:   Thu, 25 Jul 2019 12:46:44 +0200
Message-Id: <20190725104645.30642-2-vkuznets@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190725104645.30642-1-vkuznets@redhat.com>
References: <20190725104645.30642-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit 88dddc11a8d6b09201b4db9d255b3394d9bc9e57 ]

If a KVM guest is reset while running a nested guest, free_nested will
disable the shadow VMCS execution control in the vmcs01.  However,
on the next KVM_RUN vmx_vcpu_run would nevertheless try to sync
the VMCS12 to the shadow VMCS which has since been freed.

This causes a vmptrld of a NULL pointer on my machime, but Jan reports
the host to hang altogether.  Let's see how much this trivial patch fixes.

Reported-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Liran Alon <liran.alon@oracle.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 73d6d585dd66..880bc36a0d5d 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -8457,6 +8457,7 @@ static void vmx_disable_shadow_vmcs(struct vcpu_vmx *vmx)
 {
 	vmcs_clear_bits(SECONDARY_VM_EXEC_CONTROL, SECONDARY_EXEC_SHADOW_VMCS);
 	vmcs_write64(VMCS_LINK_POINTER, -1ull);
+	vmx->nested.sync_shadow_vmcs = false;
 }
 
 static inline void nested_release_vmcs12(struct vcpu_vmx *vmx)
@@ -8468,7 +8469,6 @@ static inline void nested_release_vmcs12(struct vcpu_vmx *vmx)
 		/* copy to memory all shadowed fields in case
 		   they were modified */
 		copy_shadow_to_vmcs12(vmx);
-		vmx->nested.sync_shadow_vmcs = false;
 		vmx_disable_shadow_vmcs(vmx);
 	}
 	vmx->nested.posted_intr_nv = -1;
@@ -8668,6 +8668,9 @@ static void copy_shadow_to_vmcs12(struct vcpu_vmx *vmx)
 	u64 field_value;
 	struct vmcs *shadow_vmcs = vmx->vmcs01.shadow_vmcs;
 
+	if (WARN_ON(!shadow_vmcs))
+		return;
+
 	preempt_disable();
 
 	vmcs_load(shadow_vmcs);
@@ -8706,6 +8709,9 @@ static void copy_vmcs12_to_shadow(struct vcpu_vmx *vmx)
 	u64 field_value = 0;
 	struct vmcs *shadow_vmcs = vmx->vmcs01.shadow_vmcs;
 
+	if (WARN_ON(!shadow_vmcs))
+		return;
+
 	vmcs_load(shadow_vmcs);
 
 	for (q = 0; q < ARRAY_SIZE(fields); q++) {
-- 
2.20.1

