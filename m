Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE9C112EBB
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 16:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728366AbfLDPks (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 10:40:48 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42430 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728357AbfLDPkl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Dec 2019 10:40:41 -0500
Received: by mail-wr1-f68.google.com with SMTP id a15so9144050wrf.9;
        Wed, 04 Dec 2019 07:40:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=3CWC98h+5raJqQO+ka9hGiDloggJe6dDITvR1rS981E=;
        b=LkEmcI4TGNSbygcJ7Cko+s9jE4BlWzkAAeKiWUTHaBfr1yAo7wjnpKwN1v9UuMx65t
         pVyFemQvkAQP4sTma62IrTHQJ7WI6CHPm+t8RcqfXnJ+Edn+3dAu6Ay138Uq+Nd+BG8W
         7F+vqfv2mPGubnmF3tOpfnqMAxKjleNr67b4Y2neErbm/mGF4i4RitGjxfgNhn/cZOIL
         zKT/Uk9ijI5xzkpnLzA0o6iXP0ECKT4myNr9sII/seqoKUdblE2IyonZ8c1j72peaK5I
         RB6Ih+LIi+kJiwXcwP4pgSCroZKNZGxPGP6yU8fAj0vW54DCYUInhLM7NL1c3eEfJZEe
         SXvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=3CWC98h+5raJqQO+ka9hGiDloggJe6dDITvR1rS981E=;
        b=G71MsSE1Kf4zhZRgrYj1D5afo77NuagSHrufcg+dxhsVt4IQBlpmclsMQCvsR+/sbn
         nLE3vxtDdgaHzuOmfnhgBV1lafXTygDXPoTsPo8hB6xa4uOxr3T4N67moT48MczYi0SL
         8E1ii1MZrAyApvLfYIXHd5Wxe2i9yVc0+5+F7yos48aQ+BGcKx9aFk2BmnTwdngF2v5L
         BIfUljgtGr2Ij413xipgasS9OEySMNH3RL+grbg14lrsQJJhdg1M07dgN2Xa5DCpFlOb
         Gd3kpgtpm/AEnPxDM192h5FI5erqBZN+LgSuDS2ix3dCTrgn9RGKUxtEe1Dt7i56Asae
         Ubpg==
X-Gm-Message-State: APjAAAV4b7fkitg52YnUMkMRaLEGBW8/gMyhcMu13XWXmua8RMM7AM1H
        c97RwdYhUKjmK88oRSLxENnm2brc
X-Google-Smtp-Source: APXvYqzZo5rJU83WbGx4l8YKrQdA+4qX4BShmaAoOAj76qDv2/BdhY3tSWVbfAfWwkcKl922ZsNHhQ==
X-Received: by 2002:adf:dd52:: with SMTP id u18mr4805400wrm.131.1575474038983;
        Wed, 04 Dec 2019 07:40:38 -0800 (PST)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id d19sm2372235wmd.38.2019.12.04.07.40.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Dec 2019 07:40:38 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     thomas.lendacky@amd.com, sean.j.christopherson@intel.com,
        stable@vger.kernel.org
Subject: [PATCH v2] KVM: x86: use CPUID to locate host page table reserved bits
Date:   Wed,  4 Dec 2019 16:40:37 +0100
Message-Id: <1575474037-7903-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The comment in kvm_get_shadow_phys_bits refers to MKTME, but the same is actually
true of SME and SEV.  Just use CPUID[0x8000_0008].EAX[7:0] unconditionally if
available, it is simplest and works even if memory is not encrypted.

Cc: stable@vger.kernel.org
Reported-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6f92b40d798c..1e4ee4f8de5f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -538,16 +538,20 @@ void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
 static u8 kvm_get_shadow_phys_bits(void)
 {
 	/*
-	 * boot_cpu_data.x86_phys_bits is reduced when MKTME is detected
-	 * in CPU detection code, but MKTME treats those reduced bits as
-	 * 'keyID' thus they are not reserved bits. Therefore for MKTME
-	 * we should still return physical address bits reported by CPUID.
+	 * boot_cpu_data.x86_phys_bits is reduced when MKTME or SME are detected
+	 * in CPU detection code, but the processor treats those reduced bits as
+	 * 'keyID' thus they are not reserved bits. Therefore KVM needs to look at
+	 * the physical address bits reported by CPUID.
 	 */
-	if (!boot_cpu_has(X86_FEATURE_TME) ||
-	    WARN_ON_ONCE(boot_cpu_data.extended_cpuid_level < 0x80000008))
-		return boot_cpu_data.x86_phys_bits;
+	if (likely(boot_cpu_data.extended_cpuid_level >= 0x80000008))
+		return cpuid_eax(0x80000008) & 0xff;
 
-	return cpuid_eax(0x80000008) & 0xff;
+	/*
+	 * Quite weird to have VMX or SVM but not MAXPHYADDR; probably a VM with
+	 * custom CPUID.  Proceed with whatever the kernel found since these features
+	 * aren't virtualizable (SME/SEV also require CPUIDs higher than 0x80000008).
+	 */
+	return boot_cpu_data.x86_phys_bits;
 }
 
 static void kvm_mmu_reset_all_pte_masks(void)
-- 
1.8.3.1

