Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 013521DF4F3
	for <lists+stable@lfdr.de>; Sat, 23 May 2020 07:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387582AbgEWFWy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 May 2020 01:22:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:55176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387517AbgEWFWv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 23 May 2020 01:22:51 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 721B52072C;
        Sat, 23 May 2020 05:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590211370;
        bh=QQglbWmPgUr5vTOf+1zOUyAT8qRzcqCOLjnra1dJ/x4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=uBIitKjK7GPd1+GMyH4wt2eFo2jX+tIcSSS3lh7IKrMutl1JIIQMw8pvuTRIspYVo
         m9jZOrMUPLnlQfzKwzGRoih+bhnXL1o2Mq31XRpWPCK+kPFTlzAmQbFFPibdTfGGLN
         qTDSrr6YTBKZ1PBm4d/GPV0153AXa40z4/hmsDAc=
Date:   Fri, 22 May 2020 22:22:48 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.bou9@gmail.com,
        dan.carpenter@oracle.com, jhubbard@nvidia.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, mporter@kernel.crashing.org,
        stable@vger.kernel.org, sumit.semwal@linaro.org,
        torvalds@linux-foundation.org
Subject:  [patch 03/11] rapidio: fix an error in
 get_user_pages_fast() error handling
Message-ID: <20200523052248.tWpCIO_Wo%akpm@linux-foundation.org>
In-Reply-To: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
