Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D22E548DAC
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379166AbiFMNr3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379807AbiFMNpK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:45:10 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 671EFBC32;
        Mon, 13 Jun 2022 04:32:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F12C3CE1166;
        Mon, 13 Jun 2022 11:32:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6818C34114;
        Mon, 13 Jun 2022 11:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119956;
        bh=M5mp1RPQTkYXAcbh8qjHiQxawRJ4iQjxfiOazWxSq0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZpytYb8QwpSo/P83b9KxstV8WE6bIHKQCDTiwy8cZHVs7JnIPmpKea0w6+AGS10Tm
         iI/wR1qOiCGjbF5ZqSkdCBFz94LRYb2bfgpHuXhDeGR0cUx62wzThRsypch+s1TLNg
         0jusEFyjpxZr+6pYY54j4iXOTfZcpoBkz9UwRcKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sachin Sant <sachinp@linux.ibm.com>,
        Vaibhav Jain <vaibhav@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 179/339] powerpc/papr_scm: dont requests stats with 0 sized stats buffer
Date:   Mon, 13 Jun 2022 12:10:04 +0200
Message-Id: <20220613094932.103027240@linuxfoundation.org>
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

From: Vaibhav Jain <vaibhav@linux.ibm.com>

[ Upstream commit 07bf9431b1590d1cd7a8d62075d0b50b073f0495 ]

Sachin reported [1] that on a POWER-10 lpar he is seeing a kernel panic being
reported with vPMEM when papr_scm probe is being called. The panic is of the
form below and is observed only with following option disabled(profile) for the
said LPAR 'Enable Performance Information Collection' in the HMC:

 Kernel attempted to write user page (1c) - exploit attempt? (uid: 0)
 BUG: Kernel NULL pointer dereference on write at 0x0000001c
 Faulting instruction address: 0xc008000001b90844
 Oops: Kernel access of bad area, sig: 11 [#1]
<snip>
 NIP [c008000001b90844] drc_pmem_query_stats+0x5c/0x270 [papr_scm]
 LR [c008000001b92794] papr_scm_probe+0x2ac/0x6ec [papr_scm]
 Call Trace:
       0xc00000000941bca0 (unreliable)
       papr_scm_probe+0x2ac/0x6ec [papr_scm]
       platform_probe+0x98/0x150
       really_probe+0xfc/0x510
       __driver_probe_device+0x17c/0x230
<snip>
 ---[ end trace 0000000000000000 ]---
 Kernel panic - not syncing: Fatal exception

On investigation looks like this panic was caused due to a 'stat_buffer' of
size==0 being provided to drc_pmem_query_stats() to fetch all performance
stats-ids of an NVDIMM. However drc_pmem_query_stats() shouldn't have been called
since the vPMEM NVDIMM doesn't support and performance stat-id's. This was caused
due to missing check for 'p->stat_buffer_len' at the beginning of
papr_scm_pmu_check_events() which indicates that the NVDIMM doesn't support
performance-stats.

Fix this by introducing the check for 'p->stat_buffer_len' at the beginning of
papr_scm_pmu_check_events().

[1] https://lore.kernel.org/all/6B3A522A-6A5F-4CC9-B268-0C63AA6E07D3@linux.ibm.com

Fixes: 0e0946e22f3665d2732 ("powerpc/papr_scm: Fix leaking nvdimm_events_map elements")
Reported-by: Sachin Sant <sachinp@linux.ibm.com>
Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Tested-by: Sachin Sant <sachinp@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220524112353.1718454-1-vaibhav@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/papr_scm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/powerpc/platforms/pseries/papr_scm.c b/arch/powerpc/platforms/pseries/papr_scm.c
index 181b855b3050..82cae08976bc 100644
--- a/arch/powerpc/platforms/pseries/papr_scm.c
+++ b/arch/powerpc/platforms/pseries/papr_scm.c
@@ -465,6 +465,9 @@ static int papr_scm_pmu_check_events(struct papr_scm_priv *p, struct nvdimm_pmu
 	u32 available_events;
 	int index, rc = 0;
 
+	if (!p->stat_buffer_len)
+		return -ENOENT;
+
 	available_events = (p->stat_buffer_len  - sizeof(struct papr_scm_perf_stats))
 			/ sizeof(struct papr_scm_perf_stat);
 	if (available_events == 0)
-- 
2.35.1



