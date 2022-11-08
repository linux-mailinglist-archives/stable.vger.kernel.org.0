Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1FC6215D7
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235345AbiKHOQD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:16:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235354AbiKHOQA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:16:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 473C959847
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:16:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D999C615B2
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:15:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E83C9C433D7;
        Tue,  8 Nov 2022 14:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916959;
        bh=fdQPTZzvCTSi1hToKEZqGShsl5Aa5lvHrJxSWMBpPMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qV2WtNYbr3wtaTeDzTUhqUrE/DfZ1KW9w6O7YMFDKYqSSkEWwEKktDWGxaRrZGNYu
         nIUPY7E3H4PuhBJbzDUv2h3UqjefICZhBoYA733ZwC6GHiNge4Zwxs5Pp8BAdDwpnJ
         jhKS/dq3LowF0CfKKzgx8kFCJ7SpDc6pDueA0vNw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Jannis Klinkenberg <jannis.klinkenberg@rwth-aachen.de>,
        Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.0 156/197] perf/x86/intel: Fix pebs event constraints for ICL
Date:   Tue,  8 Nov 2022 14:39:54 +0100
Message-Id: <20221108133402.039734350@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

commit acc5568b90c19ac6375508a93b9676cd18a92a35 upstream.

According to the latest event list, update the MEM_INST_RETIRED events
which support the DataLA facility.

Fixes: 6017608936c1 ("perf/x86/intel: Add Icelake support")
Reported-by: Jannis Klinkenberg <jannis.klinkenberg@rwth-aachen.de>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20221031154119.571386-1-kan.liang@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/ds.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -982,8 +982,13 @@ struct event_constraint intel_icl_pebs_e
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
 


