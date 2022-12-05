Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFE36436A0
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 22:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbiLEVN4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 16:13:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232391AbiLEVNn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 16:13:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E1412B1A8;
        Mon,  5 Dec 2022 13:13:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06F44B81232;
        Mon,  5 Dec 2022 21:13:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CD5FC433B5;
        Mon,  5 Dec 2022 21:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670274819;
        bh=Vruv68hVo08YBHFSEtZFGa4/PD/ok/tOZA0vwZIOEXc=;
        h=Date:To:From:Subject:From;
        b=IpLUtOJmA0Pfe/VFBogI8VJXpNBw6B0X1sEW0qm1njx8Jd6WCqc+CUXHk64zddbeN
         eCiChHgs+5SGaD6GcaRRyBkrIPkwHhYEJcTJNb4H684X+Qo1gXL0yIg333klan+6L0
         89g1FHlU9K5tTNWGtHPEO5rwuYsHmdblPrunui2I=
Date:   Mon, 05 Dec 2022 13:13:38 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        mgorman@techsingularity.net, tcm1030@163.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] mm-mempolicy-failed-to-disable-numa-balancing.patch removed from -mm tree
Message-Id: <20221205211339.9CD5FC433B5@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/mempolicy: failed to disable numa balancing
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-failed-to-disable-numa-balancing.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: tzm <tcm1030@163.com>
Subject: mm/mempolicy: failed to disable numa balancing
Date: Fri, 2 Dec 2022 22:16:30 +0800

The kernel fails to disable numa balancing policy permanently when the
user passes <numa_balancing=disable> to the boot cmdline parameters.  The
numabalancing_override variable is 1 for enable -1 for disable.  So,
!numabalancing_override will always be true, which causes this bug.

Link: https://lkml.kernel.org/r/20221202141630.41220-1-tcm1030@163.com
Signed-off-by: tzm <tcm1030@163.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mempolicy.c~mm-mempolicy-failed-to-disable-numa-balancing
+++ a/mm/mempolicy.c
@@ -2865,7 +2865,7 @@ static void __init check_numabalancing_e
 	if (numabalancing_override)
 		set_numabalancing_state(numabalancing_override == 1);
 
-	if (num_online_nodes() > 1 && !numabalancing_override) {
+	if (num_online_nodes() > 1 && (numabalancing_override == 1)) {
 		pr_info("%s automatic NUMA balancing. Configure with numa_balancing= or the kernel.numa_balancing sysctl\n",
 			numabalancing_default ? "Enabling" : "Disabling");
 		set_numabalancing_state(numabalancing_default);
_

Patches currently in -mm which might be from tcm1030@163.com are


