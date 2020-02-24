Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D17916A871
	for <lists+stable@lfdr.de>; Mon, 24 Feb 2020 15:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgBXOfA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Feb 2020 09:35:00 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:8373 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727803AbgBXOfA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Feb 2020 09:35:00 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e53def00000>; Mon, 24 Feb 2020 06:34:24 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Mon, 24 Feb 2020 06:34:59 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Mon, 24 Feb 2020 06:34:59 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 24 Feb
 2020 14:34:59 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 24 Feb 2020 14:34:58 +0000
Received: from thunderball.nvidia.com (Not Verified[10.21.140.91]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5e53df110000>; Mon, 24 Feb 2020 06:34:58 -0800
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Thierry Reding <thierry.reding@gmail.com>
CC:     <devicetree@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Jon Hunter <jonathanh@nvidia.com>, <stable@vger.kernel.org>
Subject: [PATCH 3/4] ARM64: tegra: Fix Tegra186 SOR supply
Date:   Mon, 24 Feb 2020 14:34:35 +0000
Message-ID: <20200224143436.5438-3-jonathanh@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200224143436.5438-1-jonathanh@nvidia.com>
References: <20200224143436.5438-1-jonathanh@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1582554864; bh=lUBb2WrI059cKuJQ/lQ6zAeA/dUVGu1GIMzWYnFLzuA=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=cDDn02CYOMd1x5bK/t7LoZ9fYn59xu8HcaGTMnsTAUfJYYkF5vUqcWjve/5PtksEv
         +bYF/ELx+KLrbyXQ4LtKHW1V8F2iDHhNR1Rrs+/MUuPuxuOXwTsaYJgLd2A/FWO54O
         men6fW7E5dJS7lmfJ050sgzZs+TABrFO/dyzOfrekczCVpqlnJEsPvdpFlBbzg125A
         ZW3sMSe1pW+54pvkCWL7YF/RFnb9zefc0feJmu0Ky+kMH2QOFPSvufzsFBxOr1bUaJ
         wqzLNTYwY6tWNy7axusq4KLKuCViERaAqSs/UlzzsrOQHJeecBOlH2GkFi8z7JASz2
         ucv0C5PUNzlTg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following warning is observed on the Jetson TX2 platform ...

 WARNING KERN tegra-sor 15540000.sor: 15540000.sor supply \
              vdd-hdmi-dp-pll not found, using dummy regulator

The problem is caused because the regulator for the SOR device is
missing the '-supply' suffix in Device-Tree. Therefore, add the
'-supply' suffix to fix this warning.

Fixes: 3fdfaf8718fa arm64: tegra: Enable DP support on Jetson TX2

Cc: <stable@vger.kernel.org>
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
---
 arch/arm64/boot/dts/nvidia/tegra186-p2771-0000.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra186-p2771-0000.dts b/arch/arm64/boot/dts/nvidia/tegra186-p2771-0000.dts
index 961b1be0c56b..1af7f9ffb7b6 100644
--- a/arch/arm64/boot/dts/nvidia/tegra186-p2771-0000.dts
+++ b/arch/arm64/boot/dts/nvidia/tegra186-p2771-0000.dts
@@ -278,7 +278,7 @@
 			status = "okay";
 
 			avdd-io-hdmi-dp-supply = <&vdd_hdmi_1v05>;
-			vdd-hdmi-dp-pll = <&vdd_1v8_ap>;
+			vdd-hdmi-dp-pll-supply = <&vdd_1v8_ap>;
 
 			nvidia,dpaux = <&dpaux>;
 		};
-- 
2.17.1

