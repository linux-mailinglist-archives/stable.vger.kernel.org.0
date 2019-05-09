Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81E8419266
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727420AbfEISpu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:45:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:37808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726903AbfEISpt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:45:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E2762182B;
        Thu,  9 May 2019 18:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427548;
        bh=aN7zUq/E67UrnccRwoLh33vhd9zhbZEvz7Rksp36vrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r8Dbf1a5ZuwCQS3PTyBQvFdNrKSheOkRMQO6N/E2vNt+A4TRVBPpcpODjHDT+u/p2
         ELNl11ZzN0yalUmLL6ZssGFjceJB3fugeWaT2BpUkGhzqTcw5OsrxG+X3tRdJNje00
         im5Zswni8dYP/IdC1PlQ3bgyYcb2E6ll+45u+gJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Heib <kamalheib1@gmail.com>,
        Adit Ranadive <aditr@vmware.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 23/42] RDMA/vmw_pvrdma: Fix memory leak on pvrdma_pci_remove
Date:   Thu,  9 May 2019 20:42:12 +0200
Message-Id: <20190509181257.358644909@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181252.616018683@linuxfoundation.org>
References: <20190509181252.616018683@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ea7a5c706fa49273cf6d1d9def053ecb50db2076 ]

Make sure to free the DSR on pvrdma_pci_remove() to avoid the memory leak.

Fixes: 29c8d9eba550 ("IB: Add vmw_pvrdma driver")
Signed-off-by: Kamal Heib <kamalheib1@gmail.com>
Acked-by: Adit Ranadive <aditr@vmware.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
index 6ce709a67959b..d549c9ffadcbb 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
@@ -1055,6 +1055,8 @@ static void pvrdma_pci_remove(struct pci_dev *pdev)
 	pvrdma_page_dir_cleanup(dev, &dev->cq_pdir);
 	pvrdma_page_dir_cleanup(dev, &dev->async_pdir);
 	pvrdma_free_slots(dev);
+	dma_free_coherent(&pdev->dev, sizeof(*dev->dsr), dev->dsr,
+			  dev->dsrbase);
 
 	iounmap(dev->regs);
 	kfree(dev->sgid_tbl);
-- 
2.20.1



