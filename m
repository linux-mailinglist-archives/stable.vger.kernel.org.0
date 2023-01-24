Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABD8A679A6E
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 14:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234555AbjAXNqw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 08:46:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234584AbjAXNqD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 08:46:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 375F247EE8;
        Tue, 24 Jan 2023 05:44:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7DCDB80F3B;
        Tue, 24 Jan 2023 13:44:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7102DC433A4;
        Tue, 24 Jan 2023 13:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674567844;
        bh=qHVGKWz40xcyB0e9AaLwqgL438Tb2zBWiEAi4PrIKCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ymc7hp3eXNx1pjHvyaHt3+UgXsV6Zed392R9qykcsKrW2eG5O38mZl/kYkR+prFbf
         5fUMg/Mg8KC5eftSKYQpGSRhDruvLDRqFNI/5I3/1Sk2k9me8+kmv4XflFHPDVKi9n
         r1GTMh2oM6RiQRCngDyfegD4z3e+/IGC3MGJlFjf5fywotZeWY7qbKoSiop/KKoJEY
         IsLGRUrUwQme8nxNJERinE+q/Rsol0+fKbVwlb4UFU8qruZaq5d0bDXznzhFmSqlF3
         6gPi/QjyJsjOToA2dqivlMDHapWT1Aft0gbSkH9uqNC5XKzL8+XeJAsBtzw74p5nR7
         X3cy4Xj/fEaGw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hui Wang <hui.wang@canonical.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        shawnguo@kernel.org, dmaengine@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 3/4] dmaengine: imx-sdma: Fix a possible memory leak in sdma_transfer_init
Date:   Tue, 24 Jan 2023 08:43:56 -0500
Message-Id: <20230124134357.637945-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230124134357.637945-1-sashal@kernel.org>
References: <20230124134357.637945-1-sashal@kernel.org>
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
index 709ead443fc5..5794d3120bb8 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -1347,10 +1347,12 @@ static struct sdma_desc *sdma_transfer_init(struct sdma_channel *sdmac,
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

