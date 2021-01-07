Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0509F2ED268
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729496AbhAGOdE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:33:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:47050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725960AbhAGOdD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:33:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A54B62333E;
        Thu,  7 Jan 2021 14:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610029943;
        bh=rL8SPjrjjedUT5cwUiy92UMYjYVpVsTctXFdFqbowhM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BFVcGKNzUt/0buB1Xjfxr8Vc9qLHoTN8qtdZ0wAmknCcE+tI7XPOILABcHumeFOog
         IkHtpYo4E9bOwwp71JvOPfmL5bC5qG98W0aaNOodwrHdQFg1W5MosYlgkUc34SwEp+
         hEuKK8aCebG4THn1wW/Fy+nOdZ+8TPDvpiuOrfaQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.4 04/13] dmaengine: at_hdmac: add missing put_device() call in at_dma_xlate()
Date:   Thu,  7 Jan 2021 15:33:23 +0100
Message-Id: <20210107143050.505932032@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107143049.929352526@linuxfoundation.org>
References: <20210107143049.929352526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

commit 3832b78b3ec2cf51e07102f9b4480e343459b20f upstream.

If of_find_device_by_node() succeed, at_dma_xlate() doesn't have a
corresponding put_device(). Thus add put_device() to fix the exception
handling for this function implementation.

Fixes: bbe89c8e3d59 ("at_hdmac: move to generic DMA binding")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20200817115728.1706719-3-yukuai3@huawei.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/at_hdmac.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1674,8 +1674,10 @@ static struct dma_chan *at_dma_xlate(str
 	dma_cap_set(DMA_SLAVE, mask);
 
 	atslave = kmalloc(sizeof(*atslave), GFP_KERNEL);
-	if (!atslave)
+	if (!atslave) {
+		put_device(&dmac_pdev->dev);
 		return NULL;
+	}
 
 	atslave->cfg = ATC_DST_H2SEL_HW | ATC_SRC_H2SEL_HW;
 	/*
@@ -1704,8 +1706,10 @@ static struct dma_chan *at_dma_xlate(str
 	atslave->dma_dev = &dmac_pdev->dev;
 
 	chan = dma_request_channel(mask, at_dma_filter, atslave);
-	if (!chan)
+	if (!chan) {
+		put_device(&dmac_pdev->dev);
 		return NULL;
+	}
 
 	atchan = to_at_dma_chan(chan);
 	atchan->per_if = dma_spec->args[0] & 0xff;


