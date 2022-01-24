Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2F54988CA
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245714AbiAXSu3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:50:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245375AbiAXStz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:49:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A32BC061759;
        Mon, 24 Jan 2022 10:49:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3268EB8121B;
        Mon, 24 Jan 2022 18:49:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E125C340E7;
        Mon, 24 Jan 2022 18:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050193;
        bh=1iwX9fiVdN109SENSvLbS9g6OOk2fPkxM7KXrvSR8zU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B3I/OgOW5w8tqXNrkt1vSIwsGHsYx4WKwUsNOZk7PP8wgWdT78ujJHASRQ2NbEVk2
         P0K2DRDOVNC9o+RgBlJAUiYunvtnbzSO6O2/hrlcuVxVYO1Rla6OkuC4vyCki1J181
         5QIG5yBJaQp3MAYJU+bU170KbzKFaedqsrRXfprk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 039/114] can: xilinx_can: xcan_probe(): check for error irq
Date:   Mon, 24 Jan 2022 19:42:14 +0100
Message-Id: <20220124183928.318364577@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183927.095545464@linuxfoundation.org>
References: <20220124183927.095545464@linuxfoundation.org>
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
index 700b98d9c2500..19745e88774e2 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -1284,7 +1284,12 @@ static int xcan_probe(struct platform_device *pdev)
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



