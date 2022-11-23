Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81964635856
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235959AbiKWJzY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:55:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236959AbiKWJyR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:54:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB4E1086
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:50:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F186AB81EF8
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 078B3C433D6;
        Wed, 23 Nov 2022 09:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197019;
        bh=sCpNoTGyv398Ucy8XEQTwDpKYllRSmpL3JdM5Ws7Azw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l+F1O+7VwTY+zrEAE9EvnVgkTt0fk1m+j7gNXcLilaRK+2EuY8GD6km0ZSnRDfLXs
         F3BXoYjVxlrLz0bHbEOIuTpHAxo9zTVdnWN0hfBtl7DCCy16WwFr0BY1y+ZCs7KV6b
         n8gmjUno9XJs85T9/9LKQq4mQfvEExAWbYvqj8iw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marek Vasut <marex@denx.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 135/314] arm64: dts: imx8mn: Fix NAND controller size-cells
Date:   Wed, 23 Nov 2022 09:49:40 +0100
Message-Id: <20221123084631.652001065@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

From: Marek Vasut <marex@denx.de>

[ Upstream commit 5468e93b5b1083eaa729f98e59da18c85d9c4126 ]

The NAND controller size-cells should be 0 per DT bindings.
Fix the following warning produces by DT bindings check:
"
nand-controller@33002000: #size-cells:0:0: 0 was expected
nand-controller@33002000: Unevaluated properties are not allowed ('#address-cells', '#size-cells' were unexpected)
"

Fixes: 6c3debcbae47a ("arm64: dts: freescale: Add i.MX8MN dtsi support")
Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mn.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mn.dtsi b/arch/arm64/boot/dts/freescale/imx8mn.dtsi
index ad0b99adf691..67b554ba690c 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mn.dtsi
@@ -1102,7 +1102,7 @@ dma_apbh: dma-controller@33000000 {
 		gpmi: nand-controller@33002000 {
 			compatible = "fsl,imx8mn-gpmi-nand", "fsl,imx7d-gpmi-nand";
 			#address-cells = <1>;
-			#size-cells = <1>;
+			#size-cells = <0>;
 			reg = <0x33002000 0x2000>, <0x33004000 0x4000>;
 			reg-names = "gpmi-nand", "bch";
 			interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
-- 
2.35.1



