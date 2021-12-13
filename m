Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E887A472430
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233970AbhLMJeu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:34:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbhLMJeI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:34:08 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F891C0698DF;
        Mon, 13 Dec 2021 01:34:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 132FFCE0E6B;
        Mon, 13 Dec 2021 09:34:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B699EC00446;
        Mon, 13 Dec 2021 09:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388044;
        bh=0yWxunA5Y9GyMGObMKX+xYzYLxqY+ynFD0oM9DUBi1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YjV2DfpWyXUkHNdlR1h5/gzaJJmCBL+oS8gVdsNbItKQP9POgLiHwbLWumiJu2p4T
         heAPbeChjTXI7AO8LYonTx04E011+CaQGqdlCwZ6zyPFr0P2E0QRGYUOpCR/9YiMXd
         RisC3CP4wsjr5zTp/mEvwyaPrs0dq95QP+Eki/Vw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 4.9 10/42] IB/hfi1: Correct guard on eager buffer deallocation
Date:   Mon, 13 Dec 2021 10:29:52 +0100
Message-Id: <20211213092926.918962696@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092926.578829548@linuxfoundation.org>
References: <20211213092926.578829548@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>

commit 9292f8f9a2ac42eb320bced7153aa2e63d8cc13a upstream.

The code tests the dma address which legitimately can be 0.

The code should test the kernel logical address to avoid leaking eager
buffer allocations that happen to map to a dma address of 0.

Fixes: 60368186fd85 ("IB/hfi1: Fix user-space buffers mapping with IOMMU enabled")
Link: https://lore.kernel.org/r/20211129191952.101968.17137.stgit@awfm-01.cornelisnetworks.com
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/hfi1/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -955,7 +955,7 @@ void hfi1_free_ctxtdata(struct hfi1_devd
 	kfree(rcd->egrbufs.rcvtids);
 
 	for (e = 0; e < rcd->egrbufs.alloced; e++) {
-		if (rcd->egrbufs.buffers[e].dma)
+		if (rcd->egrbufs.buffers[e].addr)
 			dma_free_coherent(&dd->pcidev->dev,
 					  rcd->egrbufs.buffers[e].len,
 					  rcd->egrbufs.buffers[e].addr,


