Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 007266799B3
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 14:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbjAXNli (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 08:41:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232312AbjAXNlh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 08:41:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2120437B48;
        Tue, 24 Jan 2023 05:41:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD9A8611AB;
        Tue, 24 Jan 2023 13:41:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 350E2C433A1;
        Tue, 24 Jan 2023 13:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674567696;
        bh=ha6wSSidaRlk8k90MtcnTgktnMiu1qtSpWXQtQtoTg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KEKv/UiSscjplIo+1rcb42V4ZeoeXmfNc9Lvw3tr9N60cdm3zxLGQmV05KC3HlauH
         xWgkxMOCFxHvpXA9FglbZWKTifSYYqWdDhf8vcEzX973pBMvnWqdJKb9aypb20tTGq
         x2iJvycVCSRh9VkiIzmb9To9HM9Bs0Z8bsfW4qP1EVqdRPAcfAWTpbWX5XkZfaL9e/
         EEIlbZmJ0/dCQWAGMPQJ1DX2keN75+L1o/5COstYMmq9HJi7TYidqIVngBBflyBxbT
         110vDtFdGhDxD9L3RDfwk1tpFLrBEbEiutLhxeqtTrFnHfjL9Wt0Zlx05ReyU+JSis
         LgeQWTaKohaMA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 02/35] ARM: dts: vf610: Fix pca9548 i2c-mux node names
Date:   Tue, 24 Jan 2023 08:40:58 -0500
Message-Id: <20230124134131.637036-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230124134131.637036-1-sashal@kernel.org>
References: <20230124134131.637036-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 42825d1f269355d63554ab3c3762611e4d8053e9 ]

"make dtbs_check":

    arch/arm/boot/dts/vf610-zii-dev-rev-b.dtb: tca9548@70: $nodename:0: 'tca9548@70' does not match '^(i2c-?)?mux'
	    From schema: Documentation/devicetree/bindings/i2c/i2c-mux-pca954x.yaml
    arch/arm/boot/dts/vf610-zii-dev-rev-b.dtb: tca9548@70: Unevaluated properties are not allowed ('#address-cells', '#size-cells', 'i2c@0', 'i2c@1', 'i2c@2', 'i2c@3', 'i2c@4' were unexpected)
	    From schema: /scratch/geert/linux/linux-renesas/Documentation/devicetree/bindings/i2c/i2c-mux-pca954x.yaml
    ...

Fix this by renaming PCA9548 nodes to "i2c-mux", to match the I2C bus
multiplexer/switch DT bindings and the Generic Names Recommendation in
the Devicetree Specification.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/vf610-zii-dev-rev-b.dts | 2 +-
 arch/arm/boot/dts/vf610-zii-dev-rev-c.dts | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts b/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts
index 42ed4a04a12e..6280c5e86a12 100644
--- a/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts
+++ b/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts
@@ -345,7 +345,7 @@ gpio6: io-expander@22 {
 };
 
 &i2c2 {
-	tca9548@70 {
+	i2c-mux@70 {
 		compatible = "nxp,pca9548";
 		pinctrl-0 = <&pinctrl_i2c_mux_reset>;
 		pinctrl-names = "default";
diff --git a/arch/arm/boot/dts/vf610-zii-dev-rev-c.dts b/arch/arm/boot/dts/vf610-zii-dev-rev-c.dts
index de79dcfd32e6..ba2001f37315 100644
--- a/arch/arm/boot/dts/vf610-zii-dev-rev-c.dts
+++ b/arch/arm/boot/dts/vf610-zii-dev-rev-c.dts
@@ -340,7 +340,7 @@ eeprom@50 {
 };
 
 &i2c2 {
-	tca9548@70 {
+	i2c-mux@70 {
 		compatible = "nxp,pca9548";
 		pinctrl-0 = <&pinctrl_i2c_mux_reset>;
 		pinctrl-names = "default";
-- 
2.39.0

