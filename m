Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0E503E5D54
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 16:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242503AbhHJOSp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 10:18:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:54070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242565AbhHJOQ7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 10:16:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C1B161139;
        Tue, 10 Aug 2021 14:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628604988;
        bh=bQgA2kTqYGaCCX473wmTwizJQezcU6xgL6ifyL0OfIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ER1c4kuWlURBBxYrpLeq+FwDE7cATXS5w1p77vvJxORa2RQuWSwMMvR1S9ThgwvUF
         5X+uNXm3Yig9t907dobnGDWoMwsNTp0yDqDu0K5uODjS7XoTLYoKK89F7xkygU9k63
         raGEvkVcshhXcClg4k4SfNlavx30npaSoZ7w2oOAEosg2CHyZcVfFyuu1gWDD7L+fW
         Ur9H1nnT7z2xFhw3xRut4/WJkVPXi/7ITmBZDKzENxOlOj3QresjRI3igd/1sRCNFE
         P9dDr9CMmp+MuJ6NGHVsBHL/469rB1DSmgsAoRwaMdER2w5mQy7JkGu71apt+aFFY1
         yo+yCYRLoNENA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yu Kuai <yukuai3@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 02/11] dmaengine: usb-dmac: Fix PM reference leak in usb_dmac_probe()
Date:   Tue, 10 Aug 2021 10:16:15 -0400
Message-Id: <20210810141625.3118097-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810141625.3118097-1-sashal@kernel.org>
References: <20210810141625.3118097-1-sashal@kernel.org>
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
index 6c94ed750049..d77bf325f038 100644
--- a/drivers/dma/sh/usb-dmac.c
+++ b/drivers/dma/sh/usb-dmac.c
@@ -860,8 +860,8 @@ static int usb_dmac_probe(struct platform_device *pdev)
 
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

