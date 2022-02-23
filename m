Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 446374C08C2
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 03:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237353AbiBWCee (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 21:34:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237765AbiBWCd2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 21:33:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E39B3B547;
        Tue, 22 Feb 2022 18:31:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B10D61519;
        Wed, 23 Feb 2022 02:31:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8673C340E8;
        Wed, 23 Feb 2022 02:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583503;
        bh=mrV6dQUlm23eEo1U+VXCrk3Sau7WDOBqJMKBwzUVdnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ehkYV6ySp8ObmTQodYgghP+GWQdF29fENXVezuqQuQiOVYTpUtXbbV7x0c6ysLulb
         Vm11/C82u3DUKqmfJ1sQ60EOVL7LrwRwTWHDam4WB/7zwDsC1+Zt6U249lmFy3BRnk
         hSPiOrwldvQ2Fh2W1kIBXOrWIVCb3UDvRpCtSW+zyM+EAD4Xd9pKcPu3dYFt9MfM5K
         Pdcn+/0RBn4cBcxjrjnnv3yaB8uTo2WhKtUwlOtvevWl+7i1f5bZ/dESXGuELMgjPp
         wXTfrot5kXKw5Lf74dsd11y9/K9wf90EjIjgqsUgwAbPCF0LX/8YKJUH0XS2DJM5F6
         WIPiK5yXP1UTA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yongzhi Liu <lyz_cs@pku.edu.cn>, Vinod Koul <vkoul@kernel.org>,
        Sasha Levin <sashal@kernel.org>, christophe.jaillet@wanadoo.fr,
        broonie@kernel.org, arnd@arndb.de,
        laurent.pinchart@ideasonboard.com, dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 10/13] dmaengine: shdma: Fix runtime PM imbalance on error
Date:   Tue, 22 Feb 2022 21:31:14 -0500
Message-Id: <20220223023118.241815-10-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223023118.241815-1-sashal@kernel.org>
References: <20220223023118.241815-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yongzhi Liu <lyz_cs@pku.edu.cn>

[ Upstream commit 455896c53d5b803733ddd84e1bf8a430644439b6 ]

pm_runtime_get_() increments the runtime PM usage counter even
when it returns an error code, thus a matching decrement is needed on
the error handling path to keep the counter balanced.

Signed-off-by: Yongzhi Liu <lyz_cs@pku.edu.cn>
Link: https://lore.kernel.org/r/1642311296-87020-1-git-send-email-lyz_cs@pku.edu.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/sh/shdma-base.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/sh/shdma-base.c b/drivers/dma/sh/shdma-base.c
index c51de498b5b4b..19eee3d0900b0 100644
--- a/drivers/dma/sh/shdma-base.c
+++ b/drivers/dma/sh/shdma-base.c
@@ -115,8 +115,10 @@ static dma_cookie_t shdma_tx_submit(struct dma_async_tx_descriptor *tx)
 		ret = pm_runtime_get(schan->dev);
 
 		spin_unlock_irq(&schan->chan_lock);
-		if (ret < 0)
+		if (ret < 0) {
 			dev_err(schan->dev, "%s(): GET = %d\n", __func__, ret);
+			pm_runtime_put(schan->dev);
+		}
 
 		pm_runtime_barrier(schan->dev);
 
-- 
2.34.1

