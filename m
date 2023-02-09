Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D68A86912A3
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 22:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbjBIV3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 16:29:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbjBIV3n (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 16:29:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA4ED5ACC1;
        Thu,  9 Feb 2023 13:29:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A377B816DD;
        Thu,  9 Feb 2023 21:29:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A11C4339C;
        Thu,  9 Feb 2023 21:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675978180;
        bh=HVBtsj0d+zxhqBt4QDtTRv3AilgydBUVKjFcLtKL5h0=;
        h=Date:To:From:Subject:From;
        b=tp7QNhGbWFSFFwvVQAlUv0gw+4vHT12sdlzoFyNXPo3d0CcfoG2OTayIDN5kJvBb3
         AbVG1YHlvDJaoX+1i9vLROoUZELyAcJOj5Z96bVBS1bxCD3f2zFct8syxNIaIqWws2
         lj+MB0/nOIYsdwtKnh1TY5y2OcLyrxOy3jXtdmhs=
Date:   Thu, 09 Feb 2023 13:29:39 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        shy828301@gmail.com, hughd@google.com, zokeefe@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madv_collapse-set-eagain-on-unexpected-page-refcount.patch added to mm-hotfixes-unstable branch
Message-Id: <20230209212940.08A11C4339C@smtp.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/MADV_COLLAPSE: set EAGAIN on unexpected page refcount
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-madv_collapse-set-eagain-on-unexpected-page-refcount.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madv_collapse-set-eagain-on-unexpected-page-refcount.patch

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
From: "Zach O'Keefe" <zokeefe@google.com>
Subject: mm/MADV_COLLAPSE: set EAGAIN on unexpected page refcount
Date: Tue, 24 Jan 2023 17:57:37 -0800

During collapse, in a few places we check to see if a given small page has
any unaccounted references.  If the refcount on the page doesn't match our
expectations, it must be there is an unknown user concurrently interested
in the page, and so it's not safe to move the contents elsewhere. 
However, the unaccounted pins are likely an ephemeral state.

In such a situation, make MADV_COLLAPSE set EAGAIN errno, indicating that
collapse may succeed on retry.

Link: https://lkml.kernel.org/r/20230125015738.912924-1-zokeefe@google.com
Fixes: 7d8faaf15545 ("mm/madvise: introduce MADV_COLLAPSE sync hugepage collapse")
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Reported-by: Hugh Dickins <hughd@google.com>
Acked-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/khugepaged.c~mm-madv_collapse-set-eagain-on-unexpected-page-refcount
+++ a/mm/khugepaged.c
@@ -2611,6 +2611,7 @@ static int madvise_collapse_errno(enum s
 	case SCAN_CGROUP_CHARGE_FAIL:
 		return -EBUSY;
 	/* Resource temporary unavailable - trying again might succeed */
+	case SCAN_PAGE_COUNT:
 	case SCAN_PAGE_LOCK:
 	case SCAN_PAGE_LRU:
 	case SCAN_DEL_PAGE_LRU:
_

Patches currently in -mm which might be from zokeefe@google.com are

mm-madv_collapse-set-eagain-on-unexpected-page-refcount.patch

