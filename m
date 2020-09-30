Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79FCB27F219
	for <lists+stable@lfdr.de>; Wed, 30 Sep 2020 21:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731034AbgI3S64 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Sep 2020 14:58:56 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:58812 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729504AbgI3S6z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Sep 2020 14:58:55 -0400
Date:   Wed, 30 Sep 2020 18:58:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601492333;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8cQjdg9LoevS6MsxuHOmDWXWoeYfzp2UlKUc706qxmw=;
        b=RL1EoZPgPzzqqDEyFZsUX7TM0TwbyR78dwGBqCiFA+5HPmfyNnrgvUXVC6AKQgebvrg4e1
        jPbO1pq2J7TW81MlgDl5Uin5V/sjhowqXa9eekJGfE6aL45x5Ewht3O017Ejijsosw9iO0
        Jn9LLeYVanFsRFht+vVGfBtS9Xa3NxuYL/lmRH8rH/WSn3R9+ptVajwZ4gG1Fxs30DhryC
        yM53An2keE8bRmmw2aKXQmI8dja/wSSZOVnSKbPu7OV0ece/IVWWqt+HWsNFtUijOLuHGj
        Zbno55a26mRaLnAqz2JiL73vgApn+B1NXS89o/ltbhIbeF1WQwXg1F0KN4HyIQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601492333;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8cQjdg9LoevS6MsxuHOmDWXWoeYfzp2UlKUc706qxmw=;
        b=AOQfhhHVSd9OX8+ZvdsbCP78TD8bQs4fpeyFUfS+h2bXiktYoL6xJ6TtsfakuTkCHJknOr
        m8touhLvIyTR0hDg==
From:   "tip-bot2 for Kan Liang" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/core] perf/x86/intel: Fix Ice Lake event constraint table
Cc:     "Yi, Ammy" <ammy.yi@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200928134726.13090-1-kan.liang@linux.intel.com>
References: <20200928134726.13090-1-kan.liang@linux.intel.com>
MIME-Version: 1.0
Message-ID: <160149233215.7002.2577872332043936536.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/core branch of tip:

Commit-ID:     010cb00265f150bf82b23c02ad1fb87ce5c781e1
Gitweb:        https://git.kernel.org/tip/010cb00265f150bf82b23c02ad1fb87ce5c781e1
Author:        Kan Liang <kan.liang@linux.intel.com>
AuthorDate:    Mon, 28 Sep 2020 06:47:26 -07:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Tue, 29 Sep 2020 09:57:02 +02:00

perf/x86/intel: Fix Ice Lake event constraint table

An error occues when sampling non-PEBS INST_RETIRED.PREC_DIST(0x01c0)
event.

  perf record -e cpu/event=0xc0,umask=0x01/ -- sleep 1
  Error:
  The sys_perf_event_open() syscall returned with 22 (Invalid argument)
  for event (cpu/event=0xc0,umask=0x01/).
  /bin/dmesg | grep -i perf may provide additional information.

The idxmsk64 of the event is set to 0. The event never be successfully
scheduled.

The event should be limit to the fixed counter 0.

Fixes: 6017608936c1 ("perf/x86/intel: Add Icelake support")
Reported-by: Yi, Ammy <ammy.yi@intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20200928134726.13090-1-kan.liang@linux.intel.com
---
 arch/x86/events/intel/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 75dea67..bdf28d2 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -243,7 +243,7 @@ static struct extra_reg intel_skl_extra_regs[] __read_mostly = {
 
 static struct event_constraint intel_icl_event_constraints[] = {
 	FIXED_EVENT_CONSTRAINT(0x00c0, 0),	/* INST_RETIRED.ANY */
-	INTEL_UEVENT_CONSTRAINT(0x1c0, 0),	/* INST_RETIRED.PREC_DIST */
+	FIXED_EVENT_CONSTRAINT(0x01c0, 0),	/* INST_RETIRED.PREC_DIST */
 	FIXED_EVENT_CONSTRAINT(0x003c, 1),	/* CPU_CLK_UNHALTED.CORE */
 	FIXED_EVENT_CONSTRAINT(0x0300, 2),	/* CPU_CLK_UNHALTED.REF */
 	FIXED_EVENT_CONSTRAINT(0x0400, 3),	/* SLOTS */
