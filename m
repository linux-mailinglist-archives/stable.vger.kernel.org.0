Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE76111BE69
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 21:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727299AbfLKUs4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 15:48:56 -0500
Received: from mail-pl1-f202.google.com ([209.85.214.202]:35349 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727205AbfLKUsz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 15:48:55 -0500
Received: by mail-pl1-f202.google.com with SMTP id x9so55454plv.2
        for <stable@vger.kernel.org>; Wed, 11 Dec 2019 12:48:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=0uBm59z2CSkxE1Lwa309Nz0ygPbdvHmq/YUupdQxc7E=;
        b=I8V2k3Of6lRv1EDUC410FpR8FtBNQM0aht20sKEmAa2g/XoHx4ga+H6HGWK3VmCuRc
         wTNP5z9oSZKoLgQaiyZRfW3xul3WBjmcGmueZhYjDD73dzB9Pk28xF1dD4sse2hL8zCs
         jxasrPodRUF5TKbLIqwZEHjdr4+h3zVlhnWMAH3YR8JtbbJmHg/3dkQercCnt+w81iog
         QF9DyU5dmZwGDqQjdV8hbmxVUMt0l9lKPb2ajtxp0Of4aWkLYwN04vwYz55EgnrVXlpz
         J2cnKpCAoxhwh6R+UYYFI9d/vgFOs6CdW/2EtwTnyudLXsAeiI9rXMNbv63SXKTHu2dc
         9xWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=0uBm59z2CSkxE1Lwa309Nz0ygPbdvHmq/YUupdQxc7E=;
        b=gx8MbURXEN2b8DBkz1H8CxHXYAD3nftHwmK/EACvMJ2gjvW/coAFhI5noCrdHC27ao
         OVqsUAJPL547ip4LrGfK/dhfLU/PDLhoR82xBpT6uXBSR90Z/cRrLCW8hG0KpoXbj3IM
         jlsVLD3reo2dfc6iIgXNOu9FOw24O++CNLpVfPmtNdPS93y7Z1nB1MiBJJwS0N4/UYgL
         XhwcTfjoWQoVtjMexKvJ1nex/rgIP/3kMjey6VqZWM5TNX+7/PpKFKVG+KsPHmKSnk0a
         Vo5ab+L+kOO9V4EZjUmrZql77A72J7XX5/d0DcXSUXsn0gPnZlZDiAtuGksXSgqDrQyl
         7KtA==
X-Gm-Message-State: APjAAAXlvWRawfp0J8dDJKesPZV8qcFBIts4yR+Kd5qoMrk8kSnEltHd
        YXxE59PrVxT8nODT75zxKX2V1c04qtij
X-Google-Smtp-Source: APXvYqzpV4iFVXiUK5BQScN74ZwB27juWvlBDSrPZNfl+y/rATB6M5QAfuVVUKOtVW9B7wan1hPJvtR1w6Bp
X-Received: by 2002:a63:5525:: with SMTP id j37mr6269827pgb.180.1576097334639;
 Wed, 11 Dec 2019 12:48:54 -0800 (PST)
Date:   Wed, 11 Dec 2019 12:47:47 -0800
In-Reply-To: <20191211204753.242298-1-pomonis@google.com>
Message-Id: <20191211204753.242298-8-pomonis@google.com>
Mime-Version: 1.0
References: <20191211204753.242298-1-pomonis@google.com>
X-Mailer: git-send-email 2.24.0.525.g8f36a354ae-goog
Subject: [PATCH v2 07/13] KVM: x86: Protect MSR-based index computations in
 fixed_msr_to_seg_unit() from Spectre-v1/L1TF attacks
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

This fixes a Spectre-v1/L1TF vulnerability in fixed_msr_to_seg_unit().
This function contains index computations based on the
(attacker-controlled) MSR number.

Fixes: commit de9aef5e1ad6 ("KVM: MTRR: introduce fixed_mtrr_segment table")

Signed-off-by: Nick Finco <nifi@google.com>
Signed-off-by: Marios Pomonis <pomonis@google.com>
Reviewed-by: Andrew Honig <ahonig@google.com>
Cc: stable@vger.kernel.org
---
 arch/x86/kvm/mtrr.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
index 25ce3edd1872..7f0059aa30e1 100644
--- a/arch/x86/kvm/mtrr.c
+++ b/arch/x86/kvm/mtrr.c
@@ -192,11 +192,15 @@ static bool fixed_msr_to_seg_unit(u32 msr, int *seg, int *unit)
 		break;
 	case MSR_MTRRfix16K_80000 ... MSR_MTRRfix16K_A0000:
 		*seg = 1;
-		*unit = msr - MSR_MTRRfix16K_80000;
+		*unit = array_index_nospec(
+			msr - MSR_MTRRfix16K_80000,
+			MSR_MTRRfix16K_A0000 - MSR_MTRRfix16K_80000 + 1);
 		break;
 	case MSR_MTRRfix4K_C0000 ... MSR_MTRRfix4K_F8000:
 		*seg = 2;
-		*unit = msr - MSR_MTRRfix4K_C0000;
+		*unit = array_index_nospec(
+			msr - MSR_MTRRfix4K_C0000,
+			MSR_MTRRfix4K_F8000 - MSR_MTRRfix4K_C0000 + 1);
 		break;
 	default:
 		return false;
-- 
2.24.0.525.g8f36a354ae-goog

