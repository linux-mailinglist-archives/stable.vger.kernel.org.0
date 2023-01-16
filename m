Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 419AA66C873
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233651AbjAPQjW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:39:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233616AbjAPQjB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:39:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19CB034569
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:27:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BEE15B81077
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:27:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19BCEC433EF;
        Mon, 16 Jan 2023 16:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886456;
        bh=6H2eIo0nO7m8zwKFzcZHzBExTOYRC49AvJa7aFnJYtU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1uXmkXNLFR6mOUJ8FtqvB4p8xKjnP3xzxuOKRW3bD1YkRd3InVgrdEflEJ275wHmf
         ctn5lsMT4jK8PsReCfmANvLfmk0FNzPBxsKw0yXseCH8gaXiyNX/UbZjKBMWvRUWdK
         lPrxGFQSFBEE/1TKFTLP3CH7m8E+jQrtnXCDzXVg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wang Jingjin <wangjingjin1@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 437/658] ASoC: rockchip: spdif: Add missing clk_disable_unprepare() in rk_spdif_runtime_resume()
Date:   Mon, 16 Jan 2023 16:48:45 +0100
Message-Id: <20230116154929.550865661@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index 6635145a26c4..b2b4e5b7739a 100644
--- a/sound/soc/rockchip/rockchip_spdif.c
+++ b/sound/soc/rockchip/rockchip_spdif.c
@@ -86,6 +86,7 @@ static int __maybe_unused rk_spdif_runtime_resume(struct device *dev)
 
 	ret = clk_prepare_enable(spdif->hclk);
 	if (ret) {
+		clk_disable_unprepare(spdif->mclk);
 		dev_err(spdif->dev, "hclk clock enable failed %d\n", ret);
 		return ret;
 	}
-- 
2.35.1



