Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56DE24B2FCC
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 22:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245199AbiBKVtW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 16:49:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242619AbiBKVtV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 16:49:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2585BBC;
        Fri, 11 Feb 2022 13:49:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B44C061143;
        Fri, 11 Feb 2022 21:49:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08417C340E9;
        Fri, 11 Feb 2022 21:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644616159;
        bh=P9GUISybgAWXw6YUy3x77RhDfr49i0EVYEY72uWy31E=;
        h=Date:To:From:Subject:From;
        b=cXKc0S7AMUVLvlIy1t3y2wWeB2eRnC1DD3LPKvitI5rC508t1erwNkrS+xCXV7nAC
         /HB4O9QAxeR7ITFxCYQcCEzd4/22Na82ZO2CNwrKnA9+FNXNhzy5uY4+cIyY6oPKQo
         /bEyFyLGig6kWi0FyDmTJw7ku5NN4e4bxUZmUq1c=
Date:   Fri, 11 Feb 2022 13:49:18 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        mike.kravetz@oracle.com, liuyuntao10@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlbfs-fix-a-truncation-issue-in-hugepages-parameter.patch added to -mm tree
Message-Id: <20220211214919.08417C340E9@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: hugetlbfs: fix a truncation issue in hugepages parameter
has been added to the -mm tree.  Its filename is
     hugetlbfs-fix-a-truncation-issue-in-hugepages-parameter.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlbfs-fix-a-truncation-issue-in-hugepages-parameter.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlbfs-fix-a-truncation-issue-in-hugepages-parameter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Liu Yuntao <liuyuntao10@huawei.com>
Subject: hugetlbfs: fix a truncation issue in hugepages parameter

When we specify a large number for node in hugepages parameter, it may be
parsed to another number due to truncation in this statement:

	node = tmp;

For example, add following parameter in command line:

	hugepagesz=1G hugepages=4294967297:5

and kernel will allocate 5 hugepages for node 1 instead of ignoring it.

I move the validation check earlier to fix this issue, and slightly
simplifies the condition here.

Link: https://lkml.kernel.org/r/20220209134018.8242-1-liuyuntao10@huawei.com
Fixes: b5389086ad7be0 ("hugetlbfs: extend the definition of hugepages parameter to support node allocation")
Signed-off-by: Liu Yuntao <liuyuntao10@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/hugetlb.c~hugetlbfs-fix-a-truncation-issue-in-hugepages-parameter
+++ a/mm/hugetlb.c
@@ -4159,10 +4159,10 @@ static int __init hugepages_setup(char *
 				pr_warn("HugeTLB: architecture can't support node specific alloc, ignoring!\n");
 				return 0;
 			}
+			if (tmp >= nr_online_nodes)
+				goto invalid;
 			node = tmp;
 			p += count + 1;
-			if (node < 0 || node >= nr_online_nodes)
-				goto invalid;
 			/* Parse hugepages */
 			if (sscanf(p, "%lu%n", &tmp, &count) != 1)
 				goto invalid;
_

Patches currently in -mm which might be from liuyuntao10@huawei.com are

hugetlbfs-fix-a-truncation-issue-in-hugepages-parameter.patch

