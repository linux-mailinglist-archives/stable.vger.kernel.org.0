Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF991100B57
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 19:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfKRSR6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 13:17:58 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42038 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbfKRSRy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Nov 2019 13:17:54 -0500
Received: by mail-wr1-f68.google.com with SMTP id a15so20684366wrf.9;
        Mon, 18 Nov 2019 10:17:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xuKE2SmFgctrg1WssQn4ZdOCP9av/DCBktsiIBAJY9w=;
        b=F9NFiZtCXptg/YQCw2GdCexki51nGWmL9R85iUJUQlm25ZJZ0EF27N1UBN8Tpg1mUr
         aJ9eH6X3u4U7SmVKsgajMNGmLGI9m2Gu1vgjObhH1splv5g3BLgVYpAmnk59RxQUb2Vd
         e7wG+rYJs1VEC7XIRMt7ZIlZ1S/x8qI5uBmgvjFTiMoEL7srgfquLW+t3ou+wJGN/Us2
         zKL/A/IgIbNgVRRrJjyWifAP7eSLJ2A9K0nW/g8Gq+29IyHa0FXLGgSqWHVwnWUWps+A
         nK8DlqgcvFFJcx8i/cK+zTEZoMk5NYdtXN1X1YKkUmiUFmxnOJ1UXPvsjUrkLPFDeDnn
         c5Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=xuKE2SmFgctrg1WssQn4ZdOCP9av/DCBktsiIBAJY9w=;
        b=HijLB4nVT0NgIfiBiwaUYzmEMJrjmld/ZAxi6p9Jdbh3V8oMTHmy/+ELkunxy2eck5
         pgWPFCxxsx6JgVD1CbLF4jkEnQwnjFpndLa238h2Q80ch89Epn/FC0p5t4Pc9yU7Xkam
         OW5HIXe2SAx/Q70Ze+kA8bUBzSJ0JDvBCRm4apV4SkUmZIxqLZWvwRa+2nDwM5rfVqLy
         z2/CrhJY5JzS4cv7ME+LvAblzDjrRxp5HrglZyLOojYxIHciZ+Hr7IKGvTQTO4mNA+Nd
         nb7DbS+0+wK7y0FIvQv8txGveJ5P77pxGs2j4VOuwFOxjQNpmL9ixk2mFqDVvWE09vpN
         TqRQ==
X-Gm-Message-State: APjAAAXDGApqXAz5ReObmJJmQAVNAwk3mvxaKPH1CuVTVcITjAtaUIgh
        3VZZMej+p5Cfa/yPz4Q0htdxx0Yx
X-Google-Smtp-Source: APXvYqzhyJ4Kh/a6galI0gjAkld4KLQic+pfcqsfZ4JLq3E9hN5NJdv2AysoklmRZ65fyziweX6Jqw==
X-Received: by 2002:adf:f445:: with SMTP id f5mr33093504wrp.193.1574101072269;
        Mon, 18 Nov 2019 10:17:52 -0800 (PST)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id v81sm233794wmg.4.2019.11.18.10.17.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Nov 2019 10:17:51 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jmattson@google.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/5] KVM: x86: fix presentation of TSX feature in ARCH_CAPABILITIES
Date:   Mon, 18 Nov 2019 19:17:43 +0100
Message-Id: <1574101067-5638-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574101067-5638-1-git-send-email-pbonzini@redhat.com>
References: <1574101067-5638-1-git-send-email-pbonzini@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

KVM does not implement MSR_IA32_TSX_CTRL, so it must not be presented
to the guests.  It is also confusing to have !ARCH_CAP_TSX_CTRL_MSR &&
!RTM && ARCH_CAP_TAA_NO: lack of MSR_IA32_TSX_CTRL suggests TSX was not
hidden (it actually was), yet the value says that TSX is not vulnerable
to microarchitectural data sampling.  Fix both.

Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5d530521f11d..6ea735d632e9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1327,12 +1327,18 @@ static u64 kvm_get_arch_capabilities(void)
 	 * If TSX is disabled on the system, guests are also mitigated against
 	 * TAA and clear CPU buffer mitigation is not required for guests.
 	 */
-	if (boot_cpu_has_bug(X86_BUG_TAA) && boot_cpu_has(X86_FEATURE_RTM) &&
-	    (data & ARCH_CAP_TSX_CTRL_MSR))
+	if (!boot_cpu_has(X86_FEATURE_RTM))
+		data &= ~ARCH_CAP_TAA_NO;
+	else if (!boot_cpu_has_bug(X86_BUG_TAA))
+		data |= ARCH_CAP_TAA_NO;
+	else if (data & ARCH_CAP_TSX_CTRL_MSR)
 		data &= ~ARCH_CAP_MDS_NO;
 
+	/* KVM does not emulate MSR_IA32_TSX_CTRL.  */
+	data &= ~ARCH_CAP_TSX_CTRL_MSR;
 	return data;
 }
+EXPORT_SYMBOL_GPL(kvm_get_arch_capabilities);
 
 static int kvm_get_msr_feature(struct kvm_msr_entry *msr)
 {
-- 
1.8.3.1


