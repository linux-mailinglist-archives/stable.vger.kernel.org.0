Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C408F102AF4
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 18:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbfKSRtz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 12:49:55 -0500
Received: from mga02.intel.com ([134.134.136.20]:13584 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726555AbfKSRtz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 12:49:55 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Nov 2019 09:49:54 -0800
X-IronPort-AV: E=Sophos;i="5.69,218,1571727600"; 
   d="scan'208";a="200430864"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Nov 2019 09:49:54 -0800
Subject: [PATCH] dma/debug: Fix dma vs cow-page collision detection
From:   Dan Williams <dan.j.williams@intel.com>
To:     hch@lst.de
Cc:     Russell King <linux@armlinux.org.uk>,
        Don Dutile <ddutile@redhat.com>, stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Date:   Tue, 19 Nov 2019 09:35:38 -0800
Message-ID: <157418493888.1639105.6922809760655305210.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The debug_dma_assert_idle() infrastructure was put in place to catch a
data corruption scenario first identified by the now defunct NET_DMA
receive offload feature. It caught cases where dma was in flight to a
stale page because the dma raced the cpu writing the page, and the cpu
write triggered cow_user_page().

However, the dma-debug tracking is overeager and also triggers in cases
where the dma device is reading from a page that is also undergoing
cow_user_page().

The fix proposed was originally posted in 2016, and Russell reported
"Yes, that seems to avoid the warning for me from an initial test", and
now Don is also reporting that this fix is addressing a similar false
positive report that he is seeing.

Link: https://lore.kernel.org/r/CAPcyv4j8fWqwAaX5oCdg5atc+vmp57HoAGT6AfBFwaCiv0RbAQ@mail.gmail.com
Reported-by: Russell King <linux@armlinux.org.uk>
Reported-by: Don Dutile <ddutile@redhat.com>
Fixes: 0abdd7a81b7e ("dma-debug: introduce debug_dma_assert_idle()")
Cc: <stable@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 kernel/dma/debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
index 099002d84f46..11a6db53d193 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -587,7 +587,7 @@ void debug_dma_assert_idle(struct page *page)
 	}
 	spin_unlock_irqrestore(&radix_lock, flags);
 
-	if (!entry)
+	if (!entry || entry->direction != DMA_FROM_DEVICE)
 		return;
 
 	cln = to_cacheline_number(entry);

