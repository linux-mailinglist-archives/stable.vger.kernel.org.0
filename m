Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B65F5DD4FE
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbfJRWiq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:38:46 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39025 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727137AbfJRWiq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Oct 2019 18:38:46 -0400
Received: by mail-pg1-f196.google.com with SMTP id p12so4112556pgn.6;
        Fri, 18 Oct 2019 15:38:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yo3S+hyfYKNq/ZHf33K0uVY+A7IKQznZapvdjy8vwIw=;
        b=ntD345JbaLKBRwJkiehtaJ+5h15cGRATFeL0h2JRKMXVU0wys+/gAbvUQ9xmru0Lpx
         37sPP3etbeaBdetKGAz5Z5D/PHNzvllj9H91MdlX4xFuohw/p04Ro1CSkXZiDHJ8j+1w
         cIVLFz018rZdhvny+rijj8LYeT+g+3ZRFom8+x/SzvbzBYVudBV2gdg7jbF454C0UbtS
         /OcvRbxFu43sKIqJC2XuX5dRJznFV5EDSCfJ7EKzga+Rd308n5n9OLrBTkqUhhLfdEG3
         FmuzXAeKLQ7PAJhecSj8n88tJQYeMYz/ZjIw/ZHUbouTMBj6MFJxLIFKssVzMtRYqTau
         8zjQ==
X-Gm-Message-State: APjAAAXQGRVKabDFf2msKUWuxlsG9GNOIA4IfGwV7sWez38vrE574NnA
        OgfyQTyVLcOofhmo9Ts7uHw7ah3J0S5ljQ==
X-Google-Smtp-Source: APXvYqzzjgItKlolv09ZwT2ybx7wwdoH99Swk8FdqieTY03YFdpM0U0kcWZ1GZ2I5B6cvy4hNJKqhg==
X-Received: by 2002:a63:cf11:: with SMTP id j17mr12491485pgg.236.1571438324929;
        Fri, 18 Oct 2019 15:38:44 -0700 (PDT)
Received: from localhost ([2601:646:8a00:9810:5af3:56d9:f882:39d4])
        by smtp.gmail.com with ESMTPSA id g4sm7130048pfo.33.2019.10.18.15.38.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 15:38:44 -0700 (PDT)
From:   Paul Burton <paulburton@kernel.org>
To:     linux-mips@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paul Burton <paulburton@kernel.org>,
        Dmitry Korotin <dkorotin@wavecomp.com>, stable@vger.kernel.org
Subject: [PATCH] MIPS: tlbex: Fix build_restore_pagemask KScratch restore
Date:   Fri, 18 Oct 2019 15:38:48 -0700
Message-Id: <20191018223848.1128468-1-paulburton@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

build_restore_pagemask() will restore the value of register $1/$at when
its restore_scratch argument is non-zero, and aims to do so by filling a
branch delay slot. Commit 0b24cae4d535 ("MIPS: Add missing EHB in mtc0
-> mfc0 sequence.") added an EHB instruction (Execution Hazard Barrier)
prior to restoring $1 from a KScratch register, in order to resolve a
hazard that can result in stale values of the KScratch register being
observed. In particular, P-class CPUs from MIPS with out of order
execution pipelines such as the P5600 & P6600 are affected.

Unfortunately this EHB instruction was inserted in the branch delay slot
causing the MFC0 instruction which performs the restoration to no longer
execute along with the branch. The result is that the $1 register isn't
actually restored, ie. the TLB refill exception handler clobbers it -
which is exactly the problem the EHB is meant to avoid for the P-class
CPUs.

Similarly build_get_pgd_vmalloc() will restore the value of $1/$at when
its mode argument equals refill_scratch, and suffers from the same
problem.

Fix this by in both cases moving the EHB earlier in the emitted code.
There's no reason it needs to immediately precede the MFC0 - it simply
needs to be between the MTC0 & MFC0.

This bug only affects Cavium Octeon systems which use
build_fast_tlb_refill_handler().

Signed-off-by: Paul Burton <paulburton@kernel.org>
Fixes: 0b24cae4d535 ("MIPS: Add missing EHB in mtc0 -> mfc0 sequence.")
Cc: Dmitry Korotin <dkorotin@wavecomp.com>
Cc: stable@vger.kernel.org # v3.15+
---
 arch/mips/mm/tlbex.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/mips/mm/tlbex.c b/arch/mips/mm/tlbex.c
index e01cb33bfa1a..41bb91f05688 100644
--- a/arch/mips/mm/tlbex.c
+++ b/arch/mips/mm/tlbex.c
@@ -653,6 +653,13 @@ static void build_restore_pagemask(u32 **p, struct uasm_reloc **r,
 				   int restore_scratch)
 {
 	if (restore_scratch) {
+		/*
+		 * Ensure the MFC0 below observes the value written to the
+		 * KScratch register by the prior MTC0.
+		 */
+		if (scratch_reg >= 0)
+			uasm_i_ehb(p);
+
 		/* Reset default page size */
 		if (PM_DEFAULT_MASK >> 16) {
 			uasm_i_lui(p, tmp, PM_DEFAULT_MASK >> 16);
@@ -667,12 +674,10 @@ static void build_restore_pagemask(u32 **p, struct uasm_reloc **r,
 			uasm_i_mtc0(p, 0, C0_PAGEMASK);
 			uasm_il_b(p, r, lid);
 		}
-		if (scratch_reg >= 0) {
-			uasm_i_ehb(p);
+		if (scratch_reg >= 0)
 			UASM_i_MFC0(p, 1, c0_kscratch(), scratch_reg);
-		} else {
+		else
 			UASM_i_LW(p, 1, scratchpad_offset(0), 0);
-		}
 	} else {
 		/* Reset default page size */
 		if (PM_DEFAULT_MASK >> 16) {
@@ -921,6 +926,10 @@ build_get_pgd_vmalloc64(u32 **p, struct uasm_label **l, struct uasm_reloc **r,
 	}
 	if (mode != not_refill && check_for_high_segbits) {
 		uasm_l_large_segbits_fault(l, *p);
+
+		if (mode == refill_scratch && scratch_reg >= 0)
+			uasm_i_ehb(p);
+
 		/*
 		 * We get here if we are an xsseg address, or if we are
 		 * an xuseg address above (PGDIR_SHIFT+PGDIR_BITS) boundary.
@@ -939,12 +948,10 @@ build_get_pgd_vmalloc64(u32 **p, struct uasm_label **l, struct uasm_reloc **r,
 		uasm_i_jr(p, ptr);
 
 		if (mode == refill_scratch) {
-			if (scratch_reg >= 0) {
-				uasm_i_ehb(p);
+			if (scratch_reg >= 0)
 				UASM_i_MFC0(p, 1, c0_kscratch(), scratch_reg);
-			} else {
+			else
 				UASM_i_LW(p, 1, scratchpad_offset(0), 0);
-			}
 		} else {
 			uasm_i_nop(p);
 		}
-- 
2.23.0

