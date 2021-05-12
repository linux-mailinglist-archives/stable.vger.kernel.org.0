Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1646B37C646
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237349AbhELPuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:50:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:35404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234495AbhELPo0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:44:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30DF761C91;
        Wed, 12 May 2021 15:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832966;
        bh=2J2tAljGL2+9zc0rl1Dv+X0Z9uN04ywIMMzBgFEg4c0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OzhQG5S0zZzj1nOQlOIRthWHRMug0y0MWy/hZn9kFwk6yM5G+VLmh3XxD4CcytynG
         SpmODuT5JCz4j4bswbNcCJiffLXr9++QqRSu2VI63g+UCWziqpyRKiIPtxnxWDiOaF
         SxT9ybIkcGMDaiNt/RWAoSkTg+ZdsiD3MrU9Qcts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 496/530] ARM: dts: uniphier: Change phy-mode to RGMII-ID to enable delay pins for RTL8211E
Date:   Wed, 12 May 2021 16:50:06 +0200
Message-Id: <20210512144836.064438025@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
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
index b0b15c97306b..e81e5937a60a 100644
--- a/arch/arm/boot/dts/uniphier-pxs2.dtsi
+++ b/arch/arm/boot/dts/uniphier-pxs2.dtsi
@@ -583,7 +583,7 @@
 			clocks = <&sys_clk 6>;
 			reset-names = "ether";
 			resets = <&sys_rst 6>;
-			phy-mode = "rgmii";
+			phy-mode = "rgmii-id";
 			local-mac-address = [00 00 00 00 00 00];
 			socionext,syscon-phy-mode = <&soc_glue 0>;
 
-- 
2.30.2



