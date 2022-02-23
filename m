Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB0B4C0888
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 03:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237106AbiBWCdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 21:33:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237649AbiBWCdT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 21:33:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8807E55743;
        Tue, 22 Feb 2022 18:31:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 800EAB81E10;
        Wed, 23 Feb 2022 02:31:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41164C340E8;
        Wed, 23 Feb 2022 02:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583467;
        bh=3Q6HfLvnyk20c5KteC9b+hLzCTbQ2st3hb44bFNMDzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lwn2W0AaQxj8gNKhpqJoHjTw4jPX3KVe8tzGWk07wqNo4h80PKpbi+7GN0hcejX5L
         yVpabTqqEchT6Mu3IV05zwDUF5IovzwUoNXbs2nkowXtRpq6Grk+SlkJv7paNCnEpA
         TRr37D/aEqUahdUNCi3n66qaPUU5+KSyuonrp7dWtzlKrMuJAwM+g2na3ri6xHOJS0
         v7RrGysxYia36RqZ1KH7ofaoqlg+poLQdo+3AHKnpraI20TTpcAOefWAmW95z9/A2h
         jToxNVSJoiiHtrT5gb4wPvNRu5BEd8zQBZ8oY1/mp9dEigrRaHedj4IbjxyV2QohgM
         syq/PCMsEoD9Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yongzhi Liu <lyz_cs@pku.edu.cn>, Vinod Koul <vkoul@kernel.org>,
        Sasha Levin <sashal@kernel.org>, christophe.jaillet@wanadoo.fr,
        arnd@arndb.de, laurent.pinchart@ideasonboard.com,
        broonie@kernel.org, dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 14/18] dmaengine: shdma: Fix runtime PM imbalance on error
Date:   Tue, 22 Feb 2022 21:30:31 -0500
Message-Id: <20220223023035.241551-14-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223023035.241551-1-sashal@kernel.org>
References: <20220223023035.241551-1-sashal@kernel.org>
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

