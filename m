Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80CA64D8436
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241658AbiCNMXX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241775AbiCNMSX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:18:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44197FD22;
        Mon, 14 Mar 2022 05:12:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7482F61380;
        Mon, 14 Mar 2022 12:12:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD21C340E9;
        Mon, 14 Mar 2022 12:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259977;
        bh=P9K/h8KMbQZRQi1PXI9ISur1J4HQLQ4E1D9sSKqTb14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q3wWq1wnHrThv3GOt8n8bz0LEYNbaIrNsbF/eip9NuWBwBskyIL9hK6rdL0XYy9cS
         WwLm4vEaDQoZhizmfF9HcAE9VACEH1dg2XzHJtJwXRRxi8gXEwCGBkrOqejGEixL/a
         zb+BU1HkBFBe6+snk1Uv6dF4VdS1AAcQ9NKrbjVg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 005/121] ARM: boot: dts: bcm2711: Fix HVS register range
Date:   Mon, 14 Mar 2022 12:53:08 +0100
Message-Id: <20220314112744.275113530@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
References: <20220314112744.120491875@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 515415d316168c6521d74ea8280287e28d7303e6 ]

While the HVS has the same context memory size in the BCM2711 than in
the previous SoCs, the range allocated to the registers doubled and it
now takes 16k + 16k, compared to 8k + 16k before.

The KMS driver will use the whole context RAM though, eventually
resulting in a pointer dereference error when we access the higher half
of the context memory since it hasn't been mapped.

Fixes: 4564363351e2 ("ARM: dts: bcm2711: Enable the display pipeline")
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm2711.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/bcm2711.dtsi b/arch/arm/boot/dts/bcm2711.dtsi
index dff18fc9a906..21294f775a20 100644
--- a/arch/arm/boot/dts/bcm2711.dtsi
+++ b/arch/arm/boot/dts/bcm2711.dtsi
@@ -290,6 +290,7 @@ pixelvalve4: pixelvalve@7e216000 {
 
 		hvs: hvs@7e400000 {
 			compatible = "brcm,bcm2711-hvs";
+			reg = <0x7e400000 0x8000>;
 			interrupts = <GIC_SPI 97 IRQ_TYPE_LEVEL_HIGH>;
 		};
 
-- 
2.34.1



