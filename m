Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D065D1922A
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbfEITEX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 15:04:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:41456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728042AbfEISsb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:48:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3151217D7;
        Thu,  9 May 2019 18:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427711;
        bh=AKm1vEkwF5J8C9tbcUZ9n/nVxeGNvVg6AyzgqZlIbGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rRya7tBaTKOEOGsA6KZadMIYKFRoz7fB2/UpH8+U0sV8xQPUylqSg5UsdwpwIa/uC
         H4jHmT3ZeulvHWwNPg6/YmNDP5kE24f+7Uqb2ojx562zEmIhV02oIlK5wQbf8V62Gx
         9UoSK26LPQMEKkimYkEy16OovOeXWeZpt6FFNh2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Heib <kamalheib1@gmail.com>,
        Adit Ranadive <aditr@vmware.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 40/66] RDMA/vmw_pvrdma: Fix memory leak on pvrdma_pci_remove
Date:   Thu,  9 May 2019 20:42:15 +0200
Message-Id: <20190509181306.192556547@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181301.719249738@linuxfoundation.org>
References: <20190509181301.719249738@linuxfoundation.org>
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
index a5719899f49ad..ed99f0a08dc4e 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
@@ -1123,6 +1123,8 @@ static void pvrdma_pci_remove(struct pci_dev *pdev)
 	pvrdma_page_dir_cleanup(dev, &dev->cq_pdir);
 	pvrdma_page_dir_cleanup(dev, &dev->async_pdir);
 	pvrdma_free_slots(dev);
+	dma_free_coherent(&pdev->dev, sizeof(*dev->dsr), dev->dsr,
+			  dev->dsrbase);
 
 	iounmap(dev->regs);
 	kfree(dev->sgid_tbl);
-- 
2.20.1



