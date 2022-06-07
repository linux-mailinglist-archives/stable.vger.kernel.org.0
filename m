Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1BA654159B
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376847AbiFGUhn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377498AbiFGUd2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:33:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D75AA1E4B6D;
        Tue,  7 Jun 2022 11:35:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EA50612EC;
        Tue,  7 Jun 2022 18:35:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AEB1C385A2;
        Tue,  7 Jun 2022 18:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626914;
        bh=p/mEEgaVRxduYfIb8Rfiqp4KRdQAhjYDhovJPQu9nWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lQc1BnhH/tROXVeZE1zjL4qZ1bflBW007gFBeFO4JHntL+UJIBQaHCgXAmao1E6JN
         oghKK0kNjK9cCcUr6XxgPzKvm4m9QbEvoW0+btjE5AGVrqfWKIenrgISyEcDpgW93N
         NT+9GKbJsWUZNcW4nfQoHYlWV6CWmYI5BedQiG1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kajol Jain <kjain@linux.ibm.com>,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 549/772] powerpc/perf: Fix the threshold compare group constraint for power9
Date:   Tue,  7 Jun 2022 19:02:21 +0200
Message-Id: <20220607165005.139776414@linuxfoundation.org>
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

[ Upstream commit ab0cc6bbf0c812731c703ec757fcc3fc3a457a34 ]

Thresh compare bits for a event is used to program thresh compare
field in Monitor Mode Control Register A (MMCRA: 9-18 bits for power9).
When scheduling events as a group, all events in that group should
match value in threshold bits (like thresh compare, thresh control,
thresh select). Otherwise event open for the sibling events should fail.
But in the current code, incase thresh compare bits are not valid,
we are not failing in group_constraint function which can result
in invalid group schduling.

Fix the issue by returning -1 incase event is threshold and threshold
compare value is not valid.

Thresh control bits in the event code is used to program thresh_ctl
field in Monitor Mode Control Register A (MMCRA: 48-55). In below example,
the scheduling of group events PM_MRK_INST_CMPL (873534401e0) and
PM_THRESH_MET (8734340101ec) is expected to fail as both event
request different thresh control bits and invalid thresh compare value.

Result before the patch changes:

[command]# perf stat -e "{r8735340401e0,r8734340101ec}" sleep 1

 Performance counter stats for 'sleep 1':

            11,048      r8735340401e0
             1,967      r8734340101ec

       1.001354036 seconds time elapsed

       0.001421000 seconds user
       0.000000000 seconds sys

Result after the patch changes:

[command]# perf stat -e "{r8735340401e0,r8734340101ec}" sleep 1
Error:
The sys_perf_event_open() syscall returned with 22 (Invalid argument)
for event (r8735340401e0).
/bin/dmesg | grep -i perf may provide additional information.

Fixes: 78a16d9fc1206 ("powerpc/perf: Avoid FAB_*_MATCH checks for power9")
Signed-off-by: Kajol Jain <kjain@linux.ibm.com>
Reviewed-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220506061015.43916-2-kjain@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/perf/isa207-common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/perf/isa207-common.c b/arch/powerpc/perf/isa207-common.c
index 8f0ecf99c96e..abc4c5187dbc 100644
--- a/arch/powerpc/perf/isa207-common.c
+++ b/arch/powerpc/perf/isa207-common.c
@@ -508,7 +508,8 @@ int isa207_get_constraint(u64 event, unsigned long *maskp, unsigned long *valp,
 		if (event_is_threshold(event) && is_thresh_cmp_valid(event)) {
 			mask  |= CNST_THRESH_MASK;
 			value |= CNST_THRESH_VAL(event >> EVENT_THRESH_SHIFT);
-		}
+		} else if (event_is_threshold(event))
+			return -1;
 	} else {
 		/*
 		 * Special case for PM_MRK_FAB_RSP_MATCH and PM_MRK_FAB_RSP_MATCH_CYC,
-- 
2.35.1



