Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3D3D2ED26C
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729225AbhAGOdL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:33:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:47090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729512AbhAGOdH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:33:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18F2B23355;
        Thu,  7 Jan 2021 14:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610029947;
        bh=FHfrzkrQE5F56OZDdtRzhU8tkTFlNs7/pCMHdepjlkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WybD4dAkTpxhyAVuUVC3B5ATRaHcLBqEnvc5eioWO08U5Zdm7dq7rJhXqtQjAkha6
         Bq3AE9uWV8xt/38Fa+RsKpMvDQUTZ3Ti7S0mb8DNxhT/ErDDGkzbs1hKxTsiVNNPiQ
         lg5vxg8OCsit7MSPyurrHykcHcyShHJO9BeoYyoo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.4 05/13] dmaengine: at_hdmac: add missing kfree() call in at_dma_xlate()
Date:   Thu,  7 Jan 2021 15:33:24 +0100
Message-Id: <20210107143050.632485596@linuxfoundation.org>
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

commit e097eb7473d9e70da9e03276f61cd392ccb9d79f upstream.

If memory allocation for 'atslave' succeed, at_dma_xlate() doesn't have a
corresponding kfree() in exception handling. Thus add kfree() for this
function implementation.

Fixes: bbe89c8e3d59 ("at_hdmac: move to generic DMA binding")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20200817115728.1706719-4-yukuai3@huawei.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/at_hdmac.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1708,6 +1708,7 @@ static struct dma_chan *at_dma_xlate(str
 	chan = dma_request_channel(mask, at_dma_filter, atslave);
 	if (!chan) {
 		put_device(&dmac_pdev->dev);
+		kfree(atslave);
 		return NULL;
 	}
 


