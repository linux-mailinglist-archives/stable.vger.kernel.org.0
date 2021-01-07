Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30D122EC9D6
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 06:08:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbhAGFHI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 00:07:08 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:13366 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726051AbhAGFHH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 00:07:07 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff696d30000>; Wed, 06 Jan 2021 21:06:27 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 7 Jan
 2021 05:06:26 +0000
Received: from audio.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1473.3 via Frontend
 Transport; Thu, 7 Jan 2021 05:06:24 +0000
From:   Sameer Pujar <spujar@nvidia.com>
To:     <thierry.reding@gmail.com>, <robh+dt@kernel.org>
CC:     <jonathanh@nvidia.com>, <devicetree@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Sameer Pujar <spujar@nvidia.com>, <stable@vger.kernel.org>
Subject: [PATCH] arm64: tegra: Add power-domain for Tegra210 HDA
Date:   Thu, 7 Jan 2021 10:36:10 +0530
Message-ID: <1609995970-12256-1-git-send-email-spujar@nvidia.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1609995987; bh=t8ctQ0xfU/UJdQS/7XQux5m6y8DB4xnSoWfObOddjrM=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Type;
        b=Xgt2NewP12LlsMekKGON5NTmYOsNnFgHBatUDhVlwPiCgL3/Ch7GOX8MylhRBNJ5E
         nkZozKvJsx4R0VDtMhrYwD2aXHGB0plClg43e5DX5c8amhaufXuU7iASBmqTLEWmdk
         MgCdrchSjmYJseZQXWoQPTOQ30TmFJFzajW5uJsCcVC0BCc162CVrITWFrheI2atsN
         kTKVRbQPLIFLjzfKD9ZUqxErBw2h6go2qMj/6HXuAaXrqai5a1adQyy8vvgC1yQjIC
         rJMUNHGLcN2ogLB8WfxDL4gmKbZrtpBkguv+EffFYm9MM99GsWhzrzE/JGJBTkSdnE
         mfOexJmjuCSMA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

HDA initialization is failing occasionally on Tegra210 and following
print is observed in the boot log. Because of this probe() fails and
no sound card is registered.

  [16.800802] tegra-hda 70030000.hda: no codecs found!

Codecs request a state change and enumeration by the controller. In
failure cases this does not seem to happen as STATETS register reads 0.

The problem seems to be related to the HDA codec dependency on SOR
power domain. If it is gated during HDA probe then the failure is
observed. Building Tegra HDA driver into kernel image avoids this
failure but does not completely address the dependency part. Fix this
problem by adding 'power-domains' DT property for Tegra210 HDA. Note
that Tegra186 and Tegra194 HDA do this already.

Fixes: 742af7e7a0a1 ("arm64: tegra: Add Tegra210 support")
Depends-on: 96d1f078ff0 ("arm64: tegra: Add SOR power-domain for Tegra210")
Cc: <stable@vger.kernel.org>
Signed-off-by: Sameer Pujar <spujar@nvidia.com>
---
 arch/arm64/boot/dts/nvidia/tegra210.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/nvidia/tegra210.dtsi b/arch/arm64/boot/dts/nvidia/tegra210.dtsi
index 4fbf8c1..fd33b4d 100644
--- a/arch/arm64/boot/dts/nvidia/tegra210.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra210.dtsi
@@ -997,6 +997,7 @@
 			 <&tegra_car 128>, /* hda2hdmi */
 			 <&tegra_car 111>; /* hda2codec_2x */
 		reset-names = "hda", "hda2hdmi", "hda2codec_2x";
+		power-domains = <&pd_sor>;
 		status = "disabled";
 	};
 
-- 
2.7.4

