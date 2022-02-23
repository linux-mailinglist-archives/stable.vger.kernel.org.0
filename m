Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E71B94C087A
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 03:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237034AbiBWCck (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 21:32:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237212AbiBWCcT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 21:32:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61CF25938B;
        Tue, 22 Feb 2022 18:30:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E06DCB81DD2;
        Wed, 23 Feb 2022 02:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7898C340E8;
        Wed, 23 Feb 2022 02:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583418;
        bh=3Q6HfLvnyk20c5KteC9b+hLzCTbQ2st3hb44bFNMDzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vQnhA+P/bOrDhnGttcP7T/4IzPn8B+dCyY5Y8hqsh0cikXRvzdxM1Bw0WeSgoKkep
         LaFVT1kqtnAwce67eT2Hy/3nXQbIxxUSSpb3g4BhNoyqLQCyEEZUYYu+QWAl2SpcrJ
         8SQAV9GpeyZjX+1uXWIM8ORu8CY1s2D3hf3iX10Dq+Vzi3ToxqHzoZHPbVxq9jjI9X
         rQ549CfgVACfTB0CXzDjmvmzh6s6POyzFmnATpjxi031lm1DE+04nDmH2KoRqYF/Ne
         LskqU32SaSN+XofiNi+oF9SNi+H9iQ6W1b+LcMPDXbFZiC/xOpAasgADmhdm9ue9gZ
         kCKemmvdydnGA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yongzhi Liu <lyz_cs@pku.edu.cn>, Vinod Koul <vkoul@kernel.org>,
        Sasha Levin <sashal@kernel.org>, arnd@arndb.de,
        christophe.jaillet@wanadoo.fr, laurent.pinchart@ideasonboard.com,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 22/28] dmaengine: shdma: Fix runtime PM imbalance on error
Date:   Tue, 22 Feb 2022 21:29:23 -0500
Message-Id: <20220223022929.241127-22-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223022929.241127-1-sashal@kernel.org>
References: <20220223022929.241127-1-sashal@kernel.org>
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
index 7f72b3f4cd1ae..19ac95c0098f0 100644
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

