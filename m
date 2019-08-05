Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47E3581B08
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729391AbfHENLR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:11:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:50554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730498AbfHENLP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:11:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C9EC21738;
        Mon,  5 Aug 2019 13:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565010675;
        bh=Pa4wSFVkCPxyf5+NSU1pVrZRiZUO5m60ZRYSvyppvxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cyOvs+cbmoo9x2IThMPMvF+gU7JBmk+gDVhoihBXb9vLN1Tazf/AaVcFCJ/TySiTB
         H0ek9TOpMAO5q4hFTUqgiQZ8Am4/YOTgLZCwU0BA4KI2n82RPULiHJMGpBtkpQa5MG
         dmosag/3GDqZyxM8bfGzgomY7hemFZf9wa8on6Js=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Jan Beulich <jbeulich@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 4.19 61/74] xen/swiotlb: fix condition for calling xen_destroy_contiguous_region()
Date:   Mon,  5 Aug 2019 15:03:14 +0200
Message-Id: <20190805124940.763241980@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124935.819068648@linuxfoundation.org>
References: <20190805124935.819068648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit 50f6393f9654c561df4cdcf8e6cfba7260143601 upstream.

The condition in xen_swiotlb_free_coherent() for deciding whether to
call xen_destroy_contiguous_region() is wrong: in case the region to
be freed is not contiguous calling xen_destroy_contiguous_region() is
the wrong thing to do: it would result in inconsistent mappings of
multiple PFNs to the same MFN. This will lead to various strange
crashes or data corruption.

Instead of calling xen_destroy_contiguous_region() in that case a
warning should be issued as that situation should never occur.

Cc: stable@vger.kernel.org
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/swiotlb-xen.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -357,8 +357,8 @@ xen_swiotlb_free_coherent(struct device
 	/* Convert the size to actually allocated. */
 	size = 1UL << (order + XEN_PAGE_SHIFT);
 
-	if (((dev_addr + size - 1 <= dma_mask)) ||
-	    range_straddles_page_boundary(phys, size))
+	if (!WARN_ON((dev_addr + size - 1 > dma_mask) ||
+		     range_straddles_page_boundary(phys, size)))
 		xen_destroy_contiguous_region(phys, order);
 
 	xen_free_coherent_pages(hwdev, size, vaddr, (dma_addr_t)phys, attrs);


