Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ABB74B7A45
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 23:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244497AbiBOWM7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 17:12:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244496AbiBOWM4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 17:12:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 565AC27CC4;
        Tue, 15 Feb 2022 14:12:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D012B81D11;
        Tue, 15 Feb 2022 22:12:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC805C340F2;
        Tue, 15 Feb 2022 22:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644963162;
        bh=hvqosyp3+aZA6FHBGhwNZNWZ8KHIUcsC7gsZ33yZ/AE=;
        h=Date:To:From:Subject:From;
        b=d+ZoKgFi6F4YHE6Q6bqa0P9igXVXX2IdGqqTAcLaFqdBTUhaFNuvqXX2F5lPOvks/
         So0KdUbHDiOiBU+C0J8nc/I5DqStMKp7u06QskCZAE+tNP917+qTSJ1JSEpAFEawg2
         AQerggeHfcvg68c3+JjRH6iyT9H1vRrg6VycGOcc=
Date:   Tue, 15 Feb 2022 14:12:42 -0800
To:     mm-commits@vger.kernel.org, zealci@zte.com.cn,
        yang.yang29@zte.com.cn, stable@vger.kernel.org,
        songliubraving@fb.com, mike.kravetz@oracle.com,
        kirill@shutemov.name, hughd@google.com, wang.yong12@zte.com.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fix-shmem-huge-page-failed-to-set-f_seal_write-attribute-problem.patch added to -mm tree
Message-Id: <20220215221242.AC805C340F2@smtp.kernel.org>
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
     Subject: memfd: fix shmem huge page failed to set F_SEAL_WRITE attribute problem
has been added to the -mm tree.  Its filename is
     fix-shmem-huge-page-failed-to-set-f_seal_write-attribute-problem.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fix-shmem-huge-page-failed-to-set-f_seal_write-attribute-problem.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fix-shmem-huge-page-failed-to-set-f_seal_write-attribute-problem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: wangyong <wang.yong12@zte.com.cn>
Subject: memfd: fix shmem huge page failed to set F_SEAL_WRITE attribute problem

After enabling tmpfs filesystem to support transparent hugepage with the
following command:

 echo always > /sys/kernel/mm/transparent_hugepage/shmem_enabled

The docker program adds F_SEAL_WRITE through the following command which
will prompt EBUSY.

 fcntl(5, F_ADD_SEALS, F_SEAL_WRITE)=-1.

It is found that in memfd_wait_for_pins function, the page_count of
hugepage is 512 and page_mapcount is 0, which does not meet the
conditions:

 page_count(page) - page_mapcount(page) != 1.

But the page is not busy at this time, therefore, the page_order of
hugepage should be taken into account in the calculation.

Link: https://lkml.kernel.org/r/20220215073743.1769979-1-cgel.zte@gmail.com
Signed-off-by: wangyong <wang.yong12@zte.com.cn>
Reported-by: Zeal Robot <zealci@zte.com.cn>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/mm/memfd.c~fix-shmem-huge-page-failed-to-set-f_seal_write-attribute-problem
+++ a/mm/memfd.c
@@ -31,6 +31,7 @@
 static void memfd_tag_pins(struct xa_state *xas)
 {
 	struct page *page;
+	int count = 0;
 	unsigned int tagged = 0;
 
 	lru_add_drain();
@@ -39,8 +40,12 @@ static void memfd_tag_pins(struct xa_sta
 	xas_for_each(xas, page, ULONG_MAX) {
 		if (xa_is_value(page))
 			continue;
+
 		page = find_subpage(page, xas->xa_index);
-		if (page_count(page) - page_mapcount(page) > 1)
+		count = page_count(page);
+		if (PageTransCompound(page))
+			count -= (1 << compound_order(compound_head(page))) - 1;
+		if (count - page_mapcount(page) > 1)
 			xas_set_mark(xas, MEMFD_TAG_PINNED);
 
 		if (++tagged % XA_CHECK_SCHED)
@@ -67,11 +72,12 @@ static int memfd_wait_for_pins(struct ad
 {
 	XA_STATE(xas, &mapping->i_pages, 0);
 	struct page *page;
-	int error, scan;
+	int error, scan, count;
 
 	memfd_tag_pins(&xas);
 
 	error = 0;
+	count = 0;
 	for (scan = 0; scan <= LAST_SCAN; scan++) {
 		unsigned int tagged = 0;
 
@@ -89,8 +95,12 @@ static int memfd_wait_for_pins(struct ad
 			bool clear = true;
 			if (xa_is_value(page))
 				continue;
+
 			page = find_subpage(page, xas.xa_index);
-			if (page_count(page) - page_mapcount(page) != 1) {
+			count = page_count(page);
+			if (PageTransCompound(page))
+				count -= (1 << compound_order(compound_head(page))) - 1;
+			if (count - page_mapcount(page) != 1) {
 				/*
 				 * On the last scan, we clean up all those tags
 				 * we inserted; but make a note that we still
_

Patches currently in -mm which might be from wang.yong12@zte.com.cn are

fix-shmem-huge-page-failed-to-set-f_seal_write-attribute-problem.patch

