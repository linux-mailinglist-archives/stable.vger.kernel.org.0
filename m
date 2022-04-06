Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B79D34F6B12
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 22:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbiDFUQ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 16:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234317AbiDFUPa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 16:15:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E4131B6089;
        Wed,  6 Apr 2022 11:27:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4E1EB8252B;
        Wed,  6 Apr 2022 18:27:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319D0C385A1;
        Wed,  6 Apr 2022 18:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649269637;
        bh=6G22upvbXoxta8nk2RQbeDekiGmPjZ2D3Z7Cr5183MA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cETam1jJgbMpSVIgPvdbSpjUj/gHVQtBUyzvXkRCHVYvm9ZSAIBAcPSc6CZJVv1cB
         KwLE/PPSrd00DOUTbXvgIrDcOq9nTfE42+EmK8s976f6VlEThKWYkuDMvEWsgFCewD
         iYgjx6GPspOabBY1ngMJg1ap15q0bKRiLX3qbyb0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <marc.zyngier@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 4.9 15/43] arm64: arch_timer: Add erratum handler for CPU-specific capability
Date:   Wed,  6 Apr 2022 20:26:24 +0200
Message-Id: <20220406182437.127728140@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220406182436.675069715@linuxfoundation.org>
References: <20220406182436.675069715@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <marc.zyngier@arm.com>

commit 0064030c6fd4ca6cfab42de037b2a89445beeead upstream.

Should we ever have a workaround for an erratum that is detected using
a capability and affecting a particular CPU, it'd be nice to have
a way to probe them directly.

Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/arch_timer.h  |    1 +
 drivers/clocksource/arm_arch_timer.c |   28 ++++++++++++++++++++++++----
 2 files changed, 25 insertions(+), 4 deletions(-)

--- a/arch/arm64/include/asm/arch_timer.h
+++ b/arch/arm64/include/asm/arch_timer.h
@@ -39,6 +39,7 @@ extern struct static_key_false arch_time
 
 enum arch_timer_erratum_match_type {
 	ate_match_dt,
+	ate_match_local_cap_id,
 };
 
 struct arch_timer_erratum_workaround {
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -162,6 +162,13 @@ bool arch_timer_check_dt_erratum(const s
 	return of_property_read_bool(np, wa->id);
 }
 
+static
+bool arch_timer_check_local_cap_erratum(const struct arch_timer_erratum_workaround *wa,
+					const void *arg)
+{
+	return this_cpu_has_cap((uintptr_t)wa->id);
+}
+
 static const struct arch_timer_erratum_workaround *
 arch_timer_iterate_errata(enum arch_timer_erratum_match_type type,
 			  ate_match_fn_t match_fn,
@@ -192,14 +199,16 @@ static void arch_timer_check_ool_workaro
 {
 	const struct arch_timer_erratum_workaround *wa;
 	ate_match_fn_t match_fn = NULL;
-
-	if (static_branch_unlikely(&arch_timer_read_ool_enabled))
-		return;
+	bool local = false;
 
 	switch (type) {
 	case ate_match_dt:
 		match_fn = arch_timer_check_dt_erratum;
 		break;
+	case ate_match_local_cap_id:
+		match_fn = arch_timer_check_local_cap_erratum;
+		local = true;
+		break;
 	default:
 		WARN_ON(1);
 		return;
@@ -209,8 +218,17 @@ static void arch_timer_check_ool_workaro
 	if (!wa)
 		return;
 
+	if (needs_unstable_timer_counter_workaround()) {
+		if (wa != timer_unstable_counter_workaround)
+			pr_warn("Can't enable workaround for %s (clashes with %s\n)",
+				wa->desc,
+				timer_unstable_counter_workaround->desc);
+		return;
+	}
+
 	arch_timer_enable_workaround(wa);
-	pr_info("Enabling global workaround for %s\n", wa->desc);
+	pr_info("Enabling %s workaround for %s\n",
+		local ? "local" : "global", wa->desc);
 }
 
 #else
@@ -470,6 +488,8 @@ static void __arch_timer_setup(unsigned
 			BUG();
 		}
 
+		arch_timer_check_ool_workaround(ate_match_local_cap_id, NULL);
+
 		erratum_workaround_set_sne(clk);
 	} else {
 		clk->features |= CLOCK_EVT_FEAT_DYNIRQ;


