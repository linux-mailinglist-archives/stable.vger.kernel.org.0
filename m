Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8F1811BE7D
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 21:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727310AbfLKUtF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 15:49:05 -0500
Received: from mail-vk1-f202.google.com ([209.85.221.202]:56489 "EHLO
        mail-vk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726860AbfLKUtF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 15:49:05 -0500
Received: by mail-vk1-f202.google.com with SMTP id y28so93640vkl.23
        for <stable@vger.kernel.org>; Wed, 11 Dec 2019 12:49:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=A6I91kn+0yQQJKIUv7rdcMWQv4VGfJnYJ3un85npOfQ=;
        b=EmaCb3MiHl905ggtmxlJYSNqiwbYOAuAXhBhx69L2hwmQkZB6mjkAksiMXjhmz+OtF
         xmt7gQw56ElZvY5gGaxcgRhWMdGMmJACrKJfuY0grAAY84Ehrt+pnphAdosVfe5bDP9+
         sxKD5FArmwJOfsa4pqK6ONiWhVbhIxjKINQOCnTs+eW/kcqhpVkDGog90OjcTAMlqBLQ
         ttdtfVcrQZ2vt74tvWjJ9SHYGNncd5x0OZYu6Y7TuMHQEsGrxHdN7tPv8h/t8/HFNpGr
         r/2IaW++GswPF7pTR3TfwfvKi8iv1te0lISWln3rg9S0egpCMa1QYvTqOgqRKqyX5wkN
         lzZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=A6I91kn+0yQQJKIUv7rdcMWQv4VGfJnYJ3un85npOfQ=;
        b=UyRkc9KowldLqPydpcb6kEuHyBarFkVCG7O5TNUCRZdrw1d/ruQRm+CqpZLlxIBQrN
         f08rCDr0NH8tyQEFqc3oHokSmCVlCdlAqMmiDWfxT+f6gRHgZDQt+Zdx7elaaP/wbr2e
         LhBo18Xqst+4a0r26pN/mWEEzklRuDh6K5UHf1/NySmGg/Y4eo/SOHA3HgGNz+/9bOSM
         ki9t0TV9F0Fi1zjy/sV2iZtiRpR8m8tQqVX/GCm6hQjxr555C/JWXTlet0tjj6Hj6Yj3
         NgzGVycSfUpwFCJEwsRiC0mPzf0IvBZeBdP14baxOmOPBifY8MWUFZ0ctG8YtToiiNJN
         GnFw==
X-Gm-Message-State: APjAAAXMz1kXmxTI8NYbDIaRc6iHuqdjhygGjvoyskkgG2M6z46Ei4IL
        SBc3ciemlo36G8GqA3ipNUSEodUIEV3E
X-Google-Smtp-Source: APXvYqxYKbpMOFlEoq+ZH2tIHn/2L1Xloe/h78oCH4+jdaMBYEQpa98yHc+TJpc2Wd+5EcHpPj74uIY7mZXl
X-Received: by 2002:a1f:1785:: with SMTP id 127mr5599428vkx.74.1576097343861;
 Wed, 11 Dec 2019 12:49:03 -0800 (PST)
Date:   Wed, 11 Dec 2019 12:47:50 -0800
In-Reply-To: <20191211204753.242298-1-pomonis@google.com>
Message-Id: <20191211204753.242298-11-pomonis@google.com>
Mime-Version: 1.0
References: <20191211204753.242298-1-pomonis@google.com>
X-Mailer: git-send-email 2.24.0.525.g8f36a354ae-goog
Subject: [PATCH v2 10/13] KVM: x86: Protect memory accesses from
 Spectre-v1/L1TF attacks in x86.c
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

This fixes Spectre-v1/L1TF vulnerabilities in
vmx_read_guest_seg_selector(), vmx_read_guest_seg_base(),
vmx_read_guest_seg_limit() and vmx_read_guest_seg_ar().
These functions contain index computations based on the
(attacker-influenced) segment value.

Fixes: commit 2fb92db1ec08 ("KVM: VMX: Cache vmcs segment fields")

Signed-off-by: Nick Finco <nifi@google.com>
Signed-off-by: Marios Pomonis <pomonis@google.com>
Reviewed-by: Andrew Honig <ahonig@google.com>
Cc: stable@vger.kernel.org
---
 arch/x86/kvm/vmx/vmx.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d39475e2d44e..82b25f1812aa 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -753,7 +753,9 @@ static bool vmx_segment_cache_test_set(struct vcpu_vmx *vmx, unsigned seg,
 
 static u16 vmx_read_guest_seg_selector(struct vcpu_vmx *vmx, unsigned seg)
 {
-	u16 *p = &vmx->segment_cache.seg[seg].selector;
+	size_t size = ARRAY_SIZE(vmx->segment_cache.seg);
+	size_t index = array_index_nospec(seg, size);
+	u16 *p = &vmx->segment_cache.seg[index].selector;
 
 	if (!vmx_segment_cache_test_set(vmx, seg, SEG_FIELD_SEL))
 		*p = vmcs_read16(kvm_vmx_segment_fields[seg].selector);
@@ -762,7 +764,9 @@ static u16 vmx_read_guest_seg_selector(struct vcpu_vmx *vmx, unsigned seg)
 
 static ulong vmx_read_guest_seg_base(struct vcpu_vmx *vmx, unsigned seg)
 {
-	ulong *p = &vmx->segment_cache.seg[seg].base;
+	size_t size = ARRAY_SIZE(vmx->segment_cache.seg);
+	size_t index = array_index_nospec(seg, size);
+	ulong *p = &vmx->segment_cache.seg[index].base;
 
 	if (!vmx_segment_cache_test_set(vmx, seg, SEG_FIELD_BASE))
 		*p = vmcs_readl(kvm_vmx_segment_fields[seg].base);
@@ -771,7 +775,9 @@ static ulong vmx_read_guest_seg_base(struct vcpu_vmx *vmx, unsigned seg)
 
 static u32 vmx_read_guest_seg_limit(struct vcpu_vmx *vmx, unsigned seg)
 {
-	u32 *p = &vmx->segment_cache.seg[seg].limit;
+	size_t size = ARRAY_SIZE(vmx->segment_cache.seg);
+	size_t index = array_index_nospec(seg, size);
+	u32 *p = &vmx->segment_cache.seg[index].limit;
 
 	if (!vmx_segment_cache_test_set(vmx, seg, SEG_FIELD_LIMIT))
 		*p = vmcs_read32(kvm_vmx_segment_fields[seg].limit);
@@ -780,7 +786,9 @@ static u32 vmx_read_guest_seg_limit(struct vcpu_vmx *vmx, unsigned seg)
 
 static u32 vmx_read_guest_seg_ar(struct vcpu_vmx *vmx, unsigned seg)
 {
-	u32 *p = &vmx->segment_cache.seg[seg].ar;
+	size_t size = ARRAY_SIZE(vmx->segment_cache.seg);
+	size_t index = array_index_nospec(seg, size);
+	u32 *p = &vmx->segment_cache.seg[index].ar;
 
 	if (!vmx_segment_cache_test_set(vmx, seg, SEG_FIELD_AR))
 		*p = vmcs_read32(kvm_vmx_segment_fields[seg].ar_bytes);
-- 
2.24.0.525.g8f36a354ae-goog

