Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3A8756FDBE
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 12:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234151AbiGKJ75 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234386AbiGKJ72 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:59:28 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 243F5643E2;
        Mon, 11 Jul 2022 02:27:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1C9F7CE1267;
        Mon, 11 Jul 2022 09:27:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05B50C34115;
        Mon, 11 Jul 2022 09:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531659;
        bh=pvAUyeDuhA9Doy3U65eCiwgeQOavBWcDdXsmnMt2JGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lN5uGUmdiKxegNotZ2X8eaJHxX6fPRvXF0IHN0h+6OUukshbqU+zRhRKy3bdnTVha
         wL/zktvsE8fUe9aZC41KkfZBWYjiRoLdmudZV608nC4pquA2/YyMjzZHabDCa+HKa5
         O9KCHJpXJgaJ3ATkn5NR6mgfJPMA6dvTukX1wfzM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haibo Chen <haibo.chen@nxp.com>,
        Sherry Sun <sherry.sun@nxp.com>, Peng Fan <peng.fan@nxp.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 186/230] arm64: dts: imx8mp-evk: correct the uart2 pinctl value
Date:   Mon, 11 Jul 2022 11:07:22 +0200
Message-Id: <20220711090609.384953911@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
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
index 3c4369d6468c..3f424a8937f1 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-evk.dts
@@ -383,8 +383,8 @@
 
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



