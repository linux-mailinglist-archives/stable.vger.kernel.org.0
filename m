Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25C83651551
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 23:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232685AbiLSWJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 17:09:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232556AbiLSWJB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 17:09:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01856164A8;
        Mon, 19 Dec 2022 14:06:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1951B80E48;
        Mon, 19 Dec 2022 22:05:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88993C433F0;
        Mon, 19 Dec 2022 22:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671487550;
        bh=A4qHpnyuxFin9gSIGPKBtc3arPoWOENwBvggAh4TlFo=;
        h=Date:To:From:Subject:From;
        b=pmesh8zowd9q2R8VxXCKPrFYB9Al/RGyMOfXCxd0y/z0mnt9tlJ/+g8DJCmcuEXsX
         XZV5pXtP3iWKd2VgOPvCxT29nwUebUNDA44VuLHYPLO0qarSllFghQQJgoDFKbDK7+
         ciWtJe57JDCNNlRo6zRVqUDKrOiHwuk/lQ522fPU=
Date:   Mon, 19 Dec 2022 14:05:49 -0800
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        stable@vger.kernel.org, rppt@kernel.org, Liam.Howlett@oracle.com,
        avagin@gmail.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-fix-mas_spanning_rebalance-on-insufficient-data.patch added to mm-hotfixes-unstable branch
Message-Id: <20221219220550.88993C433F0@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: maple_tree: fix mas_spanning_rebalance() on insufficient data
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maple_tree-fix-mas_spanning_rebalance-on-insufficient-data.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-fix-mas_spanning_rebalance-on-insufficient-data.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Liam Howlett <liam.howlett@oracle.com>
Subject: maple_tree: fix mas_spanning_rebalance() on insufficient data
Date: Mon, 19 Dec 2022 16:20:15 +0000

Mike Rapoport contacted me off-list with a regression in running criu. 
Periodic tests fail with an RCU stall during execution.  Although rare, it
is possible to hit this with other uses so this patch should be backported
to fix the regression.

This patchset adds the fix and a test case to the maple tree test
suite.


This patch (of 2):

An insufficient node was causing an out-of-bounds access on the node in
mas_leaf_max_gap().  The cause was the faulty detection of the new node
being a root node when overwriting many entries at the end of the tree.

Fix the detection of a new root and ensure there is sufficient data prior
to entering the spanning rebalance loop.

Link: https://lkml.kernel.org/r/20221219161922.2708732-1-Liam.Howlett@oracle.com
Link: https://lkml.kernel.org/r/20221219161922.2708732-2-Liam.Howlett@oracle.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Mike Rapoport <rppt@kernel.org>
Tested-by: Mike Rapoport <rppt@kernel.org>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-fix-mas_spanning_rebalance-on-insufficient-data
+++ a/lib/maple_tree.c
@@ -2994,7 +2994,9 @@ static int mas_spanning_rebalance(struct
 	mast->free = &free;
 	mast->destroy = &destroy;
 	l_mas.node = r_mas.node = m_mas.node = MAS_NONE;
-	if (!(mast->orig_l->min && mast->orig_r->max == ULONG_MAX) &&
+
+	/* Check if this is not root and has sufficient data.  */
+	if (((mast->orig_l->min != 0) || (mast->orig_r->max != ULONG_MAX)) &&
 	    unlikely(mast->bn->b_end <= mt_min_slots[mast->bn->type]))
 		mast_spanning_rebalance(mast);
 
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

maple_tree-fix-mas_spanning_rebalance-on-insufficient-data.patch
test_maple_tree-add-test-for-mas_spanning_rebalance-on-insufficient-data.patch

