Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5613E6584B5
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 18:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235315AbiL1RAm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 12:00:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235357AbiL1RAD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 12:00:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF0520BFE
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:55:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 686DF60D41
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:55:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7972BC433D2;
        Wed, 28 Dec 2022 16:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246525;
        bh=XKNp2vgdkZOqvb8ZpnkkTc35WysmYrXuZPl5CpeHkwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R1cshuUMo5ZpqjJfdboWzAzSEYYeLsY3f3wxD5TknkWSG5miZH7htf5S8crAEObEh
         eaYw6CZSIlQ6DmIzJKgV3SksgR9LWa3enS38h3C3mgmYtQWyyu+ANNfDzWgBkHjuYy
         9C/tFi3pGX/Ixr5wXdicGhyMX6dpFzc9IWJClDAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wang Jingjin <wangjingjin1@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1070/1146] ASoC: rockchip: pdm: Add missing clk_disable_unprepare() in rockchip_pdm_runtime_resume()
Date:   Wed, 28 Dec 2022 15:43:29 +0100
Message-Id: <20221228144359.313232311@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

[ Upstream commit ef0a098efb36660326c133af9b5a04a96a00e3ca ]

The clk_disable_unprepare() should be called in the error handling of
rockchip_pdm_runtime_resume().

Fixes: fc05a5b22253 ("ASoC: rockchip: add support for pdm controller")
Signed-off-by: Wang Jingjin <wangjingjin1@huawei.com>
Link: https://lore.kernel.org/r/20221205032802.2422983-1-wangjingjin1@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/rockchip_pdm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/rockchip/rockchip_pdm.c b/sound/soc/rockchip/rockchip_pdm.c
index a7549f827235..5b1e47bdc376 100644
--- a/sound/soc/rockchip/rockchip_pdm.c
+++ b/sound/soc/rockchip/rockchip_pdm.c
@@ -431,6 +431,7 @@ static int rockchip_pdm_runtime_resume(struct device *dev)
 
 	ret = clk_prepare_enable(pdm->hclk);
 	if (ret) {
+		clk_disable_unprepare(pdm->clk);
 		dev_err(pdm->dev, "hclock enable failed %d\n", ret);
 		return ret;
 	}
-- 
2.35.1



