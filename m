Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B24C6AE81A
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbjCGRNH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:13:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbjCGRMi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:12:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86615658D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:07:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11C9BB819A9
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 418D3C4339C;
        Tue,  7 Mar 2023 17:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678208854;
        bh=XA2DiHAmw3FOR4VNGeje9AHmZHj0EfxjBTOTP0tzwSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VBnTO7QMXQ1G3OHGJD38+K4Siflr5KAOvMzwdFm2WBpxA/VNkv6Ka5fCtjY+UIht9
         JQmVDNPoVeJ+jJDqxDcgtqGa7V9p3d+FYmicisbC2ewD6MRv8gcz3xKZXA8b11tL6s
         35wI9KQTU+KVWS7t1jKpesFUpl++zWA6neFIOLuc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen-Yu Tsai <wenst@chromium.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0032/1001] arm64: dts: mediatek: mt8186: Fix systimer 13 MHz clock description
Date:   Tue,  7 Mar 2023 17:46:44 +0100
Message-Id: <20230307170023.518932037@linuxfoundation.org>
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

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit b391efba57ff085233d5ead5e01817bf4b71d999 ]

The systimer block derives its 13 MHz clock by dividing the main 26 MHz
oscillator clock by 2 internally. The 13 MHz clock is not a separate
oscillator.

Fix this by making the 13 MHz clock a divide-by-2 fixed factor clock,
taking its input from the main 26 MHz oscillator.

Fixes: 2e78620b1350 ("arm64: dts: Add MediaTek MT8186 dts and evaluation board and Makefile")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20221201084229.3464449-5-wenst@chromium.org
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8186.dtsi | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8186.dtsi b/arch/arm64/boot/dts/mediatek/mt8186.dtsi
index c326aeb33a109..857b0c22422f4 100644
--- a/arch/arm64/boot/dts/mediatek/mt8186.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8186.dtsi
@@ -214,10 +214,12 @@ l3_0: l3-cache {
 		};
 	};
 
-	clk13m: oscillator-13m {
-		compatible = "fixed-clock";
+	clk13m: fixed-factor-clock-13m {
+		compatible = "fixed-factor-clock";
 		#clock-cells = <0>;
-		clock-frequency = <13000000>;
+		clocks = <&clk26m>;
+		clock-div = <2>;
+		clock-mult = <1>;
 		clock-output-names = "clk13m";
 	};
 
-- 
2.39.2



