Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87B6D3E80CF
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236360AbhHJRwu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:52:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:38632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234009AbhHJRur (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:50:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E7826128A;
        Tue, 10 Aug 2021 17:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617369;
        bh=pxdcajNLaLvmQ73OywZF1/YpJ+HyWkP/NPbM+75Dqjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xy4lIt9Oz4RfpXMWEWysv/Dh7qVB2rTXMYh+eiPN0oWGConxcJqjmR2xJFo3A9Wce
         7pozOzyWLsgkmmm/mfXmMwo2B9oUIkFMD6M/XQ4GnzgZ2QIX119/Ppw9/Ej6AjRtzG
         pvI3WCOCztPIB60qz1copZLjHE/l5pbg4SDMyT08=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vinod Koul <vkoul@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH 5.13 007/175] dmaengine: idxd: fix setup sequence for MSIXPERM table
Date:   Tue, 10 Aug 2021 19:28:35 +0200
Message-Id: <20210810173001.183325233@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit d5c10e0fc8645342fe5c9796b00c84ab078cd713 ]

The MSIX permission table should be programmed BEFORE request_irq()
happens. This prevents any possibility of an interrupt happening before the
MSIX perm table is setup, however slight.

Fixes: 6df0e6c57dfc ("dmaengine: idxd: clear MSIX permission entry on shutdown")
Sign-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/162456741222.1138073.1298447364671237896.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/init.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index 442d55c11a5f..4bc80eb6b9e7 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -102,6 +102,8 @@ static int idxd_setup_interrupts(struct idxd_device *idxd)
 		spin_lock_init(&idxd->irq_entries[i].list_lock);
 	}
 
+	idxd_msix_perm_setup(idxd);
+
 	irq_entry = &idxd->irq_entries[0];
 	rc = request_threaded_irq(irq_entry->vector, NULL, idxd_misc_thread,
 				  0, "idxd-misc", irq_entry);
@@ -148,7 +150,6 @@ static int idxd_setup_interrupts(struct idxd_device *idxd)
 	}
 
 	idxd_unmask_error_interrupts(idxd);
-	idxd_msix_perm_setup(idxd);
 	return 0;
 
  err_wq_irqs:
@@ -162,6 +163,7 @@ static int idxd_setup_interrupts(struct idxd_device *idxd)
  err_misc_irq:
 	/* Disable error interrupt generation */
 	idxd_mask_error_interrupts(idxd);
+	idxd_msix_perm_clear(idxd);
  err_irq_entries:
 	pci_free_irq_vectors(pdev);
 	dev_err(dev, "No usable interrupts\n");
-- 
2.30.2



