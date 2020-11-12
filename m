Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85FD62B052C
	for <lists+stable@lfdr.de>; Thu, 12 Nov 2020 13:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727762AbgKLMwP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Nov 2020 07:52:15 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:1158 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727223AbgKLMwP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Nov 2020 07:52:15 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fad2ff90000>; Thu, 12 Nov 2020 04:52:09 -0800
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 12 Nov
 2020 12:52:14 +0000
Received: from moonraker.nvidia.com (10.124.1.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1473.3 via Frontend
 Transport; Thu, 12 Nov 2020 12:52:13 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC:     <devicetree@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Jon Hunter <jonathanh@nvidia.com>,
        <stable@vger.kernel.org>
Subject: [PATCH V2] ARM: tegra: Populate OPP table for Tegra20 Ventana
Date:   Thu, 12 Nov 2020 12:52:10 +0000
Message-ID: <20201112125210.214517-1-jonathanh@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605185529; bh=aUrF7mTyktNQ/LBkcSGmc6+2uSxejCTBWAPuhk1LS7U=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         X-NVConfidentiality:Content-Transfer-Encoding:Content-Type;
        b=oU4bKU7TkhZrj5fkR5hnqStyziypBOn+zoYfIgJTjmr7Lh72NEwx6nlSCFgZJU+Ki
         72Xn8yTFCyKm1wlYD85pAWHIyzaGwxPGLUfBYZqjSFGM/6XlEKyIaFQ2a35E1vmYB+
         5xVqxj8pC8pJ681maWMvsZ4zBGjah7mBGx4/FFINdfaIfWZFMsgD+PhQG8OD6cg1W8
         KRsUsj/XsTKylV6BEXAuUyJeT+FMsomLvYQvLnSNRe1WT829IO/whqQGw6UCkdGN/w
         mWiYgd1KfL47xBc+yCH2Kxw6Tcyg/4k3kF2UtHu8RzQBxo4AqkBwo+sbiCV9+mEkjK
         he3ZTTD9V1ITw==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 9ce274630495 ("cpufreq: tegra20: Use generic cpufreq-dt driver
(Tegra30 supported now)") update the Tegra20 CPUFREQ driver to use the
generic CPUFREQ device-tree driver. Since this change CPUFREQ support
on the Tegra20 Ventana platform has been broken because the necessary
device-tree nodes with the operating point information are not populated
for this platform. Fix this by updating device-tree for Venata to
include the operating point informration for Tegra20.

Fixes: 9ce274630495 ("cpufreq: tegra20: Use generic cpufreq-dt driver (Tegr=
a30 supported now)")
Cc: stable@vger.kernel.org

Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
---
Changes since V1:
- Remove unneeded 'cpu0' phandle

 arch/arm/boot/dts/tegra20-ventana.dts | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/tegra20-ventana.dts b/arch/arm/boot/dts/tegr=
a20-ventana.dts
index b158771ac0b7..1b2a0dcd929a 100644
--- a/arch/arm/boot/dts/tegra20-ventana.dts
+++ b/arch/arm/boot/dts/tegra20-ventana.dts
@@ -3,6 +3,7 @@
=20
 #include <dt-bindings/input/input.h>
 #include "tegra20.dtsi"
+#include "tegra20-cpu-opp.dtsi"
=20
 / {
 	model =3D "NVIDIA Tegra20 Ventana evaluation board";
@@ -592,6 +593,16 @@ clk32k_in: clock@0 {
 		#clock-cells =3D <0>;
 	};
=20
+	cpus {
+		cpu@0 {
+			operating-points-v2 =3D <&cpu0_opp_table>;
+		};
+
+		cpu@1 {
+			operating-points-v2 =3D <&cpu0_opp_table>;
+		};
+	};
+
 	gpio-keys {
 		compatible =3D "gpio-keys";
=20
--=20
2.25.1

