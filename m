Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC482657E6F
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233089AbiL1Pxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:53:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234078AbiL1Pxd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:53:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B76186BC
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:53:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E599E613E9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:53:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A84C433F0;
        Wed, 28 Dec 2022 15:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242812;
        bh=QR6MxQrldUdDWMfrKT93GGo/bMaTZQ2jwrNxGnVBOgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w8SenFPySVS4AIDBKboT/0lMElcAoYZuzxprh3XUbjzb8G1JriS82572cEZENpOk4
         Po628zqZs78rISWt+MvIdkPOVxrLyNtK7tgxnwj+hddgHTJDUyzjK30QsbTQJgdipV
         b2/57ip75rVlq7+ihwmU+G2BrNiHr0IylKZ6pPo8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0419/1146] ASoC: dt-bindings: wcd9335: fix reset line polarity in example
Date:   Wed, 28 Dec 2022 15:32:38 +0100
Message-Id: <20221228144341.553039597@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 34cb111f8a7b98b5fec809dd194003bca20ef1b2 ]

When resetting the block, the reset line is being driven low and then
high, which means that the line in DTS should be annotated as "active
low".

Fixes: 1877c9fda1b7 ("ASoC: dt-bindings: add dt bindings for wcd9335 audio codec")
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20221027074652.1044235-2-dmitry.torokhov@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/sound/qcom,wcd9335.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/sound/qcom,wcd9335.txt b/Documentation/devicetree/bindings/sound/qcom,wcd9335.txt
index 5d6ea66a863f..1f75feec3dec 100644
--- a/Documentation/devicetree/bindings/sound/qcom,wcd9335.txt
+++ b/Documentation/devicetree/bindings/sound/qcom,wcd9335.txt
@@ -109,7 +109,7 @@ audio-codec@1{
 	reg  = <1 0>;
 	interrupts = <&msmgpio 54 IRQ_TYPE_LEVEL_HIGH>;
 	interrupt-names = "intr2"
-	reset-gpios = <&msmgpio 64 0>;
+	reset-gpios = <&msmgpio 64 GPIO_ACTIVE_LOW>;
 	slim-ifc-dev  = <&wc9335_ifd>;
 	clock-names = "mclk", "native";
 	clocks = <&rpmcc RPM_SMD_DIV_CLK1>,
-- 
2.35.1



