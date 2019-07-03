Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC83C5E806
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 17:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfGCPmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 11:42:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:48116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726718AbfGCPmk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jul 2019 11:42:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6927218A0;
        Wed,  3 Jul 2019 15:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562168560;
        bh=go94/OWAKo2d66QfIYF7J0GXC2VtZCMnhNp57kleudI=;
        h=Subject:To:From:Date:From;
        b=hXHavZp2guDdYZxI/ZuESqpXeGCPzAIJgv3gdJyBJnQq92vaPTz3GNIe9r8xGpE83
         gVuIXkyzDnds7xD9emE/vWJ+mtgNmE6kIywik256naQzMA+30/6tKM2ldHshffqzhi
         VTJoxiK9+dms7PbvWD3X2ywV7Vrc998xq0BX17xI=
Subject: patch "intel_th: msu: Fix single mode with disabled IOMMU" added to char-misc-testing
To:     alexander.shishkin@linux.intel.com, ammy.yi@intel.com,
        andriy.shevchenko@linux.intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 03 Jul 2019 17:42:25 +0200
Message-ID: <1562168545140105@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    intel_th: msu: Fix single mode with disabled IOMMU

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 918b8646497b5dba6ae82d4a7325f01b258972b9 Mon Sep 17 00:00:00 2001
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Date: Fri, 21 Jun 2019 19:19:29 +0300
Subject: intel_th: msu: Fix single mode with disabled IOMMU

Commit 4e0eaf239fb3 ("intel_th: msu: Fix single mode with IOMMU") switched
the single mode code to use dma mapping pages obtained from the page
allocator, but with IOMMU disabled, that may lead to using SWIOTLB bounce
buffers and without additional sync'ing, produces empty trace buffers.

Fix this by using a DMA32 GFP flag to the page allocation in single mode,
as the device supports full 32-bit DMA addressing.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Fixes: 4e0eaf239fb3 ("intel_th: msu: Fix single mode with IOMMU")
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reported-by: Ammy Yi <ammy.yi@intel.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190621161930.60785-4-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/intel_th/msu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwtracing/intel_th/msu.c b/drivers/hwtracing/intel_th/msu.c
index 6bfce03c6489..cfd48c81b9d9 100644
--- a/drivers/hwtracing/intel_th/msu.c
+++ b/drivers/hwtracing/intel_th/msu.c
@@ -667,7 +667,7 @@ static int msc_buffer_contig_alloc(struct msc *msc, unsigned long size)
 		goto err_out;
 
 	ret = -ENOMEM;
-	page = alloc_pages(GFP_KERNEL | __GFP_ZERO, order);
+	page = alloc_pages(GFP_KERNEL | __GFP_ZERO | GFP_DMA32, order);
 	if (!page)
 		goto err_free_sgt;
 
-- 
2.22.0


