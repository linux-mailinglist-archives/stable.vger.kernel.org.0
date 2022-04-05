Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 744074F2C36
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245099AbiDEIyC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241112AbiDEIct (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BD3015A03;
        Tue,  5 Apr 2022 01:27:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38AA6609D0;
        Tue,  5 Apr 2022 08:27:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BABEC385A1;
        Tue,  5 Apr 2022 08:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147266;
        bh=EnA4E1E6YC+Ts/nEjs3dxfm5+HpqhwGpXCsmYHQ1Iew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YKV1F5fsYRU6H1/K6SZdhwv1GxZBiBSjaDfMfyOClbOOgJfm6lbEXOypuqEx0YO4n
         P9z/6ma/GP5Ba9kywAOkF1FFVnnNip/GEW7crJLB4v8HzLGeoaxtMQGbjtD3K2gioN
         EiUiostJJZZO+qHC5is1gbbsMcz+BAEoCiMYp90c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Meng Tang <tangmeng@uniontech.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.17 1045/1126] ASoC: rockchip: i2s_tdm: Fixup config for SND_SOC_DAIFMT_DSP_A/B
Date:   Tue,  5 Apr 2022 09:29:52 +0200
Message-Id: <20220405070438.145487194@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Meng Tang <tangmeng@uniontech.com>

commit 2f45a4e2897793cc6ae25f5fe78b485ce7fd01d0 upstream.

SND_SOC_DAIFMT_DSP_A: PCM delay 1 bit mode, L data MSB after FRM LRC
SND_SOC_DAIFMT_DSP_B: PCM no delay mode, L data MSB during FRM LRC

Fixes: 081068fd64140 (ASoC: rockchip: add support for i2s-tdm controller)

Signed-off-by: Meng Tang <tangmeng@uniontech.com>
Link: https://lore.kernel.org/r/20220318100146.23991-1-tangmeng@uniontech.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/rockchip/rockchip_i2s_tdm.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/sound/soc/rockchip/rockchip_i2s_tdm.c
+++ b/sound/soc/rockchip/rockchip_i2s_tdm.c
@@ -469,14 +469,14 @@ static int rockchip_i2s_tdm_set_fmt(stru
 		txcr_val = I2S_TXCR_IBM_NORMAL;
 		rxcr_val = I2S_RXCR_IBM_NORMAL;
 		break;
-	case SND_SOC_DAIFMT_DSP_A: /* PCM no delay mode */
-		txcr_val = I2S_TXCR_TFS_PCM;
-		rxcr_val = I2S_RXCR_TFS_PCM;
-		break;
-	case SND_SOC_DAIFMT_DSP_B: /* PCM delay 1 mode */
+	case SND_SOC_DAIFMT_DSP_A: /* PCM delay 1 mode */
 		txcr_val = I2S_TXCR_TFS_PCM | I2S_TXCR_PBM_MODE(1);
 		rxcr_val = I2S_RXCR_TFS_PCM | I2S_RXCR_PBM_MODE(1);
 		break;
+	case SND_SOC_DAIFMT_DSP_B: /* PCM no delay mode */
+		txcr_val = I2S_TXCR_TFS_PCM;
+		rxcr_val = I2S_RXCR_TFS_PCM;
+		break;
 	default:
 		ret = -EINVAL;
 		goto err_pm_put;


