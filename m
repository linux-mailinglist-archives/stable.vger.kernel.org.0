Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 451871D8A16
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 23:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbgERVhi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 17:37:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726250AbgERVhi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 17:37:38 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE81B205CB;
        Mon, 18 May 2020 21:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589837858;
        bh=Yr57iNU/6PqAGt9zXiupJG/Q44homhWpqBPRGpCJtYQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=CgLFBQg/p5JZ+xBcZKv2g+7hwlBRCuMy5XEnsoT6rGFV7DMiT/yT8lFxjhakGPv0+
         UrG5N8bkumw4LxUY4Nq2OQzRYlKunQmRYcamuWv0dDOc+9G2f93kdPUuTWI7YE1f2o
         pcRFBBdjqNZO9bMQ7kz4QWnbf4xtxzuI1y5nlpMo=
Date:   Mon, 18 May 2020 14:37:37 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.bou9@gmail.com,
        dan.carpenter@oracle.com, jhubbard@nvidia.com,
        mm-commits@vger.kernel.org, mporter@kernel.crashing.org,
        stable@vger.kernel.org, sumit.semwal@linaro.org
Subject:  +
 rapidio-fix-an-error-in-get_user_pages_fast-error-handling.patch added to
 -mm tree
Message-ID: <20200518213737.wQv6yFzC8%akpm@linux-foundation.org>
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: rapidio: fix an error in get_user_pages_fast() error handling
has been added to the -mm tree.  Its filename is
     rapidio-fix-an-error-in-get_user_pages_fast-error-handling.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-fix-an-error-in-get_user_pages_fast-error-handling.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-fix-an-error-in-get_user_pages_fast-error-handling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

rapidio-fix-an-error-in-get_user_pages_fast-error-handling.patch
mm-gup-introduce-pin_user_pages_unlocked.patch
ivtv-convert-get_user_pages-pin_user_pages.patch
rapidio-convert-get_user_pages-pin_user_pages.patch

