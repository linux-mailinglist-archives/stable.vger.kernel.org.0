Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E30F29B18F
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2902188AbgJ0ObP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:31:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2902133AbgJ0Oan (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:30:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A6D620754;
        Tue, 27 Oct 2020 14:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809042;
        bh=3XB9ugt7OyV653v7aSM2DpFppWYd501bNgytNPQxfII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z+6EQude7ms31dmJAmhqj6zXnl+qFsffmqEWm5M+HviNEwUGOEFycgPQb0lcAJxef
         57wRd6r3vzxAoLHKnz5hv6SEiCW8AYCok0zbod2OHTTgg/nMWZkBHarFmO+9RoIIfB
         v+aP6RZJm8zFcvX1+zwRXL8nTzBkZzMVqs4b6QR4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Dan Murphy <dmurphy@ti.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.4 013/408] can: m_can_platform: dont call m_can_class_suspend in runtime suspend
Date:   Tue, 27 Oct 2020 14:49:11 +0100
Message-Id: <20201027135455.672038135@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit 81f1f5ae8b3cbd54fdd994c9e9aacdb7b414a802 ]

    0704c5743694 can: m_can_platform: remove unnecessary m_can_class_resume() call

removed the m_can_class_resume() call in the runtime resume path to get
rid of a infinite recursion, so the runtime resume now only handles the device
clocks.

Unfortunately it did not remove the complementary m_can_class_suspend() call in
the runtime suspend function, so those paths are now unbalanced, which causes
the pinctrl state to get stuck on the "sleep" state, which breaks all CAN
functionality on SoCs where this state is defined. Remove the
m_can_class_suspend() call to fix this.

Fixes: 0704c5743694 can: m_can_platform: remove unnecessary m_can_class_resume() call
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Link: https://lore.kernel.org/r/20200811081545.19921-1-l.stach@pengutronix.de
Acked-by: Dan Murphy <dmurphy@ti.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/m_can/m_can_platform.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/net/can/m_can/m_can_platform.c
+++ b/drivers/net/can/m_can/m_can_platform.c
@@ -144,8 +144,6 @@ static int __maybe_unused m_can_runtime_
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct m_can_classdev *mcan_class = netdev_priv(ndev);
 
-	m_can_class_suspend(dev);
-
 	clk_disable_unprepare(mcan_class->cclk);
 	clk_disable_unprepare(mcan_class->hclk);
 


