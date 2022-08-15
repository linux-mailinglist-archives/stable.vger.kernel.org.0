Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B403B59391D
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243431AbiHOSdM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243419AbiHOSc1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:32:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D5CB33A3B;
        Mon, 15 Aug 2022 11:21:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D663F60EF0;
        Mon, 15 Aug 2022 18:21:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E851EC433D6;
        Mon, 15 Aug 2022 18:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587694;
        bh=S2ObVKAk2Czmdwa90vDdbeK7xcB/HLGSbOYkdyJRyPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GamRk8ksFtHBWDKJ1l35/pmBLHrEltief518zVJo1ULUfotoe8fSOG4FyfG/IsrRy
         B/Jjrhqi0FAPThfLttjeqpJs0Ct3l9qyZYxo84E+E6T1CgRUazfznfvUc+/6AI/Z9o
         vHRKfYgkaLKJ6AFPabz/lA9ak/DmN73ZmmcLp+v0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 166/779] arm64: dts: renesas: Fix thermal-sensors on single-zone sensors
Date:   Mon, 15 Aug 2022 19:56:50 +0200
Message-Id: <20220815180344.417750555@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 62e8a53431145e06e503b71625a34eaa87b72b2c ]

"make dtbs_check":

    arch/arm64/boot/dts/renesas/r8a774c0-cat874.dtb: thermal-zones: cpu-thermal:thermal-sensors: [[74], [0]] is too long
    arch/arm64/boot/dts/renesas/r8a774c0-ek874.dtb: thermal-zones: cpu-thermal:thermal-sensors: [[79], [0]] is too long
    arch/arm64/boot/dts/renesas/r8a774c0-ek874-idk-2121wr.dtb: thermal-zones: cpu-thermal:thermal-sensors: [[82], [0]] is too long
    arch/arm64/boot/dts/renesas/r8a774c0-ek874-mipi-2.1.dtb: thermal-zones: cpu-thermal:thermal-sensors: [[87], [0]] is too long
    arch/arm64/boot/dts/renesas/r8a77990-ebisu.dtb: thermal-zones: cpu-thermal:thermal-sensors: [[105], [0]] is too long
	    From schema: Documentation/devicetree/bindings/thermal/thermal-zones.yaml

Indeed, the thermal sensors on R-Car E3 and RZ/G2E support only a single
zone, hence #thermal-sensor-cells = <0>.

Fix this by dropping the bogus zero cell from the thermal sensor
specifiers.

Fixes: 8fa7d18f9ee2dc20 ("arm64: dts: renesas: r8a77990: Create thermal zone to support IPA")
Fixes: 8438bfda9d768157 ("arm64: dts: renesas: r8a774c0: Create thermal zone to support IPA")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Link: https://lore.kernel.org/r/28b812fdd1fc3698311fac984ab8b91d3d655c1c.1655301684.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a774c0.dtsi | 2 +-
 arch/arm64/boot/dts/renesas/r8a77990.dtsi | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/r8a774c0.dtsi b/arch/arm64/boot/dts/renesas/r8a774c0.dtsi
index d597772c4c37..9eb08be3b98e 100644
--- a/arch/arm64/boot/dts/renesas/r8a774c0.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a774c0.dtsi
@@ -1953,7 +1953,7 @@ thermal-zones {
 		cpu-thermal {
 			polling-delay-passive = <250>;
 			polling-delay = <0>;
-			thermal-sensors = <&thermal 0>;
+			thermal-sensors = <&thermal>;
 			sustainable-power = <717>;
 
 			cooling-maps {
diff --git a/arch/arm64/boot/dts/renesas/r8a77990.dtsi b/arch/arm64/boot/dts/renesas/r8a77990.dtsi
index 0ea300a8147d..9e616b0f04d4 100644
--- a/arch/arm64/boot/dts/renesas/r8a77990.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77990.dtsi
@@ -2102,7 +2102,7 @@ thermal-zones {
 		cpu-thermal {
 			polling-delay-passive = <250>;
 			polling-delay = <0>;
-			thermal-sensors = <&thermal 0>;
+			thermal-sensors = <&thermal>;
 			sustainable-power = <717>;
 
 			cooling-maps {
-- 
2.35.1



