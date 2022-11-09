Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB4C622BB5
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 13:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbiKIMib (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 07:38:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiKIMia (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 07:38:30 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 415485F5D;
        Wed,  9 Nov 2022 04:38:27 -0800 (PST)
Date:   Wed, 09 Nov 2022 12:38:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1667997505;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LK9EehdZiIwa5K6hobz+g0DwtgtF0AoOZ+vJ/cDRSTQ=;
        b=X8v+aomFyx+6qc64lsUgqcWnLs18jl2WeFenLKsSMchrZ0ZxEvrz5EIwyc1IMAF2F5FW8T
        HISO1hwgxFBtBZrXHIBVMed5aw0Znht/g3wMWyJwB2hLuI77hhVsqy4OuawYnFqpHynSDE
        hcPW7bh9bRoad7sPsnXFPd2AoJjZLPDMK4DNLRZJ16RbxR/Gn6CwZZLztAjll5nVpgqSDU
        9G8ZkGuEB/OWYS4odt5stkzvMkrEM1O2LbJ3mzgyyzYN9fxBTP3g2JOBYfc2wnY7VxPlFp
        wyD1EhhyBCH+RihPn7sdKXCXK41AXPOm+90Wz1hZCURg46G9vlAyqmJh2b2DHQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1667997505;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LK9EehdZiIwa5K6hobz+g0DwtgtF0AoOZ+vJ/cDRSTQ=;
        b=j8vSZZIKZIusfpm1+LokwLrBq+BhGrnFw5Vz30eY0DGuBIWuHzDlq8YVklpsW54ZJU46ge
        7PNcUTWq56EgKUCw==
From:   "tip-bot2 for Andrew Cooper" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/fpu] x86/fpu/xstate: Fix XSTATE_WARN_ON() to emit relevant
 diagnostics
Cc:     Andrew Cooper <andrew.cooper3@citrix.com>,
        Borislav Petkov <bp@suse.de>, <stable@vger.kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20220810221909.12768-1-andrew.cooper3@citrix.com>
References: <20220810221909.12768-1-andrew.cooper3@citrix.com>
MIME-Version: 1.0
Message-ID: <166799750447.4906.6850685710564265854.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/fpu branch of tip:

Commit-ID:     48280042f2c6e3ac2cfb1d8b752ab4a7e0baea24
Gitweb:        https://git.kernel.org/tip/48280042f2c6e3ac2cfb1d8b752ab4a7e0baea24
Author:        Andrew Cooper <andrew.cooper3@citrix.com>
AuthorDate:    Wed, 10 Aug 2022 23:19:09 +01:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Wed, 09 Nov 2022 13:28:31 +01:00

x86/fpu/xstate: Fix XSTATE_WARN_ON() to emit relevant diagnostics

"XSAVE consistency problem" has been reported under Xen, but that's the extent
of my divination skills.

Modify XSTATE_WARN_ON() to force the caller to provide relevant diagnostic
information, and modify each caller suitably.

For check_xstate_against_struct(), this removes a double WARN() where one will
do perfectly fine.

CC stable as this has been wonky debugging for 7 years and it is good to
have there too.

Signed-off-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220810221909.12768-1-andrew.cooper3@citrix.com
---
 arch/x86/kernel/fpu/xstate.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 59e543b..c2dde46 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -440,8 +440,8 @@ static void __init __xstate_dump_leaves(void)
 	}
 }
 
-#define XSTATE_WARN_ON(x) do {							\
-	if (WARN_ONCE(x, "XSAVE consistency problem, dumping leaves")) {	\
+#define XSTATE_WARN_ON(x, fmt, ...) do {					\
+	if (WARN_ONCE(x, "XSAVE consistency problem: " fmt, ##__VA_ARGS__)) {	\
 		__xstate_dump_leaves();						\
 	}									\
 } while (0)
@@ -554,8 +554,7 @@ static bool __init check_xstate_against_struct(int nr)
 	    (nr >= XFEATURE_MAX) ||
 	    (nr == XFEATURE_PT_UNIMPLEMENTED_SO_FAR) ||
 	    ((nr >= XFEATURE_RSRVD_COMP_11) && (nr <= XFEATURE_RSRVD_COMP_16))) {
-		WARN_ONCE(1, "no structure for xstate: %d\n", nr);
-		XSTATE_WARN_ON(1);
+		XSTATE_WARN_ON(1, "No structure for xstate: %d\n", nr);
 		return false;
 	}
 	return true;
@@ -598,12 +597,13 @@ static bool __init paranoid_xstate_size_valid(unsigned int kernel_size)
 		 * XSAVES.
 		 */
 		if (!xsaves && xfeature_is_supervisor(i)) {
-			XSTATE_WARN_ON(1);
+			XSTATE_WARN_ON(1, "Got supervisor feature %d, but XSAVES not advertised\n", i);
 			return false;
 		}
 	}
 	size = xstate_calculate_size(fpu_kernel_cfg.max_features, compacted);
-	XSTATE_WARN_ON(size != kernel_size);
+	XSTATE_WARN_ON(size != kernel_size,
+		       "size %u != kernel_size %u\n", size, kernel_size);
 	return size == kernel_size;
 }
 
