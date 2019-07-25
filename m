Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD7D74C14
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 12:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbfGYKqw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 06:46:52 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50655 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728288AbfGYKqw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jul 2019 06:46:52 -0400
Received: by mail-wm1-f67.google.com with SMTP id v15so44551473wml.0
        for <stable@vger.kernel.org>; Thu, 25 Jul 2019 03:46:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rT2+tyA6pTmguoDJ8MW+YlSOOFSIN1Vu53Mbq2U4pRc=;
        b=nEvicAJjHomgxt//LOzKlvaiTVlKBkTZ+7ulF/HzuAfhIQA3v+c4vW8mTtaU5L5m95
         UF0N+F33Qk4tPnfidQJ/4N7WKdJv+KPVfResNo8k6lqJ6S6Re/zU3ydNsoOsSLyEhTSE
         SVeDV2nX9BGR+7cTZhgQNcbYJGrWfPzVHo7tNDBLvGbTuswr6dBLX75UewLDFXQuJQxv
         AeO9OeRpzA5EmN0XiQyEkl0ZUUmHqlNWGJ3dz73SzbPuL4fNbknROWL7RcZa0cj4+Lg6
         fjFCYMZmAZAl+rERkKk7WKgSD1PWcoBcM5WJ0k0G/GscXIQ6/X1RCjXJC6iDeLxx0P5I
         RhGg==
X-Gm-Message-State: APjAAAViWyr22ao33seE5n+yWQAICqk7BUjB2E9AJRLfVOQasE2WvSC9
        JY2hpfHDXZToc3vb5ifPzA3y6uCwUmY=
X-Google-Smtp-Source: APXvYqwTcecpPSHGjHuXabH4BPu7LoiVzTbv2SdE24oH8xT1yDoFoSRpS5PQy97iHgQ88CuC5+fdjQ==
X-Received: by 2002:a7b:c7cb:: with SMTP id z11mr72257839wmk.24.1564051609799;
        Thu, 25 Jul 2019 03:46:49 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id f204sm72042696wme.18.2019.07.25.03.46.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 25 Jul 2019 03:46:49 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     stable@vger.kernel.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH stable-4.19 2/2] KVM: nVMX: Clear pending KVM_REQ_GET_VMCS12_PAGES when leaving nested
Date:   Thu, 25 Jul 2019 12:46:45 +0200
Message-Id: <20190725104645.30642-3-vkuznets@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190725104645.30642-1-vkuznets@redhat.com>
References: <20190725104645.30642-1-vkuznets@redhat.com>
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
 arch/x86/kvm/vmx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 880bc36a0d5d..4cf16378dffe 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -8490,6 +8490,8 @@ static void free_nested(struct vcpu_vmx *vmx)
 	if (!vmx->nested.vmxon && !vmx->nested.smm.vmxon)
 		return;
 
+	kvm_clear_request(KVM_REQ_GET_VMCS12_PAGES, &vmx->vcpu);
+
 	hrtimer_cancel(&vmx->nested.preemption_timer);
 	vmx->nested.vmxon = false;
 	vmx->nested.smm.vmxon = false;
-- 
2.20.1

