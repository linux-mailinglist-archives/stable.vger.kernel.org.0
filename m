Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D785657928
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233216AbiL1O6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:58:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233322AbiL1O6N (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:58:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD5E12D04
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:58:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5411B81710
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:58:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23A6DC433D2;
        Wed, 28 Dec 2022 14:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239482;
        bh=gAmBoqw4wbX+MYP/T9RGg4IOrRl8Kem9L1L7oGTJ7uo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qhh5wFiCJF4EaH5vBPDyPW9VGN+LWk0meHn+MSvdalTNLNrVGgvDhaZf5uZzmgARG
         7TIYvL7g150N+8LlcEDJRiasp4rfmwN7zoj9PvDTiXFzSFF3zojTla+1hlqvqyM3P+
         1IPhNxLjkjMzGuaLvw0gCqXeat9UZCFmRq+O1MT0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0037/1073] arm64: dts: qcom: sm8250-mtp: fix reset line polarity
Date:   Wed, 28 Dec 2022 15:27:05 +0100
Message-Id: <20221228144329.139732500@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

[ Upstream commit 15d9fcbb3e6e8420c7d1ae331405780c5d9c1c25 ]

The driver for the codec, when resetting the chip, first drives the line
low, and then high. This means that the line is active low. Change the
annotation in the DTS accordingly.

Fixes: 36c9d012f193 ("arm64: dts: qcom: use GPIO flags for tlmm")
Fixes: 5a263cf629a8 ("arm64: dts: qcom: sm8250-mtp: Add wcd9380 audio codec node")
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221027074652.1044235-3-dmitry.torokhov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250-mtp.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8250-mtp.dts b/arch/arm64/boot/dts/qcom/sm8250-mtp.dts
index a102aa5efa32..a05fe468e0b4 100644
--- a/arch/arm64/boot/dts/qcom/sm8250-mtp.dts
+++ b/arch/arm64/boot/dts/qcom/sm8250-mtp.dts
@@ -635,7 +635,7 @@ &soc {
 	wcd938x: codec {
 		compatible = "qcom,wcd9380-codec";
 		#sound-dai-cells = <1>;
-		reset-gpios = <&tlmm 32 GPIO_ACTIVE_HIGH>;
+		reset-gpios = <&tlmm 32 GPIO_ACTIVE_LOW>;
 		vdd-buck-supply = <&vreg_s4a_1p8>;
 		vdd-rxtx-supply = <&vreg_s4a_1p8>;
 		vdd-io-supply = <&vreg_s4a_1p8>;
-- 
2.35.1



