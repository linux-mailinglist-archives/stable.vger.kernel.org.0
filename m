Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0815D253
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 17:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbfGBPEs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 11:04:48 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39712 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbfGBPEn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jul 2019 11:04:43 -0400
Received: by mail-wm1-f67.google.com with SMTP id z23so1399682wma.4;
        Tue, 02 Jul 2019 08:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZRNHlXUigXjGU5a3lZWUqJMuxAc6p2T+k9d3I5VYScQ=;
        b=Tetkj5G0/Te2mIwrsStd90h3ChcvHTEZq0KzFhLk1LBcqcarl3rWKPN9x1KvidfSNi
         Mp5OCpWeGRCD5izJ/6U8AYI8CIkFbZvKBWgYefKeY456FrecoLo7pbcBcxToZs5xIg4x
         c8QgsvhGF6uEF6ZILMKlbzhassjEc8S60AsYg2E+YITt2ZhFi8jxgfuHYRZfN55rJd1t
         PlgOqHAW2NY7It1B7/+Wj8WEEtRZXDEr/QkzVVm5gwBdcu1ksiDgvQwiOZ1itaG2xumR
         swvjMIP27aMttemB8V9WoLQReScLMmBEcj9Bwzf8Veyk0PyKl76ptbdEewPW2Gt1iMS7
         qy3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=ZRNHlXUigXjGU5a3lZWUqJMuxAc6p2T+k9d3I5VYScQ=;
        b=blRd2Usyqq0AqpW5uIxd/SGnjeX9rl/PrClRI9FcvnsNtKlsrd0LtI/PIZs52gXRs3
         kwhTPYLyt0RKeib2bu6Z7Fz9tNa9vZwSTs38hKeG4VU5LeCEMOQAsd+4lWveydcqeU3f
         T+XMN4QzPSvGbimrCQ0/HdEXf4n40xyNjv9RwuiJo5gu4T/HyHHrZf7BiSB1uUpeHmAb
         DbyBSwy3Ete+sVnAVT6kSvulSxx4zH9UBDd9PbSKtLrp5VPCay8bFAapHbNQEk+J2n2f
         mOrnuQJxXxfmmLOyysGbmZbL7PH4b0oPkWvWMc6XO+67jqAYZw5ANyVgSV9V9MHNj7VM
         iN4A==
X-Gm-Message-State: APjAAAXXQ0H/Iiwc540OJaPg5mBbYV9J67YUfjRCIlB16e71Uf8uZhE9
        rK6GX2zJJXyidEF2u6pKQAFQ0BHCqno=
X-Google-Smtp-Source: APXvYqxVsiR+PKXuwyeeuUHR/y+wM9C1MpcG3pmuOVHiatR1t0bY2kAeqgOE3d9q0Y9zA0ES9LQjpw==
X-Received: by 2002:a05:600c:204c:: with SMTP id p12mr3751294wmg.121.1562079880395;
        Tue, 02 Jul 2019 08:04:40 -0700 (PDT)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id b203sm3494191wmd.41.2019.07.02.08.04.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 08:04:39 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Liran Alon <liran.alon@oracle.com>, stable@vger.kernel.org
Subject: [PATCH 2/3] KVM: nVMX: allow setting the VMFUNC controls MSR
Date:   Tue,  2 Jul 2019 17:04:35 +0200
Message-Id: <1562079876-20756-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562079876-20756-1-git-send-email-pbonzini@redhat.com>
References: <1562079876-20756-1-git-send-email-pbonzini@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Allow userspace to set a custom value for the VMFUNC controls MSR, as long
as the capabilities it advertises do not exceed those of the host.

Fixes: 27c42a1bb ("KVM: nVMX: Enable VMFUNC for the L1 hypervisor", 2017-08-03)
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index c4e29ef0b21e..163d226efa96 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1234,6 +1234,11 @@ int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 	case MSR_IA32_VMX_VMCS_ENUM:
 		vmx->nested.msrs.vmcs_enum = data;
 		return 0;
+	case MSR_IA32_VMX_VMFUNC:
+		if (data & ~vmx->nested.msrs.vmfunc_controls)
+			return -EINVAL;
+		vmx->nested.msrs.vmfunc_controls = data;
+		return 0;
 	default:
 		/*
 		 * The rest of the VMX capability MSRs do not support restore.
-- 
1.8.3.1


