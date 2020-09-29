Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 686C827C6BC
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730994AbgI2LsL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:48:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:50252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730673AbgI2LsK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:48:10 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 659E32158C;
        Tue, 29 Sep 2020 11:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601380084;
        bh=nscEwxwc6U/SkxtkUjLEY5F41Cu3CY1Vilu22rDfEww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tadu75FJRnt0P2NbayxKrqh6BZLUhUbqLNhL3jz6u6FzlVsXypvlHKtPLevW5IgBG
         DCI3QHj6AwW8YiklGO2OAK8VfBnHWi77XxLcPzHZwLCURn57IrFtl53l0Uiw1Aw927
         uP47Iez7fOy5ZxhsFWinMonW51YCG9v7YUA7CM98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Jian <liujian56@huawei.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 21/99] ieee802154: fix one possible memleak in ca8210_dev_com_init
Date:   Tue, 29 Sep 2020 13:01:04 +0200
Message-Id: <20200929105930.769867380@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
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
index e04c3b60cae78..4eb64709d44cb 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -2925,6 +2925,7 @@ static int ca8210_dev_com_init(struct ca8210_priv *priv)
 	);
 	if (!priv->irq_workqueue) {
 		dev_crit(&priv->spi->dev, "alloc of irq_workqueue failed!\n");
+		destroy_workqueue(priv->mlme_workqueue);
 		return -ENOMEM;
 	}
 
-- 
2.25.1



