Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB5A127C651
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730823AbgI2Lnz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:43:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:42506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730821AbgI2Lnx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:43:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79F7B206E5;
        Tue, 29 Sep 2020 11:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379833;
        bh=LoAXF5XTR4w9T6a3sMyjEc6yieQF+GoGSbOwzvnNPLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rWn9hdh+3Q/WXjgb8c9C+FoZN3Es4qR38ziFGuy3EFKbaRapwfjrztDAwcz8fyiI5
         KF03xAb9zr2ReNCBGGgGdgu6jXMEuZiqcFVHE3dmp47KdYvg8k45xddMFJ6vwnayzI
         5HHGoAmJxRPPepsX2ltICwQF1b6vIDqrQK/dxOEE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Jian <liujian56@huawei.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 337/388] ieee802154: fix one possible memleak in ca8210_dev_com_init
Date:   Tue, 29 Sep 2020 13:01:08 +0200
Message-Id: <20200929110026.776642274@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Jian <liujian56@huawei.com>

[ Upstream commit 88f46b3fe2ac41c381770ebad9f2ee49346b57a2 ]

We should call destroy_workqueue to destroy mlme_workqueue in error branch.

Fixes: ded845a781a5 ("ieee802154: Add CA8210 IEEE 802.15.4 device driver")
Signed-off-by: Liu Jian <liujian56@huawei.com>
Link: https://lore.kernel.org/r/20200720143315.40523-1-liujian56@huawei.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ieee802154/ca8210.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index 430c937861534..25dbea302fb6d 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -2924,6 +2924,7 @@ static int ca8210_dev_com_init(struct ca8210_priv *priv)
 	);
 	if (!priv->irq_workqueue) {
 		dev_crit(&priv->spi->dev, "alloc of irq_workqueue failed!\n");
+		destroy_workqueue(priv->mlme_workqueue);
 		return -ENOMEM;
 	}
 
-- 
2.25.1



