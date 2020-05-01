Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 755D41C0ED4
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 09:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbgEAH20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 03:28:26 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:1347 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgEAH20 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 May 2020 03:28:26 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5eabcf8d0000>; Fri, 01 May 2020 00:28:13 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 01 May 2020 00:28:25 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 01 May 2020 00:28:25 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 1 May
 2020 07:28:25 +0000
Received: from hqnvemgw03.nvidia.com (10.124.88.68) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Fri, 1 May 2020 07:28:25 +0000
Received: from moonraker.nvidia.com (Not Verified[10.26.73.165]) by hqnvemgw03.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5eabcf980000>; Fri, 01 May 2020 00:28:25 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Thierry Reding <thierry.reding@gmail.com>
CC:     <devicetree@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Peter Robinson <pbrobinson@redhat.com>,
        Jon Hunter <jonathanh@nvidia.com>, <stable@vger.kernel.org>
Subject: [PATCH] arm64: tegra: Fix ethernet phy-mode for Jetson Xavier
Date:   Fri, 1 May 2020 08:27:56 +0100
Message-ID: <20200501072756.25348-1-jonathanh@nvidia.com>
X-Mailer: git-send-email 2.17.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1588318093; bh=d+dYuOUYYG3jFlbXdN72xXUr16sgw2ePdUeUPoMzbSo=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         X-NVConfidentiality:MIME-Version:Content-Type;
        b=jaB3BsEDf3Fc0WN6kwJrPRalITORiFw8jh6J6ICTotAIsVMyxupddkxZxvK2bpOpK
         dw771EHWsja2buZgJ1YGA4ZmleyqFnlXDrl/r6f/yyEoBYvTDJEBlggHz1zyZ2cCSe
         AemmvCRR7KOLMYq9AUpQSVz5u8zuQVezob0pIQjVZRZ1FxjXbiDILaI5mFrAnRzpg9
         IxzEPnPtX6nAMz/IM5oCiUpUCSRwSLtIQtyvQMeOgCbeINMsGMg3AuPYxohlF1QqkZ
         fRZWpiuhT4RclVX+ga7roOMUpumX0hmQPA61LmkPwdd373pOsGjBOPZWwZ9GCoq1mT
         EXSJdwyKZLJvQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The 'phy-mode' property is currently defined as 'rgmii' for Jetson
Xavier. This indicates that the RGMII RX and TX delays are set by the
MAC and the internal delays set by the PHY are not used.

If the Marvell PHY driver is enabled, such that it is used and not the
generic PHY, ethernet failures are seen (DHCP is failing to obtain an
IP address) and this is caused because the Marvell PHY driver is
disabling the internal RX and TX delays. For Jetson Xavier the internal
PHY RX and TX delay should be used and so fix this by setting the
'phy-mode' to 'rgmii-id' and not 'rgmii'.

Cc: stable@vger.kernel.org

Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
---
 arch/arm64/boot/dts/nvidia/tegra194-p2888.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra194-p2888.dtsi b/arch/arm64/boot/dts/nvidia/tegra194-p2888.dtsi
index 623f7d7d216b..8e3136dfdd62 100644
--- a/arch/arm64/boot/dts/nvidia/tegra194-p2888.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra194-p2888.dtsi
@@ -33,7 +33,7 @@
 
 			phy-reset-gpios = <&gpio TEGRA194_MAIN_GPIO(G, 5) GPIO_ACTIVE_LOW>;
 			phy-handle = <&phy>;
-			phy-mode = "rgmii";
+			phy-mode = "rgmii-id";
 
 			mdio {
 				#address-cells = <1>;
-- 
2.17.1

