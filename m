Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69D104F2CB7
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344038AbiDEJQ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245018AbiDEIxB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:53:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F1F2CDF;
        Tue,  5 Apr 2022 01:49:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E8FD60FFB;
        Tue,  5 Apr 2022 08:49:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 535D7C385A0;
        Tue,  5 Apr 2022 08:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148570;
        bh=Liju10TvGCS1yQDNFGGcvBTeSq06ruBprmwSCYMZRYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vvo/h3MPq33t4ZN875IksOgkIwK2DE5PKw8DDqxfvS7szd9SmTur82N2ObwbXRIcl
         WSDD/7RPFCndQaPDo7CQaTwcuNlwxd0+u1ddOh+s7OSAsnnimoruv2LECxBjq5NlYe
         H4VhtfNzh+szGZ+EP+Nz7i0vXmOJUoC798SxbnUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Fabio Estevam <festevam@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0386/1017] ASoC: fsl_spdif: Disable TX clock when stop
Date:   Tue,  5 Apr 2022 09:21:39 +0200
Message-Id: <20220405070405.743458114@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 6ddf611219ba8f7c8fa0d26b39710a641e7d37a5 ]

The TX clock source may be changed in next case, need to
disable it when stop, otherwise the TX may not work after
changing the clock source, error log is:

aplay: pcm_write:2058: write error: Input/output error

Fixes: a2388a498ad2 ("ASoC: fsl: Add S/PDIF CPU DAI driver")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Link: https://lore.kernel.org/r/1646879863-27711-1-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_spdif.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/fsl/fsl_spdif.c b/sound/soc/fsl/fsl_spdif.c
index d178b479c8bd..06d4a014f296 100644
--- a/sound/soc/fsl/fsl_spdif.c
+++ b/sound/soc/fsl/fsl_spdif.c
@@ -610,6 +610,8 @@ static void fsl_spdif_shutdown(struct snd_pcm_substream *substream,
 		mask = SCR_TXFIFO_AUTOSYNC_MASK | SCR_TXFIFO_CTRL_MASK |
 			SCR_TXSEL_MASK | SCR_USRC_SEL_MASK |
 			SCR_TXFIFO_FSEL_MASK;
+		/* Disable TX clock */
+		regmap_update_bits(regmap, REG_SPDIF_STC, STC_TXCLK_ALL_EN_MASK, 0);
 	} else {
 		scr = SCR_RXFIFO_OFF | SCR_RXFIFO_CTL_ZERO;
 		mask = SCR_RXFIFO_FSEL_MASK | SCR_RXFIFO_AUTOSYNC_MASK|
-- 
2.34.1



