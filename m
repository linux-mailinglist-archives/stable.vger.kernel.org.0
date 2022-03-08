Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFF8D4D19E4
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 14:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347299AbiCHOAI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 09:00:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347302AbiCHOAF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 09:00:05 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2FB1A81A;
        Tue,  8 Mar 2022 05:58:58 -0800 (PST)
Date:   Tue, 08 Mar 2022 13:58:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646747936;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pMl034rKP4KtUY285VK2E6QJXRhnqapuqE6b3KEw77U=;
        b=OuoNm45+FXMY2UTHFPsi1R/xlVnz5iCdQY7U55DRTAb/SZvD4Y52OpSydXmIHGblCCKMP+
        KzmvRZvgRSSBFlj6qUV+fxVwdnC+bNSFIis38nSBmwEPIpnru1aIRksBx7Yzgi+SWYzMbS
        q4mr81RLlvYjbRVv2V3UaNgZG4U/qrItwCJC/27LEGG6guGXRgDQhv47RXrgid51idaOXc
        Ck37OqDPTmfTcfWfksEaWpW2iZAkO1AxpQlijNLAZjh3zGzYhe3C8kBBhlAsB7lFVlFznZ
        592SoEy31cLmDralu3hQNlHq1SHUMlI2/0LPzcP8QWhnReZi2bIsS0xNgvTAyg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646747936;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pMl034rKP4KtUY285VK2E6QJXRhnqapuqE6b3KEw77U=;
        b=1q4a2o1+w6yJb76iN1PLkJP0vJGIIqIhdm1LUBVZaJdNf1Zx7Cscd2Bvsab8NeQjTB0eBR
        LtYAExP2CwTf2DCg==
From:   "tip-bot2 for Peter Zijlstra" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/module: Fix the paravirt vs alternative order
Cc:     "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>, Miroslav Benes <mbenes@suse.cz>,
        <stable@vger.kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20220303112825.068773913@infradead.org>
References: <20220303112825.068773913@infradead.org>
MIME-Version: 1.0
Message-ID: <164674793535.16921.13542564445645377142.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     5adf349439d29f92467e864f728dfc23180f3ef9
Gitweb:        https://git.kernel.org/tip/5adf349439d29f92467e864f728dfc23180f3ef9
Author:        Peter Zijlstra <peterz@infradead.org>
AuthorDate:    Thu, 03 Mar 2022 12:23:23 +01:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Tue, 08 Mar 2022 14:15:25 +01:00

x86/module: Fix the paravirt vs alternative order

Ever since commit

  4e6292114c74 ("x86/paravirt: Add new features for paravirt patching")

there is an ordering dependency between patching paravirt ops and
patching alternatives, the module loader still violates this.

Fixes: 4e6292114c74 ("x86/paravirt: Add new features for paravirt patching")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220303112825.068773913@infradead.org
---
 arch/x86/kernel/module.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index 95fa745..96d7c27 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -273,6 +273,14 @@ int module_finalize(const Elf_Ehdr *hdr,
 			retpolines = s;
 	}
 
+	/*
+	 * See alternative_instructions() for the ordering rules between the
+	 * various patching types.
+	 */
+	if (para) {
+		void *pseg = (void *)para->sh_addr;
+		apply_paravirt(pseg, pseg + para->sh_size);
+	}
 	if (retpolines) {
 		void *rseg = (void *)retpolines->sh_addr;
 		apply_retpolines(rseg, rseg + retpolines->sh_size);
@@ -290,11 +298,6 @@ int module_finalize(const Elf_Ehdr *hdr,
 					    tseg, tseg + text->sh_size);
 	}
 
-	if (para) {
-		void *pseg = (void *)para->sh_addr;
-		apply_paravirt(pseg, pseg + para->sh_size);
-	}
-
 	/* make jump label nops */
 	jump_label_apply_nops(me);
 
