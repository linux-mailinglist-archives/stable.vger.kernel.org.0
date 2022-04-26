Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA81850F462
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233603AbiDZIf4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344918AbiDZIfN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:35:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E7407F211;
        Tue, 26 Apr 2022 01:28:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C46B561864;
        Tue, 26 Apr 2022 08:28:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D14E3C385A0;
        Tue, 26 Apr 2022 08:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961704;
        bh=/xxwTARog4nsNtTU4Kw8BDH+DOxCXvEIoJd0Sjp398M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o5+SnyuSig3GPbR9uf8fmk8YGEc2+Oif02/qOYrTB3HbwQzwOCu79sLAyCWmCeie1
         aUdAvx7miGraL6aOv1yeWpUQj4wupgHtDk0J+bC5XrfKz4iKTR1Py0HXy3ZeptapIP
         Nl7EUlQknB9Kv6I74pDkXXWc+uz/btqsNDctMQJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 33/53] powerpc/perf: Fix power9 event alternatives
Date:   Tue, 26 Apr 2022 10:21:13 +0200
Message-Id: <20220426081736.620247833@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081735.651926456@linuxfoundation.org>
References: <20220426081735.651926456@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Athira Rajeev <atrajeev@linux.vnet.ibm.com>

[ Upstream commit 0dcad700bb2776e3886fe0a645a4bf13b1e747cd ]

When scheduling a group of events, there are constraint checks done to
make sure all events can go in a group. Example, one of the criteria is
that events in a group cannot use the same PMC. But platform specific
PMU supports alternative event for some of the event codes. During
perf_event_open(), if any event group doesn't match constraint check
criteria, further lookup is done to find alternative event.

By current design, the array of alternatives events in PMU code is
expected to be sorted by column 0. This is because in
find_alternative() the return criteria is based on event code
comparison. ie. "event < ev_alt[i][0])". This optimisation is there
since find_alternative() can be called multiple times. In power9 PMU
code, the alternative event array is not sorted properly and hence there
is breakage in finding alternative events.

To work with existing logic, fix the alternative event array to be
sorted by column 0 for power9-pmu.c

Results:

With alternative events, multiplexing can be avoided. That is, for
example, in power9 PM_LD_MISS_L1 (0x3e054) has alternative event,
PM_LD_MISS_L1_ALT (0x400f0). This is an identical event which can be
programmed in a different PMC.

Before:

 # perf stat -e r3e054,r300fc

 Performance counter stats for 'system wide':

           1057860      r3e054              (50.21%)
               379      r300fc              (49.79%)

       0.944329741 seconds time elapsed

Since both the events are using PMC3 in this case, they are
multiplexed here.

After:

 # perf stat -e r3e054,r300fc

 Performance counter stats for 'system wide':

           1006948      r3e054
               182      r300fc

Fixes: 91e0bd1e6251 ("powerpc/perf: Add PM_LD_MISS_L1 and PM_BR_2PATH to power9 event list")
Signed-off-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Reviewed-by: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220419114828.89843-1-atrajeev@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/perf/power9-pmu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/perf/power9-pmu.c b/arch/powerpc/perf/power9-pmu.c
index c07b1615ee39..1aa083db77f1 100644
--- a/arch/powerpc/perf/power9-pmu.c
+++ b/arch/powerpc/perf/power9-pmu.c
@@ -143,11 +143,11 @@ int p9_dd22_bl_ev[] = {
 
 /* Table of alternatives, sorted by column 0 */
 static const unsigned int power9_event_alternatives[][MAX_ALT] = {
-	{ PM_INST_DISP,			PM_INST_DISP_ALT },
-	{ PM_RUN_CYC_ALT,		PM_RUN_CYC },
-	{ PM_RUN_INST_CMPL_ALT,		PM_RUN_INST_CMPL },
-	{ PM_LD_MISS_L1,		PM_LD_MISS_L1_ALT },
 	{ PM_BR_2PATH,			PM_BR_2PATH_ALT },
+	{ PM_INST_DISP,			PM_INST_DISP_ALT },
+	{ PM_RUN_CYC_ALT,               PM_RUN_CYC },
+	{ PM_LD_MISS_L1,                PM_LD_MISS_L1_ALT },
+	{ PM_RUN_INST_CMPL_ALT,         PM_RUN_INST_CMPL },
 };
 
 static int power9_get_alternatives(u64 event, unsigned int flags, u64 alt[])
-- 
2.35.1



