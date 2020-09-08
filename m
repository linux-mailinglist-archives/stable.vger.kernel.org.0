Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90EB1261C82
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731881AbgIHTUs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:20:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:48752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731112AbgIHQBq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:01:46 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34AF423C8E;
        Tue,  8 Sep 2020 15:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579398;
        bh=XaZSweeH6YaRj/4/7chvv0iwCB8mFC24aGi2uCz/AsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B3rZSqAzHshD2+cXy67R3BDIwwhxChcngM1kGx9lnMY8v0jKNKmg8MM1P6Q+NjBsP
         00rdLpfOAkR+nBbnTlQaCquuNXnINesyMHnrWlSlAYa1HaglU8Hmlj8hg7AbTYmctt
         d0uQx+rL97Jqoe5Go8F8K8B4h47XqcQabwH/gidY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 044/186] dmaengine: at_hdmac: add missing put_device() call in at_dma_xlate()
Date:   Tue,  8 Sep 2020 17:23:06 +0200
Message-Id: <20200908152243.796562500@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 3832b78b3ec2cf51e07102f9b4480e343459b20f ]

If of_find_device_by_node() succeed, at_dma_xlate() doesn't have a
corresponding put_device(). Thus add put_device() to fix the exception
handling for this function implementation.

Fixes: bbe89c8e3d59 ("at_hdmac: move to generic DMA binding")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20200817115728.1706719-3-yukuai3@huawei.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/at_hdmac.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 22c1c507055a3..c91642b5f1037 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1657,8 +1657,10 @@ static struct dma_chan *at_dma_xlate(struct of_phandle_args *dma_spec,
 	dma_cap_set(DMA_SLAVE, mask);
 
 	atslave = kmalloc(sizeof(*atslave), GFP_KERNEL);
-	if (!atslave)
+	if (!atslave) {
+		put_device(&dmac_pdev->dev);
 		return NULL;
+	}
 
 	atslave->cfg = ATC_DST_H2SEL_HW | ATC_SRC_H2SEL_HW;
 	/*
@@ -1687,8 +1689,10 @@ static struct dma_chan *at_dma_xlate(struct of_phandle_args *dma_spec,
 	atslave->dma_dev = &dmac_pdev->dev;
 
 	chan = dma_request_channel(mask, at_dma_filter, atslave);
-	if (!chan)
+	if (!chan) {
+		put_device(&dmac_pdev->dev);
 		return NULL;
+	}
 
 	atchan = to_at_dma_chan(chan);
 	atchan->per_if = dma_spec->args[0] & 0xff;
-- 
2.25.1



