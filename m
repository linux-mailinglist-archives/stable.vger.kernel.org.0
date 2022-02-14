Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95CFC4B4A1C
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347524AbiBNK3F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:29:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347305AbiBNK1m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:27:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E80419680D;
        Mon, 14 Feb 2022 01:58:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54962B80DD0;
        Mon, 14 Feb 2022 09:58:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 601E1C340E9;
        Mon, 14 Feb 2022 09:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832702;
        bh=/apOOMgqf/OTkUOcSRp5I3Rhi45H/kugQwMz+9Cmq98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EqlAhVIj/ktsNCBUDNhhSLq/CsHsf9VUtCuLvRUb30bkUdwcPWYTgXA6+8zA80gaJ
         BgH2fYZjFkphKrmanyNKX6wamXADf/0k5fM2sO84BTbzDjInjHBgSCWk4WtI3MHKXe
         sHO2hG2fslM5TQGBomkDarlNrVPJniAWLlbs2kK8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Cooper <alcooperx@gmail.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 097/203] phy: broadcom: Kconfig: Fix PHY_BRCM_USB config option
Date:   Mon, 14 Feb 2022 10:25:41 +0100
Message-Id: <20220214092513.554851385@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Cooper <alcooperx@gmail.com>

[ Upstream commit 5070ce86246a8a4ebacd0c15b121e6b6325bc167 ]

The previous commit 4b402fa8e0b7 ("phy: phy-brcm-usb: support PHY on
the BCM4908") added a second "default" line for ARCH_BCM_4908 above
the original "default" line for ARCH_BRCMSTB. When two "default"
lines are used, only the first is used and this change stopped
the PHY_BRCM_USB option for being enabled for ARCH_BRCMSTB.
The fix is to use one "default line with "||".

Fixes: 4b402fa8e0b7 ("phy: phy-brcm-usb: support PHY on the BCM4908")
Signed-off-by: Al Cooper <alcooperx@gmail.com>
Acked-by: Rafał Miłecki <rafal@milecki.pl>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20211201180653.35097-4-alcooperx@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/broadcom/Kconfig | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/phy/broadcom/Kconfig b/drivers/phy/broadcom/Kconfig
index f81e237420799..849c4204f5506 100644
--- a/drivers/phy/broadcom/Kconfig
+++ b/drivers/phy/broadcom/Kconfig
@@ -97,8 +97,7 @@ config PHY_BRCM_USB
 	depends on OF
 	select GENERIC_PHY
 	select SOC_BRCMSTB if ARCH_BRCMSTB
-	default ARCH_BCM4908
-	default ARCH_BRCMSTB
+	default ARCH_BCM4908 || ARCH_BRCMSTB
 	help
 	  Enable this to support the Broadcom STB USB PHY.
 	  This driver is required by the USB XHCI, EHCI and OHCI
-- 
2.34.1



