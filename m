Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 815B2617096
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 23:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbiKBWXK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 18:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbiKBWXJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 18:23:09 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63768A467;
        Wed,  2 Nov 2022 15:23:08 -0700 (PDT)
Date:   Wed, 02 Nov 2022 22:23:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1667427786;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z1dVtGo5iEau0GObV6ZlrFrixHqrFcsKq5JPVirrBdY=;
        b=lEbHW4CXyUc0spTPpDFEo9esDx15AW3mAY3S89JloWPhMlzsYREtxPTkB3hv0DsX+V1+yT
        9qkGEMsjfx84gcgifEgO3xKgl0tyQl12z+zfYDj/FVCiNGBpf6EUmjzVG+Mox6nUHpYwNp
        IWts+Uw56Deti9OmO0BDpaJMdEw0axt51IqaPemD4LS4GQ5SjlcnGPHz9PxI/SMPvkZ18q
        RVNctrgCVmJW+WRTsibS3gtD/ury8beRHLV5BeU4VMtsiUbw54raGXYKK5K6Y3lZ1x+UCT
        c8Ox7a9HFUto5d0VASRhx3nTIkcv5B0uXspY/L0pRV7YNrLL0mCnfS2IbO3PBQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1667427786;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z1dVtGo5iEau0GObV6ZlrFrixHqrFcsKq5JPVirrBdY=;
        b=1QiNCdCRU3wMyIyuWunZie0d57vNGUQuwoVW0WvxbKkLpnhXEzl7M/vMpKgosLW+gVEUI2
        qhpB28ltSi9SUIAg==
From:   "tip-bot2 for Kan Liang" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/urgent] perf/x86/intel: Fix pebs event constraints for SPR
Cc:     Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20221031154119.571386-2-kan.liang@linux.intel.com>
References: <20221031154119.571386-2-kan.liang@linux.intel.com>
MIME-Version: 1.0
Message-ID: <166742778547.6127.15390204561307101823.tip-bot2@tip-bot2>
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

Commit-ID:     0916886bb978e7eae1ca3955ba07f51c020da20c
Gitweb:        https://git.kernel.org/tip/0916886bb978e7eae1ca3955ba07f51c020da20c
Author:        Kan Liang <kan.liang@linux.intel.com>
AuthorDate:    Mon, 31 Oct 2022 08:41:19 -07:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Wed, 02 Nov 2022 12:22:06 +01:00

perf/x86/intel: Fix pebs event constraints for SPR

According to the latest event list, update the MEM_INST_RETIRED events
which support the DataLA facility for SPR.

Fixes: 61b985e3e775 ("perf/x86/intel: Add perf core PMU support for Sapphire Rapids")
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20221031154119.571386-2-kan.liang@linux.intel.com
---
 arch/x86/events/intel/ds.c |  9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index 41e8d65..446d283 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -1009,8 +1009,13 @@ struct event_constraint intel_spr_pebs_event_constraints[] = {
 	INTEL_FLAGS_EVENT_CONSTRAINT(0xc0, 0xfe),
 	INTEL_PLD_CONSTRAINT(0x1cd, 0xfe),
 	INTEL_PSD_CONSTRAINT(0x2cd, 0x1),
-	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_LD(0x1d0, 0xf),
-	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_ST(0x2d0, 0xf),
+	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_LD(0x11d0, 0xf),	/* MEM_INST_RETIRED.STLB_MISS_LOADS */
+	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_ST(0x12d0, 0xf),	/* MEM_INST_RETIRED.STLB_MISS_STORES */
+	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_LD(0x21d0, 0xf),	/* MEM_INST_RETIRED.LOCK_LOADS */
+	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_LD(0x41d0, 0xf),	/* MEM_INST_RETIRED.SPLIT_LOADS */
+	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_ST(0x42d0, 0xf),	/* MEM_INST_RETIRED.SPLIT_STORES */
+	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_LD(0x81d0, 0xf),	/* MEM_INST_RETIRED.ALL_LOADS */
+	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_ST(0x82d0, 0xf),	/* MEM_INST_RETIRED.ALL_STORES */
 
 	INTEL_FLAGS_EVENT_CONSTRAINT_DATALA_LD_RANGE(0xd1, 0xd4, 0xf),
 
