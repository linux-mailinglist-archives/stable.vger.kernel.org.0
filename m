Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0115112DC0
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 15:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727978AbfLDOvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 09:51:05 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33456 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727850AbfLDOvE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Dec 2019 09:51:04 -0500
Received: by mail-wr1-f65.google.com with SMTP id b6so9011254wrq.0;
        Wed, 04 Dec 2019 06:51:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=yYZqbXXZPzEVcnnLng9M3IBm2A+jek74weSxMJq/iFE=;
        b=k49RhWK/OQMSeTLWRRb/52BYdCf1Q/03pZKLEloGnJ7ddXIOfJiz/6JfpuiJVbPGjX
         gXMY6YTd/Qqw9UFEkw+9KUI5Vp0ng/hZ66lLnfe9zWFt0aVpiUS92CPDQKMpI+M6wVwR
         e2CaDlPKATJbUVes/UpFot8+PpD2QgP4AGEd/HZpSQJ8Ot80iazLwIid2ITtch00e8XY
         D8uVwpk5iITo54/nARn5hQ0YbV3h+ODJmXkOuvJGVHt/jmJBgQXM5mmhQtn3dDK7ew/N
         fMyS36e01rxhWkCmWR8mrpWKFdH7wdut7+zK/Kw88uwBNCRFT1Y/ccy8pfBSBjg/+wu5
         bbTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=yYZqbXXZPzEVcnnLng9M3IBm2A+jek74weSxMJq/iFE=;
        b=OOo+9RfGlsXKw2qVpt7FGCg+QsbMWf7YyU0rNfovUQZFpOmcG6URGc9fwcLMCFZbO6
         Yl2YOX5OGyptkL0rUhypnM7X3Aq1fRMcAUe/w2hziwyLuUnjYQ2S9H5WpnlEmxxGDLPk
         DQjkOzfLD4aXabLMCEGEUSgo1JaU5712Kol76s+X8oXN+Bjynk252bn3jntKTqqyQC1u
         xjgbMp1t5XZDtAk+mZNVmqDyNEuj0RkThJML20Tq2gRnPYJvp/1ua+ghJFJmNQpOhIRq
         KMIETN1NUhLyKcp8eUjxE+mCX9YvwNDtA2RjA6OSMU16Kv7G0aOse2CyqvO2Ibsab/O8
         XwyQ==
X-Gm-Message-State: APjAAAUMSrVNJ+wnWoGND9TIw1SMf8z3TWaAqog3W6ilp9FHWvw4AN8e
        +47dOQSDx+z5jhYE2/RK1B5NA8dU
X-Google-Smtp-Source: APXvYqzhNhpH8GkpLpuDoFIfARsuUlf8LRkpE+8kJfbaaR4NmRo7TS5sSDxQ0Hyau5wcWOxyLFSfnw==
X-Received: by 2002:adf:ec48:: with SMTP id w8mr4606345wrn.19.1575471062187;
        Wed, 04 Dec 2019 06:51:02 -0800 (PST)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id g74sm6747674wme.5.2019.12.04.06.51.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Dec 2019 06:51:01 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] KVM: x86: use CPUID to locate host page table reserved bits
Date:   Wed,  4 Dec 2019 15:51:00 +0100
Message-Id: <1575471060-55790-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The comment in kvm_get_shadow_phys_bits refers to MKTME, but the same is actually
true of SME and SEV.  Just use CPUID[0x8000_0008].EAX[7:0] unconditionally, it is
simplest and works even if memory is not encrypted.

Cc: stable@vger.kernel.org
Reported-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6f92b40d798c..8b8edfbdbaef 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -538,15 +538,11 @@ void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
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
-
 	return cpuid_eax(0x80000008) & 0xff;
 }
 
-- 
1.8.3.1

