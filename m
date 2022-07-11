Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC52A56FB70
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbiGKJam (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:30:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232845AbiGKJ3p (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:29:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2652709AE;
        Mon, 11 Jul 2022 02:16:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0892761226;
        Mon, 11 Jul 2022 09:16:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1615AC34115;
        Mon, 11 Jul 2022 09:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530994;
        bh=QjqgyLl0/S8E7GIf56Ex+JLVKwqnCTDYX7/NdJD+5yM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NUZuuIg/nGYZISMVaBmzESg0b27klzZflcUs99P7kLUbdXcA4f2QKlF1pQONZzrGg
         ZJu/2kMGSEOzoyBYCN3fPQJ+w++HfMHDIavSNzb4WujHZS/LqwqYbqLaYd1VnpyRiE
         BFiRT+vMo4QDcS73oxlNcrLHMfqGP91elxjARbO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haibo Chen <haibo.chen@nxp.com>,
        Sherry Sun <sherry.sun@nxp.com>, Peng Fan <peng.fan@nxp.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 058/112] arm64: dts: imx8mp-evk: correct the uart2 pinctl value
Date:   Mon, 11 Jul 2022 11:06:58 +0200
Message-Id: <20220711090551.219419939@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Sherry Sun <sherry.sun@nxp.com>

[ Upstream commit 2d4fb72b681205eed4553d8802632bd3270be3ba ]

According to the IOMUXC_SW_PAD_CTL_PAD_UART2_RXD/TXD register define in
imx8mp RM, bit0 and bit3 are reserved, and the uart2 rx/tx pin should
enable the pull up, so need to set bit8 to 1. The original pinctl value
0x49 is incorrect and needs to be changed to 0x140, same as uart1 and
uart3.

Fixes: 9e847693c6f3 ("arm64: dts: freescale: Add i.MX8MP EVK board support")
Reviewed-by: Haibo Chen <haibo.chen@nxp.com>
Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-evk.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-evk.dts b/arch/arm64/boot/dts/freescale/imx8mp-evk.dts
index f31cf778890d..4ba31fc5d0a5 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-evk.dts
@@ -506,8 +506,8 @@
 
 	pinctrl_uart2: uart2grp {
 		fsl,pins = <
-			MX8MP_IOMUXC_UART2_RXD__UART2_DCE_RX	0x49
-			MX8MP_IOMUXC_UART2_TXD__UART2_DCE_TX	0x49
+			MX8MP_IOMUXC_UART2_RXD__UART2_DCE_RX	0x140
+			MX8MP_IOMUXC_UART2_TXD__UART2_DCE_TX	0x140
 		>;
 	};
 
-- 
2.35.1



