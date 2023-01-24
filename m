Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEB8F679A46
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 14:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234630AbjAXNpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 08:45:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234550AbjAXNo6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 08:44:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84D3E46D53;
        Tue, 24 Jan 2023 05:43:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FED061220;
        Tue, 24 Jan 2023 13:43:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D1DC4339E;
        Tue, 24 Jan 2023 13:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674567822;
        bh=nyx8R1iatVI0dqQqG052dXSkuLS+LDgoROTQpI0M2Ow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nw4lv7461fxyitizI3117Nnz8vUhIXrCxE18MwZFV9AigZjMqoO4ccz1XRC6jSGq1
         Iodeudl2oe1g3B0NjCQNYDFjLsfGRUV0F2DiDb1HamlMfVcp9sYjStY9JnCYAiCSrd
         I4E7lMArzlGS/SG/cI48ya/QTuowuuEMY0WHZfm76q0e1s3ci3tqjE5QUc1Jj2naZw
         9lKq0fWcFgjCx0CyTcVRrYOMCpCL5YFW1o5MdXsIqRbSLBXYcxBn2eT4kVUNgfieDd
         PsU/u7pW5nAfdLREP4vAroIrwJv1qsPSYQoaVpY2Ivn9P2RZtzC3SA1H9XtDwIvuLp
         9gx444Fy0qIvA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hui Wang <hui.wang@canonical.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        shawnguo@kernel.org, dmaengine@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 7/8] dmaengine: imx-sdma: Fix a possible memory leak in sdma_transfer_init
Date:   Tue, 24 Jan 2023 08:43:27 -0500
Message-Id: <20230124134328.637707-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230124134328.637707-1-sashal@kernel.org>
References: <20230124134328.637707-1-sashal@kernel.org>
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
index 2283dcd8bf91..6514db824473 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -1363,10 +1363,12 @@ static struct sdma_desc *sdma_transfer_init(struct sdma_channel *sdmac,
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

