Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3045C541567
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359522AbiFGUfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377480AbiFGUdZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:33:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E621E4B59;
        Tue,  7 Jun 2022 11:35:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF18B61579;
        Tue,  7 Jun 2022 18:35:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D18C385A2;
        Tue,  7 Jun 2022 18:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626912;
        bh=MwkXSTXX1SoxGg296H8rRNoP2hCJWyFATvvvYG9Rq2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tXVR3fuyAHg6ECIPP154vO3C3DjW5GzZApIRxRbGi9I1lf3pspkwmaE6NalBnAl8X
         MGv8lzAfewZdmv6J27RMpALMeAAQWqgxM7z6juzrk17fCE4ABynuEk+QGw01rzsrSp
         kck645mP52YFC3tI8IXbW5sKE+RQk41mL+pHh3Ts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kajol Jain <kjain@linux.ibm.com>,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 548/772] powerpc/perf: Fix the threshold compare group constraint for power10
Date:   Tue,  7 Jun 2022 19:02:20 +0200
Message-Id: <20220607165005.111530900@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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

From: Kajol Jain <kjain@linux.ibm.com>

[ Upstream commit 505d31650ba96d6032313480fdb566d289a4698c ]

Thresh compare bits for a event is used to program thresh compare
field in Monitor Mode Control Register A (MMCRA: 8-18 bits for power10).
When scheduling events as a group, all events in that group should
match value in threshold bits. Otherwise event open for the sibling
events should fail. But in the current code, incase thresh compare bits are
not valid, we are not failing in group_constraint function which can result
in invalid group schduling.

Fix the issue by returning -1 incase event is threshold and threshold
compare value is not valid in group_constraint function.

Patch also fixes the p10_thresh_cmp_val function to return -1,
incase threshold bits are not valid and changes corresponding check in
is_thresh_cmp_valid function to return false only when the thresh_cmp
value is less then 0.

Thresh control bits in the event code is used to program thresh_ctl
field in Monitor Mode Control Register A (MMCRA: 48-55). In below example,
the scheduling of group events PM_MRK_INST_CMPL (3534401e0) and
PM_THRESH_MET (34340101ec) is expected to fail as both event
request different thresh control bits.

Result before the patch changes:

[command]# perf stat -e "{r35340401e0,r34340101ec}" sleep 1

 Performance counter stats for 'sleep 1':

             8,482      r35340401e0
                 0      r34340101ec

       1.001474838 seconds time elapsed

       0.001145000 seconds user
       0.000000000 seconds sys

Result after the patch changes:

[command]# perf stat -e "{r35340401e0,r34340101ec}" sleep 1

 Performance counter stats for 'sleep 1':

     <not counted>      r35340401e0
   <not supported>      r34340101ec

       1.001499607 seconds time elapsed

       0.000204000 seconds user
       0.000760000 seconds sys

Fixes: 82d2c16b350f7 ("powerpc/perf: Adds support for programming of Thresholding in P10")
Signed-off-by: Kajol Jain <kjain@linux.ibm.com>
Reviewed-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220506061015.43916-1-kjain@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/perf/isa207-common.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/perf/isa207-common.c b/arch/powerpc/perf/isa207-common.c
index 4037ea652522..8f0ecf99c96e 100644
--- a/arch/powerpc/perf/isa207-common.c
+++ b/arch/powerpc/perf/isa207-common.c
@@ -108,7 +108,7 @@ static void mmcra_sdar_mode(u64 event, unsigned long *mmcra)
 		*mmcra |= MMCRA_SDAR_MODE_TLB;
 }
 
-static u64 p10_thresh_cmp_val(u64 value)
+static int p10_thresh_cmp_val(u64 value)
 {
 	int exp = 0;
 	u64 result = value;
@@ -139,7 +139,7 @@ static u64 p10_thresh_cmp_val(u64 value)
 		 * exponent is also zero.
 		 */
 		if (!(value & 0xC0) && exp)
-			result = 0;
+			result = -1;
 		else
 			result = (exp << 8) | value;
 	}
@@ -187,7 +187,7 @@ static bool is_thresh_cmp_valid(u64 event)
 	unsigned int cmp, exp;
 
 	if (cpu_has_feature(CPU_FTR_ARCH_31))
-		return p10_thresh_cmp_val(event) != 0;
+		return p10_thresh_cmp_val(event) >= 0;
 
 	/*
 	 * Check the mantissa upper two bits are not zero, unless the
@@ -502,7 +502,8 @@ int isa207_get_constraint(u64 event, unsigned long *maskp, unsigned long *valp,
 			value |= CNST_THRESH_CTL_SEL_VAL(event >> EVENT_THRESH_SHIFT);
 			mask  |= p10_CNST_THRESH_CMP_MASK;
 			value |= p10_CNST_THRESH_CMP_VAL(p10_thresh_cmp_val(event_config1));
-		}
+		} else if (event_is_threshold(event))
+			return -1;
 	} else if (cpu_has_feature(CPU_FTR_ARCH_300))  {
 		if (event_is_threshold(event) && is_thresh_cmp_valid(event)) {
 			mask  |= CNST_THRESH_MASK;
-- 
2.35.1



