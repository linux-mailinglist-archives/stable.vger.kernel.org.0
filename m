Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D60302C07A9
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733004AbgKWMm6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:42:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:55942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732998AbgKWMm5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:42:57 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28D772076E;
        Mon, 23 Nov 2020 12:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135377;
        bh=KCMwQ8ms3+fccT4L3vRK+OEf2EEAZReWYJ/yKv6uKkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xZvkdbdF47CoKwbdbg5NBPRqBsjMKEJTAG7d8/8qhRjDy7rwW7XjnIOSzMna2eqmC
         D7eoE0hrr1zEGI4YUxqwoHfWjzegLtfK/38CBcIkfvxXPnwe4wiCVfHZK6Y2t30KC1
         a7dSLX2CTcfV9qiznoCf1gXFbJXj22BzB+PKhEL0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 016/252] net: ethernet: mtk-star-emac: fix error return code in mtk_star_enable()
Date:   Mon, 23 Nov 2020 13:19:26 +0100
Message-Id: <20201123121836.375444396@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit baee1991fad928d6c8dd5be3197ecb413c420c97 ]

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 8c7bd5a454ff ("net: ethernet: mtk-star-emac: new driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Acked-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Link: https://lore.kernel.org/r/1605180879-2573-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mediatek/mtk_star_emac.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -966,6 +966,7 @@ static int mtk_star_enable(struct net_de
 				      mtk_star_adjust_link, 0, priv->phy_intf);
 	if (!priv->phydev) {
 		netdev_err(ndev, "failed to connect to PHY\n");
+		ret = -ENODEV;
 		goto err_free_irq;
 	}
 


