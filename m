Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7FC02B6114
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:16:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729077AbgKQNPf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:15:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:47026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730198AbgKQNPe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:15:34 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC6A0221EB;
        Tue, 17 Nov 2020 13:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618933;
        bh=ZLfbjJetd2mwMbBTvrQ+pzHIWw+U0/kvUFLgVWSROGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iny5VG8AOU8PwNcPiZYkCrFI8lyaltEKR+aElFqPrpxarJaichzeQIWlZp84WE6vG
         +Pl2I5PM8Qr08kPfP0RcDHhdzzQ2sjhRmUBRir3c73Or77AwCRGe5CQI1k6J8HmRsG
         zvmAOa49XpanHj0SlspO/lPGG/RtfljfCdCT6PFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Elliott Mitchell <ehem+xen@m5p.com>,
        Stefano Stabellini <stefano.stabellini@xilinx.com>,
        Christoph Hellwig <hch@lst.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 4.14 57/85] swiotlb: fix "x86: Dont panic if can not alloc buffer for swiotlb"
Date:   Tue, 17 Nov 2020 14:05:26 +0100
Message-Id: <20201117122113.827306499@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122111.018425544@linuxfoundation.org>
References: <20201117122111.018425544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@xilinx.com>

commit e9696d259d0fb5d239e8c28ca41089838ea76d13 upstream.

kernel/dma/swiotlb.c:swiotlb_init gets called first and tries to
allocate a buffer for the swiotlb. It does so by calling

  memblock_alloc_low(PAGE_ALIGN(bytes), PAGE_SIZE);

If the allocation must fail, no_iotlb_memory is set.

Later during initialization swiotlb-xen comes in
(drivers/xen/swiotlb-xen.c:xen_swiotlb_init) and given that io_tlb_start
is != 0, it thinks the memory is ready to use when actually it is not.

When the swiotlb is actually needed, swiotlb_tbl_map_single gets called
and since no_iotlb_memory is set the kernel panics.

Instead, if swiotlb-xen.c:xen_swiotlb_init knew the swiotlb hadn't been
initialized, it would do the initialization itself, which might still
succeed.

Fix the panic by setting io_tlb_start to 0 on swiotlb initialization
failure, and also by setting no_iotlb_memory to false on swiotlb
initialization success.

Fixes: ac2cbab21f31 ("x86: Don't panic if can not alloc buffer for swiotlb")

Reported-by: Elliott Mitchell <ehem+xen@m5p.com>
Tested-by: Elliott Mitchell <ehem+xen@m5p.com>
Signed-off-by: Stefano Stabellini <stefano.stabellini@xilinx.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/swiotlb.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -254,6 +254,7 @@ int __init swiotlb_init_with_tbl(char *t
 		io_tlb_orig_addr[i] = INVALID_PHYS_ADDR;
 	}
 	io_tlb_index = 0;
+	no_iotlb_memory = false;
 
 	if (verbose)
 		swiotlb_print_info();
@@ -285,9 +286,11 @@ swiotlb_init(int verbose)
 	if (vstart && !swiotlb_init_with_tbl(vstart, io_tlb_nslabs, verbose))
 		return;
 
-	if (io_tlb_start)
+	if (io_tlb_start) {
 		memblock_free_early(io_tlb_start,
 				    PAGE_ALIGN(io_tlb_nslabs << IO_TLB_SHIFT));
+		io_tlb_start = 0;
+	}
 	pr_warn("Cannot allocate buffer");
 	no_iotlb_memory = true;
 }
@@ -390,6 +393,7 @@ swiotlb_late_init_with_tbl(char *tlb, un
 		io_tlb_orig_addr[i] = INVALID_PHYS_ADDR;
 	}
 	io_tlb_index = 0;
+	no_iotlb_memory = false;
 
 	swiotlb_print_info();
 


