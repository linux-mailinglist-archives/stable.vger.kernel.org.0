Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3673D3FD9FF
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244414AbhIAM3b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:29:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:58814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244316AbhIAM3G (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:29:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9615E60F92;
        Wed,  1 Sep 2021 12:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499290;
        bh=vo+0wE1OvcoQmdBPeqEYanvNLCv7gekrs7aUx+UHX78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tPfT6nd04aIN4Hgm+PxnXLGhMBqpWve/0lJ3T4kDZHbQgiOpNRRyKZeWMV0KGDD3y
         /9ajjfIKgGhzDf4tXpZMqG+daqIqf8xat7X/j+0iXBXebu7o+Tm3yGaSczhm+f64BF
         yfM57RCbu1YoUUnEwbxeYp/mMqT+mrhhwNSeNnd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 10/23] xgene-v2: Fix a resource leak in the error handling path of xge_probe()
Date:   Wed,  1 Sep 2021 14:26:55 +0200
Message-Id: <20210901122250.121760660@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122249.786673285@linuxfoundation.org>
References: <20210901122249.786673285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 5ed74b03eb4d08f5dd281dcb5f1c9bb92b363a8d ]

A successful 'xge_mdio_config()' call should be balanced by a corresponding
'xge_mdio_remove()' call in the error handling path of the probe, as
already done in the remove function.

Update the error handling path accordingly.

Fixes: ea8ab16ab225 ("drivers: net: xgene-v2: Add MDIO support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/apm/xgene-v2/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/apm/xgene-v2/main.c b/drivers/net/ethernet/apm/xgene-v2/main.c
index 0f2ad50f3bd7..7f37e7cb687e 100644
--- a/drivers/net/ethernet/apm/xgene-v2/main.c
+++ b/drivers/net/ethernet/apm/xgene-v2/main.c
@@ -691,11 +691,13 @@ static int xge_probe(struct platform_device *pdev)
 	ret = register_netdev(ndev);
 	if (ret) {
 		netdev_err(ndev, "Failed to register netdev\n");
-		goto err;
+		goto err_mdio_remove;
 	}
 
 	return 0;
 
+err_mdio_remove:
+	xge_mdio_remove(ndev);
 err:
 	free_netdev(ndev);
 
-- 
2.30.2



