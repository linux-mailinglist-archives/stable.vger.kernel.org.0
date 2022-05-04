Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C827051A62E
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353961AbiEDQxg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 12:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353854AbiEDQwf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:52:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964EA4755D;
        Wed,  4 May 2022 09:48:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AEEA16177E;
        Wed,  4 May 2022 16:48:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A405C385A5;
        Wed,  4 May 2022 16:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651682923;
        bh=NR3zf8+wobyKh5rsMqyyrs5WlQl2JkF1VRptszhN0xc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P5P3MYSFvh2X33BDPWBLLD+W0WXiHz0B1WVTJCaUSycINYgZ5TvUjrnGRxFMbxmK0
         TMQXCD1ZvweYM7po0SqK8PP8UGIcNDknOUOCTq5ycARuk8Cie3fFeUl8aIAwmFbPN3
         3MnA52V+/ZYnjmu+O54i1Cx7Pb+J7SnSXMlzTdQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 41/84] phy: ti: Add missing pm_runtime_disable() in serdes_am654_probe
Date:   Wed,  4 May 2022 18:44:22 +0200
Message-Id: <20220504152930.721903004@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504152927.744120418@linuxfoundation.org>
References: <20220504152927.744120418@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit ce88613e5bd579478653a028291098143f2a5bdf ]

The pm_runtime_enable() will increase power disable depth.
If the probe fails, we should use pm_runtime_disable() to balance
pm_runtime_enable().
Add missing pm_runtime_disable() for serdes_am654_probe().

Fixes: 71e2f5c5c224 ("phy: ti: Add a new SERDES driver for TI's AM654x SoC")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220301025853.1911-1-linmq006@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/ti/phy-am654-serdes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/ti/phy-am654-serdes.c b/drivers/phy/ti/phy-am654-serdes.c
index 6ef12017ff4e..96e3426f9293 100644
--- a/drivers/phy/ti/phy-am654-serdes.c
+++ b/drivers/phy/ti/phy-am654-serdes.c
@@ -641,7 +641,7 @@ static int serdes_am654_probe(struct platform_device *pdev)
 
 clk_err:
 	of_clk_del_provider(node);
-
+	pm_runtime_disable(dev);
 	return ret;
 }
 
-- 
2.35.1



