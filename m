Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C47C64724A0
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234350AbhLMJh2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:37:28 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:60354 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234562AbhLMJgR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:36:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 51B4FCE0E39;
        Mon, 13 Dec 2021 09:36:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1DA9C00446;
        Mon, 13 Dec 2021 09:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388173;
        bh=D1viUoDsLB19wvRR6wkKh9Un/NC+yq8uC8Prq9MVH00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zeynnSSdiE8PsMdrzo7o7KGGdwgPY0HGQJFNwN2c536/U83u/t30NbXACRbQObAuM
         M/noDj9Njz/pHAL+rdwDIyZ1vj+1GWZA7m7Ex8Z7DyEkPpBcFsAp4gT8T8UuzZoOAd
         j0EwmGfuFnEZbQQpEnHGi3cT/FDN/ovOcoEwUdYI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 4.14 12/53] IB/hfi1: Correct guard on eager buffer deallocation
Date:   Mon, 13 Dec 2021 10:29:51 +0100
Message-Id: <20211213092928.770718740@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092928.349556070@linuxfoundation.org>
References: <20211213092928.349556070@linuxfoundation.org>
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
@@ -1138,7 +1138,7 @@ void hfi1_free_ctxtdata(struct hfi1_devd
 	rcd->egrbufs.rcvtids = NULL;
 
 	for (e = 0; e < rcd->egrbufs.alloced; e++) {
-		if (rcd->egrbufs.buffers[e].dma)
+		if (rcd->egrbufs.buffers[e].addr)
 			dma_free_coherent(&dd->pcidev->dev,
 					  rcd->egrbufs.buffers[e].len,
 					  rcd->egrbufs.buffers[e].addr,


