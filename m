Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80ACB1EF7D
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732829AbfEOLbG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:31:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:42772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732840AbfEOLbG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:31:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14C5E206BF;
        Wed, 15 May 2019 11:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919865;
        bh=MIhzsOA6fwEdEx1ikBp/ndqyYoZ40hTNplsc78QFuCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DC+AlT5gLvqmW58XL2bJ39yMqrYRv1LqmnnpWArOBJA6fIV81P5DjwpmDjcjmU5Gd
         1RezUTSGj0SrbydDAJw/r+y7iG3wx4zGqNdtBBQiXf/YMcqAbBV4g3ucU9BvIAsvME
         bEhcx0cSpU2pol1Dq6vlCP46gTWbDp5VP3FFrOQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 079/137] dmaengine: bcm2835: Avoid GFP_KERNEL in device_prep_slave_sg
Date:   Wed, 15 May 2019 12:56:00 +0200
Message-Id: <20190515090659.195406339@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f147384774a7b24dda4783a3dcd61af272757ea8 ]

The commit af19b7ce76ba ("mmc: bcm2835: Avoid possible races on
data requests") introduces a possible circular locking dependency,
which is triggered by swapping to the sdhost interface.

So instead of reintroduce the race condition again, we could also
avoid this situation by using GFP_NOWAIT for the allocation of the
DMA buffer descriptors.

Reported-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Fixes: af19b7ce76ba ("mmc: bcm2835: Avoid possible races on data requests")
Link: http://lists.infradead.org/pipermail/linux-rpi-kernel/2019-March/008615.html
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/bcm2835-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/bcm2835-dma.c b/drivers/dma/bcm2835-dma.c
index ae10f5614f953..bf51192036378 100644
--- a/drivers/dma/bcm2835-dma.c
+++ b/drivers/dma/bcm2835-dma.c
@@ -674,7 +674,7 @@ static struct dma_async_tx_descriptor *bcm2835_dma_prep_slave_sg(
 	d = bcm2835_dma_create_cb_chain(chan, direction, false,
 					info, extra,
 					frames, src, dst, 0, 0,
-					GFP_KERNEL);
+					GFP_NOWAIT);
 	if (!d)
 		return NULL;
 
-- 
2.20.1



