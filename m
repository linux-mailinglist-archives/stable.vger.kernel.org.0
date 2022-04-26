Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7A7950F58E
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345777AbiDZIrt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346936AbiDZIpd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:45:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06DF83D1E0;
        Tue, 26 Apr 2022 01:36:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D0DC6185A;
        Tue, 26 Apr 2022 08:36:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11B6C385A0;
        Tue, 26 Apr 2022 08:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962214;
        bh=Fbabi4I2ep9mRIfgpDWVEW8fiXo08VooavgX6hur53g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ZAFUWIw676N6FGCXmK/jFh8seC/KN+XXOzSIzdpfYwztjMddn7RaMzTmsFbR+4CZ
         vGo39CGr9Vrp30S498O5zZNcUb73ggU0penEeBCfXQbOa6L33KQ0RPSzCd7k01vUoj
         C7THSVLWi5QtYF3zgp1EeWfeCXl4ZMAHNQXkg8iY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 023/124] dmaengine: imx-sdma: Fix error checking in sdma_event_remap
Date:   Tue, 26 Apr 2022 10:20:24 +0200
Message-Id: <20220426081747.963991804@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081747.286685339@linuxfoundation.org>
References: <20220426081747.286685339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 7104b9cb35a33ad803a1adbbfa50569b008faf15 ]

of_parse_phandle() returns NULL on errors, rather than error
pointers. Using NULL check on grp_np to fix this.

Fixes: d078cd1b4185 ("dmaengine: imx-sdma: Add imx6sx platform support")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220308064952.15743-1-linmq006@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/imx-sdma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index cacc725ca545..263f0466b1b8 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -1869,7 +1869,7 @@ static int sdma_event_remap(struct sdma_engine *sdma)
 	u32 reg, val, shift, num_map, i;
 	int ret = 0;
 
-	if (IS_ERR(np) || IS_ERR(gpr_np))
+	if (IS_ERR(np) || !gpr_np)
 		goto out;
 
 	event_remap = of_find_property(np, propname, NULL);
@@ -1917,7 +1917,7 @@ static int sdma_event_remap(struct sdma_engine *sdma)
 	}
 
 out:
-	if (!IS_ERR(gpr_np))
+	if (gpr_np)
 		of_node_put(gpr_np);
 
 	return ret;
-- 
2.35.1



