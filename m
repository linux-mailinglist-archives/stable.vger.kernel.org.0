Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A24B4480C
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 19:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393352AbfFMRD7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 13:03:59 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52762 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393330AbfFMRD6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 13:03:58 -0400
Received: by mail-wm1-f68.google.com with SMTP id s3so10999160wms.2;
        Thu, 13 Jun 2019 10:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SqYVNQRBQw0+2e1mPaeiDvtM5nLFIn1D7Ljqw3ZywMo=;
        b=TYaI8jjmk9KxUXZNJjXkRAVLM2Brwz407vEC/bcauH5iRyzVldhglUYZ3Yo/nsXhjp
         oBiSkYJXvgEW6JkTgi5u5wIqGd7oC7jmSPJltHSmlnXSP+hOoP6BkAmURr24z2kkOZxJ
         lV8lY6LiTbkkE5J2qtjQ/JS567apJZmRuv7B9IL3/jmSJ8DJyX+lK3Yc42+mbn8BiQ0W
         Bhjm/yLT2Q6owjZBjrMLbeSpjarboR3C4F6JXSwHcpQMKSBNMjNLk1OnYI64EzQ+0okj
         Y59j08d5y4wxM2ElCGHjgZkaIr1FN88niE2KbXURjz2OUd5Zc1y2HzNnwCrC7tnokEFv
         Nj6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=SqYVNQRBQw0+2e1mPaeiDvtM5nLFIn1D7Ljqw3ZywMo=;
        b=frk1NxdmB4oJLjyd/doWLRXa1SMPg7Cyi3TBp3k8863Qr4PZN9ALKdHc8Y2opSExDa
         HVRpIeydQ3uP9oUj/NQx7LeYt4j/rIqwwD8KdoJJieoeqNj3Ty6Tu4qvg6/66Uhx41CV
         XZif6cgmD88MuLF3SdHJ4gAvwmM7dtC126HZ2Qb9fZxCV/iGAY+u90odryYXfGLQmlOx
         pFxtEepoGDkcCkgFPsIpwUo+uXt+krdNNCU7AdRpxbBqZDuUXO5VW0Hc//6J4maZ0FXa
         9tKO0QHebuRbsbv4FOiPvvSq2RQ+F2t8oSu5vXCMyAvQMFgd83KsLwFOSDAy5XQuPxjk
         vgxg==
X-Gm-Message-State: APjAAAUQ7LPQsLbtFXjlwRRuK1IZ3nq2l+hCxvjWUEosQA1bSm0kO3GJ
        oCfX1NxZVluGCQvl+sTeH049QhJ4
X-Google-Smtp-Source: APXvYqxWkWCctKupl/0mrqa7ZlTzrrIthPcWeQJbQbeonu5tL2b5U7zxqveNlAqO1ZshP1Z78tAxyg==
X-Received: by 2002:a1c:c011:: with SMTP id q17mr4668764wmf.105.1560445435991;
        Thu, 13 Jun 2019 10:03:55 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a10sm341856wrx.17.2019.06.13.10.03.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:03:55 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        vkuznets@redhat.com, stable@vger.kernel.org
Subject: [PATCH 22/43] KVM: nVMX: Don't dump VMCS if virtual APIC page can't be mapped
Date:   Thu, 13 Jun 2019 19:03:08 +0200
Message-Id: <1560445409-17363-23-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

... as a malicious userspace can run a toy guest to generate invalid
virtual-APIC page addresses in L1, i.e. flood the kernel log with error
messages.

Fixes: 690908104e39d ("KVM: nVMX: allow tests to use bad virtual-APIC page address")
Cc: stable@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 9478d8947595..0f4cb473bd36 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2880,9 +2880,6 @@ static void nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 			 */
 			vmcs_clear_bits(CPU_BASED_VM_EXEC_CONTROL,
 					CPU_BASED_TPR_SHADOW);
-		} else {
-			printk("bad virtual-APIC page address\n");
-			dump_vmcs();
 		}
 	}
 
-- 
1.8.3.1


