Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5063AED84
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbhFUQUg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:20:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:40024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231295AbhFUQUK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:20:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FB9F6120D;
        Mon, 21 Jun 2021 16:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292275;
        bh=ubxOpBglMmBwIhwZNBTjWYW72B9eStWwuAUoHUbfyqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=udfHxALL4iD0N5OGu5SELduoWC62iqQYN7cwA3C0XewjGGrw9UHGEQnsU0LEq46I5
         6rK1sdWsiU2lVYpjMtTrsQYw5yny983cwobE5arQn4t+TwSH7wjey0TJBk65Il4RQj
         YHqcLZTpQo3i5hd0OeLDizni4DCsWbazZOksQA3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 03/90] dmaengine: stedma40: add missing iounmap() on error in d40_probe()
Date:   Mon, 21 Jun 2021 18:14:38 +0200
Message-Id: <20210621154904.276961759@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154904.159672728@linuxfoundation.org>
References: <20210621154904.159672728@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit fffdaba402cea79b8d219355487d342ec23f91c6 ]

Add the missing iounmap() before return from d40_probe()
in the error handling case.

Fixes: 8d318a50b3d7 ("DMAENGINE: Support for ST-Ericssons DMA40 block v3")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20210518141108.1324127-1-yangyingliang@huawei.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index de8bfd9a76e9..6671bfe08489 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3678,6 +3678,9 @@ static int __init d40_probe(struct platform_device *pdev)
 
 	kfree(base->lcla_pool.base_unaligned);
 
+	if (base->lcpa_base)
+		iounmap(base->lcpa_base);
+
 	if (base->phy_lcpa)
 		release_mem_region(base->phy_lcpa,
 				   base->lcpa_size);
-- 
2.30.2



