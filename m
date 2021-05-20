Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E162938A469
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234630AbhETKFi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:05:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:37298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235067AbhETKB4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:01:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8ED48613C9;
        Thu, 20 May 2021 09:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503584;
        bh=2eHnlKvy8jXTTvz7gkTic+rXRunp3W2Ece+LmUP8Z6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tZx6a36TgA3YNxO/Bz5QhRDMOG3mrPoMlqFXkasUCBeFOHRIBaJf1KWKxE+WfivTC
         l5oT+8I9iyFLhbrdkCxjjYRKmD1FybH+4iD3EJexpNNplOg/dNzrznmHV/szYXJ4LV
         bs3yIoniqnnrx53TtYYL6rHmdr3PDxeEMXKSjn4Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 286/425] ARM: dts: uniphier: Change phy-mode to RGMII-ID to enable delay pins for RTL8211E
Date:   Thu, 20 May 2021 11:20:55 +0200
Message-Id: <20210520092140.843333493@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

[ Upstream commit 9ba585cc5b56ea14a453ba6be9bdb984ed33471a ]

UniPhier PXs2 boards have RTL8211E ethernet phy, and the phy have the RX/TX
delays of RGMII interface using pull-ups on the RXDLY and TXDLY pins.

After the commit bbc4d71d6354 ("net: phy: realtek: fix rtl8211e rx/tx
delay config"), the delays are working correctly, however, "rgmii" means
no delay and the phy doesn't work. So need to set the phy-mode to
"rgmii-id" to show that RX/TX delays are enabled.

Fixes: e3cc931921d2 ("ARM: dts: uniphier: add AVE ethernet node")
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/uniphier-pxs2.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/uniphier-pxs2.dtsi b/arch/arm/boot/dts/uniphier-pxs2.dtsi
index e2d1a22c5950..d8a32104aad0 100644
--- a/arch/arm/boot/dts/uniphier-pxs2.dtsi
+++ b/arch/arm/boot/dts/uniphier-pxs2.dtsi
@@ -513,7 +513,7 @@
 			clocks = <&sys_clk 6>;
 			reset-names = "ether";
 			resets = <&sys_rst 6>;
-			phy-mode = "rgmii";
+			phy-mode = "rgmii-id";
 			local-mac-address = [00 00 00 00 00 00];
 			socionext,syscon-phy-mode = <&soc_glue 0>;
 
-- 
2.30.2



