Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E62364C0935
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 03:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237568AbiBWCjE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 21:39:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237674AbiBWChz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 21:37:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29AAF5BD18;
        Tue, 22 Feb 2022 18:32:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04879615BA;
        Wed, 23 Feb 2022 02:32:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7289FC340F0;
        Wed, 23 Feb 2022 02:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583571;
        bh=z26jdcz8ETQiT0yMjJkEpAN2tFFILIDjhzcZj/5HSQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ce2lPLtIOqH+Joc3ksU+Jc89XRkn7pu7mGcxuthHjXFBVa2DrCQOWG7VlUW+3apdT
         jrrz1bS1JKRv8v9BRtTr/Yed8qKrT3yMLKWLLx6S7cEuHvwmo7jNKB7WjOAXVUN7XV
         UR1D8KttKKrodaFdTEHloml26sHKIsFhN1HlNaegD5KG2AsDWZGfVHRXVD+GSzTTx4
         vSe4NEs0tHPQynMyOFII3aL+1KEAFdQjfrSIGBOnW/AkGckAwWKXFuRiNYoinZ78ed
         DHv3WA3tdFjyS1E5xu/TjTVtqY+r541jyxxMxBPyYzIFNSlFdXLy3lMplZCjgFVrHJ
         /L4F/SZbzJGsg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yongzhi Liu <lyz_cs@pku.edu.cn>, Vinod Koul <vkoul@kernel.org>,
        Sasha Levin <sashal@kernel.org>, broonie@kernel.org,
        christophe.jaillet@wanadoo.fr, arnd@arndb.de,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 07/10] dmaengine: shdma: Fix runtime PM imbalance on error
Date:   Tue, 22 Feb 2022 21:32:30 -0500
Message-Id: <20220223023233.242468-7-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223023233.242468-1-sashal@kernel.org>
References: <20220223023233.242468-1-sashal@kernel.org>
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
index 12fa48e380cf5..4f8dfe77da3c5 100644
--- a/drivers/dma/sh/shdma-base.c
+++ b/drivers/dma/sh/shdma-base.c
@@ -118,8 +118,10 @@ static dma_cookie_t shdma_tx_submit(struct dma_async_tx_descriptor *tx)
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

