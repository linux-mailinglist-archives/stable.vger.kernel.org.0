Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2BE43702E
	for <lists+stable@lfdr.de>; Fri, 22 Oct 2021 04:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbhJVCr7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Oct 2021 22:47:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:60354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232462AbhJVCr7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Oct 2021 22:47:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 226296139F;
        Fri, 22 Oct 2021 02:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634870742;
        bh=Dq8gAtx3Q7skG/xEFWryn9aZZxlJ71TIEerd2aPEi9U=;
        h=Date:From:To:Subject:From;
        b=QODXJfEa2CvnblTF3DJqA35H3Sk2joTfmljNEizeSx9KZvQ0UEgQoYOtzkZgDMlrx
         U5AOh8r+zyI91gIE/1hJqUTr8dz8Drl/H0NO9jXH65SXtAZa4X1OvcousaPI4gif85
         UyYgqa+iz5+0tPL7AVQVsT9NTI4EagvnKlS7fmdo=
Date:   Thu, 21 Oct 2021 19:45:41 -0700
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, hch@infradead.org, jisoo2146.oh@samsung.com,
        junho89.kim@samsung.com, mj0123.lee@samsung.com,
        mm-commits@vger.kernel.org, nanich.lee@samsung.com,
        seunghwan.hyun@samsung.com, sookwan7.kim@samsung.com,
        stable@vger.kernel.org, willy@infradead.org, yt0928.kim@samsung.com
Subject:  +
 mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister.patch added to -mm tree
Message-ID: <20211022024541.xivOGGGRP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: bdi: initialize bdi_min_ratio when bdi is unregistered
has been added to the -mm tree.  Its filename is
     mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Manjong Lee <mj0123.lee@samsung.com>
Subject: mm: bdi: initialize bdi_min_ratio when bdi is unregistered

Initialize min_ratio if it is set during bdi unregistration.
This can prevent problems that may occur a when bdi is removed without
resetting min_ratio.

For example.
1) insert external sdcard
2) set external sdcard's min_ratio 70
3) remove external sdcard without setting min_ratio 0
4) insert external sdcard
5) set external sdcard's min_ratio 70 << error occur(can't set)

Because when an sdcard is removed, the present bdi_min_ratio value will
remain.  Currently, the only way to reset bdi_min_ratio is to reboot.

Link: https://lkml.kernel.org/r/20211021161942.5983-1-mj0123.lee@samsung.com
Signed-off-by: Manjong Lee <mj0123.lee@samsung.com>
Cc: Changheun Lee <nanich.lee@samsung.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <seunghwan.hyun@samsung.com>
Cc: <sookwan7.kim@samsung.com>
Cc: <yt0928.kim@samsung.com>
Cc: <junho89.kim@samsung.com>
Cc: <jisoo2146.oh@samsung.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/backing-dev.c~mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister
+++ a/mm/backing-dev.c
@@ -947,6 +947,11 @@ void bdi_unregister(struct backing_dev_i
 	wb_shutdown(&bdi->wb);
 	cgwb_bdi_unregister(bdi);
 
+	/* if min ratio doesn't 0, it has to set 0 before unregister */
+	if (bdi->min_ratio) {
+		bdi_set_min_ratio(bdi, 0);
+	}
+
 	if (bdi->dev) {
 		bdi_debug_unregister(bdi);
 		device_unregister(bdi->dev);
_

Patches currently in -mm which might be from mj0123.lee@samsung.com are

mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister.patch

