Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 469331EAC26
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729914AbgFASPi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:15:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:35996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730497AbgFASPh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:15:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69C3C2065C;
        Mon,  1 Jun 2020 18:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035336;
        bh=74mmgenOw4MmKp1UIPKTZunpiAwuag71URypgKevze8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ADFraXfqtfUYQhOPtvgmSeyEeZyfPuiVbhneU+9ALiyd9yQLE+9VnAc85rov1KXsS
         xiNRcvJg1cf540Od6d4np3iZ5/gN7NrSJsKJTVlwQ1nsqej2d+Lv3dHbDTIpmGz1On
         o11AZgYp6LSlhjAiMF0cstOpja9nax26UkhDYWrc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiushi Wu <wu000273@umn.edu>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 113/177] RDMA/pvrdma: Fix missing pci disable in pvrdma_pci_probe()
Date:   Mon,  1 Jun 2020 19:54:11 +0200
Message-Id: <20200601174058.042187108@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

[ Upstream commit db857e6ae548f0f4f4a0f63fffeeedf3cca21f9d ]

In function pvrdma_pci_probe(), pdev was not disabled in one error
path. Thus replace the jump target “err_free_device” by
"err_disable_pdev".

Fixes: 29c8d9eba550 ("IB: Add vmw_pvrdma driver")
Link: https://lore.kernel.org/r/20200523030457.16160-1-wu000273@umn.edu
Signed-off-by: Qiushi Wu <wu000273@umn.edu>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
index e580ae9cc55a..780fd2dfc07e 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
@@ -829,7 +829,7 @@ static int pvrdma_pci_probe(struct pci_dev *pdev,
 	    !(pci_resource_flags(pdev, 1) & IORESOURCE_MEM)) {
 		dev_err(&pdev->dev, "PCI BAR region not MMIO\n");
 		ret = -ENOMEM;
-		goto err_free_device;
+		goto err_disable_pdev;
 	}
 
 	ret = pci_request_regions(pdev, DRV_NAME);
-- 
2.25.1



