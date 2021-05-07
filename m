Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2EB2376A3B
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 20:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbhEGTAM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 15:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbhEGTAM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 15:00:12 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2F3BC061574
        for <stable@vger.kernel.org>; Fri,  7 May 2021 11:59:11 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id j63-20020a25d2420000b02904d9818b80e8so11059839ybg.14
        for <stable@vger.kernel.org>; Fri, 07 May 2021 11:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=bUlmaJ3DBmOWkEirS18krGME+5oWQAss7CnV2FEmkzk=;
        b=XQ9v8g7z6GB9VUIw2oYSL5SOghNhEZ3cWe+NMcSCmNIOhOKFkVY2XX+4CwUArSk/Vv
         UyW34xEruNFEDNzFGOXySQTM4Ppv9gcHMPA/aG/MCn1Z8ILau/LwYHLiKzzBwD1vz9L9
         xLxn6PN7liWUlV9I4haX9SDN4WTwvZv0qVd2WMCYIBfZafSSNC+62McNoGOUdGs/gAq6
         EWJjlyD+QuO0Elqfj8pZIKiqBGSsbuO4kVocrfhreLo2PEGy16FDg0ofh3IOEV1nQ8bv
         Ll3FXexPAiCUDZaA/JQRjPN7ZUbVykeSQJO1wrdm0U3AyvR8YeIxkbVYvk2f+BqsvZ+4
         HAog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=bUlmaJ3DBmOWkEirS18krGME+5oWQAss7CnV2FEmkzk=;
        b=QHiLxbBCBzW+hOPbODUF8Gv2e/mZPgXLvlfYzcHEmdvuIJAcyXbrE24azljHa2JIHG
         W7Xv1yMgI83KCIolaYX5XarrG/VgF1XjWvXLWIPFXosvW/rQPGED23p3yrEH+aOWZL5f
         LOjgnh2pe9Ct1UuY1I3R7E1B2PYxPbpaUyWk34HIkxeMkZ/p9N9L99DoJ0Gqzyh1sIT8
         /pB6R7Ile/EL02k6/2rCM9lDM4WT3u53ixIk2st6Tz0Dgg9Q8pLrPridTO36RMXeuVYo
         S8eC1PEnI4x31wxtVLq+9kYAA4CS5ocf+sZ9RWFMaw6LBGaC3pZfEjUJFPMfTahKffGJ
         pkjg==
X-Gm-Message-State: AOAM533HFcqL4iTYIH0mJ1RdNOkvrcLbMNu29I1u60GsLlNQ0Yp/vqS+
        UrTKwTGbzfcXjpCjO7AT1YouXtg=
X-Google-Smtp-Source: ABdhPJwbAM/J36vBWavQC7bJD9ssurzMNB9MreR8OB6/9spaIo9+Ja5ENG1xLTKBo6cktzQtD+Uopkk=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:f4bc:e4fd:1d93:96b2])
 (user=pcc job=sendgmr) by 2002:a25:2bc1:: with SMTP id r184mr15777161ybr.51.1620413950833;
 Fri, 07 May 2021 11:59:10 -0700 (PDT)
Date:   Fri,  7 May 2021 11:59:05 -0700
Message-Id: <20210507185905.1745402-1-pcc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [PATCH v2] arm64: mte: initialize RGSR_EL1.SEED in __cpu_setup
From:   Peter Collingbourne <pcc@google.com>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
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
Fixes: 3b714d24ef17 ("arm64: mte: CPU feature detection and initial sysreg configuration")
Cc: <stable@vger.kernel.org> # 5.10
Link: https://linux-review.googlesource.com/id/I2b089b6c7d6f17ee37e2f0db7df5ad5bcc04526c
---
 arch/arm64/mm/proc.S | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index 0a48191534ff..97d7bcd8d4f2 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -447,6 +447,18 @@ SYM_FUNC_START(__cpu_setup)
 	mov	x10, #(SYS_GCR_EL1_RRND | SYS_GCR_EL1_EXCL_MASK)
 	msr_s	SYS_GCR_EL1, x10
 
+	/*
+	 * If GCR_EL1.RRND=1 is implemented the same way as RRND=0, then
+	 * RGSR_EL1.SEED must be non-zero for IRG to produce
+	 * pseudorandom numbers. As RGSR_EL1 is UNKNOWN out of reset, we
+	 * must initialize it.
+	 */
+	mrs	x10, CNTVCT_EL0
+	ands	x10, x10, #SYS_RGSR_EL1_SEED_MASK
+	csinc	x10, x10, xzr, ne
+	lsl	x10, x10, #SYS_RGSR_EL1_SEED_SHIFT
+	msr_s	SYS_RGSR_EL1, x10
+
 	/* clear any pending tag check faults in TFSR*_EL1 */
 	msr_s	SYS_TFSR_EL1, xzr
 	msr_s	SYS_TFSRE0_EL1, xzr
-- 
2.31.1.607.g51e8a6a459-goog

