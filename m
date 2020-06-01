Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD5911EAF10
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728448AbgFAR5k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 13:57:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:38988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728939AbgFAR5j (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 13:57:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9D5E206E2;
        Mon,  1 Jun 2020 17:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034259;
        bh=zh+hjr+eJIQBo26ohfepRYxTdhIc+nP1ysNKviD1wAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N0wa0LyftWV2cXIOEKm5KKMOSkZ+V85MluG02irU7d1ZSWD7h2iqNJ2EsQLRxpKop
         3klqzteKEAVcefR/8+tqIMrFTXRGsnEf0XbWKnaZ8MJ2BazLdJBXa9XmRyfM78CCGU
         lcl5g+cCzPaX8JH/g65eZjtTgYdpllSSX8Sk8f8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 14/61] net: microchip: encx24j600: add missed kthread_stop
Date:   Mon,  1 Jun 2020 19:53:21 +0200
Message-Id: <20200601174014.377647504@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174010.316778377@linuxfoundation.org>
References: <20200601174010.316778377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

[ Upstream commit ff8ce319e9c25e920d994cc35236f0bb32dfc8f3 ]

This driver calls kthread_run() in probe, but forgets to call
kthread_stop() in probe failure and remove.
Add the missed kthread_stop() to fix it.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/encx24j600.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/encx24j600.c b/drivers/net/ethernet/microchip/encx24j600.c
index b14f0305aa31..ad661d1979c7 100644
--- a/drivers/net/ethernet/microchip/encx24j600.c
+++ b/drivers/net/ethernet/microchip/encx24j600.c
@@ -1058,7 +1058,7 @@ static int encx24j600_spi_probe(struct spi_device *spi)
 	if (unlikely(ret)) {
 		netif_err(priv, probe, ndev, "Error %d initializing card encx24j600 card\n",
 			  ret);
-		goto out_free;
+		goto out_stop;
 	}
 
 	eidled = encx24j600_read_reg(priv, EIDLED);
@@ -1076,6 +1076,8 @@ static int encx24j600_spi_probe(struct spi_device *spi)
 
 out_unregister:
 	unregister_netdev(priv->ndev);
+out_stop:
+	kthread_stop(priv->kworker_task);
 out_free:
 	free_netdev(ndev);
 
@@ -1088,6 +1090,7 @@ static int encx24j600_spi_remove(struct spi_device *spi)
 	struct encx24j600_priv *priv = dev_get_drvdata(&spi->dev);
 
 	unregister_netdev(priv->ndev);
+	kthread_stop(priv->kworker_task);
 
 	free_netdev(priv->ndev);
 
-- 
2.25.1



