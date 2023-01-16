Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0439D66C72F
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233176AbjAPQ3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:29:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232889AbjAPQ2R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:28:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83EF42D14B
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:16:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E242B81063
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:16:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D52C433EF;
        Mon, 16 Jan 2023 16:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885797;
        bh=QR6MxQrldUdDWMfrKT93GGo/bMaTZQ2jwrNxGnVBOgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VatgKX+dCls3tV/tV+8LhTHzRmE7wTN/8pZjcwa50A9aVdjVPa4TTh4ZTwS0wizMD
         EbH3MKz1d5/L0QHB5StEg8bPJiU3U1lA1fuS/y1cRQlCfn/mWoDJ7lP7oLIJ4OT88T
         L90aiR6NmLiglFyIVUuJKF4eNjjzF1fglxJcHbAI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 158/658] ASoC: dt-bindings: wcd9335: fix reset line polarity in example
Date:   Mon, 16 Jan 2023 16:44:06 +0100
Message-Id: <20230116154916.680567237@linuxfoundation.org>
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



