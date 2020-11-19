Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9999A2B8A54
	for <lists+stable@lfdr.de>; Thu, 19 Nov 2020 04:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbgKSDHf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 22:07:35 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:4437 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726235AbgKSDHe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Nov 2020 22:07:34 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb5e16c0001>; Wed, 18 Nov 2020 19:07:24 -0800
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 19 Nov
 2020 03:07:34 +0000
Received: from jckuo-lt.nvidia.com (10.124.1.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1473.3 via Frontend
 Transport; Thu, 19 Nov 2020 03:07:32 +0000
From:   JC Kuo <jckuo@nvidia.com>
To:     <gregkh@linuxfoundation.org>, <thierry.reding@gmail.com>,
        <jonathanh@nvidia.com>, <robh+dt@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <stable@vger.kernel.org>,
        JC Kuo <jckuo@nvidia.com>
Subject: [PATCH v2] arm64: tegra: jetson-tx1: Fix USB_VBUS_EN0 regulator
Date:   Thu, 19 Nov 2020 11:07:29 +0800
Message-ID: <20201119030729.111333-1-jckuo@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605755244; bh=UwRlc1vc1TaW7C81NSQX3kT87+p+ogagD6Bjdv/PkR0=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         X-NVConfidentiality:Content-Transfer-Encoding:Content-Type;
        b=fJpaC5Xbp8OOkJ5waNL5CJbfMEj7pWT68N/d7ylwX4fKATWvIhDk5PsmHbTRqUG2o
         Ml/Y8wX5GObHuwwaCRo4hc4IXsmnWUioCJ3+7F4NvXpbzets5xpynzD3kGX6q3jJ4H
         yePV6Dd3OvPPm3sJWRXSmSfFgNAhi+aUjSam7+N02Ix8burtg2ucuzgshJxYhGVzyZ
         qj/+KxQD+Mmbr+obEJgWfkbguMzCZwr2Pi3f4YyBstrsMGQiEiQVHYjkScyNknNdaU
         T8N4tYpJrZdqfMKmwb5+7PHKU4yX9pHByDFdbhpa1NOmZhYKAyNV4RHZiFUIOpXmkZ
         OKaJZPrtTd4og==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

USB_VBUS_EN0 regulator (regulator@11) is being overwritten by vdd-cam-1v2
regulator. This commit rearrange USB_VBUS_EN0 to be regulator@14.

Fixes: 257c8047be44 ("arm64: tegra: jetson-tx1: Add camera supplies")
Signed-off-by: JC Kuo <jckuo@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
---
v2:
    add 'Fixes:' tag
    add Reviewed-by: Jon Hunter <jonathanh@nvidia.com>

 .../arm64/boot/dts/nvidia/tegra210-p2597.dtsi | 20 +++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi b/arch/arm64/bo=
ot/dts/nvidia/tegra210-p2597.dtsi
index e18e1a9a3011..a9caaf7c0d67 100644
--- a/arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi
@@ -1663,16 +1663,6 @@ vdd_usb_vbus: regulator@9 {
 		vin-supply =3D <&vdd_5v0_sys>;
 	};
=20
-	vdd_usb_vbus_otg: regulator@11 {
-		compatible =3D "regulator-fixed";
-		regulator-name =3D "USB_VBUS_EN0";
-		regulator-min-microvolt =3D <5000000>;
-		regulator-max-microvolt =3D <5000000>;
-		gpio =3D <&gpio TEGRA_GPIO(CC, 4) GPIO_ACTIVE_HIGH>;
-		enable-active-high;
-		vin-supply =3D <&vdd_5v0_sys>;
-	};
-
 	vdd_hdmi: regulator@10 {
 		compatible =3D "regulator-fixed";
 		regulator-name =3D "VDD_HDMI_5V0";
@@ -1712,4 +1702,14 @@ vdd_cam_1v8: regulator@13 {
 		enable-active-high;
 		vin-supply =3D <&vdd_3v3_sys>;
 	};
+
+	vdd_usb_vbus_otg: regulator@14 {
+		compatible =3D "regulator-fixed";
+		regulator-name =3D "USB_VBUS_EN0";
+		regulator-min-microvolt =3D <5000000>;
+		regulator-max-microvolt =3D <5000000>;
+		gpio =3D <&gpio TEGRA_GPIO(CC, 4) GPIO_ACTIVE_HIGH>;
+		enable-active-high;
+		vin-supply =3D <&vdd_5v0_sys>;
+	};
 };
--=20
2.25.1

