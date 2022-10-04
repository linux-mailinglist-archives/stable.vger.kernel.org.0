Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 309695F4756
	for <lists+stable@lfdr.de>; Tue,  4 Oct 2022 18:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbiJDQR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Oct 2022 12:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiJDQR1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Oct 2022 12:17:27 -0400
X-Greylist: delayed 1200 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 04 Oct 2022 09:17:26 PDT
Received: from uho.ysoft.cz (uho.ysoft.cz [81.19.3.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77BC95A8B3
        for <stable@vger.kernel.org>; Tue,  4 Oct 2022 09:17:26 -0700 (PDT)
Received: from vokac-Latitude-7410.ysoft.local (unknown [10.1.8.111])
        by uho.ysoft.cz (Postfix) with ESMTP id 20435A042B;
        Tue,  4 Oct 2022 17:40:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ysoft.com;
        s=20160406-ysoft-com; t=1664898027;
        bh=i9PnxML2126tErWZLbzvJMO++0lET7Udk97r6lwj1NY=;
        h=From:To:Cc:Subject:Date:From;
        b=M4FBZUpJafUb+eJ24wfxuU2UfA/BIx/eDfRtKsNfgmZbg3/TKc+TH89UXza/gVk5i
         mIrDBzs6UFY5r1g6351zz4YrFfRH5uMZLRIonH9PtJxKhkfwMU+wu/xTGg1BOVvxKZ
         TCW+qvi2iBRcDHAv6OOYRqp2+OEVzSsI707b/XTQ=
From:   Petr Benes <petr.benes@ysoft.com>
To:     Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Petr Benes <petr.benes@ysoft.com>, petrben@gmail.com,
        stable@vger.kernel.org,
        =?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <michal.vokac@ysoft.com>
Subject: [PATCH] ARM: dts: imx6dl-yapp4: Do not allow PM to switch PU regulator off on Q/QP
Date:   Tue,  4 Oct 2022 17:39:20 +0200
Message-Id: <20221004153920.104984-1-petr.benes@ysoft.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix our design flaw in supply voltage distribution on the Quad and QuadPlus
based boards.

The problem is that we supply the SoC cache (VDD_CACHE_CAP) from VDD_PU
instead of VDD_SOC. The VDD_PU internal regulator can be disabled by PM
if VPU or GPU is not used. If that happens the system freezes. To prevent
that configure the reg_pu regulator to be always on.

Fixes: 0de4ab81ab26 ("ARM: dts: imx6dl-yapp4: Add Y Soft IOTA Crux/Crux+ board")
Cc: petrben@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Petr Benes <petr.benes@ysoft.com>
Signed-off-by: Michal Vokáč <michal.vokac@ysoft.com>
---
 arch/arm/boot/dts/imx6q-yapp4-crux.dts       | 4 ++++
 arch/arm/boot/dts/imx6qp-yapp4-crux-plus.dts | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/imx6q-yapp4-crux.dts b/arch/arm/boot/dts/imx6q-yapp4-crux.dts
index deb18c57cf18..22f647eb12e7 100644
--- a/arch/arm/boot/dts/imx6q-yapp4-crux.dts
+++ b/arch/arm/boot/dts/imx6q-yapp4-crux.dts
@@ -45,6 +45,10 @@ &oled_1309 {
 	status = "okay";
 };
 
+&reg_pu {
+	regulator-always-on;
+};
+
 &reg_usb_h1_vbus {
 	status = "okay";
 };
diff --git a/arch/arm/boot/dts/imx6qp-yapp4-crux-plus.dts b/arch/arm/boot/dts/imx6qp-yapp4-crux-plus.dts
index a450a77f920f..b580ce891f7e 100644
--- a/arch/arm/boot/dts/imx6qp-yapp4-crux-plus.dts
+++ b/arch/arm/boot/dts/imx6qp-yapp4-crux-plus.dts
@@ -45,6 +45,10 @@ &oled_1309 {
 	status = "okay";
 };
 
+&reg_pu {
+	regulator-always-on;
+};
+
 &reg_usb_h1_vbus {
 	status = "okay";
 };
-- 
2.25.1

