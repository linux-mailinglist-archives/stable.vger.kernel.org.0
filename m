Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9AEF540B36
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349897AbiFGS1h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352522AbiFGSRP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:17:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56A09136417;
        Tue,  7 Jun 2022 10:52:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 984E2B80B66;
        Tue,  7 Jun 2022 17:52:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06602C34115;
        Tue,  7 Jun 2022 17:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624335;
        bh=uZOwd6s3kVhfsImudmQXu07CdvivTkI16naom/J1bL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hTe92qRg+aPZ48J1fZNS2MvL3ZxlDOo/tDzKaGDg7p/UaaOkwZygb2NRWeD7sEaBy
         C3ZVHr4/l/ctHBuSfgAKsk0rw5GUCNOBomuh3GXbSbLeLsPPFm/afjwOEAGYh1CUO5
         9v5eQ1BxxMrt8JuyHqZownVsof+l/4AVmmFX3QgY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Frattaroli <frattaroli.nicolas@gmail.com>,
        Katsuhiro Suzuki <katsuhiro@katsuster.net>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 263/667] ASoC: rk3328: fix disabling mclk on pclk probe failure
Date:   Tue,  7 Jun 2022 18:58:48 +0200
Message-Id: <20220607164942.670355929@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Frattaroli <frattaroli.nicolas@gmail.com>

[ Upstream commit dd508e324cdde1c06ace08a8143fa50333a90703 ]

If preparing/enabling the pclk fails, the probe function should
unprepare and disable the previously prepared and enabled mclk,
which it doesn't do. This commit rectifies this.

Fixes: c32759035ad2 ("ASoC: rockchip: support ACODEC for rk3328")
Signed-off-by: Nicolas Frattaroli <frattaroli.nicolas@gmail.com>
Reviewed-by: Katsuhiro Suzuki <katsuhiro@katsuster.net>
Link: https://lore.kernel.org/r/20220427172310.138638-1-frattaroli.nicolas@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rk3328_codec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rk3328_codec.c b/sound/soc/codecs/rk3328_codec.c
index 758d439e8c7a..86b679cf7aef 100644
--- a/sound/soc/codecs/rk3328_codec.c
+++ b/sound/soc/codecs/rk3328_codec.c
@@ -481,7 +481,7 @@ static int rk3328_platform_probe(struct platform_device *pdev)
 	ret = clk_prepare_enable(rk3328->pclk);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to enable acodec pclk\n");
-		return ret;
+		goto err_unprepare_mclk;
 	}
 
 	base = devm_platform_ioremap_resource(pdev, 0);
-- 
2.35.1



