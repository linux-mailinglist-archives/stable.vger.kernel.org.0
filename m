Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F670A9194
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389740AbfIDSTR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:19:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390019AbfIDSJ7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:09:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 245042087E;
        Wed,  4 Sep 2019 18:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620598;
        bh=mMUhugRxCVP5bdl6+7j98wwjOy/wromZmzTztlHSIZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XTxWR2YclJVOYRGd/IIINdiJt1802a2lCNgmNoLBlhimL2J/Vj/4Ogu+kv2EV8Ktu
         ULgb/lo3zQzarUsJEYU7b3IwapvBOfqGRJJMYWnK5rZBd23svisatjekJmCqdSAg8a
         nxtPIx+lFPoFeEoDHHuPX/PPoYlwBzT+9ewOozmk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Atish Patra <atish.patra@wdc.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 025/143] dma-direct: dont truncate dma_required_mask to bus addressing capabilities
Date:   Wed,  4 Sep 2019 19:52:48 +0200
Message-Id: <20190904175315.051650883@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d8ad55538abe443919e20e0bb996561bca9cad84 ]

The dma required_mask needs to reflect the actual addressing capabilities
needed to handle the whole system RAM. When truncated down to the bus
addressing capabilities dma_addressing_limited() will incorrectly signal
no limitations for devices which are restricted by the bus_dma_mask.

Fixes: b4ebe6063204 (dma-direct: implement complete bus_dma_mask handling)
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Tested-by: Atish Patra <atish.patra@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/direct.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 2c2772e9702ab..9912be7a970de 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -55,9 +55,6 @@ u64 dma_direct_get_required_mask(struct device *dev)
 {
 	u64 max_dma = phys_to_dma_direct(dev, (max_pfn - 1) << PAGE_SHIFT);
 
-	if (dev->bus_dma_mask && dev->bus_dma_mask < max_dma)
-		max_dma = dev->bus_dma_mask;
-
 	return (1ULL << (fls64(max_dma) - 1)) * 2 - 1;
 }
 
-- 
2.20.1



