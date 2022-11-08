Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6786215D6
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235287AbiKHOQB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:16:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235345AbiKHOQA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:16:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0AA0686B1
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:15:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59B1DB81ADB
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:15:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A2C3C433D6;
        Tue,  8 Nov 2022 14:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916956;
        bh=3GbL4dcmGlWKmU83u3q3YZQkedmXKpi+Ui/bhZ57wR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=irj6gSrpunGTTcDV9yJc42+3cjG24aZhAqJ5/UMRC+2mauQsy3yFlOBLFdS/rF4DJ
         1NGIQB/Dgw3VTJbcvSzzRnWSoCZCuwGZOe/ls9Ps0RHtbZ7HXzc7qj8Pi+ucm3hHtt
         +qLbpG1h3RfvvQHtFdmX/FAJv8bijHsZ5IJ9Q5Vo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, petrben@gmail.com,
        Petr Benes <petr.benes@ysoft.com>,
        =?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <michal.vokac@ysoft.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.0 155/197] ARM: dts: imx6dl-yapp4: Do not allow PM to switch PU regulator off on Q/QP
Date:   Tue,  8 Nov 2022 14:39:53 +0100
Message-Id: <20221108133401.992825285@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Benes <petr.benes@ysoft.com>

commit 5e67d47d0b010f0704aca469d6d27637b1dcb2ce upstream.

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
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/imx6q-yapp4-crux.dts       | 4 ++++
 arch/arm/boot/dts/imx6qp-yapp4-crux-plus.dts | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/imx6q-yapp4-crux.dts b/arch/arm/boot/dts/imx6q-yapp4-crux.dts
index 15f4824a5142..bddf3822ebf7 100644
--- a/arch/arm/boot/dts/imx6q-yapp4-crux.dts
+++ b/arch/arm/boot/dts/imx6q-yapp4-crux.dts
@@ -33,6 +33,10 @@ &oled_1309 {
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
index cea165f2161a..afaf4a6759d4 100644
--- a/arch/arm/boot/dts/imx6qp-yapp4-crux-plus.dts
+++ b/arch/arm/boot/dts/imx6qp-yapp4-crux-plus.dts
@@ -33,6 +33,10 @@ &oled_1309 {
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
2.38.1



