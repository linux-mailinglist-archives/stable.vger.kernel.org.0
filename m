Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3545489A7
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352280AbiFMLQl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352436AbiFMLNf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:13:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E3A35AA4;
        Mon, 13 Jun 2022 03:36:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D5C8610AB;
        Mon, 13 Jun 2022 10:36:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DDCDC34114;
        Mon, 13 Jun 2022 10:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116574;
        bh=2ShDRgVQ6THU9Qg1k/cJ+lEf8jfLwnbw+QQ64SgSjEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2cpg14E5LR9TULmjkWUtEaVN0WkiMCOHJR73MUsgeRHAfYlxg5eFP0rk1UZBsE/dN
         4ecsG96j8OBur85LVOdnFKDFJDPhnAeJ26YX75/cJ2w8SR8IOwzeH4LWK0rz8ROaEQ
         H4G3PpUyFsgyJbY8JFzya9cPeFQqvAofVXE/CsD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Frattaroli <frattaroli.nicolas@gmail.com>,
        Katsuhiro Suzuki <katsuhiro@katsuster.net>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 111/411] ASoC: rk3328: fix disabling mclk on pclk probe failure
Date:   Mon, 13 Jun 2022 12:06:24 +0200
Message-Id: <20220613094932.001428315@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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
index 514ebe16bbfa..4e71ecf54af7 100644
--- a/sound/soc/codecs/rk3328_codec.c
+++ b/sound/soc/codecs/rk3328_codec.c
@@ -479,7 +479,7 @@ static int rk3328_platform_probe(struct platform_device *pdev)
 	ret = clk_prepare_enable(rk3328->pclk);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to enable acodec pclk\n");
-		return ret;
+		goto err_unprepare_mclk;
 	}
 
 	base = devm_platform_ioremap_resource(pdev, 0);
-- 
2.35.1



