Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70E7D412522
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353541AbhITSlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:41:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:54226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1381473AbhITSiR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:38:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 662FE61440;
        Mon, 20 Sep 2021 17:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158989;
        bh=i4LcWwvR2rayH2yP62levZhOyXc56jezu34Fls1SmV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yyVhp8VsurQY3dGZQouQ9b9HG3kmxHiGlAWiN5P9Rc2NXK5/YL4VH4LFR9En2LTr5
         Zfvdi/JfcT7bfIDA9Ab50CURlP89olRWTbDktskNO+PGCtN4I3iYmc3RZHpopsnvzj
         b7Qu315iszZ1XIjVVzqfv9eOWEGUaDlDJVrLe9BM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Christoph Hellwig <hch@lst.de>, Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.14 003/168] swiotlb-xen: fix late init retry
Date:   Mon, 20 Sep 2021 18:42:21 +0200
Message-Id: <20210920163921.756646422@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Beulich <jbeulich@suse.com>

commit 4c092c59015f7adf0f07685f869edb96d997a756 upstream.

The commit referenced below removed the assignment of "bytes" from
xen_swiotlb_init() without - like done for xen_swiotlb_init_early() -
adding an assignment on the retry path, thus leading to excessively
sized allocations upon retries.

Fixes: 2d29960af0be ("swiotlb: dynamically allocate io_tlb_default_mem")
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Link: https://lore.kernel.org/r/778299d6-9cfd-1c13-026e-25ee5d14ecb3@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>
---
 drivers/xen/swiotlb-xen.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -211,8 +211,8 @@ error:
 	if (repeat--) {
 		/* Min is 2MB */
 		nslabs = max(1024UL, (nslabs >> 1));
-		pr_info("Lowering to %luMB\n",
-			(nslabs << IO_TLB_SHIFT) >> 20);
+		bytes = nslabs << IO_TLB_SHIFT;
+		pr_info("Lowering to %luMB\n", bytes >> 20);
 		goto retry;
 	}
 	pr_err("%s (rc:%d)\n", xen_swiotlb_error(m_ret), rc);


