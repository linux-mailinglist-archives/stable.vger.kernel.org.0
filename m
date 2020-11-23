Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20DCD2C0B1A
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732062AbgKWMiJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:38:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:50560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732025AbgKWMiH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:38:07 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4AB7208C3;
        Mon, 23 Nov 2020 12:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135087;
        bh=+/XInTxqoknupdebruEVQIZZbeJa9DLxTBHjIGoaWDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T06t+Df02z3kICeIOnO6Qks/Cptyavgrn2iUpTZNVT8SRPW1qWnttxDwEaHGS77+c
         mk4xf2Ps8iGZKupteYCJAzD44Ygc0JKdNwPYhgrwPgSPhLVuwRdtD40iNpJM409KSt
         FQKxvIiyFXRIXC6fVRmbGl/VhABaczJLKhVNDKzs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 100/158] can: m_can: process interrupt only when not runtime suspended
Date:   Mon, 23 Nov 2020 13:22:08 +0100
Message-Id: <20201123121824.756406776@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

[ Upstream commit a1f634463aaf2c94dfa13001dbdea011303124cc ]

Avoid processing bogus interrupt statuses when the HW is runtime suspended and
the M_CAN_IR register read may get all bits 1's. Handler can be called if the
interrupt request is shared with other peripherals or at the end of free_irq().

Therefore check the runtime suspended status before processing.

Fixes: cdf8259d6573 ("can: m_can: Add PM Support")
Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Link: https://lore.kernel.org/r/20200915134715.696303-1-jarkko.nikula@linux.intel.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/m_can.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 661db85d569ce..246fa2657d744 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -913,6 +913,8 @@ static irqreturn_t m_can_isr(int irq, void *dev_id)
 	struct net_device_stats *stats = &dev->stats;
 	u32 ir;
 
+	if (pm_runtime_suspended(cdev->dev))
+		return IRQ_NONE;
 	ir = m_can_read(cdev, M_CAN_IR);
 	if (!ir)
 		return IRQ_NONE;
-- 
2.27.0



