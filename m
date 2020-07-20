Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B740B22672D
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387525AbgGTQJ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:09:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:47310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387499AbgGTQJZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:09:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 700ED2064B;
        Mon, 20 Jul 2020 16:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261365;
        bh=SX4S4gF6dd0rnPHQwe1PVTi8sEa+1+Qsr20QtDcLSAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sTryk/IxR4oiqI0EzdZ0xaIptTznGYiQWtcZkSNw+QYJLA0FP1X2Efe/Gjo4Yle84
         l0DO4qzvWxR4pdYoc5QH6vwwsICOy5GteiExFDROxp2BSVhiZ1c8WRHM9qeFxO+/Qi
         gI9zjth516ZynshvLWxEK0SDaGBjnDBVbw7lmqCQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 090/244] dmaengine: idxd: fix misc interrupt handler thread unmasking
Date:   Mon, 20 Jul 2020 17:36:01 +0200
Message-Id: <20200720152830.123221567@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit e3122822a74033ba8d6d9af855078f9ab741e33f ]

Fix unmasking of misc interrupt handler when completing normal. It exits
early and skips the unmasking with the current implementation. Fix to
unmask interrupt when exiting normally.

Fixes: bfe1d56091c1 ("dmaengine: idxd: Init and probe for Intel data accelerators")
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/159311256528.855.11527922406329728512.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/irq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/idxd/irq.c b/drivers/dma/idxd/irq.c
index 6510791b9921b..8a35f58da6890 100644
--- a/drivers/dma/idxd/irq.c
+++ b/drivers/dma/idxd/irq.c
@@ -141,7 +141,7 @@ irqreturn_t idxd_misc_thread(int vec, void *data)
 
 	iowrite32(cause, idxd->reg_base + IDXD_INTCAUSE_OFFSET);
 	if (!err)
-		return IRQ_HANDLED;
+		goto out;
 
 	gensts.bits = ioread32(idxd->reg_base + IDXD_GENSTATS_OFFSET);
 	if (gensts.state == IDXD_DEVICE_STATE_HALT) {
@@ -162,6 +162,7 @@ irqreturn_t idxd_misc_thread(int vec, void *data)
 		spin_unlock_bh(&idxd->dev_lock);
 	}
 
+ out:
 	idxd_unmask_msix_vector(idxd, irq_entry->id);
 	return IRQ_HANDLED;
 }
-- 
2.25.1



