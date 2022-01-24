Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D23F4989D6
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242517AbiAXS6j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:58:39 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55756 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343689AbiAXS4h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:56:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E11DD614E5;
        Mon, 24 Jan 2022 18:56:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CA74C340E5;
        Mon, 24 Jan 2022 18:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050596;
        bh=35jegGiN93H7Fj9HVJIl3g4TLC5sxCZv4Kb0JVKO0CU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FxXVDFif86HUwJd0Z/7v0QwopkPNHxS9yB038Vx4rhUyIdhVIH6HSb/xTNBPO8RlT
         0QF8KKZivGg3z899Q2fhhocigXAFpKrLhS1DWDBpQauJz/CteaRJyqXexXIZt7DQMX
         MZQPWUklYQivp+xSqetIEsmOnDKruApLTliChqjc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 053/157] can: xilinx_can: xcan_probe(): check for error irq
Date:   Mon, 24 Jan 2022 19:42:23 +0100
Message-Id: <20220124183934.470430305@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183932.787526760@linuxfoundation.org>
References: <20220124183932.787526760@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit c6564c13dae25cd7f8e1de5127b4da4500ee5844 ]

For the possible failure of the platform_get_irq(), the returned irq
could be error number and will finally cause the failure of the
request_irq().

Consider that platform_get_irq() can now in certain cases return
-EPROBE_DEFER, and the consequences of letting request_irq()
effectively convert that into -EINVAL, even at probe time rather than
later on. So it might be better to check just now.

Fixes: b1201e44f50b ("can: xilinx CAN controller support")
Link: https://lore.kernel.org/all/20211224021324.1447494-1-jiasheng@iscas.ac.cn
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/xilinx_can.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index e680bab27dd7e..ef24b619e0e57 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -1302,7 +1302,12 @@ static int xcan_probe(struct platform_device *pdev)
 	spin_lock_init(&priv->tx_lock);
 
 	/* Get IRQ for the device */
-	ndev->irq = platform_get_irq(pdev, 0);
+	ret = platform_get_irq(pdev, 0);
+	if (ret < 0)
+		goto err_free;
+
+	ndev->irq = ret;
+
 	ndev->flags |= IFF_ECHO;	/* We support local echo */
 
 	platform_set_drvdata(pdev, ndev);
-- 
2.34.1



