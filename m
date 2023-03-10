Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6DB6B4853
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233664AbjCJPB0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:01:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233663AbjCJPBF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:01:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6271220A7
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:54:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29661B8231F
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E3C7C4339C;
        Fri, 10 Mar 2023 14:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460023;
        bh=OsTvTladaaV6kytI5+x/CU4Kp+1XIzI4wSRH++SDxak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SH9Ymx1n7Yo5v4Y1qlAk+JbVbfAup6F78jTHb3DpnICBeK86+GDe/yKGXOilr4tAS
         q3MOSBOOmsCVkfEIBydvwA1ZSsBhh2N609/0mnMp/1Bw+8V01sjnnVDockxkxgYe1O
         hAicB1gybQGutO5DiifiCrbCh5l0nVbByMhRa2PE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 198/529] ASoC: mchp-spdifrx: Fix uninitialized use of mr in mchp_spdifrx_hw_params()
Date:   Fri, 10 Mar 2023 14:35:41 +0100
Message-Id: <20230310133814.174300157@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 218674a45930c700486d27b765bf2f1b43f8cbf7 ]

Clang warns:

  ../sound/soc/atmel/mchp-spdifrx.c:455:3: error: variable 'mr' is uninitialized when used here [-Werror,-Wuninitialized]
                  mr |= SPDIFRX_MR_ENDIAN_BIG;
                  ^~
  ../sound/soc/atmel/mchp-spdifrx.c:432:8: note: initialize the variable 'mr' to silence this warning
          u32 mr;
                ^
                 = 0
  1 error generated.

Zero initialize mr so that these bitwise OR and assignment operation
works unconditionally.

Fixes: fa09fa60385a ("ASoC: mchp-spdifrx: fix controls which rely on rsr register")
Link: https://github.com/ClangBuiltLinux/linux/issues/1797
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20230202-mchp-spdifrx-fix-uninit-mr-v1-1-629a045d7a2f@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/atmel/mchp-spdifrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/atmel/mchp-spdifrx.c b/sound/soc/atmel/mchp-spdifrx.c
index 03b7037239b85..39a3c2a33bdbb 100644
--- a/sound/soc/atmel/mchp-spdifrx.c
+++ b/sound/soc/atmel/mchp-spdifrx.c
@@ -362,7 +362,7 @@ static int mchp_spdifrx_hw_params(struct snd_pcm_substream *substream,
 				  struct snd_soc_dai *dai)
 {
 	struct mchp_spdifrx_dev *dev = snd_soc_dai_get_drvdata(dai);
-	u32 mr;
+	u32 mr = 0;
 	int ret;
 
 	dev_dbg(dev->dev, "%s() rate=%u format=%#x width=%u channels=%u\n",
-- 
2.39.2



