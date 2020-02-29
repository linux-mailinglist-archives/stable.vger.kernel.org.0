Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8211748E2
	for <lists+stable@lfdr.de>; Sat, 29 Feb 2020 20:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbgB2Ta1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Feb 2020 14:30:27 -0500
Received: from mail-pg1-f202.google.com ([209.85.215.202]:37048 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727102AbgB2Ta0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Feb 2020 14:30:26 -0500
Received: by mail-pg1-f202.google.com with SMTP id q29so4105314pgk.4
        for <stable@vger.kernel.org>; Sat, 29 Feb 2020 11:30:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zN9W9s3tt491wsnTdiI9FOLxD/Do99w+fhxd16Xg1BY=;
        b=H6fOuXZWG6Gmg2u0weRkAjplqipjfftT45Au+HJwKOA76nFIdZXu3E9erT+Eq7vgav
         RwJaQO3vVoKIN/1fZI7iXsk00/J5BEyRLssxY14MVSTpnggWkH1mEivpveZnZ3PQI6iM
         kQVzPijSvSWogcX1IpBxE5wTofMXvS/C99X/8LZvuK/zx9AZJ5Z5dI44vliL0WmCqqFN
         x76MiyPCZMvMOFzxM60Ly9aAmGwR7htbsNL0Af4nPxCnQ8tDPN7ZAz316o2cFM5w3AD9
         jR/oNQ8knQpCP4tW8Pci6j8rtQQD8SssYNoxqApjTfnIGbZ6RohdEkNtb7k9jBGb3mcJ
         OYxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zN9W9s3tt491wsnTdiI9FOLxD/Do99w+fhxd16Xg1BY=;
        b=F2QGTT4aU6x1Mz0Un4vOpS1O8eHT1P5Jj4I2fMvVDehoDM1+jG7TzoFQ8t40DaKad5
         FiFYBfQlC2H67kKKU+a+r2CZMtZvJuyY1QRi26vx6czDG7Id+eiGwftN+CXc/uvZWDBk
         rJ0loinU4IzmoJlbbap+9d74ZLD1Km+eYbebv99T/0PGzsULqEmMi6it9LD7a2tvJ8FC
         N7G6HUX9ctL5dAcAZkboWDr7PEy4UY1vxebOvQSsnlgWDCykSURH/4LPtT6Qr75X1g7p
         j2+PryjXzkTNsP2XckZkw8InTk2BJt3hu99D5Rs8xjI94t/EiwzSQ3C2dqNNR+7n1GuG
         /LYA==
X-Gm-Message-State: APjAAAVO2T41cXaZzKymMvrfpqo40YrLT2se0eNSTF9BBHhFTZwbqzZM
        4HBo61Tyne4sU5+9YeUzq+7QZ6n2S2o=
X-Google-Smtp-Source: APXvYqyNjIU+ikUX/0d+vVdKRVbkUdm8fqhXOh6WEkz04PCj0Qrl9MJT3wDbQrX+snIufKZ/yRAnKMfHG2s=
X-Received: by 2002:a65:5948:: with SMTP id g8mr11544791pgu.161.1583004625445;
 Sat, 29 Feb 2020 11:30:25 -0800 (PST)
Date:   Sat, 29 Feb 2020 11:30:14 -0800
In-Reply-To: <e8fe4664-d948-f239-4ec9-82d9010b7d26@web.de>
Message-Id: <20200229193014.106806-1-oupton@google.com>
Mime-Version: 1.0
References: <e8fe4664-d948-f239-4ec9-82d9010b7d26@web.de>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [PATCH] KVM: VMX: check descriptor table exits on instruction emulation
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Oliver Upton <oupton@google.com>, Jan Kiszka <jan.kiszka@web.de>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

KVM emulates UMIP on hardware that doesn't support it by setting the
'descriptor table exiting' VM-execution control and performing
instruction emulation. When running nested, this emulation is broken as
KVM refuses to emulate L2 instructions by default.

Correct this regression by allowing the emulation of descriptor table
instructions if L1 hasn't requested 'descriptor table exiting'.

Fixes: 07721feee46b ("KVM: nVMX: Don't emulate instructions in guest mode")
Reported-by: Jan Kiszka <jan.kiszka@web.de>
Cc: stable@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Jim Mattson <jmattson@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 63aaf44edd1f..e718b4c9455f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7204,6 +7204,17 @@ static int vmx_check_intercept(struct kvm_vcpu *vcpu,
 	case x86_intercept_outs:
 		return vmx_check_intercept_io(vcpu, info);
 
+	case x86_intercept_lgdt:
+	case x86_intercept_lidt:
+	case x86_intercept_lldt:
+	case x86_intercept_ltr:
+	case x86_intercept_sgdt:
+	case x86_intercept_sidt:
+	case x86_intercept_sldt:
+	case x86_intercept_str:
+		if (!nested_cpu_has2(vmcs12, SECONDARY_EXEC_DESC))
+			return X86EMUL_CONTINUE;
+
 	/* TODO: check more intercepts... */
 	default:
 		break;
-- 
2.25.0.265.gbab2e86ba0-goog

