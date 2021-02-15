Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF1931BCF7
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbhBOPhw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:37:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:49602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230459AbhBOPg5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:36:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B988364E8E;
        Mon, 15 Feb 2021 15:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403157;
        bh=nKIGJtfqLEwveiYn9Xc73rQHQjsxo+hapHWA2sKcDIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v/s1ioYmelxLbcsG5BI97urxpXpmB8uBbSuh+a0QmoIwwxjb2ekC1uMGLQnkIasZI
         JmImis/ZH5dCqvWGm/JeJOApzwjJMjH4A+sBSWboaJKU3jmHaEPpeZtoKeJGp5FRVY
         E19otseZkTX5o6OBwnbpOC6WIlBAXrIQG9eUOck0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikhil Rao <nikhil.rao@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 050/104] dmaengine: idxd: fix misc interrupt completion
Date:   Mon, 15 Feb 2021 16:27:03 +0100
Message-Id: <20210215152721.092303584@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit f5cc9ace24fbdf41b4814effbb2f9bad7046e988 ]

Nikhil reported the misc interrupt handler can sometimes miss handling
the command interrupt when an error interrupt happens near the same time.
Have the irq handling thread continue to process the misc interrupts until
all interrupts are processed. This is a low usage interrupt and is not
expected to handle high volume traffic. Therefore there is no concern of
this thread running for a long time.

Fixes: 0d5c10b4c84d ("dmaengine: idxd: add work queue drain support")
Reported-by: Nikhil Rao <nikhil.rao@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/161074755329.2183844.13295528344116907983.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/irq.c | 36 +++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/drivers/dma/idxd/irq.c b/drivers/dma/idxd/irq.c
index 17a65a13fb649..552e2e2707058 100644
--- a/drivers/dma/idxd/irq.c
+++ b/drivers/dma/idxd/irq.c
@@ -53,19 +53,14 @@ irqreturn_t idxd_irq_handler(int vec, void *data)
 	return IRQ_WAKE_THREAD;
 }
 
-irqreturn_t idxd_misc_thread(int vec, void *data)
+static int process_misc_interrupts(struct idxd_device *idxd, u32 cause)
 {
-	struct idxd_irq_entry *irq_entry = data;
-	struct idxd_device *idxd = irq_entry->idxd;
 	struct device *dev = &idxd->pdev->dev;
 	union gensts_reg gensts;
-	u32 cause, val = 0;
+	u32 val = 0;
 	int i;
 	bool err = false;
 
-	cause = ioread32(idxd->reg_base + IDXD_INTCAUSE_OFFSET);
-	iowrite32(cause, idxd->reg_base + IDXD_INTCAUSE_OFFSET);
-
 	if (cause & IDXD_INTC_ERR) {
 		spin_lock_bh(&idxd->dev_lock);
 		for (i = 0; i < 4; i++)
@@ -123,7 +118,7 @@ irqreturn_t idxd_misc_thread(int vec, void *data)
 			      val);
 
 	if (!err)
-		goto out;
+		return 0;
 
 	gensts.bits = ioread32(idxd->reg_base + IDXD_GENSTATS_OFFSET);
 	if (gensts.state == IDXD_DEVICE_STATE_HALT) {
@@ -144,10 +139,33 @@ irqreturn_t idxd_misc_thread(int vec, void *data)
 				gensts.reset_type == IDXD_DEVICE_RESET_FLR ?
 				"FLR" : "system reset");
 			spin_unlock_bh(&idxd->dev_lock);
+			return -ENXIO;
 		}
 	}
 
- out:
+	return 0;
+}
+
+irqreturn_t idxd_misc_thread(int vec, void *data)
+{
+	struct idxd_irq_entry *irq_entry = data;
+	struct idxd_device *idxd = irq_entry->idxd;
+	int rc;
+	u32 cause;
+
+	cause = ioread32(idxd->reg_base + IDXD_INTCAUSE_OFFSET);
+	if (cause)
+		iowrite32(cause, idxd->reg_base + IDXD_INTCAUSE_OFFSET);
+
+	while (cause) {
+		rc = process_misc_interrupts(idxd, cause);
+		if (rc < 0)
+			break;
+		cause = ioread32(idxd->reg_base + IDXD_INTCAUSE_OFFSET);
+		if (cause)
+			iowrite32(cause, idxd->reg_base + IDXD_INTCAUSE_OFFSET);
+	}
+
 	idxd_unmask_msix_vector(idxd, irq_entry->id);
 	return IRQ_HANDLED;
 }
-- 
2.27.0



