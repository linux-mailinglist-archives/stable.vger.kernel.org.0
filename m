Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D37B111F43
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729215AbfLCWqj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:46:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:36410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729214AbfLCWqi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:46:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 880D420684;
        Tue,  3 Dec 2019 22:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413198;
        bh=9JYLrUUpM0aBZhoAx+R07YXaj7ac/jBYho1RxIWZO7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bN9Pg7reBYyhH09h6GssUZHZlm7lVfWrwcdpwDxNYQUnPDL2phvf8UAeNqfD/i5Rg
         w9gvM6/TUtsbR+vX0D+MMrBs9WywMetZtE225jWxjuYCfvqgZIEwt6wik6mu+9AH0g
         zTuelXdnMeWqHYUYfVuxnlpvJIY8lapfdOx1mDd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Timo=20Schl=C3=BC=C3=9Fler?= <schluessler@krause.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 035/321] can: mcp251x: mcp251x_restart_work_handler(): Fix potential force_quit race condition
Date:   Tue,  3 Dec 2019 23:31:41 +0100
Message-Id: <20191203223428.940510843@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
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
index de8d9dceb1236..0b0dd3f096dc6 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -773,6 +773,7 @@ static void mcp251x_restart_work_handler(struct work_struct *ws)
 	if (priv->after_suspend) {
 		mcp251x_hw_reset(spi);
 		mcp251x_setup(net, spi);
+		priv->force_quit = 0;
 		if (priv->after_suspend & AFTER_SUSPEND_RESTART) {
 			mcp251x_set_normal_mode(spi);
 		} else if (priv->after_suspend & AFTER_SUSPEND_UP) {
@@ -784,7 +785,6 @@ static void mcp251x_restart_work_handler(struct work_struct *ws)
 			mcp251x_hw_sleep(spi);
 		}
 		priv->after_suspend = 0;
-		priv->force_quit = 0;
 	}
 
 	if (priv->restart_tx) {
-- 
2.20.1



