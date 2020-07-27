Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0C4022F002
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731671AbgG0OVH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:21:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:49638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731638AbgG0OVH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:21:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F6C22070A;
        Mon, 27 Jul 2020 14:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859666;
        bh=XQDfGytVTpKeb+agTuSXemU8hW+k5+3VzA9zL6czwig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PKupiYhceYfqkN7aiWz7u4BtA9LJj1hp5mUgv9FBn9/JviRa0NAkUogzGLBWwSP74
         yxk7CE8stMMqaInIo3A1sgl4P4ZJ+6DhKGa1LGaOGD9MFzB02ruAVozM6MBRV7KP3W
         1FM9Epa/2SVdacz92E2jw3ihdMMo9xTI4JpqLofg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Jian <liujian56@huawei.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 059/179] ieee802154: fix one possible memleak in adf7242_probe
Date:   Mon, 27 Jul 2020 16:03:54 +0200
Message-Id: <20200727134935.545552337@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
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
index 5a37514e42347..8dbccec6ac866 100644
--- a/drivers/net/ieee802154/adf7242.c
+++ b/drivers/net/ieee802154/adf7242.c
@@ -1262,7 +1262,7 @@ static int adf7242_probe(struct spi_device *spi)
 					     WQ_MEM_RECLAIM);
 	if (unlikely(!lp->wqueue)) {
 		ret = -ENOMEM;
-		goto err_hw_init;
+		goto err_alloc_wq;
 	}
 
 	ret = adf7242_hw_init(lp);
@@ -1294,6 +1294,8 @@ static int adf7242_probe(struct spi_device *spi)
 	return ret;
 
 err_hw_init:
+	destroy_workqueue(lp->wqueue);
+err_alloc_wq:
 	mutex_destroy(&lp->bmux);
 	ieee802154_free_hw(lp->hw);
 
-- 
2.25.1



