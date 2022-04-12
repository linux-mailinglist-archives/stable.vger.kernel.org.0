Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0F1F4FD8B0
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351245AbiDLHc6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354029AbiDLH0A (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:26:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9707215722;
        Tue, 12 Apr 2022 00:05:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9BBD5B81B4D;
        Tue, 12 Apr 2022 07:05:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA116C385A6;
        Tue, 12 Apr 2022 07:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747122;
        bh=yqQ8br7MQ3MrgXQimt529wUVNzkOSYPYS0M367HdvJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2bcEbQq/S3Wp3sTnywYSEHs4+bBeRcO7hEuHc8pjC21AfEb3l65FAnenLgkST1sNK
         3FnbjzcvQiW907WjJxSemqtwf5/fSdqVtqdTDsEutAU9E/KxR7tuFHjDivFTJ3K49D
         teLKHSnM+kIvoP9dGwP/Utn6NlKDnobkGAWM2V4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.16 244/285] perf/x86/intel: Dont extend the pseudo-encoding to GP counters
Date:   Tue, 12 Apr 2022 08:31:41 +0200
Message-Id: <20220412062950.703096996@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
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

From: Kan Liang <kan.liang@linux.intel.com>

commit 4a263bf331c512849062805ef1b4ac40301a9829 upstream.

The INST_RETIRED.PREC_DIST event (0x0100) doesn't count on SPR.
perf stat -e cpu/event=0xc0,umask=0x0/,cpu/event=0x0,umask=0x1/ -C0

 Performance counter stats for 'CPU(s) 0':

           607,246      cpu/event=0xc0,umask=0x0/
                 0      cpu/event=0x0,umask=0x1/

The encoding for INST_RETIRED.PREC_DIST is pseudo-encoding, which
doesn't work on the generic counters. However, current perf extends its
mask to the generic counters.

The pseudo event-code for a fixed counter must be 0x00. Check and avoid
extending the mask for the fixed counter event which using the
pseudo-encoding, e.g., ref-cycles and PREC_DIST event.

With the patch,
perf stat -e cpu/event=0xc0,umask=0x0/,cpu/event=0x0,umask=0x1/ -C0

 Performance counter stats for 'CPU(s) 0':

           583,184      cpu/event=0xc0,umask=0x0/
           583,048      cpu/event=0x0,umask=0x1/

Fixes: 2de71ee153ef ("perf/x86/intel: Fix ICL/SPR INST_RETIRED.PREC_DIST encodings")
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/1648482543-14923-1-git-send-email-kan.liang@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/core.c      |    6 +++++-
 arch/x86/include/asm/perf_event.h |    5 +++++
 2 files changed, 10 insertions(+), 1 deletion(-)

--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -5521,7 +5521,11 @@ static void intel_pmu_check_event_constr
 			/* Disabled fixed counters which are not in CPUID */
 			c->idxmsk64 &= intel_ctrl;
 
-			if (c->idxmsk64 != INTEL_PMC_MSK_FIXED_REF_CYCLES)
+			/*
+			 * Don't extend the pseudo-encoding to the
+			 * generic counters
+			 */
+			if (!use_fixed_pseudo_encoding(c->code))
 				c->idxmsk64 |= (1ULL << num_counters) - 1;
 		}
 		c->idxmsk64 &=
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -241,6 +241,11 @@ struct x86_pmu_capability {
 #define INTEL_PMC_IDX_FIXED_SLOTS	(INTEL_PMC_IDX_FIXED + 3)
 #define INTEL_PMC_MSK_FIXED_SLOTS	(1ULL << INTEL_PMC_IDX_FIXED_SLOTS)
 
+static inline bool use_fixed_pseudo_encoding(u64 code)
+{
+	return !(code & 0xff);
+}
+
 /*
  * We model BTS tracing as another fixed-mode PMC.
  *


