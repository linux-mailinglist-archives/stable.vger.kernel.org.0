Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A81B111FA8
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728592AbfLCWls (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:41:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:56394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728587AbfLCWlr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:41:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 307D1206EC;
        Tue,  3 Dec 2019 22:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412906;
        bh=SQ88NzCVo4FfYtk3jHrQFqZQpHL9QPX0q0E6FyiuBbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UHPScInDULYuCVQpvr9CM9oIvN4nZKLLrXeHrSnx4lqXibipTWoxNZMqXGnXFXDSU
         tzrOSfIBCAB+JSHK71g3c6NErOzr6aZa4elAxM7Ib5OzkhSP1aa1+OlZOvP5r0GCfr
         TwXjh0rx3eSMkn2C5sa0MMytbsci2VxISrgHSck4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Timo=20Schl=C3=BC=C3=9Fler?= <schluessler@krause.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 062/135] can: mcp251x: mcp251x_restart_work_handler(): Fix potential force_quit race condition
Date:   Tue,  3 Dec 2019 23:35:02 +0100
Message-Id: <20191203213023.079828697@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Timo Schlüßler <schluessler@krause.de>

[ Upstream commit 27a0e54bae09d2dd023a01254db506d61cc50ba1 ]

In mcp251x_restart_work_handler() the variable to stop the interrupt
handler (priv->force_quit) is reset after the chip is restarted and thus
a interrupt might occur.

This patch fixes the potential race condition by resetting force_quit
before enabling interrupts.

Signed-off-by: Timo Schlüßler <schluessler@krause.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/spi/mcp251x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index 5d6f8977df3f8..c0ee0fa909702 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -759,6 +759,7 @@ static void mcp251x_restart_work_handler(struct work_struct *ws)
 	if (priv->after_suspend) {
 		mcp251x_hw_reset(spi);
 		mcp251x_setup(net, spi);
+		priv->force_quit = 0;
 		if (priv->after_suspend & AFTER_SUSPEND_RESTART) {
 			mcp251x_set_normal_mode(spi);
 		} else if (priv->after_suspend & AFTER_SUSPEND_UP) {
@@ -770,7 +771,6 @@ static void mcp251x_restart_work_handler(struct work_struct *ws)
 			mcp251x_hw_sleep(spi);
 		}
 		priv->after_suspend = 0;
-		priv->force_quit = 0;
 	}
 
 	if (priv->restart_tx) {
-- 
2.20.1



