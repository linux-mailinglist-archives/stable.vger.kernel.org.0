Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 017A34F2DFF
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344765AbiDEKkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243878AbiDEJkf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:40:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF7CEBA312;
        Tue,  5 Apr 2022 02:25:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3813F61659;
        Tue,  5 Apr 2022 09:25:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 456F6C385A2;
        Tue,  5 Apr 2022 09:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150703;
        bh=kHivgI89ExcwhIzHs0s0eahszGcG5QZveN98bO2rNkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PK3+5p4+ACdA8Y85tVazSMEYCZcMDYuTUbapoBHfX0Jztvrz7t1BkMPxkpVJiV7FZ
         vODIpCWuLXL3eB93eNO9zmJIet6XBmh99RaR9OL1WqVI+JzYSg05K4s7jS4wBJ2za1
         D96QoPYLkeDOwRXHWNSgFTc/tC49O11jFUeBXmRI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH 5.15 150/913] ARM: dts: exynos: add missing HDMI supplies on SMDK5420
Date:   Tue,  5 Apr 2022 09:20:12 +0200
Message-Id: <20220405070344.333212523@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

commit 453a24ded415f7fce0499c6b0a2c7b28f84911f2 upstream.

Add required VDD supplies to HDMI block on SMDK5420.  Without them, the
HDMI driver won't probe.  Because of lack of schematics, use same
supplies as on Arndale Octa and Odroid XU3 boards (voltage matches).

Cc: <stable@vger.kernel.org> # v3.15+
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Link: https://lore.kernel.org/r/20220208171823.226211-3-krzysztof.kozlowski@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/exynos5420-smdk5420.dts |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm/boot/dts/exynos5420-smdk5420.dts
+++ b/arch/arm/boot/dts/exynos5420-smdk5420.dts
@@ -124,6 +124,9 @@
 	hpd-gpios = <&gpx3 7 GPIO_ACTIVE_HIGH>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&hdmi_hpd_irq>;
+	vdd-supply = <&ldo6_reg>;
+	vdd_osc-supply = <&ldo7_reg>;
+	vdd_pll-supply = <&ldo6_reg>;
 };
 
 &hsi2c_4 {


