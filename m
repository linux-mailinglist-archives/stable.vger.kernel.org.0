Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF421375F35
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 05:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232241AbhEGDio (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 23:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232236AbhEGDin (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 May 2021 23:38:43 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12233C061574
        for <stable@vger.kernel.org>; Thu,  6 May 2021 20:37:44 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id s10-20020a05620a030ab02902e061a1661fso5053374qkm.12
        for <stable@vger.kernel.org>; Thu, 06 May 2021 20:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=mmh/HasNad45uSD7aVtNYaJgQvNsNvTGr9AsS2eHU3s=;
        b=RfTCNGnRBobPph7DjJQKUzjwlChJOsSNHGppS/YfPq1Fwd0paDPKYSwBwqC6OA+ona
         0UHYZJ2GeOpOMBDHatX05MwoBm9DaJT6BleLIzzrw0ZP1rixPUzW2gWSBzhQGTiDFptG
         QEIHFDkySObAtAITjJyjOGzQpl+eC+a9KA3Li+T28Ms+kxM4dXa7UHSWctLcEbwJbrVq
         NWiw6IaZ1UXIKobEkBWO5R6a6UkSnD9djIZZiPOA38+QGqQJ64ut7RuuboUkFSsOPdFb
         fFh8iIvXdw0ESGrzrA9Z2NrLLXHX25Dps/xl9xxsrE1nlWKRjubqvm5i7n/jCMKJLtAv
         yzCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=mmh/HasNad45uSD7aVtNYaJgQvNsNvTGr9AsS2eHU3s=;
        b=tqmFkRUt6jKbjx9CQvu6KLvvkZArKuzpLWtaG98CjNkeTbO3gr2d4QKbsR8I+mYQAW
         4uJF/s9MJuqqK9QC4hc6y6QqEZwC8onPjDSrvlTfQgp6bpTpmNTyORYfMfNnD94iNLhy
         HxPgknJL0nMeecqG6hMN9yP33pRUU03YbLphwReUJRaK4doQtMt/pA1JL1+sr19RnLE+
         CMRXrTxWV0Si+UQHebjEIzBsNJjZDEc/fm8A2xvXvw9t19Wqcsllv8F9B7LH2OnrCtE0
         7JYsCnn15mh9DxWCdYjKVav9kTwePw0dM3zaEQH2tlZXJ7lg8jVSJHod71T8FEgIbqfH
         /sZQ==
X-Gm-Message-State: AOAM533U5unmuJxHTtMk90nUsLDGTokyplZ5Ae825DrHnnbPC8GN+pwP
        s6KknjXhKJ9wXcgxhgSZ96No6oU=
X-Google-Smtp-Source: ABdhPJzw6qkCrj56jDT5D8uW81ZD4tJiE+Ui+OuZHuGtY5kaBkPhqNLmwdNvnacQapTZCpHH4kBZ37M=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:c762:3d3c:b811:8e75])
 (user=pcc job=sendgmr) by 2002:a0c:e9c6:: with SMTP id q6mr7701948qvo.15.1620358663196;
 Thu, 06 May 2021 20:37:43 -0700 (PDT)
Date:   Thu,  6 May 2021 20:37:25 -0700
Message-Id: <20210507033725.1479129-1-pcc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [PATCH] arm64: mte: initialize RGSR_EL1.SEED in __cpu_setup
From:   Peter Collingbourne <pcc@google.com>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Will Deacon <will@kernel.org>
Cc:     Peter Collingbourne <pcc@google.com>,
        Evgenii Stepanov <eugenis@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A valid implementation choice for the ChooseRandomNonExcludedTag()
pseudocode function used by IRG is to behave in the same way as with
GCR_EL1.RRND=0. This would mean that RGSR_EL1.SEED is used as an LFSR
which must have a non-zero value in order for IRG to properly produce
pseudorandom numbers. However, RGSR_EL1 is reset to an UNKNOWN value
on soft reset and thus may reset to 0. Therefore we must initialize
RGSR_EL1.SEED to a non-zero value in order to ensure that IRG behaves
as expected.

Signed-off-by: Peter Collingbourne <pcc@google.com>
Cc: stable@vger.kernel.org
Link: https://linux-review.googlesource.com/id/I2b089b6c7d6f17ee37e2f0db7df5ad5bcc04526c
---
 arch/arm64/mm/proc.S | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index 0a48191534ff..e8e1eaee4b3f 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -437,7 +437,7 @@ SYM_FUNC_START(__cpu_setup)
 	mrs	x10, ID_AA64PFR1_EL1
 	ubfx	x10, x10, #ID_AA64PFR1_MTE_SHIFT, #4
 	cmp	x10, #ID_AA64PFR1_MTE
-	b.lt	1f
+	b.lt	2f
 
 	/* Normal Tagged memory type at the corresponding MAIR index */
 	mov	x10, #MAIR_ATTR_NORMAL_TAGGED
@@ -447,6 +447,19 @@ SYM_FUNC_START(__cpu_setup)
 	mov	x10, #(SYS_GCR_EL1_RRND | SYS_GCR_EL1_EXCL_MASK)
 	msr_s	SYS_GCR_EL1, x10
 
+	/*
+	 * Initialize RGSR_EL1.SEED to a non-zero value. If the implementation
+	 * chooses to implement GCR_EL1.RRND=1 in the same way as RRND=0 then
+	 * the seed will be used as an LFSR, so it should be put onto the MLS.
+	 */
+	mrs	x10, CNTVCT_EL0
+	and	x10, x10, #SYS_RGSR_EL1_SEED_MASK
+	cbnz	x10, 1f
+	mov	x10, #1
+1:
+	lsl	x10, x10, #SYS_RGSR_EL1_SEED_SHIFT
+	msr_s	SYS_RGSR_EL1, x10
+
 	/* clear any pending tag check faults in TFSR*_EL1 */
 	msr_s	SYS_TFSR_EL1, xzr
 	msr_s	SYS_TFSRE0_EL1, xzr
@@ -454,7 +467,7 @@ SYM_FUNC_START(__cpu_setup)
 	/* set the TCR_EL1 bits */
 	mov_q	x10, TCR_KASAN_HW_FLAGS
 	orr	tcr, tcr, x10
-1:
+2:
 #endif
 	tcr_clear_errata_bits tcr, x9, x5
 
-- 
2.31.1.607.g51e8a6a459-goog

