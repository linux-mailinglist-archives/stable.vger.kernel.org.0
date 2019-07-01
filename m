Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7975D4CA27
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 11:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730930AbfFTJAX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 05:00:23 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41927 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbfFTJAX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jun 2019 05:00:23 -0400
Received: by mail-pf1-f196.google.com with SMTP id m30so1283072pff.8;
        Thu, 20 Jun 2019 02:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9mZWqiev/Unq+yxOlmq3nGcEHMBANDGewZajCQ6YEDc=;
        b=L+l5mzWSPYtd/+Wi+/zSnb5yNtada/zpZySwqsUYKxYWVBKOEHKvVYyZlCcYP9FgSx
         iZ8sn1PyIlIsNgAZwv5u3ACfuqqRYXRK4F66zRUOO2GV8E4JzC7aGd7CIvtJP+SnnuW4
         k7btPQZ9mYK+zfe0aD9zT44YutP+6UfBkpyRM2WtFVV04IjBTyBzOuW9G1L4NRun8shm
         AOxFkJJWtrD/bjNkJw0kpsHPt8LCoPPr5r6nLWr/ip0SWUtFq/1G3hnwt5EgGiZBF62+
         q1fkVqvKcyCNhrcgQTc6tkYd2f3batVtm/coERP1czagBsyyvLPnBiIrpEFhIM4mGoNz
         pjZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9mZWqiev/Unq+yxOlmq3nGcEHMBANDGewZajCQ6YEDc=;
        b=D/pP/4kEj0TN6Rty6IuvZY96yYPdUbeCCOgzfOmt1yNeImXmWJCdUinuWSR7L3VLlq
         YBZZRQUtbGmjOX18ADu7y0v1eBoEWw1D/UyIHPHrhG/diX/RMYT0hI3Oy3yDP5eIbRpQ
         e0b9kr/A7WCVXo06wqySvXsVmK8bN7jAWhNqel/Xpok6N0fxrl8yPGrOIrL9sZH0irps
         aEY08ml7+19rtifelSBKoQdkQ/3Ghdba2fhhLgBRoK8G3MmQiZ8sU+WPn4mlHGOXe2lF
         5f9kdtNMyVi1a4x+kfPXqZyIaUjcdJBudDXja8t2XqVxgIed4A9Gum5Cvkjt0b573vhq
         tQcg==
X-Gm-Message-State: APjAAAVYr/IMZ1CMwO4y1IJsLCKvMyrWZRkGXqFb050rGVqOxFVEYqsr
        i+g/TkXRPuC9YH1DjPaEsYQ4DDHZ
X-Google-Smtp-Source: APXvYqzo+rTxgjrUjGfk8CKkbLda89Le3yKz/DFV96t5ocCNur5kDi3FfMOVzimVD6FNIpdb75xktQ==
X-Received: by 2002:aa7:8294:: with SMTP id s20mr119818264pfm.75.1561021222275;
        Thu, 20 Jun 2019 02:00:22 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id h62sm23183321pgc.54.2019.06.20.02.00.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 20 Jun 2019 02:00:21 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        stable@vger.kernel.org
Subject: [PATCH] KVM: VMX: Raise #GP when guest read/write forbidden IA32_XSS
Date:   Thu, 20 Jun 2019 17:00:02 +0800
Message-Id: <1561021202-13789-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Raise #GP when guest read/write forbidden IA32_XSS.  

Fixes: 203000993de5 (kvm: vmx: add MSR logic for XSAVES) 
Reported-by: Xiaoyao Li <xiaoyao.li@linux.intel.com>
Reported-by: Tao Xu <tao3.xu@intel.com>
Cc: Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/vmx/vmx.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b939a68..d174b62 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1732,7 +1732,10 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		return vmx_get_vmx_msr(&vmx->nested.msrs, msr_info->index,
 				       &msr_info->data);
 	case MSR_IA32_XSS:
-		if (!vmx_xsaves_supported())
+		if (!vmx_xsaves_supported() ||
+			(!msr_info->host_initiated &&
+			!(guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
+			guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))))
 			return 1;
 		msr_info->data = vcpu->arch.ia32_xss;
 		break;
@@ -1962,7 +1965,10 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		return vmx_set_vmx_msr(vcpu, msr_index, data);
 	case MSR_IA32_XSS:
-		if (!vmx_xsaves_supported())
+		if (!vmx_xsaves_supported() ||
+			(!msr_info->host_initiated &&
+			!(guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
+			guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))))
 			return 1;
 		/*
 		 * The only supported bit as of Skylake is bit 8, but
-- 
2.7.4

