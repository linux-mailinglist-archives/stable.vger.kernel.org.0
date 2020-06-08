Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D562A1F2BB9
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730444AbgFIASZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:18:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:40948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730660AbgFHXSh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:18:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69FD620814;
        Mon,  8 Jun 2020 23:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658317;
        bh=74mmgenOw4MmKp1UIPKTZunpiAwuag71URypgKevze8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pnY/RZ2WIfZCpi/pGnF1he024wuY7odGsZbVcgIfxHE2fz2J8PY4YP915SBjQaMcu
         YqXaWo3QdY1y/Qfd7nNO/lIwiNsox9+w0WjAeHcQLZt+CwUTRyXgmh+Q9+kLG0aFFb
         Aw36ESfwkc4bHPuBA6rA0RmgJK1AxjexY1DOnUok=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qiushi Wu <wu000273@umn.edu>, Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 317/606] RDMA/pvrdma: Fix missing pci disable in pvrdma_pci_probe()
Date:   Mon,  8 Jun 2020 19:07:22 -0400
Message-Id: <20200608231211.3363633-317-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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

