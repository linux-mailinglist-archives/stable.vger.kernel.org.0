Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26A2767BF42
	for <lists+stable@lfdr.de>; Wed, 25 Jan 2023 22:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235574AbjAYVw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Jan 2023 16:52:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236631AbjAYVwq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Jan 2023 16:52:46 -0500
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94BE24EFD
        for <stable@vger.kernel.org>; Wed, 25 Jan 2023 13:52:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=lmG53ki6l+2bYYwFGbjwOPBgjhKcqTLHkQW0buw6Ajk=; b=E4Ed7VAzzhK7B6H9KC0cAP8Sfw
        gijRglQvTbIMFAiQtgIjQ5gfgtuQxFUtaSyKhY6SIxob3qBFOAKvLMpJuL39iYq2xIgMvqFAx+l8o
        qFXOJjyco6gySWLRSlE9uoiyoE/sSyK+/GBTR2Bv1YuZqFBMxCGe7hcBdU92L/a6iJl/O4V7IAG8N
        wFioo+BpoTsYnTI5EKLsMkE10KCTYOWx9TV/0KsZejj/sO7IM6yyRYGwWfED21sTTDURe3nJnLvwW
        PDJAEsWFq3pxdwYmaBSOJC1q+Mo01q6OJhnrOOIZSjFxIcXCCeLRXFL+s+j2UFsVwgxCtBPnF46O8
        EWc6m01g==;
Received: from [187.56.70.205] (helo=localhost)
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
        id 1pKnge-000mA6-5L; Wed, 25 Jan 2023 22:52:09 +0100
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org, x86@kernel.org,
        kernel@gpiccoli.net, kernel-dev@igalia.com,
        Deepak Sharma <deepak.sharma@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        "Guilherme G . Piccoli" <gpiccoli@igalia.com>
Subject: [PATCH 5.10 / 5.15] x86: ACPI: cstate: Optimize C3 entry on AMD CPUs
Date:   Wed, 25 Jan 2023 18:51:45 -0300
Message-Id: <20230125215145.1171151-1-gpiccoli@igalia.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Deepak Sharma <deepak.sharma@amd.com>

commit a8fb40966f19ff81520d9ccf8f7e2b95201368b8 upstream.

All Zen or newer CPU which support C3 shares cache. Its not necessary to
flush the caches in software before entering C3. This will cause drop in
performance for the cores which share some caches. ARB_DIS is not used
with current AMD C state implementation. So set related flags correctly.

Signed-off-by: Deepak Sharma <deepak.sharma@amd.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
---


Hi folks, this is a very simple optimization that might be read
as a fix IMO, since it's setting the flags correctly for the Zen CPUs.
It was built/boot tested in the Steam Deck.

The backport for stable was a suggestion from Greg [0], so lemme
know if any of you see an issue with that, or if we should target
other stable versions (or less versions, maybe only 5.15).
Cheers,


Guilherme


[0] https://github.com/ValveSoftware/SteamOS/issues/954#issuecomment-1368182597

 arch/x86/kernel/acpi/cstate.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/kernel/acpi/cstate.c b/arch/x86/kernel/acpi/cstate.c
index 49ae4e1ac9cd..d28d43d774a2 100644
--- a/arch/x86/kernel/acpi/cstate.c
+++ b/arch/x86/kernel/acpi/cstate.c
@@ -79,6 +79,21 @@ void acpi_processor_power_init_bm_check(struct acpi_processor_flags *flags,
 		 */
 		flags->bm_control = 0;
 	}
+	if (c->x86_vendor == X86_VENDOR_AMD && c->x86 >= 0x17) {
+		/*
+		 * For all AMD Zen or newer CPUs that support C3, caches
+		 * should not be flushed by software while entering C3
+		 * type state. Set bm->check to 1 so that kernel doesn't
+		 * need to execute cache flush operation.
+		 */
+		flags->bm_check = 1;
+		/*
+		 * In current AMD C state implementation ARB_DIS is no longer
+		 * used. So set bm_control to zero to indicate ARB_DIS is not
+		 * required while entering C3 type state.
+		 */
+		flags->bm_control = 0;
+	}
 }
 EXPORT_SYMBOL(acpi_processor_power_init_bm_check);
 
-- 
2.39.0

