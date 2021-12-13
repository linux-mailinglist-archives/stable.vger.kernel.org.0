Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48DAD472924
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242196AbhLMKSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:18:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243727AbhLMKO2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:14:28 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD73C08ED6B;
        Mon, 13 Dec 2021 01:54:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 40DF1CE0EF5;
        Mon, 13 Dec 2021 09:54:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ACBAC34600;
        Mon, 13 Dec 2021 09:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389295;
        bh=flLDWejcOhLIyiH32goEBxNet+7mdfgFJKibneY7I0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nlAruCa+9EG6HFaMAF/r5OhSRe7oqpHtEZ4F08djY6cTtFT9oF/3yn+MiBmyEg1Pf
         YH//2TlMNJNKpZK3RUpbJXM23iF8Z/7WJejT5G3d8p3wD9Z4Homqo2op5Iz4GieHV9
         q/oBfE5KqZIRKUodTqUQpIB+K044JxGbTr7gSr1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.15 050/171] IB/hfi1: Correct guard on eager buffer deallocation
Date:   Mon, 13 Dec 2021 10:29:25 +0100
Message-Id: <20211213092946.775221769@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
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
@@ -1106,7 +1106,7 @@ void hfi1_free_ctxtdata(struct hfi1_devd
 	rcd->egrbufs.rcvtids = NULL;
 
 	for (e = 0; e < rcd->egrbufs.alloced; e++) {
-		if (rcd->egrbufs.buffers[e].dma)
+		if (rcd->egrbufs.buffers[e].addr)
 			dma_free_coherent(&dd->pcidev->dev,
 					  rcd->egrbufs.buffers[e].len,
 					  rcd->egrbufs.buffers[e].addr,


