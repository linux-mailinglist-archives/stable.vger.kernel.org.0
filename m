Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73DAD1E03D9
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 01:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388500AbgEXXSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 May 2020 19:18:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:54732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388468AbgEXXSY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 24 May 2020 19:18:24 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 944E420787;
        Sun, 24 May 2020 23:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590362303;
        bh=p7Spk7tmcNQHEa5PSG0X16U8bOtO5FQbh5xnjojoZBg=;
        h=Date:From:To:Subject:From;
        b=dLpuSgAohpJDVvCvljiUpxHUGTeXj3MzxcIDXO+QlSxX/ZR96vaXudFVdRq9K5sLj
         Q/1BLWV+IplXpOM0DuXBGEaY3Mkj3iYHP8Ec6+K2vOHcBRT6iyVeOv0mxZqHLvknWp
         0AfYis8/3pLPLeOgkyyT4ffULtMfEelbYLykYwQ4=
Date:   Sun, 24 May 2020 16:18:23 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, alex.bou9@gmail.com,
        dan.carpenter@oracle.com, jhubbard@nvidia.com,
        mm-commits@vger.kernel.org, mporter@kernel.crashing.org,
        stable@vger.kernel.org, sumit.semwal@linaro.org
Subject:  [merged]
 rapidio-fix-an-error-in-get_user_pages_fast-error-handling.patch removed
 from -mm tree
Message-ID: <20200524231823.ACC7mexne%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: rapidio: fix an error in get_user_pages_fast() error handling
has been removed from the -mm tree.  Its filename was
     rapidio-fix-an-error-in-get_user_pages_fast-error-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: rapidio: fix an error in get_user_pages_fast() error handling

In the case of get_user_pages_fast() returning fewer pages than requested,
rio_dma_transfer() does not quite do the right thing.  It attempts to
release all the pages that were requested, rather than just the pages that
were pinned.

Fix the error handling so that only the pages that were successfully
pinned are released.

Link: http://lkml.kernel.org/r/20200517235620.205225-2-jhubbard@nvidia.com
Fixes: e8de370188d0 ("rapidio: add mport char device driver")
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/rio_mport_cdev.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/rapidio/devices/rio_mport_cdev.c~rapidio-fix-an-error-in-get_user_pages_fast-error-handling
+++ a/drivers/rapidio/devices/rio_mport_cdev.c
@@ -877,6 +877,11 @@ rio_dma_transfer(struct file *filp, u32
 				rmcd_error("pinned %ld out of %ld pages",
 					   pinned, nr_pages);
 			ret = -EFAULT;
+			/*
+			 * Set nr_pages up to mean "how many pages to unpin, in
+			 * the error handler:
+			 */
+			nr_pages = pinned;
 			goto err_pg;
 		}
 
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

mm-gup-introduce-pin_user_pages_unlocked.patch
ivtv-convert-get_user_pages-pin_user_pages.patch
mm-gup-move-__get_user_pages_fast-down-a-few-lines-in-gupc.patch
mm-gup-refactor-and-de-duplicate-gup_fast-code.patch
mm-gup-refactor-and-de-duplicate-gup_fast-code-fix.patch
mm-gup-introduce-pin_user_pages_fast_only.patch
drm-i915-convert-get_user_pages-pin_user_pages.patch
mm-gup-might_lock_readmmap_sem-in-get_user_pages_fast.patch
khugepaged-add-self-test-fix-3.patch
rapidio-convert-get_user_pages-pin_user_pages.patch

