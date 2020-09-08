Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4013B2619E0
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729212AbgIHS1p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:27:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:56670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731417AbgIHQK3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:10:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1966B24805;
        Tue,  8 Sep 2020 15:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579794;
        bh=gNjhvH4+C+o+6lSMH6s19KO6QdOeaKVYNf7dHoeUAVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K4OkjV7sej7JvZ6RxzRizWRuR8FwkC3R9Bh/AfXNCnJQcWZSO3QaZXyBGU8uhxWsD
         pxkGKEO98CPMATdi82DrkuJyFnN90VH9/2gnXyYUz0dXqMihnTYkCHuzk5T3qozXBv
         6WffAd698uca0jxfH8nGwUu5koLR3W4s8IohmFgA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 036/129] net: systemport: Fix memleak in bcm_sysport_probe
Date:   Tue,  8 Sep 2020 17:24:37 +0200
Message-Id: <20200908152231.479089440@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152229.689878733@linuxfoundation.org>
References: <20200908152229.689878733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 7ef1fc57301f3cef7201497aa27e89ccb91737fe ]

When devm_kcalloc() fails, dev should be freed just
like what we've done in the subsequent error paths.

Fixes: 7b78be48a8eb6 ("net: systemport: Dynamically allocate number of TX rings")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bcmsysport.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 4dfdb5a58025b..71eb8914e620b 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -2453,8 +2453,10 @@ static int bcm_sysport_probe(struct platform_device *pdev)
 	priv->tx_rings = devm_kcalloc(&pdev->dev, txq,
 				      sizeof(struct bcm_sysport_tx_ring),
 				      GFP_KERNEL);
-	if (!priv->tx_rings)
-		return -ENOMEM;
+	if (!priv->tx_rings) {
+		ret = -ENOMEM;
+		goto err_free_netdev;
+	}
 
 	priv->is_lite = params->is_lite;
 	priv->num_rx_desc_words = params->num_rx_desc_words;
-- 
2.25.1



