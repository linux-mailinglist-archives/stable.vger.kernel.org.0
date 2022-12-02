Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 549D3640ED4
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 21:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234449AbiLBUAL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 15:00:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234215AbiLBUAL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 15:00:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF3EE02EA;
        Fri,  2 Dec 2022 12:00:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DEB3D62035;
        Fri,  2 Dec 2022 20:00:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 410C9C433D6;
        Fri,  2 Dec 2022 20:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670011209;
        bh=7LqwGyELMsEFkuEfbtBx4GEsTrKWFewyBc7UknguVx8=;
        h=Date:To:From:Subject:From;
        b=pD/maZZezzVHFdUAcXisa9Do9R584rKFOZjypApbKghuBZyWvMC9+kvoRQpVF1zLW
         lmtU5FbZg6cmXsyCK8BRdXe6wQajoaEU7t7UdmPmEY4iHhbJ1Vvi8kZgNH0FgbDz5h
         XmRpc8iiKzSieUmnVjBw9AJPVOtFne7tY4TXGiGM=
Date:   Fri, 02 Dec 2022 12:00:08 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        mgorman@techsingularity.net, tcm1030@163.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-failed-to-disable-numa-balancing.patch added to mm-unstable branch
Message-Id: <20221202200009.410C9C433D6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: failed to disable numa balancing
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mempolicy-failed-to-disable-numa-balancing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-failed-to-disable-numa-balancing.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-mempolicy-failed-to-disable-numa-balancing.patch

