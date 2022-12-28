Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69F31657988
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233435AbiL1PCv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:02:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233456AbiL1PCY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:02:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B702C1263D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:02:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52CEB61541
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:02:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D91DC433EF;
        Wed, 28 Dec 2022 15:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239719;
        bh=ysZfnA5mNSD8NEl09JBPcRMr0a04SdU+IXJUC3p/Xn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=imi4S9/OEbylrUArRvGRLYZKmAQ5c9c/6khlcnBiYm6YnqKZAUUNgsQscG5FBrs/h
         UDVl7RaUaSv2UoM+8OZW8brDfN3FYpxJaA6DSd5wQAvApd+p8x25ExT1ItpvIgDpIz
         W6KV8NdcXs27bWe0VJut3R6vDjUrkT0Uf81gToRw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0031/1146] arm64: dts: qcom: msm8996: fix sound card reset line polarity
Date:   Wed, 28 Dec 2022 15:26:10 +0100
Message-Id: <20221228144331.014852125@linuxfoundation.org>
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

[ Upstream commit 76d21ffc5d425bf7ea9888652c49d7dbda15f356 ]

When resetting the block, the reset line is being driven low and then
high, which means that the line in DTS should be annotated as "active
low". It will become important when wcd9335 driver will be converted
to gpiod API that respects declared line polarities.

Fixes: f3eb39a55a1f ("arm64: dts: db820c: Add sound card support")
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221027074652.1044235-1-dmitry.torokhov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8996.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8996.dtsi b/arch/arm64/boot/dts/qcom/msm8996.dtsi
index 67f0167dfda2..1107befc3b09 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -3362,7 +3362,7 @@ wcd9335: codec@1{
 					interrupt-names = "intr1", "intr2";
 					interrupt-controller;
 					#interrupt-cells = <1>;
-					reset-gpios = <&tlmm 64 GPIO_ACTIVE_HIGH>;
+					reset-gpios = <&tlmm 64 GPIO_ACTIVE_LOW>;
 
 					slim-ifc-dev = <&tasha_ifd>;
 
-- 
2.35.1



