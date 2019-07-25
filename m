Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B339E74D79
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 13:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404331AbfGYLtp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 07:49:45 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51954 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404315AbfGYLto (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jul 2019 07:49:44 -0400
Received: by mail-wm1-f67.google.com with SMTP id 207so44716060wma.1
        for <stable@vger.kernel.org>; Thu, 25 Jul 2019 04:49:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z59Fx3FchhtcYpGTAy6/0+pqXBGTFpbIQm7SLJs066s=;
        b=Nbzv5eicPKfOyrBeNMAvC78OJ8lJK9qD4Njy8TwIMAu2DWb9T2BPBjrfbWusnLKlxw
         4Wc9EWHnsk6sovY9GgYWI4yJGjV0YZLHp0zvdqzxdQQaxdQgQIBfyIeLRH1LcsmQKLM9
         C21EEca81RP+zvBxjHAHE2hYKm1wzopCKG4TYJutqEqS/R0gwUegC+wpDifGUOfBGobm
         gTfJ0urVDh6vAurgh8aCABNk8d1ZONwvrbd9FNZQGGxlO/PtQsx9FAywafTqW68wkHOy
         66CS5d2g8m+KANhLwYNpIfgs9PBoKK15jITVZgA91YmUAZCMHoVFj7qKemaxImkLQTNE
         nTPg==
X-Gm-Message-State: APjAAAV+cTKnA6q0+SXnMzoYE+RYUG2fPc8Pn6JuEYsxiS0g+93vpVH3
        /FdAbgzRSg2O6ED7LXbLOHtvH0t74Zs=
X-Google-Smtp-Source: APXvYqxRX1Odd/FqOub1CpfyIe42j8zssRTmGESC5RT9PX9QN36ChMZZssuNdKvI3JcnDGwivfGf1A==
X-Received: by 2002:a7b:c0c6:: with SMTP id s6mr3698651wmh.115.1564055382411;
        Thu, 25 Jul 2019 04:49:42 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id t140sm44784683wmt.0.2019.07.25.04.49.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 25 Jul 2019 04:49:41 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     stable@vger.kernel.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH stable-5.1 2/3] KVM: nVMX: Clear pending KVM_REQ_GET_VMCS12_PAGES when leaving nested
Date:   Thu, 25 Jul 2019 13:49:37 +0200
Message-Id: <20190725114938.3976-3-vkuznets@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190725114938.3976-1-vkuznets@redhat.com>
References: <20190725114938.3976-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

[ Upstream commit cf64527bb33f6cec2ed50f89182fc4688d0056b6 ]

Letting this pend may cause nested_get_vmcs12_pages to run against an
invalid state, corrupting the effective vmcs of L1.

This was triggerable in QEMU after a guest corruption in L2, followed by
a L1 reset.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Reviewed-by: Liran Alon <liran.alon@oracle.com>
Cc: stable@vger.kernel.org
Fixes: 7f7f1ba33cf2 ("KVM: x86: do not load vmcs12 pages while still in SMM")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 3f48006a43ec..f78975d4a7fa 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -212,6 +212,8 @@ static void free_nested(struct kvm_vcpu *vcpu)
 	if (!vmx->nested.vmxon && !vmx->nested.smm.vmxon)
 		return;
 
+	kvm_clear_request(KVM_REQ_GET_VMCS12_PAGES, vcpu);
+
 	vmx->nested.vmxon = false;
 	vmx->nested.smm.vmxon = false;
 	free_vpid(vmx->nested.vpid02);
-- 
2.20.1

