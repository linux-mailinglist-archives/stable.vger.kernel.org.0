Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3E5454958E
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380006AbiFMOGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380867AbiFMODX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:03:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA898FFBE;
        Mon, 13 Jun 2022 04:38:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A9C2B80EC6;
        Mon, 13 Jun 2022 11:38:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC312C34114;
        Mon, 13 Jun 2022 11:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120306;
        bh=mWme0B+Y9j89HzNHz5kBs6pMKkO05ChqT2k1l2qX2Fk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dG/MFrL/HmmyRtYu0WU+UKAaoUfu+cOSBbBy1JKsMB+TetiD7umw8Ds542yc0OdFY
         fcjbjNuFfVnARetL8omEbM11So3TtWl+YcKrWL065rCYaDZwbRPfHhQeO/H4WZImLJ
         WJr+tzLO2ldKeRDmrqLq/ZTkji9IMjBXeDqkP0js=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.18 324/339] cpuidle,intel_idle: Fix CPUIDLE_FLAG_IRQ_ENABLE
Date:   Mon, 13 Jun 2022 12:12:29 +0200
Message-Id: <20220613094936.573277604@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 32d4fd5751eadbe1823a37eb38df85ec5c8e6207 upstream.

Commit c227233ad64c ("intel_idle: enable interrupts before C1 on
Xeons") wrecked intel_idle in two ways:

 - must not have tracing in idle functions
 - must return with IRQs disabled

Additionally, it added a branch for no good reason.

Fixes: c227233ad64c ("intel_idle: enable interrupts before C1 on Xeons")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
[ rjw: Moved the intel_idle() kerneldoc comment next to the function ]
Cc: 5.16+ <stable@vger.kernel.org> # 5.16+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/idle/intel_idle.c |   32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -115,6 +115,18 @@ static unsigned int mwait_substates __in
 #define flg2MWAIT(flags) (((flags) >> 24) & 0xFF)
 #define MWAIT2flg(eax) ((eax & 0xFF) << 24)
 
+static __always_inline int __intel_idle(struct cpuidle_device *dev,
+					struct cpuidle_driver *drv, int index)
+{
+	struct cpuidle_state *state = &drv->states[index];
+	unsigned long eax = flg2MWAIT(state->flags);
+	unsigned long ecx = 1; /* break on interrupt flag */
+
+	mwait_idle_with_hints(eax, ecx);
+
+	return index;
+}
+
 /**
  * intel_idle - Ask the processor to enter the given idle state.
  * @dev: cpuidle device of the target CPU.
@@ -132,16 +144,19 @@ static unsigned int mwait_substates __in
 static __cpuidle int intel_idle(struct cpuidle_device *dev,
 				struct cpuidle_driver *drv, int index)
 {
-	struct cpuidle_state *state = &drv->states[index];
-	unsigned long eax = flg2MWAIT(state->flags);
-	unsigned long ecx = 1; /* break on interrupt flag */
+	return __intel_idle(dev, drv, index);
+}
 
-	if (state->flags & CPUIDLE_FLAG_IRQ_ENABLE)
-		local_irq_enable();
+static __cpuidle int intel_idle_irq(struct cpuidle_device *dev,
+				    struct cpuidle_driver *drv, int index)
+{
+	int ret;
 
-	mwait_idle_with_hints(eax, ecx);
+	raw_local_irq_enable();
+	ret = __intel_idle(dev, drv, index);
+	raw_local_irq_disable();
 
-	return index;
+	return ret;
 }
 
 /**
@@ -1668,6 +1683,9 @@ static void __init intel_idle_init_cstat
 		/* Structure copy. */
 		drv->states[drv->state_count] = cpuidle_state_table[cstate];
 
+		if (cpuidle_state_table[cstate].flags & CPUIDLE_FLAG_IRQ_ENABLE)
+			drv->states[drv->state_count].enter = intel_idle_irq;
+
 		if ((disabled_states_mask & BIT(drv->state_count)) ||
 		    ((icpu->use_acpi || force_use_acpi) &&
 		     intel_idle_off_by_default(mwait_hint) &&


