Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D333679A53
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 14:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234665AbjAXNqD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 08:46:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234580AbjAXNpV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 08:45:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B135B474FB;
        Tue, 24 Jan 2023 05:43:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91BF5611D7;
        Tue, 24 Jan 2023 13:43:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 299F4C433D2;
        Tue, 24 Jan 2023 13:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674567835;
        bh=KDl2zacnSK0FLUxtKWcIV32UB7/5CvDpOu567wZ5mOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BsXKMWZjJbcC8mvBCXJhxoT1tLJ79RIEO517BBwE7u+TNZXpCS4RioZpTJupyVcEp
         Ym/FHp8pG7jlMhi41zEm3y//IoMCpFmyPThS29p8Z8Y9EDfte0Kl0yl2JpiGrVxoNb
         Te/j+mYmBjT8xt7gdDipOSFHtmrOGg8KJVRCTd+qbDBvqFk/TgnntfNRqi/2PjwtjE
         PgvZ97kPrxnS6V3FoCqT8czlFuh13eMu+gW6MYoZytdps7NuxVBhMXAqiW3O48JSCA
         mqSKOtVOlk8/x8mlK1B1ZjNC0bIF7ODfjvx9SVZwPlS2fWotGN23eItK0+GCncbNLJ
         DOy45kF0motZg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hui Wang <hui.wang@canonical.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        shawnguo@kernel.org, dmaengine@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 5/6] dmaengine: imx-sdma: Fix a possible memory leak in sdma_transfer_init
Date:   Tue, 24 Jan 2023 08:43:43 -0500
Message-Id: <20230124134344.637846-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230124134344.637846-1-sashal@kernel.org>
References: <20230124134344.637846-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

[ Upstream commit 1417f59ac0b02130ee56c0c50794b9b257be3d17 ]

If the function sdma_load_context() fails, the sdma_desc will be
freed, but the allocated desc->bd is forgot to be freed.

We already met the sdma_load_context() failure case and the log as
below:
[ 450.699064] imx-sdma 30bd0000.dma-controller: Timeout waiting for CH0 ready
...

In this case, the desc->bd will not be freed without this change.

Signed-off-by: Hui Wang <hui.wang@canonical.com>
Reviewed-by: Sascha Hauer <s.hauer@pengutronix.de>
Link: https://lore.kernel.org/r/20221130090800.102035-1-hui.wang@canonical.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/imx-sdma.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index 8ec7a7041e84..8dbff2f6c3b8 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -1360,10 +1360,12 @@ static struct sdma_desc *sdma_transfer_init(struct sdma_channel *sdmac,
 		sdma_config_ownership(sdmac, false, true, false);
 
 	if (sdma_load_context(sdmac))
-		goto err_desc_out;
+		goto err_bd_out;
 
 	return desc;
 
+err_bd_out:
+	sdma_free_bd(desc);
 err_desc_out:
 	kfree(desc);
 err_out:
-- 
2.39.0

