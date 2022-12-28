Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1436579A2
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233395AbiL1PDR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:03:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233442AbiL1PDL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:03:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2370412AFE
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:03:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDDF861541
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:03:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B32EC433EF;
        Wed, 28 Dec 2022 15:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239788;
        bh=Ve7Gt19B41ulMObmLoJP1Zw1apIg7+STq8HY4gTukfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yTB7b/wlG7/770Rinb4SSfiUwzYw/Sq+M00fesY2jHoSgUQzwp7zTfZg8GWpYPf3Z
         1+xqpWf6KiUWTPzH7ieY4+Ibo1wt9iJrJK3w0VgLEx5vs+piTQNul5vh4+d0Pn0Oeq
         cj1pFUn1DLJHCfz+osVTgiAQSF8ZYPCazn8ljH+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0043/1146] arm64: dts: renesas: r9a09g011: Fix I2C SoC specific strings
Date:   Wed, 28 Dec 2022 15:26:22 +0100
Message-Id: <20221228144331.333322460@linuxfoundation.org>
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

From: Fabrizio Castro <fabrizio.castro.jz@renesas.com>

[ Upstream commit 2ac909916b520df09a23f152bb9016d7b892b496 ]

The preferred form for Renesas' compatible strings is:
"<vendor>,<family>-<module>"

Somehow the compatible string for the r9a09g011 I2C IP was upstreamed
as renesas,i2c-r9a09g011 instead of renesas,r9a09g011-i2c, which
is really confusing, especially considering the generic fallback
is renesas,rzv2m-i2c.

The first user of renesas,i2c-r9a09g011 in the kernel is not yet in
a kernel release, it will be in v6.1, therefore it can still be
fixed in v6.1.
Even if we don't fix it before v6.2, I don't think there is any
harm in making such a change.

s/renesas,i2c-r9a09g011/renesas,r9a09g011-i2c/g for consistency.

Fixes: 54ac6794df9d ("arm64: dts: renesas: r9a09g011: Add i2c nodes")
Signed-off-by: Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Link: https://lore.kernel.org/r/20221107165027.54150-3-fabrizio.castro.jz@renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r9a09g011.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/r9a09g011.dtsi b/arch/arm64/boot/dts/renesas/r9a09g011.dtsi
index 0e72a66f8e3a..ebaa8cdd747d 100644
--- a/arch/arm64/boot/dts/renesas/r9a09g011.dtsi
+++ b/arch/arm64/boot/dts/renesas/r9a09g011.dtsi
@@ -126,7 +126,7 @@ cpg: clock-controller@a3500000 {
 		i2c0: i2c@a4030000 {
 			#address-cells = <1>;
 			#size-cells = <0>;
-			compatible = "renesas,i2c-r9a09g011", "renesas,rzv2m-i2c";
+			compatible = "renesas,r9a09g011-i2c", "renesas,rzv2m-i2c";
 			reg = <0 0xa4030000 0 0x80>;
 			interrupts = <GIC_SPI 232 IRQ_TYPE_EDGE_RISING>,
 				     <GIC_SPI 236 IRQ_TYPE_EDGE_RISING>;
@@ -140,7 +140,7 @@ i2c0: i2c@a4030000 {
 		i2c2: i2c@a4030100 {
 			#address-cells = <1>;
 			#size-cells = <0>;
-			compatible = "renesas,i2c-r9a09g011", "renesas,rzv2m-i2c";
+			compatible = "renesas,r9a09g011-i2c", "renesas,rzv2m-i2c";
 			reg = <0 0xa4030100 0 0x80>;
 			interrupts = <GIC_SPI 234 IRQ_TYPE_EDGE_RISING>,
 				     <GIC_SPI 238 IRQ_TYPE_EDGE_RISING>;
-- 
2.35.1



