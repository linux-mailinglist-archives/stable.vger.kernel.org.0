Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFC56895E6
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233451AbjBCKYE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:24:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233468AbjBCKXt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:23:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7876EBD
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:23:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A418B82A5F
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:23:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA98FC433D2;
        Fri,  3 Feb 2023 10:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419791;
        bh=SzU9FuLsCn/aY8nB02LZNgXGlSYllkTHp+y8BzaUhQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZpnNrVzKCL/2peudXZUt2UTKmoNOxxwqPrRti9snZ52AoNuwHGMBCxnUgm+myj5Of
         svx4bc9tnyyjj76hRWhtm1xiqPT1wQ6VfVumwKbMf4gYlfhO1l+iz3lRWSbNq8mq3r
         jSO7kw0A4S38ofFtlLwdk0macZ0owTv5M02fF5/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 2/9] ARM: dts: vf610: Fix pca9548 i2c-mux node names
Date:   Fri,  3 Feb 2023 11:13:31 +0100
Message-Id: <20230203101006.541098443@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101006.422534094@linuxfoundation.org>
References: <20230203101006.422534094@linuxfoundation.org>
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
index 6f1e0f0d4f0a..073f5d196ca9 100644
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



