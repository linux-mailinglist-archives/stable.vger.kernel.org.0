Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4379922F240
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729829AbgG0OK1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:10:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:33198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729843AbgG0OKZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:10:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FED02173E;
        Mon, 27 Jul 2020 14:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859024;
        bh=r9m2u3fFRZQaAQ2EmZjr12wYwtTC6YK4ob/28+R+PpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f1U0HLUOg5Ze1fW/9cdzKAn33uSiqfgAGRHN69ieHj4sxOFF/1qofCy/y9YimbCBj
         Jns/sUV/lOWUjO7NNfJ0qG4pOIL2Q+McxCUw6LKaBmyX2skZ4p8jxlEXDDdvh5Lel2
         1luHnnaqU6zzj+WmOoM4BQ0N0E7HTXCobT5/7eoA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Jian <liujian56@huawei.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 30/86] ieee802154: fix one possible memleak in adf7242_probe
Date:   Mon, 27 Jul 2020 16:04:04 +0200
Message-Id: <20200727134915.953736595@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134914.312934924@linuxfoundation.org>
References: <20200727134914.312934924@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Jian <liujian56@huawei.com>

[ Upstream commit 66673f96f0f968b991dc38be06102246919c663c ]

When probe fail, we should destroy the workqueue.

Fixes: 2795e8c25161 ("net: ieee802154: fix a potential NULL pointer dereference")
Signed-off-by: Liu Jian <liujian56@huawei.com>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
Link: https://lore.kernel.org/r/20200717090121.2143-1-liujian56@huawei.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ieee802154/adf7242.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ieee802154/adf7242.c b/drivers/net/ieee802154/adf7242.c
index cd6b95e673a58..71be8524cca87 100644
--- a/drivers/net/ieee802154/adf7242.c
+++ b/drivers/net/ieee802154/adf7242.c
@@ -1270,7 +1270,7 @@ static int adf7242_probe(struct spi_device *spi)
 					     WQ_MEM_RECLAIM);
 	if (unlikely(!lp->wqueue)) {
 		ret = -ENOMEM;
-		goto err_hw_init;
+		goto err_alloc_wq;
 	}
 
 	ret = adf7242_hw_init(lp);
@@ -1302,6 +1302,8 @@ static int adf7242_probe(struct spi_device *spi)
 	return ret;
 
 err_hw_init:
+	destroy_workqueue(lp->wqueue);
+err_alloc_wq:
 	mutex_destroy(&lp->bmux);
 	ieee802154_free_hw(lp->hw);
 
-- 
2.25.1



