Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0664694901
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbjBMOzO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:55:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbjBMOzO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:55:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9058F5FE0
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:55:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27DE86112F
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:55:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD52C433EF;
        Mon, 13 Feb 2023 14:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300111;
        bh=1kRjcPjUe4XEZ5PgFWV3dWVAccBlu/RFH4NF4XwDMME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uJWZygDOWMtoRAvcXm9UNmaUCH74ubKddH10ns1DyL201cMa/rKtCGzUZrQ1U0P3k
         y3PTEg9IUFLoEWjI+LsdrPFbaia6+LjIdi1YY+7Y2sXr7UkOU5wdchfpoDQTvjAl5K
         6Ie8D8Paxm/trkFYHbXRyoz/greOY6EsnZwTRysw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Fabio Estevam <festevam@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 068/114] ASoC: fsl_sai: fix getting version from VERID
Date:   Mon, 13 Feb 2023 15:48:23 +0100
Message-Id: <20230213144745.747987281@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
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

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 29aab38823b61e482995c24644bd2d8acfe56185 ]

The version information is at the bit31 ~ bit16 in the VERID
register, so need to right shift 16bit to get it, otherwise
the result of comparison "sai->verid.version >= 0x0301" is
wrong.

Fixes: 99c1e74f25d4 ("ASoC: fsl_sai: store full version instead of major/minor")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Reviewed-by: Iuliana Prodan <iuliana.prodan@nxp.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Link: https://lore.kernel.org/r/1675760664-25193-1-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_sai.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index e60c7b3445623..8205b32171495 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -1141,6 +1141,7 @@ static int fsl_sai_check_version(struct device *dev)
 
 	sai->verid.version = val &
 		(FSL_SAI_VERID_MAJOR_MASK | FSL_SAI_VERID_MINOR_MASK);
+	sai->verid.version >>= FSL_SAI_VERID_MINOR_SHIFT;
 	sai->verid.feature = val & FSL_SAI_VERID_FEATURE_MASK;
 
 	ret = regmap_read(sai->regmap, FSL_SAI_PARAM, &val);
-- 
2.39.0



