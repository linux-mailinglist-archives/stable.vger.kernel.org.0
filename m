Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9670D11BE66
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 21:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbfLKUsu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 15:48:50 -0500
Received: from mail-pj1-f73.google.com ([209.85.216.73]:54765 "EHLO
        mail-pj1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727235AbfLKUst (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 15:48:49 -0500
Received: by mail-pj1-f73.google.com with SMTP id iq22so10536727pjb.21
        for <stable@vger.kernel.org>; Wed, 11 Dec 2019 12:48:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=hTNW3ODcCvFxOFPF3z95jUajN2yDUtML20vR5t2IREg=;
        b=dy2B3r+++dZl+ThGERMOVovQJLenKliQYHzqLXvVkDm/0uZ8Gq3hCRgZG7tyd84kSC
         vdk9fXkvOx45tG0X/9LZdpJ53i3mcwnbYwDT/z2mUEz6CF5qqnHx/UEYV7hMKX2L/5Oo
         BwjoIzsDdayWCwOFblKERarcaoxS0sRtURTgX+1+//NTSuTbTaH33yi5DOtom0S4lq99
         q+VJL0Dp1iY7Rap3CiKHhUUEccLEo67XSSOOFB/8NY4dDN5uw4tafg/feMXo5GKJ6uUV
         lHcfsBn1Ipdrjt/9jS4WdLQ3fw4u180ZNYPIOOr8WbI+cLMuRWTUky++KooaR2tV0dO9
         ITpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=hTNW3ODcCvFxOFPF3z95jUajN2yDUtML20vR5t2IREg=;
        b=CNqzb9Q54gLJ3/DKFjksOUDDNlLPBhSCwOYpvZ7YF1wUbiHtLtEoFl6BeA3DF1slMp
         LFikJTuED/Zz0XRotjX3E+1dFfM/ZVVRVdqfEZEtmj0l50c4U3F9PNAV0fOmS9fxB+tx
         H8zgg/mVG6SPoQ9OHxx0H/oR5JaLaOmhpq3DPl8ZnZ5u3DPhtkzj41a2/8HYFr+saT/L
         8U29k8An80mTgoqdG8bvHnlgqkDPKsfe5z/xN8HZUkYrQE9Z/wOZoRJz9Qath2vyv1+o
         1y6oIvPjDzX3LdoJFE3fQctH3w4GPA/ng+B/s3N1X2gsD7K6ULTkxcODgOKF0kS78ALI
         tSRA==
X-Gm-Message-State: APjAAAVVxtdB1XsuqSfMSVkrn61Xx3fTZ9B8ETZJxKD0qmoXwenzpcDR
        BVrgMU+5V8X992+26x13oEFNRNi6PpBC
X-Google-Smtp-Source: APXvYqxHJ71qg3FHMyk8lYMOq9M63OQ9kqtvkCKDj4/LJ57ylFSIwgHpaTerPBZmkwqI10yVqtfehV1zS4R6
X-Received: by 2002:a63:6c03:: with SMTP id h3mr5981055pgc.19.1576097328530;
 Wed, 11 Dec 2019 12:48:48 -0800 (PST)
Date:   Wed, 11 Dec 2019 12:47:46 -0800
In-Reply-To: <20191211204753.242298-1-pomonis@google.com>
Message-Id: <20191211204753.242298-7-pomonis@google.com>
Mime-Version: 1.0
References: <20191211204753.242298-1-pomonis@google.com>
X-Mailer: git-send-email 2.24.0.525.g8f36a354ae-goog
Subject: [PATCH v2 06/13] KVM: x86: Protect kvm_lapic_reg_write() from
 Spectre-v1/L1TF attacks
From:   Marios Pomonis <pomonis@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nick Finco <nifi@google.com>, Andrew Honig <ahonig@google.com>,
        Marios Pomonis <pomonis@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This fixes a Spectre-v1/L1TF vulnerability in kvm_lapic_reg_write().
This function contains index computations based on the
(attacker-controlled) MSR number.

Fixes: commit 0105d1a52640 ("KVM: x2apic interface to lapic")

Signed-off-by: Nick Finco <nifi@google.com>
Signed-off-by: Marios Pomonis <pomonis@google.com>
Reviewed-by: Andrew Honig <ahonig@google.com>
Cc: stable@vger.kernel.org
---
 arch/x86/kvm/lapic.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index cf9177b4a07f..3323115f52d5 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1963,15 +1963,20 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 	case APIC_LVTTHMR:
 	case APIC_LVTPC:
 	case APIC_LVT1:
-	case APIC_LVTERR:
+	case APIC_LVTERR: {
 		/* TODO: Check vector */
+		size_t size;
+		u32 index;
+
 		if (!kvm_apic_sw_enabled(apic))
 			val |= APIC_LVT_MASKED;
-
-		val &= apic_lvt_mask[(reg - APIC_LVTT) >> 4];
+		size = ARRAY_SIZE(apic_lvt_mask);
+		index = array_index_nospec(
+				(reg - APIC_LVTT) >> 4, size);
+		val &= apic_lvt_mask[index];
 		kvm_lapic_set_reg(apic, reg, val);
-
 		break;
+	}
 
 	case APIC_LVTT:
 		if (!kvm_apic_sw_enabled(apic))
-- 
2.24.0.525.g8f36a354ae-goog

