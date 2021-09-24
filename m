Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB854173C5
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345472AbhIXM7w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:59:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345582AbhIXM6e (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:58:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2920613A7;
        Fri, 24 Sep 2021 12:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487959;
        bh=+FIp5NzQV6eQM3QjCyLeX2KEWv+OocV6d+Plna1uBcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QEc6pasA8K8G/tvwfWkRMFOxxaX7sBeZmYE1HSZzd707AKyp0VTXSqjm5tIVvhiL3
         kmhO+W+xpeo4gWtiKXtLlBml3CPbpyXJOvI0DH96T3IwVkVJlpQSpP0OD1GP+lrPnt
         aV+u8Chyxj2iy14UYANy4SsOckMEkwqImeXQRAAM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ramesh Thomas <ramesh.thomas@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 028/100] dmaengine: idxd: have command status always set
Date:   Fri, 24 Sep 2021 14:43:37 +0200
Message-Id: <20210924124342.399518730@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 53499d1fc11267e078557fc68ce943c1eb3b7a37 ]

The cached command status is only set when the write back status is
is passed in. Move the variable set outside of the check so it is
always set.

Fixes: 0d5c10b4c84d ("dmaengine: idxd: add work queue drain support")
Reported-by: Ramesh Thomas <ramesh.thomas@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/162274329740.1822314.3443875665504707588.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/device.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index 928c2c8817f0..c8cf1de72176 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -486,6 +486,7 @@ static void idxd_cmd_exec(struct idxd_device *idxd, int cmd_code, u32 operand,
 	union idxd_command_reg cmd;
 	DECLARE_COMPLETION_ONSTACK(done);
 	unsigned long flags;
+	u32 stat;
 
 	if (idxd_device_is_halted(idxd)) {
 		dev_warn(&idxd->pdev->dev, "Device is HALTED!\n");
@@ -518,11 +519,11 @@ static void idxd_cmd_exec(struct idxd_device *idxd, int cmd_code, u32 operand,
 	 */
 	spin_unlock_irqrestore(&idxd->cmd_lock, flags);
 	wait_for_completion(&done);
+	stat = ioread32(idxd->reg_base + IDXD_CMDSTS_OFFSET);
 	spin_lock_irqsave(&idxd->cmd_lock, flags);
-	if (status) {
-		*status = ioread32(idxd->reg_base + IDXD_CMDSTS_OFFSET);
-		idxd->cmd_status = *status & GENMASK(7, 0);
-	}
+	if (status)
+		*status = stat;
+	idxd->cmd_status = stat & GENMASK(7, 0);
 
 	__clear_bit(IDXD_FLAG_CMD_RUNNING, &idxd->flags);
 	/* Wake up other pending commands */
-- 
2.33.0



