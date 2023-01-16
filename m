Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6F966CB5C
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234240AbjAPRNT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:13:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232648AbjAPRMj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:12:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53EAC193FA
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:52:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B45AB810A0
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:52:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57EB6C433D2;
        Mon, 16 Jan 2023 16:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887963;
        bh=NJ3egBCaytDsuzH7PX5b8qsmsCf8nLRqStSTw5U1Azc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jGOpk27POh1bWha+izk+Uym4Nw+AdJWpSSQJZjc7yfvJbozvKyCEzmCc6SPzavNjQ
         zzZVde8rYCMaP7BmOwNEVGiOC5LZsO0SaHTGGFNap4Zs3OZsY+yXjeTCx81F12ov+6
         9WLFxxcAvqJLwMTYowjAkKdwDw6qr31B3k49Joog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wang Jingjin <wangjingjin1@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 348/521] ASoC: rockchip: pdm: Add missing clk_disable_unprepare() in rockchip_pdm_runtime_resume()
Date:   Mon, 16 Jan 2023 16:50:10 +0100
Message-Id: <20230116154902.705578688@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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
index ad16c8310dd3..7dfd1e6b2c25 100644
--- a/sound/soc/rockchip/rockchip_pdm.c
+++ b/sound/soc/rockchip/rockchip_pdm.c
@@ -303,6 +303,7 @@ static int rockchip_pdm_runtime_resume(struct device *dev)
 
 	ret = clk_prepare_enable(pdm->hclk);
 	if (ret) {
+		clk_disable_unprepare(pdm->clk);
 		dev_err(pdm->dev, "hclock enable failed %d\n", ret);
 		return ret;
 	}
-- 
2.35.1



