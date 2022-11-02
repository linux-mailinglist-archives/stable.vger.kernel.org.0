Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7973F61709A
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 23:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbiKBWXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 18:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbiKBWXK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 18:23:10 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ECABA474;
        Wed,  2 Nov 2022 15:23:09 -0700 (PDT)
Date:   Wed, 02 Nov 2022 22:23:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1667427787;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YUW1QVhkjRWaatCaIAT8He2QfaycB0btMRJuB7W3Bnk=;
        b=RD+nxuQeX31+tzaN+UXlupWoQ22DX3nQKFXU5DeR2FYqfEp5jePpKo8iHZL8wyf4yKs1Qg
        k2SdwrlZC1HJ7wHo+64FYIqVt0z59KfTlHIOyEi9ua4gFUGoAS40sZAbxrQaoYjk9LNrri
        YK8DXRNwWsDzOk9G66TPN+JgCGOtZ3PREod7qb33Ez6xb96bJt/M0aRVLM4xkxZ2+0q5ES
        6xynFVf2ASVprqei1U789qqpZw2yrDDuCMfPsXOI4w69xw/3uy2M2axD32PYA6lbZvyIYz
        eKJ9TxNp2sjjXkQU/mObpkAZrTigqMEG5sOjB2uYBdu8HoNKYYyF5apvvo6Vbw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1667427787;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YUW1QVhkjRWaatCaIAT8He2QfaycB0btMRJuB7W3Bnk=;
        b=dpXIZ3UBbaE8fJRRP5S/jOTDGjVvplVZsWGXV9/rtb85ejlVmh4cR5jPJTrkr/6emj70rG
        zY1+k1vIRHOvJSBA==
From:   "tip-bot2 for Kan Liang" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/urgent] perf/x86/intel: Fix pebs event constraints for ICL
Cc:     Jannis Klinkenberg <jannis.klinkenberg@rwth-aachen.de>,
        Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20221031154119.571386-1-kan.liang@linux.intel.com>
References: <20221031154119.571386-1-kan.liang@linux.intel.com>
MIME-Version: 1.0
Message-ID: <166742778655.6127.8719495668978265751.tip-bot2@tip-bot2>
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

The following commit has been merged into the perf/urgent branch of tip:

Commit-ID:     acc5568b90c19ac6375508a93b9676cd18a92a35
Gitweb:        https://git.kernel.org/tip/acc5568b90c19ac6375508a93b9676cd18a92a35
Author:        Kan Liang <kan.liang@linux.intel.com>
AuthorDate:    Mon, 31 Oct 2022 08:41:18 -07:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Wed, 02 Nov 2022 12:22:06 +01:00

perf/x86/intel: Fix pebs event constraints for ICL

According to the latest event list, update the MEM_INST_RETIRED events
which support the DataLA facility.

Fixes: 6017608936c1 ("perf/x86/intel: Add Icelake support")
Reported-by: Jannis Klinkenberg <jannis.klinkenberg@rwth-aachen.de>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20221031154119.571386-1-kan.liang@linux.intel.com
---
 arch/x86/events/intel/ds.c |  9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index 7839507..41e8d65 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -982,8 +982,13 @@ struct event_constraint intel_icl_pebs_event_constraints[] = {
 	INTEL_FLAGS_UEVENT_CONSTRAINT(0x0400, 0x800000000ULL),	/* SLOTS */
 
 	INTEL_PLD_CONSTRAINT(0x1cd, 0xff),			/* MEM_TRANS_RETIRED.LOAD_LATENCY */
-	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_LD(0x1d0, 0xf),	/* MEM_INST_RETIRED.LOAD */
-	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_ST(0x2d0, 0xf),	/* MEM_INST_RETIRED.STORE */
+	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_LD(0x11d0, 0xf),	/* MEM_INST_RETIRED.STLB_MISS_LOADS */
+	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_ST(0x12d0, 0xf),	/* MEM_INST_RETIRED.STLB_MISS_STORES */
+	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_LD(0x21d0, 0xf),	/* MEM_INST_RETIRED.LOCK_LOADS */
+	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_LD(0x41d0, 0xf),	/* MEM_INST_RETIRED.SPLIT_LOADS */
+	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_ST(0x42d0, 0xf),	/* MEM_INST_RETIRED.SPLIT_STORES */
+	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_LD(0x81d0, 0xf),	/* MEM_INST_RETIRED.ALL_LOADS */
+	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_ST(0x82d0, 0xf),	/* MEM_INST_RETIRED.ALL_STORES */
 
 	INTEL_FLAGS_EVENT_CONSTRAINT_DATALA_LD_RANGE(0xd1, 0xd4, 0xf), /* MEM_LOAD_*_RETIRED.* */
 
