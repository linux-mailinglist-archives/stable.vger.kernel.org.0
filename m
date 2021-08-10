Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5303E80AB
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236062AbhHJRvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:51:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:44064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237116AbhHJRuE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:50:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 968A061264;
        Tue, 10 Aug 2021 17:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617331;
        bh=2kARajZmK2KIafaGGZzJr3GcZacWmqGy54qn2kr7HvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ce3L1ZDLfgfFF4TEhMXyRE4CKQ8J6ZVj34VA78b0+pPiY24l1XG9IVCRUjNMgoa/p
         9cNT5zS8TXwWYBJRcDJ73E8DjPMsBy/LAbUgJtSPe3jhOg6CCmnyu0FOhd3pJMdEMS
         vY6XKTbLiZ/GVZeM+JvYw/ej6TG9JNEDIW/OyJsA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 012/175] dmaengine: idxd: fix desc->vector that isnt being updated
Date:   Tue, 10 Aug 2021 19:28:40 +0200
Message-Id: <20210810173001.351282138@linuxfoundation.org>
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

[ Upstream commit 8ba89a3c7967808f33478a8573277cf6a7412c4c ]

Missing update for desc->vector when the wq vector gets updated. This
causes the desc->vector to always be at 0.

Fixes: da435aedb00a ("dmaengine: idxd: fix array index when int_handles are being used")
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/162628784374.353761.4736602409627820431.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/submit.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/dma/idxd/submit.c b/drivers/dma/idxd/submit.c
index e29887528077..21d7d09f73dd 100644
--- a/drivers/dma/idxd/submit.c
+++ b/drivers/dma/idxd/submit.c
@@ -25,11 +25,10 @@ static struct idxd_desc *__get_desc(struct idxd_wq *wq, int idx, int cpu)
 	 * Descriptor completion vectors are 1...N for MSIX. We will round
 	 * robin through the N vectors.
 	 */
-	wq->vec_ptr = (wq->vec_ptr % idxd->num_wq_irqs) + 1;
+	wq->vec_ptr = desc->vector = (wq->vec_ptr % idxd->num_wq_irqs) + 1;
 	if (!idxd->int_handles) {
 		desc->hw->int_handle = wq->vec_ptr;
 	} else {
-		desc->vector = wq->vec_ptr;
 		/*
 		 * int_handles are only for descriptor completion. However for device
 		 * MSIX enumeration, vec 0 is used for misc interrupts. Therefore even
-- 
2.30.2



