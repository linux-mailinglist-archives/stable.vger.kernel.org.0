Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2797E302AF6
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 20:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731325AbhAYS54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:57:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:41920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731401AbhAYSz6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:55:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A514D2074B;
        Mon, 25 Jan 2021 18:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600916;
        bh=eO0dDmEDWVk+yU+pjZ+9iVs9+6DLE+paynmH/iXW0tw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EMIzHMBLRb0mPIr2ERwaqOaO192Pv0hHyFnM/dveZ+Ev1QLGDHm8Xyk+Mn7VVFGwS
         h8E4oDpbvApg9oFKseIG1IzXyhgoZ/lmhQh6ZI7NgRpckmvmhyxY2DDqWQBVLpmVNO
         duVCD92ShXIh93a/KWKhZfZMNSkFCPQVJlEl+3q8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 190/199] net: systemport: free dev before on error path
Date:   Mon, 25 Jan 2021 19:40:12 +0100
Message-Id: <20210125183224.194503367@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

commit 0c630a66bf10991b0ef13d27c93d7545e692ef5b upstream.

On the error path, it should goto the error handling label to free
allocated memory rather than directly return.

Fixes: 31bc72d97656 ("net: systemport: fetch and use clock resources")
Signed-off-by: Pan Bian <bianpan2016@163.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20210120044423.1704-1-bianpan2016@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bcmsysport.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -2503,8 +2503,10 @@ static int bcm_sysport_probe(struct plat
 	priv = netdev_priv(dev);
 
 	priv->clk = devm_clk_get_optional(&pdev->dev, "sw_sysport");
-	if (IS_ERR(priv->clk))
-		return PTR_ERR(priv->clk);
+	if (IS_ERR(priv->clk)) {
+		ret = PTR_ERR(priv->clk);
+		goto err_free_netdev;
+	}
 
 	/* Allocate number of TX rings */
 	priv->tx_rings = devm_kcalloc(&pdev->dev, txq,


