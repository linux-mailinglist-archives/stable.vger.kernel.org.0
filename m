Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A73336425F
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238369AbhDSNIT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:08:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:42844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238512AbhDSNIS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:08:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A77361245;
        Mon, 19 Apr 2021 13:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837667;
        bh=5UGggfXQEozhhPBFqntgmeLebew8m3ioZg8MfzcGirA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oALnYd8FeoT1c48IivsqLLBzfSlUAtl2N/zTGrVo7oeVqFUUQ2cR1OSoVwPjB9CdM
         6fPzpTTt0khafUOwch4BZaaDW0l+gir3dnVRz8YXCtocSk9ZzomwhEvVtDvgl1dCmk
         utXVr8AH+C7rkIIu7trEHsV8PC3T2ueJAyVNh2IE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 012/122] dmaengine: Fix a double free in dma_async_device_register
Date:   Mon, 19 Apr 2021 15:04:52 +0200
Message-Id: <20210419130530.583490663@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Yunlong <lyl2019@mail.ustc.edu.cn>

[ Upstream commit ea45b6008f8095db0cc09ad6e03c7785c2986197 ]

In the first list_for_each_entry() macro of dma_async_device_register,
it gets the chan from list and calls __dma_async_device_channel_register
(..,chan). We can see that chan->local is allocated by alloc_percpu() and
it is freed chan->local by free_percpu(chan->local) when
__dma_async_device_channel_register() failed.

But after __dma_async_device_channel_register() failed, the caller will
goto err_out and freed the chan->local in the second time by free_percpu().

The cause of this problem is forget to set chan->local to NULL when
chan->local was freed in __dma_async_device_channel_register(). My
patch sets chan->local to NULL when the callee failed to avoid double free.

Fixes: d2fb0a0438384 ("dmaengine: break out channel registration")
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20210331014458.3944-1-lyl2019@mail.ustc.edu.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dmaengine.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index fe6a460c4373..af3ee288bc11 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -1086,6 +1086,7 @@ static int __dma_async_device_channel_register(struct dma_device *device,
 	kfree(chan->dev);
  err_free_local:
 	free_percpu(chan->local);
+	chan->local = NULL;
 	return rc;
 }
 
-- 
2.30.2



