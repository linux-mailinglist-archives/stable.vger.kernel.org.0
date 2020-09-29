Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBA3E27CAB4
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732397AbgI2MUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:20:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:49134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729859AbgI2Lff (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:35:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AFCD23D50;
        Tue, 29 Sep 2020 11:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378992;
        bh=AM5QSygGdA20FkJSA8T59iLLm550iFWw8QwzqKxR/aE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EEEJCDG/PGtRvuQDjyBVI+pKYW/yl8o7ouc0udhfuIP9ojmlFja1gTVLORc8jW6ex
         SMDkwj7si86hqTw0T9lpkgpVUSUeCrffPUPh5se3/C42Ozt53iVH70/YxAILqHP6VW
         tH14QFZxqbLF9DjV83kMJgXAArqg4Oc/MzLmJmrw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Jian <liujian56@huawei.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 215/245] ieee802154: fix one possible memleak in ca8210_dev_com_init
Date:   Tue, 29 Sep 2020 13:01:06 +0200
Message-Id: <20200929105957.443162082@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
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
index 38a41651e451c..deace0aadad24 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -2923,6 +2923,7 @@ static int ca8210_dev_com_init(struct ca8210_priv *priv)
 	);
 	if (!priv->irq_workqueue) {
 		dev_crit(&priv->spi->dev, "alloc of irq_workqueue failed!\n");
+		destroy_workqueue(priv->mlme_workqueue);
 		return -ENOMEM;
 	}
 
-- 
2.25.1



