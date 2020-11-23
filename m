Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE2112C085F
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733026AbgKWMtn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:49:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:34220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732578AbgKWMtQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:49:16 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2408B204EF;
        Mon, 23 Nov 2020 12:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135754;
        bh=lQuSwnhswOCZ7+C2Vp3txiTakjs7bjRL8jJOsDTDvPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TFCAnnR1ZRD9BeQ4xean0T7PJJH1yLJCXLYtPmNQgackdMnqaNAmGK3hR1TFeG0TK
         CSICTdCVCkmAu1SruLTu2xRL8jxK0Eo/Aa1s1Kp0SwLaooVVjaCy79jN7Po63OLbQV
         aKdjWsheDXW0I86CHynQIJyHzk9DUMWNLNaMj6/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 143/252] dmaengine: idxd: fix mapping of portal size
Date:   Mon, 23 Nov 2020 13:21:33 +0100
Message-Id: <20201123121842.499145755@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 8326be9f1c0bb498baf134878a8deb8a952e0135 ]

Portal size is 4k. Current code is mapping all 4 portals in a single chunk.
Restrict the mapped portal size to a single portal to ensure that submission
only goes to the intended portal address.

Fixes: c52ca478233c ("dmaengine: idxd: add configuration component of driver")
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/160513342642.510187.16450549281618747065.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/device.c    | 2 +-
 drivers/dma/idxd/registers.h | 2 +-
 drivers/dma/idxd/submit.c    | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index c2beece445215..66e947627f569 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -271,7 +271,7 @@ int idxd_wq_map_portal(struct idxd_wq *wq)
 	resource_size_t start;
 
 	start = pci_resource_start(pdev, IDXD_WQ_BAR);
-	start = start + wq->id * IDXD_PORTAL_SIZE;
+	start += idxd_get_wq_portal_full_offset(wq->id, IDXD_PORTAL_LIMITED);
 
 	wq->dportal = devm_ioremap(dev, start, IDXD_PORTAL_SIZE);
 	if (!wq->dportal)
diff --git a/drivers/dma/idxd/registers.h b/drivers/dma/idxd/registers.h
index aef5a902829ee..54390334c243a 100644
--- a/drivers/dma/idxd/registers.h
+++ b/drivers/dma/idxd/registers.h
@@ -8,7 +8,7 @@
 
 #define IDXD_MMIO_BAR		0
 #define IDXD_WQ_BAR		2
-#define IDXD_PORTAL_SIZE	0x4000
+#define IDXD_PORTAL_SIZE	PAGE_SIZE
 
 /* MMIO Device BAR0 Registers */
 #define IDXD_VER_OFFSET			0x00
diff --git a/drivers/dma/idxd/submit.c b/drivers/dma/idxd/submit.c
index 156a1ee233aa5..417048e3c42aa 100644
--- a/drivers/dma/idxd/submit.c
+++ b/drivers/dma/idxd/submit.c
@@ -74,7 +74,7 @@ int idxd_submit_desc(struct idxd_wq *wq, struct idxd_desc *desc)
 	if (idxd->state != IDXD_DEV_ENABLED)
 		return -EIO;
 
-	portal = wq->dportal + idxd_get_wq_portal_offset(IDXD_PORTAL_UNLIMITED);
+	portal = wq->dportal;
 	/*
 	 * The wmb() flushes writes to coherent DMA data before possibly
 	 * triggering a DMA read. The wmb() is necessary even on UP because
-- 
2.27.0



