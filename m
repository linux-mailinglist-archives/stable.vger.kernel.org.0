Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 313F73E80D1
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236376AbhHJRwv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:52:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:43682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233479AbhHJRuq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:50:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E67DA611C5;
        Tue, 10 Aug 2021 17:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617367;
        bh=xXL8ePronqgP4Q5UI0RrObOC2fXpJugQd8r/svqQrYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EcCQ7NB4EMK/ZrbtNTAx9gg5uQnSXUGz0OBxT9NJSjE28JubtH9aQxKra0UPg8/MC
         EhkN3z3R4CHPe4bzHfGipGBR4RBIr1vo4aGmE7lxK4m99q1ZluqGpHw5ILb/g8RpOW
         ZC4UanlHnJZtgHE03vq5C6efmEEJTxCxYqguYVXA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 006/175] dmaengine: idxd: fix array index when int_handles are being used
Date:   Tue, 10 Aug 2021 19:28:34 +0200
Message-Id: <20210810173001.152548365@linuxfoundation.org>
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

[ Upstream commit da435aedb00a4ef61019ff11ae0c08ffb9b1fb18 ]

The index to the irq vector should be local and has no relation to
the assigned interrupt handle. Assign the MSIX interrupt index that is
programmed for the descriptor. The interrupt handle only matters when it
comes to hardware descriptor programming.

Fixes: eb15e7154fbf ("dmaengine: idxd: add interrupt handle request and release support")
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/162456176939.1121476.3366256009925001897.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/submit.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/dma/idxd/submit.c b/drivers/dma/idxd/submit.c
index 19afb62abaff..e29887528077 100644
--- a/drivers/dma/idxd/submit.c
+++ b/drivers/dma/idxd/submit.c
@@ -128,19 +128,8 @@ int idxd_submit_desc(struct idxd_wq *wq, struct idxd_desc *desc)
 	 * Pending the descriptor to the lockless list for the irq_entry
 	 * that we designated the descriptor to.
 	 */
-	if (desc->hw->flags & IDXD_OP_FLAG_RCI) {
-		int vec;
-
-		/*
-		 * If the driver is on host kernel, it would be the value
-		 * assigned to interrupt handle, which is index for MSIX
-		 * vector. If it's guest then can't use the int_handle since
-		 * that is the index to IMS for the entire device. The guest
-		 * device local index will be used.
-		 */
-		vec = !idxd->int_handles ? desc->hw->int_handle : desc->vector;
-		llist_add(&desc->llnode, &idxd->irq_entries[vec].pending_llist);
-	}
+	if (desc->hw->flags & IDXD_OP_FLAG_RCI)
+		llist_add(&desc->llnode, &idxd->irq_entries[desc->vector].pending_llist);
 
 	return 0;
 }
-- 
2.30.2



