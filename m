Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2183E5D2F
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 16:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242666AbhHJORy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 10:17:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:54544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242665AbhHJOQb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 10:16:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86BF96109E;
        Tue, 10 Aug 2021 14:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628604969;
        bh=iWvU1n7Xu0JlgJ0bdwl8Mf+K9kye/OKxXwSbIDFd6S0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lZ70TX3TUjMEORAsfe3vLg2AfqnxpwwS91txTwohmLlYGGdpAKQ1jyr1wZ6Xix9hD
         aAj4arzIf2UnsEVj6Ouro267MrELgzJWGFNZFMd9ytqXy3B+TqHl2PAiji2n3XFFZt
         8qg42TngbOKnhoJKxXNb1Q/tQdrNz36opMUKIhCh66SpKi8fbGJ+uICUc9b/r7EYDK
         d5GG6V75mjTJzl9cfgijoONJ6fr0ahSLLa0fhkfl0rx1S36td5jm0uEOchyW5R2FDv
         QjEm8Fpnqk1syITSQAaTK1uf6MYv0HB497sPgnnApGyskG2RtTXFDzF5dPFe8vR7l5
         av5Md51BtXSRg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yu Kuai <yukuai3@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 02/13] dmaengine: usb-dmac: Fix PM reference leak in usb_dmac_probe()
Date:   Tue, 10 Aug 2021 10:15:54 -0400
Message-Id: <20210810141606.3117932-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810141606.3117932-1-sashal@kernel.org>
References: <20210810141606.3117932-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 1da569fa7ec8cb0591c74aa3050d4ea1397778b4 ]

pm_runtime_get_sync will increment pm usage counter even it failed.
Forgetting to putting operation will result in reference leak here.
Fix it by moving the error_pm label above the pm_runtime_put() in
the error path.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20210706124521.1371901-1-yukuai3@huawei.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/sh/usb-dmac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/sh/usb-dmac.c b/drivers/dma/sh/usb-dmac.c
index 8f7ceb698226..1cc06900153e 100644
--- a/drivers/dma/sh/usb-dmac.c
+++ b/drivers/dma/sh/usb-dmac.c
@@ -855,8 +855,8 @@ static int usb_dmac_probe(struct platform_device *pdev)
 
 error:
 	of_dma_controller_free(pdev->dev.of_node);
-	pm_runtime_put(&pdev->dev);
 error_pm:
+	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	return ret;
 }
-- 
2.30.2

