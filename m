Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07C415EB114
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 21:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbiIZTPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 15:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiIZTPf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 15:15:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC9F32042;
        Mon, 26 Sep 2022 12:15:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B12160EB1;
        Mon, 26 Sep 2022 19:15:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2810C433D7;
        Mon, 26 Sep 2022 19:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664219733;
        bh=2r+tnLDfuIYp2N/vNJ9Ix4iq2DF7c9IvsqCKfJlQ6aE=;
        h=Date:To:From:Subject:From;
        b=NV0b4sIQH/WfSLAqY51kJIgSU6ER6688S0MSNbKwDb0Gu3+9a8/uZcwqfAhuil1vV
         FZRun+l+1ibHEGcyUo7RANuMguabmX3hECxOncYY2TSYFWKaVkJeIdEjBvjVRer1de
         0Leud8hoI7zqtFLYa9l+5zPzOQd7XQv0g6ExwSpY=
Date:   Mon, 26 Sep 2022 12:15:33 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        shy828301@gmail.com, hantianshuo@iie.ac.cn, minchan@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-fix-madivse_pageout-mishandling-on-non-lru-page.patch removed from -mm tree
Message-Id: <20220926191533.B2810C433D7@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,PP_MIME_FAKE_ASCII_TEXT,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm: fix madvise_pageout mishandling on non-LRU page
has been removed from the -mm tree.  Its filename was
     mm-fix-madivse_pageout-mishandling-on-non-lru-page.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: fix madivse_pageout mishandling on non-LRU page
Date: Thu, 8 Sep 2022 08:12:04 -0700

MADV_PAGEOUT tries to isolate non-LRU pages and gets a warning from
isolate_lru_page below.

Fix it by checking PageLRU in advance.

------------[ cut here ]------------
trying to isolate tail page
WARNING: CPU: 0 PID: 6175 at mm/folio-compat.c:158 isolate_lru_page+0x130/0x140
Modules linked in:
CPU: 0 PID: 6175 Comm: syz-executor.0 Not tainted 5.18.12 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:isolate_lru_page+0x130/0x140

Link: https://lore.kernel.org/linux-mm/485f8c33.2471b.182d5726afb.Coremail.hantianshuo@iie.ac.cn/
Link: https://lkml.kernel.org/r/20220908151204.762596-1-minchan@kernel.org
Fixes: 1a4e58cce84e ("mm: introduce MADV_PAGEOUT")
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reported-by: éŸ©å¤©ç`• <hantianshuo@iie.ac.cn>
Suggested-by: Yang Shi <shy828301@gmail.com>
Acked-by: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/madvise.c~mm-fix-madivse_pageout-mishandling-on-non-lru-page
+++ a/mm/madvise.c
@@ -451,8 +451,11 @@ regular_page:
 			continue;
 		}
 
-		/* Do not interfere with other mappings of this page */
-		if (page_mapcount(page) != 1)
+		/*
+		 * Do not interfere with other mappings of this page and
+		 * non-LRU page.
+		 */
+		if (!PageLRU(page) || page_mapcount(page) != 1)
 			continue;
 
 		VM_BUG_ON_PAGE(PageTransCompound(page), page);
_

Patches currently in -mm which might be from minchan@kernel.org are


