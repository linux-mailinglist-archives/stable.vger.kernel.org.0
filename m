Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9AFC50F3C5
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243995AbiDZI15 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344755AbiDZI12 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:27:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D0B73A186;
        Tue, 26 Apr 2022 01:23:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52DAE617E8;
        Tue, 26 Apr 2022 08:23:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E003C385A0;
        Tue, 26 Apr 2022 08:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961413;
        bh=fqhTmAqzBRh8HZ0aX6wqEd4AStiCK9N2MoFQSNpn2Rw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fjqm4jSSLFGMlkBUmbtX4TDfxiKEJ+3BwMvCxBA8yG76TG+A8SIJRDTHKbl2MYNpz
         hB9RYvEDe3o0NraBafKrLYVI/oP99O4FLRY49yFDGamI2+BNYMWGDx05OlCxUPFvmr
         CRLTM0s2//At7EwjBrElgh8R5uRemS0zgiRIL2rk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 05/24] dmaengine: imx-sdma: Fix error checking in sdma_event_remap
Date:   Tue, 26 Apr 2022 10:20:59 +0200
Message-Id: <20220426081731.533246482@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081731.370823950@linuxfoundation.org>
References: <20220426081731.370823950@linuxfoundation.org>
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
index 558d509b7d85..4337cf9defc2 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -1528,7 +1528,7 @@ static int sdma_event_remap(struct sdma_engine *sdma)
 	u32 reg, val, shift, num_map, i;
 	int ret = 0;
 
-	if (IS_ERR(np) || IS_ERR(gpr_np))
+	if (IS_ERR(np) || !gpr_np)
 		goto out;
 
 	event_remap = of_find_property(np, propname, NULL);
@@ -1576,7 +1576,7 @@ static int sdma_event_remap(struct sdma_engine *sdma)
 	}
 
 out:
-	if (!IS_ERR(gpr_np))
+	if (gpr_np)
 		of_node_put(gpr_np);
 
 	return ret;
-- 
2.35.1



