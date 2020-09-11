Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61298266663
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 19:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbgIKR0V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 13:26:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:49260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbgIKNAK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 09:00:10 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEC1622251;
        Fri, 11 Sep 2020 12:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599828961;
        bh=SBK2HNKNJ+JL6x4mU7ei9C5WVJMlfumQ0oEPx2yqabY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sZCxz+iiumqdGhhxW+hYovaEUUVGToqa7ruaeGlysD38SlpGQnRM0Qyk464BCaRJb
         WQ/YPPzBaDZvkuHYZDpGhwZuH2nxD9rRZJBTBgKE/JDfJkfFZSewaffar6R7MovZFf
         ku1O3ioD0yFGbLOz2BboV2mq+ndFQTspanupC5vQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 12/71] dmaengine: at_hdmac: check return value of of_find_device_by_node() in at_dma_xlate()
Date:   Fri, 11 Sep 2020 14:45:56 +0200
Message-Id: <20200911122505.554791505@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122504.928931589@linuxfoundation.org>
References: <20200911122504.928931589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 0cef8e2c5a07d482ec907249dbd6687e8697677f ]

The reurn value of of_find_device_by_node() is not checked, thus null
pointer dereference will be triggered if of_find_device_by_node()
failed.

Fixes: bbe89c8e3d59 ("at_hdmac: move to generic DMA binding")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20200817115728.1706719-2-yukuai3@huawei.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/at_hdmac.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index a32cd71f94bbe..cb72b8c915c73 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1810,6 +1810,8 @@ static struct dma_chan *at_dma_xlate(struct of_phandle_args *dma_spec,
 		return NULL;
 
 	dmac_pdev = of_find_device_by_node(dma_spec->np);
+	if (!dmac_pdev)
+		return NULL;
 
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_SLAVE, mask);
-- 
2.25.1



