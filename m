Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0141B1B39E2
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 10:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbgDVIS0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 04:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725811AbgDVISZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 04:18:25 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F361C03C1A6;
        Wed, 22 Apr 2020 01:18:24 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id e25so1307567ljg.5;
        Wed, 22 Apr 2020 01:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=nt+kRiqmM2DnZoAPDCxq3F10ZB+J0rcax3yCDJcUZQo=;
        b=O+ruexNnVUo5OzrLczwc6UYX+jSD+p7msm6KuPB2fMV3u/6qIzH5PiXt3i/UXFejdU
         eX+aSwjvYfhvFYkV8XPDGAOo1/SmrJqWiAmWTNmduOfZ48pAf01ToMJT2Hyv/8ynP1t8
         r6eBgt5i43TwWZm13zJ/cUe/KQJs7+JSa44ldvfQyT1m+JHQa/bXWHgKcji7pgcJldhn
         QpRuSXm5AUkHrb75d2M+rOieLrKbMBKZf4cUtHkvA5qkegrdHqNIU/OZSKdcukUMcBO+
         XSEWaPTQq95wYAWzpR2jCmygLUCK1wtzmPSyw61ROAwUQ4/nDORzCU/sYdIOo3g6CmGi
         63hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=nt+kRiqmM2DnZoAPDCxq3F10ZB+J0rcax3yCDJcUZQo=;
        b=LxjH02X1KxXtY/0NdN0FPov3SzSYhpTH3vBuQW1LtgBsjg+R9uoByfUPcokOnSyQlS
         3kNdYjcTsog5edA1UTv84TfpfIxDdsZWF3YqdUrS43f2hYVJmp/+VUNyg3Y/+/JItck0
         9rPXOlkOZXOUOgw+eJkK9g+v5JxbEA2sVYeCQ1alX3SRyExTttynJ3fLKGhK6uHf0AhZ
         WgSRfQ1+DYIUdc99r9B58tyq3CbQV5TvVPZbnAloHntvlv1qR/PQFTt+VQg7DKcfTFkq
         SVXH5/Ya/Uj6gnu6c9Ih6hsmPQ+m42+b+zVYzR0wnAxP9KHh6mtKHA1c1aJaOavxTU4X
         pupQ==
X-Gm-Message-State: AGi0PuaZoDdQRinnfAhsSc0ZUmnqrFQiY9cda7WdNf4Nb3DyhpvKQDd4
        av2Mrc2P7fDUCyphRjJcNnqe5zQ8HwM=
X-Google-Smtp-Source: APiQypJOPrvwNHcGRwIeARqlkuawGEIenbD2GGiUS/itar2r/mjHhhLGt7usGl8ha9CtKdAADnH41w==
X-Received: by 2002:a2e:164b:: with SMTP id 11mr15263577ljw.23.1587543502188;
        Wed, 22 Apr 2020 01:18:22 -0700 (PDT)
Received: from test.lan ([91.105.39.216])
        by smtp.gmail.com with ESMTPSA id f21sm3947163lfk.94.2020.04.22.01.18.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Apr 2020 01:18:21 -0700 (PDT)
From:   Evalds Iodzevics <evalds.iodzevics@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, tglx@linutronix.de,
        ben@decadent.org.uk, bp@suse.de,
        Evalds Iodzevics <evalds.iodzevics@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] x86/microcode/intel: replace sync_core() with native_cpuid_reg(eax)
Date:   Wed, 22 Apr 2020 11:17:59 +0300
Message-Id: <20200422081759.1632-1-evalds.iodzevics@gmail.com>
X-Mailer: git-send-email 2.17.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Intel it is required to do CPUID(1) before reading the microcode
revision MSR. Current code in 4.4 an 4.9 relies on sync_core() to call
CPUID, unfortunately on 32 bit machines code inside sync_core() always
jumps past CPUID instruction as it depends on data structure boot_cpu_data
witch are not populated correctly so early in boot sequence.

It depends on:
commit 5dedade6dfa2 ("x86/CPU: Add native CPUID variants returning a single
datum")

This patch is for 4.4 but also should apply to 4.9

Signed-off-by: Evalds Iodzevics <evalds.iodzevics@gmail.com>
Cc: stable@vger.kernel.org
---
 arch/x86/include/asm/microcode_intel.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/microcode_intel.h b/arch/x86/include/asm/microcode_intel.h
index 90343ba50485..92ce9c8a508b 100644
--- a/arch/x86/include/asm/microcode_intel.h
+++ b/arch/x86/include/asm/microcode_intel.h
@@ -60,7 +60,7 @@ static inline u32 intel_get_microcode_revision(void)
 	native_wrmsrl(MSR_IA32_UCODE_REV, 0);
 
 	/* As documented in the SDM: Do a CPUID 1 here */
-	sync_core();
+	native_cpuid_eax(1);
 
 	/* get the current revision from MSR 0x8B */
 	native_rdmsr(MSR_IA32_UCODE_REV, dummy, rev);
-- 
2.17.4

