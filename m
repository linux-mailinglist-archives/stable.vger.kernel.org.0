Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8174B4975
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345069AbiBNKEK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:04:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344762AbiBNKC6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:02:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9454C40A17;
        Mon, 14 Feb 2022 01:48:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34DA66126B;
        Mon, 14 Feb 2022 09:48:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 827D1C340E9;
        Mon, 14 Feb 2022 09:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832117;
        bh=5VH8L7tI6N2kV+EX2YOtx1QVX/xjPOomFTTF7cF4La8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b40rNQD53l+hlQqyKuw2p9o55UnFd7XkR/YCNYEDKuasxddl0Ekc4RxGcCa1SSJLM
         y9kq4eFfGtyyf1RnNLUZpGLnkADpwsVenJPpzDr3eb13BZrVwoQpNn67rc9cZ4TUIG
         V2NRSE3z2DjWQzT+3daIWU76lu3A8stp4DgadgMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Cooper <alcooperx@gmail.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 084/172] phy: broadcom: Kconfig: Fix PHY_BRCM_USB config option
Date:   Mon, 14 Feb 2022 10:25:42 +0100
Message-Id: <20220214092509.310822278@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
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
index fd92b73b71095..1dcfa3bd1442d 100644
--- a/drivers/phy/broadcom/Kconfig
+++ b/drivers/phy/broadcom/Kconfig
@@ -95,8 +95,7 @@ config PHY_BRCM_USB
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



