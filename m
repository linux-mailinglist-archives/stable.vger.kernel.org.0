Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 743786AE860
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbjCGRP0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:15:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbjCGRO4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:14:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC6F94F76
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:10:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE18661508
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093CCC4339B;
        Tue,  7 Mar 2023 17:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209015;
        bh=4jnSMzRt7kAs1B2RsLrqVHzvL7Pxaz9mnNvYatVFz2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MJ+XGiGrEANrH22WKQ4Yc55Lh/TmjFgIrNWTJiy6hJBTH8yrwrn+/HCKYiqvq+xKc
         BMwiSPnBBjLEo7zJyqSxbRs8HUF5kiQeSVrBhHyGgKISnGUddWx1qOs63IPAAAiXFJ
         htUJgkow+I1bBC03clQCiIzFGgxX1pMARjWOboNk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ricardo Pardini <ricardo@pardini.net>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0083/1001] arm64: dts: amlogic: meson-sm1-odroid-hc4: fix active fan thermal trip
Date:   Tue,  7 Mar 2023 17:47:35 +0100
Message-Id: <20230307170025.697423067@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit 1d2f14117aa7773efff50f832b85fc7779e586e0 ]

Add an active trip tied to the on-board fan cooling device, which is better
than describing it along the passive cooling maps.

Fixes: 33b14f663df8 ("arm64: dts: meson: add initial device-tree for ODROID-HC4")
Reported-by: Ricardo Pardini <ricardo@pardini.net>
Link: https://lore.kernel.org/r/20230124-topic-odroid-hc4-upstream-fix-fan-trip-v1-1-b0c6aa355d93@linaro.org
Tested-by: Ricardo Pardini <ricardo@pardini.net>
[narmstrong: added Ricardo's tested-by from off-list chat]
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-sm1-odroid-hc4.dts | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-sm1-odroid-hc4.dts b/arch/arm64/boot/dts/amlogic/meson-sm1-odroid-hc4.dts
index a1f0c38ccadda..74088e7280fee 100644
--- a/arch/arm64/boot/dts/amlogic/meson-sm1-odroid-hc4.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-sm1-odroid-hc4.dts
@@ -76,9 +76,17 @@ sound {
 };
 
 &cpu_thermal {
+	trips {
+		cpu_active: cpu-active {
+			temperature = <60000>; /* millicelsius */
+			hysteresis = <2000>; /* millicelsius */
+			type = "active";
+		};
+	};
+
 	cooling-maps {
 		map {
-			trip = <&cpu_passive>;
+			trip = <&cpu_active>;
 			cooling-device = <&fan0 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
 		};
 	};
-- 
2.39.2



