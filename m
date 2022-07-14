Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 509D25742C0
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235469AbiGNE0S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234728AbiGNEZ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:25:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 059012AC56;
        Wed, 13 Jul 2022 21:23:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 678B0B82371;
        Thu, 14 Jul 2022 04:23:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D49FCC34115;
        Thu, 14 Jul 2022 04:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772606;
        bh=mlyiupWzoaqCGlzd2A4M2PlghwEdsgGXG2cqiizqiTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VHw/NmvbylW3ufXSvh3DZvn4SONR4q3JEYy4V/uLV+X2iXXjXGPlXExjlU2I2qOXj
         Bjm8D9yN8SLNphyr2Wp5ZLwr3REN+DXmK7+QZhbwIJpemfiziDnALOVisRhTiojoHR
         i9Oa2A+7Vut3i5IbcJ4YL377nMpFOIviwqTsm/wa7bZMnGJguuTm771YlKhaP09VKh
         JIbCvCZu6HrbJnGgmp7q94ECk6clll2QzITVNybVTQrWf4TmyfvjvggZEVeP6zoRoL
         G3S3UvPLq0bole5wLl0D/7q0Hk3PVBVbHQECLz8otziMbHZgprVaVVkgWMUiw/ZicH
         nrugbjT2SUnwQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jacky Bai <ping.bai@nxp.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, aisheng.dong@nxp.com,
        festevam@gmail.com, shawnguo@kernel.org, stefan@agner.ch,
        linux-gpio@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.18 27/41] pinctrl: imx: Add the zero base flag for imx93
Date:   Thu, 14 Jul 2022 00:22:07 -0400
Message-Id: <20220714042221.281187-27-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714042221.281187-1-sashal@kernel.org>
References: <20220714042221.281187-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacky Bai <ping.bai@nxp.com>

[ Upstream commit fbc24ebc65507feb9728dc38197f90486148dda0 ]

On i.MX93, the pin mux reg offset is from 0x0,
so need to add the 'ZERO_OFFSET_VALID' flag to make
sure the pin at mux offset 0 can be found.

Signed-off-by: Jacky Bai <ping.bai@nxp.com>
Link: https://lore.kernel.org/r/20220613031854.1571357-1-ping.bai@nxp.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/freescale/pinctrl-imx93.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/freescale/pinctrl-imx93.c b/drivers/pinctrl/freescale/pinctrl-imx93.c
index c0630f69e995..417e41b37a6f 100644
--- a/drivers/pinctrl/freescale/pinctrl-imx93.c
+++ b/drivers/pinctrl/freescale/pinctrl-imx93.c
@@ -239,6 +239,7 @@ static const struct pinctrl_pin_desc imx93_pinctrl_pads[] = {
 static const struct imx_pinctrl_soc_info imx93_pinctrl_info = {
 	.pins = imx93_pinctrl_pads,
 	.npins = ARRAY_SIZE(imx93_pinctrl_pads),
+	.flags = ZERO_OFFSET_VALID,
 	.gpr_compatible = "fsl,imx93-iomuxc-gpr",
 };
 
-- 
2.35.1

