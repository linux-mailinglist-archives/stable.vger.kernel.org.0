Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD4271D39F3
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 20:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728616AbgENSxO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 14:53:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:52248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728613AbgENSxO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 14:53:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 184FA20675;
        Thu, 14 May 2020 18:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482393;
        bh=BDIu2FHOYFJWjlD0EAagGTHSDPr1k1bPMbv1Wek1FPQ=;
        h=From:To:Cc:Subject:Date:From;
        b=k5s8uSJr3ZyvwISmDZyR0EO82mLLM9zb4tE9ldEYdlPi/VHSXuygLI4k0KNEUhCA7
         MFhhL7YdoLNcODpFiW5rLfL/+McvWkDFdnrdFM208+1T+bU86kDtmzPsJXVMaVxV0B
         3WEr+UvAg2/fIi0+GIFfS+Vq+ehfk9DNGHkfnoOQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 01/49] kbuild: avoid concurrency issue in parallel building dtbs and dtbs_check
Date:   Thu, 14 May 2020 14:52:22 -0400
Message-Id: <20200514185311.20294-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit b5154bf63e5577faaaca1d942df274f7de91dd2a ]

'make dtbs_check' checks the shecma in addition to building *.dtb files,
in other words, 'make dtbs_check' is a super-set of 'make dtbs'.
So, you do not have to do 'make dtbs dtbs_check', but I want to keep
the build system as robust as possible in any use.

Currently, 'dtbs' and 'dtbs_check' are independent of each other.
In parallel building, two threads descend into arch/*/boot/dts/,
one for dtbs and the other for dtbs_check, then end up with building
the same DTB simultaneously.

This commit fixes the concurrency issue. Otherwise, I see build errors
like follows:

$ make ARCH=arm64 defconfig
$ make -j16 ARCH=arm64 DT_SCHEMA_FILES=Documentation/devicetree/bindings/arm/psci.yaml dtbs dtbs_check
  <snip>
  DTC     arch/arm64/boot/dts/qcom/sdm845-cheza-r2.dtb
  DTC     arch/arm64/boot/dts/amlogic/meson-gxl-s905x-p212.dtb
  DTC     arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-lite2.dtb
  DTC     arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-lite2.dtb
  DTC     arch/arm64/boot/dts/freescale/imx8mn-evk.dtb
  DTC     arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-one-plus.dtb
  DTC     arch/arm64/boot/dts/zte/zx296718-pcbox.dtb
  DTC     arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dt.yaml
  DTC     arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p230.dtb
  DTC     arch/arm64/boot/dts/xilinx/zynqmp-zc1254-revA.dtb
  DTC     arch/arm64/boot/dts/allwinner/sun50i-h6-pine-h64.dtb
  DTC     arch/arm64/boot/dts/rockchip/rk3399-gru-scarlet-inx.dtb
  DTC     arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-one-plus.dtb
  CHECK   arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dt.yaml
fixdep: error opening file: arch/arm64/boot/dts/allwinner/.sun50i-h6-orangepi-lite2.dtb.d: No such file or directory
make[2]: *** [scripts/Makefile.lib:296: arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-lite2.dtb] Error 2
make[2]: *** Deleting file 'arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-lite2.dtb'
make[2]: *** Waiting for unfinished jobs....
  DTC     arch/arm64/boot/dts/rockchip/rk3399-gru-scarlet-kd.dtb
  DTC     arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p231.dtb
  DTC     arch/arm64/boot/dts/xilinx/zynqmp-zc1275-revA.dtb
  DTC     arch/arm64/boot/dts/freescale/imx8mn-ddr4-evk.dtb
fixdep: parse error; no targets found
make[2]: *** [scripts/Makefile.lib:296: arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-one-plus.dtb] Error 1
make[2]: *** Deleting file 'arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-one-plus.dtb'
make[1]: *** [scripts/Makefile.build:505: arch/arm64/boot/dts/allwinner] Error 2
make[1]: *** Waiting for unfinished jobs....
  DTC     arch/arm64/boot/dts/renesas/r8a77951-salvator-xs.dtb

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index a8c772b299aa8..54dd58bc60712 100644
--- a/Makefile
+++ b/Makefile
@@ -1238,11 +1238,15 @@ ifneq ($(dtstree),)
 	$(Q)$(MAKE) $(build)=$(dtstree) $(dtstree)/$@
 
 PHONY += dtbs dtbs_install dtbs_check
-dtbs dtbs_check: include/config/kernel.release scripts_dtc
+dtbs: include/config/kernel.release scripts_dtc
 	$(Q)$(MAKE) $(build)=$(dtstree)
 
+ifneq ($(filter dtbs_check, $(MAKECMDGOALS)),)
+dtbs: dt_binding_check
+endif
+
 dtbs_check: export CHECK_DTBS=1
-dtbs_check: dt_binding_check
+dtbs_check: dtbs
 
 dtbs_install:
 	$(Q)$(MAKE) $(dtbinst)=$(dtstree)
-- 
2.20.1

