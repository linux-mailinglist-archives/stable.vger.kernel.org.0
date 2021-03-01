Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 666AE328B08
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239901AbhCAS13 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:27:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:39690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239756AbhCASUe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:20:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23C6B651C4;
        Mon,  1 Mar 2021 17:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619006;
        bh=jStxmN0GRKAnqHt1nhbljYEq4i+PwkcP8PPGxiD/gxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xOMVCSr9U2NaqdPx5oPxqO5m78PCvRFuW17xLoECoYKNuzELxLD0XDKZ3l0fdU9yB
         bPLTKlXBwhfV9dWURZ01b63FJ4BibVqskmXdChee51pcLWpm+heK4tVTIuUxOaiXND
         MDTtQMaKUr7eI0WtY5HDRyWxaTHWF7yuXSkH8c+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>,
        Ray Jui <ray.jui@broadcom.com>, Wolfram Sang <wsa@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 267/663] i2c: iproc: handle only slave interrupts which are enabled
Date:   Mon,  1 Mar 2021 17:08:35 +0100
Message-Id: <20210301161155.024978379@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>

[ Upstream commit 545f4011e156554d704d6278245d54543f6680d1 ]

Handle only slave interrupts which are enabled.

The IS_OFFSET register contains the interrupt status bits which will be
set regardless of the enabling of the corresponding interrupt condition.
One must therefore look at both IS_OFFSET and IE_OFFSET to determine
whether an interrupt condition is set and enabled.

Fixes: c245d94ed106 ("i2c: iproc: Add multi byte read-write support for slave mode")
Signed-off-by: Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>
Acked-by: Ray Jui <ray.jui@broadcom.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-bcm-iproc.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-bcm-iproc.c b/drivers/i2c/busses/i2c-bcm-iproc.c
index d8295b1c379d1..b98433c04d184 100644
--- a/drivers/i2c/busses/i2c-bcm-iproc.c
+++ b/drivers/i2c/busses/i2c-bcm-iproc.c
@@ -505,12 +505,17 @@ static void bcm_iproc_i2c_process_m_event(struct bcm_iproc_i2c_dev *iproc_i2c,
 static irqreturn_t bcm_iproc_i2c_isr(int irq, void *data)
 {
 	struct bcm_iproc_i2c_dev *iproc_i2c = data;
-	u32 status = iproc_i2c_rd_reg(iproc_i2c, IS_OFFSET);
+	u32 slave_status;
+	u32 status;
 	bool ret;
-	u32 sl_status = status & ISR_MASK_SLAVE;
 
-	if (sl_status) {
-		ret = bcm_iproc_i2c_slave_isr(iproc_i2c, sl_status);
+	status = iproc_i2c_rd_reg(iproc_i2c, IS_OFFSET);
+	/* process only slave interrupt which are enabled */
+	slave_status = status & iproc_i2c_rd_reg(iproc_i2c, IE_OFFSET) &
+		       ISR_MASK_SLAVE;
+
+	if (slave_status) {
+		ret = bcm_iproc_i2c_slave_isr(iproc_i2c, slave_status);
 		if (ret)
 			return IRQ_HANDLED;
 		else
-- 
2.27.0



