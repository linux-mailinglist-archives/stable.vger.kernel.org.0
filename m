Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A37034BF68
	for <lists+stable@lfdr.de>; Sun, 28 Mar 2021 23:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbhC1Vke (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Mar 2021 17:40:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:47668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230184AbhC1VkZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 28 Mar 2021 17:40:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 913D761936;
        Sun, 28 Mar 2021 21:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616967624;
        bh=phaHqdSHaYeq4heUgAfHA/lEIE9IeZt1TwGioJP+39E=;
        h=Date:From:To:Subject:From;
        b=h9DHTJtTHJAU7YzB+5B3mr0HDq6bWnlES1wH/SIGOiDGFaR6e/OTmU60GyYkuJKmI
         N9KQgUXaXBNpvOkI9TF2Yu9BR0FQREHqRMIJBbgi43AqEx8LXq/j+mzwlvybe+yN74
         IP7XTzWZ/Vclg8fia6Izr/F8bCGiKgzrKs94whXs=
Date:   Sun, 28 Mar 2021 14:40:24 -0700
From:   akpm@linux-foundation.org
To:     jack.qiu@huawei.com, jack@suse.cz, mm-commits@vger.kernel.org,
        stable@vger.kernel.org
Subject:  + fs-direct-io-fix-missing-sdio-boundary.patch added to
 -mm tree
Message-ID: <20210328214024.f6aCv9Crz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: fs: direct-io: fix missing sdio->boundary
has been added to the -mm tree.  Its filename is
     fs-direct-io-fix-missing-sdio-boundary.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-direct-io-fix-missing-sdio-boundary.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-direct-io-fix-missing-sdio-boundary.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jack Qiu <jack.qiu@huawei.com>
Subject: fs: direct-io: fix missing sdio->boundary

dio_send_cur_page() may clear sdio->boundary, so save it to avoid missing
a boundary.

Link: https://lkml.kernel.org/r/20210322042253.38312-1-jack.qiu@huawei.com
Fixes: b1058b981272 ("direct-io: submit bio after boundary buffer is
added to it")
Signed-off-by: Jack Qiu <jack.qiu@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/direct-io.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/direct-io.c~fs-direct-io-fix-missing-sdio-boundary
+++ a/fs/direct-io.c
@@ -812,6 +812,7 @@ submit_page_section(struct dio *dio, str
 		    struct buffer_head *map_bh)
 {
 	int ret = 0;
+	int boundary = sdio->boundary;	/* dio_send_cur_page may clear it */
 
 	if (dio->op == REQ_OP_WRITE) {
 		/*
@@ -850,10 +851,10 @@ submit_page_section(struct dio *dio, str
 	sdio->cur_page_fs_offset = sdio->block_in_file << sdio->blkbits;
 out:
 	/*
-	 * If sdio->boundary then we want to schedule the IO now to
+	 * If boundary then we want to schedule the IO now to
 	 * avoid metadata seeks.
 	 */
-	if (sdio->boundary) {
+	if (boundary) {
 		ret = dio_send_cur_page(dio, sdio, map_bh);
 		if (sdio->bio)
 			dio_bio_submit(dio, sdio);
_

Patches currently in -mm which might be from jack.qiu@huawei.com are

fs-direct-io-fix-missing-sdio-boundary.patch

