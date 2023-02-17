Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0A369A3C6
	for <lists+stable@lfdr.de>; Fri, 17 Feb 2023 03:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbjBQCM3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 21:12:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbjBQCM3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 21:12:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D3033B856;
        Thu, 16 Feb 2023 18:12:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07B406123D;
        Fri, 17 Feb 2023 02:12:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53654C4339B;
        Fri, 17 Feb 2023 02:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676599947;
        bh=xJKhC3IDqhyWV/NDvL4zoWgraVILgyFZbv5mjWHunuE=;
        h=Date:To:From:Subject:From;
        b=UUiJ4QqwN4gdBQOpbbEbBeKgvSq4EsXSfnuLqiRXDQa/vFDt7D+zetzZ3X8JdatyY
         Bn+voMlXG6GAgW1dJewSkYerVgkwehm7xU5zGGJ+mx8IJOeI2kM+Pl7FWAysxNCiuD
         8Sr2sEJJ+1aaogPyWXA2P4Z2Mw4MBEYfL6FmfUjI=
Date:   Thu, 16 Feb 2023 18:12:26 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        shy828301@gmail.com, hughd@google.com, zokeefe@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-madv_collapse-set-eagain-on-unexpected-page-refcount.patch removed from -mm tree
Message-Id: <20230217021227.53654C4339B@smtp.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/MADV_COLLAPSE: set EAGAIN on unexpected page refcount
has been removed from the -mm tree.  Its filename was
     mm-madv_collapse-set-eagain-on-unexpected-page-refcount.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Zach O'Keefe" <zokeefe@google.com>
Subject: mm/MADV_COLLAPSE: set EAGAIN on unexpected page refcount
Date: Tue, 24 Jan 2023 17:57:37 -0800

During collapse, in a few places we check to see if a given small page has
any unaccounted references.  If the refcount on the page doesn't match our
expectations, it must be there is an unknown user concurrently interested
in the page, and so it's not safe to move the contents elsewhere. 
However, the unaccounted pins are likely an ephemeral state.

In this situation, MADV_COLLAPSE returns -EINVAL when it should return
-EAGAIN.  This could cause userspace to conclude that the syscall
failed, when it in fact could succeed by retrying.

Link: https://lkml.kernel.org/r/20230125015738.912924-1-zokeefe@google.com
Fixes: 7d8faaf15545 ("mm/madvise: introduce MADV_COLLAPSE sync hugepage collapse")
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Reported-by: Hugh Dickins <hughd@google.com>
Acked-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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


