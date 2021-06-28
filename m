Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A032C3B6305
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235586AbhF1OvI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:51:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:54460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234714AbhF1Os4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:48:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40ED161D10;
        Mon, 28 Jun 2021 14:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891007;
        bh=hTkNF0HvWXn3x7IYcVylTQZqlyN/pW/R6aGXvTZ35o4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GcGxcZN60qgz7g89F6YqAJb6GnS76ZUwwuJguNyr5NSnRi8WkRqVyJiAa+6CSm1m1
         RCt0cSwUKRwwh1CT7ci19IJegHVNzvaPnHRdHmy/mZ/6ErSyFlnlc1hR946RW0blyw
         MaDhUS+wF6yllv6UsyJxwZNwq0ezI+5vUv+rwuvisLQDnfxmzJ1CAph/OkaZLOmoEr
         lSTXsG3Xwq7PDw+G9kagWfVpiMhMXvf52X/LcIRlWYUaptAfzvUTR6qipLfa4nQBy5
         p2FNqjISGTyUMVyfmZHSNb5QRDGyHFyVX2QHX62ZJFACc/4wDlwtMtGZvr73eWFWx7
         7e49Ze3aWLCzQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 20/88] dmaengine: stedma40: add missing iounmap() on error in d40_probe()
Date:   Mon, 28 Jun 2021 10:35:20 -0400
Message-Id: <20210628143628.33342-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143628.33342-1-sashal@kernel.org>
References: <20210628143628.33342-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.238-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.238-rc1
X-KernelTest-Deadline: 2021-06-30T14:36+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
index 90feb6a05e59..ee15d4fefbad 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3656,6 +3656,9 @@ static int __init d40_probe(struct platform_device *pdev)
 
 	kfree(base->lcla_pool.base_unaligned);
 
+	if (base->lcpa_base)
+		iounmap(base->lcpa_base);
+
 	if (base->phy_lcpa)
 		release_mem_region(base->phy_lcpa,
 				   base->lcpa_size);
-- 
2.30.2

