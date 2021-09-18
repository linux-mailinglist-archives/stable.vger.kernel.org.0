Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E45C410662
	for <lists+stable@lfdr.de>; Sat, 18 Sep 2021 14:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbhIRMWr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Sep 2021 08:22:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:51702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234449AbhIRMWr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Sep 2021 08:22:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 606D961108;
        Sat, 18 Sep 2021 12:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631967684;
        bh=fPOAwF/3pqGnLZvWKSOiqiHhvnoFM8F4d+Kn38ISVUM=;
        h=Subject:To:Cc:From:Date:From;
        b=Mj7a8BQ6xsgat4vlySEF+RVlQOFtq8gafdPL7x/ILI+bieT5mhfDhbthq8QAEmHko
         W5/qzK+c0eMAYHZDlZhJEi5TOg6x1MevBABJZ82IJ119yq32tifolzuniZ+nqG3pfd
         KdoLmcyB5GS2iZVefjXgU/eZwDcmYm9iSxraMUes=
Subject: FAILED: patch "[PATCH] swiotlb-xen: avoid double free" failed to apply to 4.9-stable tree
To:     jbeulich@suse.com, hch@lst.de, jgross@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 18 Sep 2021 14:21:04 +0200
Message-ID: <1631967664159174@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ce6a80d1b2f923b1839655a1cda786293feaa085 Mon Sep 17 00:00:00 2001
From: Jan Beulich <jbeulich@suse.com>
Date: Tue, 7 Sep 2021 14:04:25 +0200
Subject: [PATCH] swiotlb-xen: avoid double free

Of the two paths leading to the "error" label in xen_swiotlb_init() one
didn't allocate anything, while the other did already free what was
allocated.

Fixes: b82776005369 ("xen/swiotlb: Use the swiotlb_late_init_with_tbl to init Xen-SWIOTLB late when PV PCI is used")
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>

Link: https://lore.kernel.org/r/ce9c2adb-8a52-6293-982a-0d6ece943ac6@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 24d11861ac7d..99d518526eaf 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -216,7 +216,6 @@ int __ref xen_swiotlb_init(void)
 		goto retry;
 	}
 	pr_err("%s (rc:%d)\n", xen_swiotlb_error(m_ret), rc);
-	free_pages((unsigned long)start, order);
 	return rc;
 }
 

