Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2A5D56FDF7
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 12:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234474AbiGKKCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 06:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234455AbiGKKCY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 06:02:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC973B7D7;
        Mon, 11 Jul 2022 02:28:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05ABF612E8;
        Mon, 11 Jul 2022 09:28:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14485C34115;
        Mon, 11 Jul 2022 09:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531723;
        bh=hd3BvXFtrDlYs7GBArIMajBN6rCnoaaFqeDLoOJf8pw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c45vFQ16/U6zNSG0VAzN/tfQX+gexhb05fPQKEtqGm9kPfFoaU/tdwtXWzxWNF54L
         csJqRPT+xt19lnNt+4nezszcOHjIcxuPgM45cfeZgmeT+X2qxL3bwQnczfrCNqb01A
         dY2xJ5l+G1Zxu9TVfTfVIx6InCU0uKE4Wz25hqO0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Amelie Delaunay <amelie.delaunay@foss.st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 207/230] ARM: dts: stm32: use usbphyc ck_usbo_48m as USBH OHCI clock on stm32mp151
Date:   Mon, 11 Jul 2022 11:07:43 +0200
Message-Id: <20220711090609.975961001@linuxfoundation.org>
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

From: Amelie Delaunay <amelie.delaunay@foss.st.com>

[ Upstream commit db7be2cb87ae65e2d033a9f61f7fb94bce505177 ]

Referring to the note under USBH reset and clocks chapter of RM0436,
"In order to access USBH_OHCI registers it is necessary to activate the USB
clocks by enabling the PLL controlled by USBPHYC" (ck_usbo_48m).

The point is, when USBPHYC PLL is not enabled, OHCI register access
freezes the resume from STANDBY. It is the case when dual USBH is enabled,
instead of OTG + single USBH.
When OTG is probed, as ck_usbo_48m is USBO clock parent, then USBPHYC PLL
is enabled and OHCI register access is OK.

This patch adds ck_usbo_48m (provided by USBPHYC PLL) as clock of USBH
OHCI, thus USBPHYC PLL will be enabled and OHCI register access will be OK.

Signed-off-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp151.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/stm32mp151.dtsi b/arch/arm/boot/dts/stm32mp151.dtsi
index 6992a4b0ba79..f693a7d24247 100644
--- a/arch/arm/boot/dts/stm32mp151.dtsi
+++ b/arch/arm/boot/dts/stm32mp151.dtsi
@@ -1452,7 +1452,7 @@
 		usbh_ohci: usb@5800c000 {
 			compatible = "generic-ohci";
 			reg = <0x5800c000 0x1000>;
-			clocks = <&rcc USBH>;
+			clocks = <&rcc USBH>, <&usbphyc>;
 			resets = <&rcc USBH_R>;
 			interrupts = <GIC_SPI 74 IRQ_TYPE_LEVEL_HIGH>;
 			status = "disabled";
-- 
2.35.1



