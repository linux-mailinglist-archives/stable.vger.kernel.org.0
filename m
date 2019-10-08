Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C120CFDD4
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 17:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbfJHPkQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 11:40:16 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51286 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728071AbfJHPkQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 11:40:16 -0400
Received: by mail-wm1-f68.google.com with SMTP id 7so3708280wme.1
        for <stable@vger.kernel.org>; Tue, 08 Oct 2019 08:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TiS7GtjKACCq/gPzWLfsIVgr7mVCgq9QJv62y5ATfHE=;
        b=Rb6AtPIls/TUR8VV/nV1wTxl6lCS5Fv2dTAroWe5wdy74pXlVUkWyf2Ekb5xglXmCZ
         DsjQmN5bN6lBT3fVVnkIub1yJzxdDuFSB9/YVwlC88yg0CaVVgglV8BamvtwpfIpihsS
         MC6a4m68Brp9JNJpDVD17ZJV9L2CGu2AR0UYdPRwJEu2WE9Z3p5qQtfBSP8ClH8BIGsq
         mfsiTux20ay0M4M+Sq/pM48DeWxZLByJt4KNHf0RfQh0V6e0w4Hrjw7BMFTgifUze7re
         LNugtIOcXV6LFZ5MiLzUTknpucRX6cJqUTw/8f9bDAYmpo/zpu0jQEjXAFpr/+r3vJ4e
         9xLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TiS7GtjKACCq/gPzWLfsIVgr7mVCgq9QJv62y5ATfHE=;
        b=EZ11dS+E5At4b91575D+snf4xDSvr0BWC8UnIZBVFokySErER0mdV35rnsBj9zdwNv
         C/GCj9TnoQcdYtURJqfvPX92UtRF1v1XhxDtFz2nHyuLSYC/fp5dNvVP6P8I3wvof1TT
         kBRng3I0RA7Nh9qZJC0n2G1hSiYBm6WuB0abydXZVt3i7thTMT1/T6/lpovKhT30/KbS
         3etzMaFL61GdPY157nd9QRF3grqZ8fdvcmhE02Whz9mRVSr+sBNYEEGN8xPgt5r+nJHo
         Gi1p6+R4d6v/y/HRztpMysiI+D6Tg/2WLwfGbIuLn8Xasgh5VS3QzkfL33z41h9jQKFT
         3USA==
X-Gm-Message-State: APjAAAUMx7v5yj5XN37WdnBOy3KzC4gcB9nzhU7PSEtOtyrCQEPbjAdS
        GxVFMunWbBX66JuDDxYmbHNi9kYx29jasQ==
X-Google-Smtp-Source: APXvYqy2hKOKY5Mhzu/+EyhO5AYyQJ8z8wLw4YZ4/w/hl3v7wiDedWsPPgJojXbtLANsvZYEQsOJ+Q==
X-Received: by 2002:a1c:f718:: with SMTP id v24mr4090040wmh.82.1570549214361;
        Tue, 08 Oct 2019 08:40:14 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id x16sm16784723wrl.32.2019.10.08.08.40.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 08:40:13 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH for-stable-v4.19 05/16] arm64: fix SSBS sanitization
Date:   Tue,  8 Oct 2019 17:39:19 +0200
Message-Id: <20191008153930.15386-6-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191008153930.15386-1-ard.biesheuvel@linaro.org>
References: <20191008153930.15386-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit f54dada8274643e3ff4436df0ea124aeedc43cae ]

In valid_user_regs() we treat SSBS as a RES0 bit, and consequently it is
unexpectedly cleared when we restore a sigframe or fiddle with GPRs via
ptrace.

This patch fixes valid_user_regs() to account for this, updating the
function to refer to the latest ARM ARM (ARM DDI 0487D.a). For AArch32
tasks, SSBS appears in bit 23 of SPSR_EL1, matching its position in the
AArch32-native PSR format, and we don't need to translate it as we have
to for DIT.

There are no other bit assignments that we need to account for today.
As the recent documentation describes the DIT bit, we can drop our
comment regarding DIT.

While removing SSBS from the RES0 masks, existing inconsistent
whitespace is corrected.

Fixes: d71be2b6c0e19180 ("arm64: cpufeature: Detect SSBS and advertise to userspace")
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/kernel/ptrace.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 6219486fa25f..0211c3c7533b 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -1666,19 +1666,20 @@ void syscall_trace_exit(struct pt_regs *regs)
 }
 
 /*
- * SPSR_ELx bits which are always architecturally RES0 per ARM DDI 0487C.a
- * We also take into account DIT (bit 24), which is not yet documented, and
- * treat PAN and UAO as RES0 bits, as they are meaningless at EL0, and may be
- * allocated an EL0 meaning in future.
+ * SPSR_ELx bits which are always architecturally RES0 per ARM DDI 0487D.a.
+ * We permit userspace to set SSBS (AArch64 bit 12, AArch32 bit 23) which is
+ * not described in ARM DDI 0487D.a.
+ * We treat PAN and UAO as RES0 bits, as they are meaningless at EL0, and may
+ * be allocated an EL0 meaning in future.
  * Userspace cannot use these until they have an architectural meaning.
  * Note that this follows the SPSR_ELx format, not the AArch32 PSR format.
  * We also reserve IL for the kernel; SS is handled dynamically.
  */
 #define SPSR_EL1_AARCH64_RES0_BITS \
-	(GENMASK_ULL(63,32) | GENMASK_ULL(27, 25) | GENMASK_ULL(23, 22) | \
-	 GENMASK_ULL(20, 10) | GENMASK_ULL(5, 5))
+	(GENMASK_ULL(63, 32) | GENMASK_ULL(27, 25) | GENMASK_ULL(23, 22) | \
+	 GENMASK_ULL(20, 13) | GENMASK_ULL(11, 10) | GENMASK_ULL(5, 5))
 #define SPSR_EL1_AARCH32_RES0_BITS \
-	(GENMASK_ULL(63,32) | GENMASK_ULL(23, 22) | GENMASK_ULL(20,20))
+	(GENMASK_ULL(63, 32) | GENMASK_ULL(22, 22) | GENMASK_ULL(20, 20))
 
 static int valid_compat_regs(struct user_pt_regs *regs)
 {
-- 
2.20.1

