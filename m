Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C315E47ADC9
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236107AbhLTOzr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:55:47 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44574 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238064AbhLTOxP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:53:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34381611AA;
        Mon, 20 Dec 2021 14:53:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB61C36AEB;
        Mon, 20 Dec 2021 14:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011994;
        bh=OgUK2/b5wEhh+wY0uvCGv+QMelzBSNs7f96OyyOOKOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DfBvjua9nSmH0vqY/PqU5HWgD2LL1b8o/xuuzA4c7j+yhxjGl4eO1SYVFojytIaOY
         l7X63kEJPrtu1OOmD09ivbDCnGB0MeGavFpK+ZR3NRukQkXoM0XxbJ+YhiJr3xfHDm
         wMWUun8x9/CX0aRVD6YOj+oIBJo1660vA7309LOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 043/177] dmaengine: idxd: add halt interrupt support
Date:   Mon, 20 Dec 2021 15:33:13 +0100
Message-Id: <20211220143041.554477535@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 88d97ea82cbe352851a8654ee952d3a694c8c2c6 ]

Add halt interrupt support. Given that the misc interrupt handler already
check halt state, the driver just need to run the halt handling code when
receiving the halt interrupt.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/163114224352.846654.14334468363464318828.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/irq.c       | 5 +++++
 drivers/dma/idxd/registers.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/drivers/dma/idxd/irq.c b/drivers/dma/idxd/irq.c
index ca88fa7a328e7..3261ea247e832 100644
--- a/drivers/dma/idxd/irq.c
+++ b/drivers/dma/idxd/irq.c
@@ -63,6 +63,9 @@ static int process_misc_interrupts(struct idxd_device *idxd, u32 cause)
 	int i;
 	bool err = false;
 
+	if (cause & IDXD_INTC_HALT_STATE)
+		goto halt;
+
 	if (cause & IDXD_INTC_ERR) {
 		spin_lock(&idxd->dev_lock);
 		for (i = 0; i < 4; i++)
@@ -121,6 +124,7 @@ static int process_misc_interrupts(struct idxd_device *idxd, u32 cause)
 	if (!err)
 		return 0;
 
+halt:
 	gensts.bits = ioread32(idxd->reg_base + IDXD_GENSTATS_OFFSET);
 	if (gensts.state == IDXD_DEVICE_STATE_HALT) {
 		idxd->state = IDXD_DEV_HALTED;
@@ -134,6 +138,7 @@ static int process_misc_interrupts(struct idxd_device *idxd, u32 cause)
 			queue_work(idxd->wq, &idxd->work);
 		} else {
 			spin_lock(&idxd->dev_lock);
+			idxd->state = IDXD_DEV_HALTED;
 			idxd_wqs_quiesce(idxd);
 			idxd_wqs_unmap_portal(idxd);
 			idxd_device_clear_state(idxd);
diff --git a/drivers/dma/idxd/registers.h b/drivers/dma/idxd/registers.h
index ffc7550a77eeb..97ffb06de9b0d 100644
--- a/drivers/dma/idxd/registers.h
+++ b/drivers/dma/idxd/registers.h
@@ -158,6 +158,7 @@ enum idxd_device_reset_type {
 #define IDXD_INTC_CMD			0x02
 #define IDXD_INTC_OCCUPY			0x04
 #define IDXD_INTC_PERFMON_OVFL		0x08
+#define IDXD_INTC_HALT_STATE		0x10
 
 #define IDXD_CMD_OFFSET			0xa0
 union idxd_command_reg {
-- 
2.33.0



