Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80F5A65841B
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235307AbiL1Qxx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:53:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235206AbiL1Qw6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:52:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF5E1178
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:48:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE5966157C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:48:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B90DEC433F0;
        Wed, 28 Dec 2022 16:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246082;
        bh=NP9roU9tcRKBE5/Z72M2A8EyHFHSkBSeFbblojAjbDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZXHZKnFH1YAwXDqloOPGXijND3boB1WIaO8A1BSHQDJ4GzuzzxVSrWaxrQK53pKag
         Q+3jXvqzAj1pkw6djOsF8CnE6S0+mojGFBRkwzAtq1xcAgmBQ80tXtS8I9ytzNOTcy
         xErnsOF+1vfLbuLKF6NmjvNLNpKzj2KS6KGfT5ok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wang Jingjin <wangjingjin1@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 1009/1073] ASoC: rockchip: spdif: Add missing clk_disable_unprepare() in rk_spdif_runtime_resume()
Date:   Wed, 28 Dec 2022 15:43:17 +0100
Message-Id: <20221228144355.566630598@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Jingjin <wangjingjin1@huawei.com>

[ Upstream commit 6d94d0090527b1763872275a7ccd44df7219b31e ]

rk_spdif_runtime_resume() may have called clk_prepare_enable() before return
from failed branches, add missing clk_disable_unprepare() in this case.

Fixes: f874b80e1571 ("ASoC: rockchip: Add rockchip SPDIF transceiver driver")
Signed-off-by: Wang Jingjin <wangjingjin1@huawei.com>
Link: https://lore.kernel.org/r/20221208063900.4180790-1-wangjingjin1@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/rockchip_spdif.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/rockchip/rockchip_spdif.c b/sound/soc/rockchip/rockchip_spdif.c
index 8bef572d3cbc..5b4f00457587 100644
--- a/sound/soc/rockchip/rockchip_spdif.c
+++ b/sound/soc/rockchip/rockchip_spdif.c
@@ -88,6 +88,7 @@ static int __maybe_unused rk_spdif_runtime_resume(struct device *dev)
 
 	ret = clk_prepare_enable(spdif->hclk);
 	if (ret) {
+		clk_disable_unprepare(spdif->mclk);
 		dev_err(spdif->dev, "hclk clock enable failed %d\n", ret);
 		return ret;
 	}
-- 
2.35.1



