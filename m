Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 752644CF70B
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237940AbiCGJoN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:44:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239247AbiCGJj3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:39:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A76116D393;
        Mon,  7 Mar 2022 01:35:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3DAB61052;
        Mon,  7 Mar 2022 09:34:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D92C340E9;
        Mon,  7 Mar 2022 09:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645693;
        bh=75ZY1WfUHU2Io4whiLfTwywajK/W9695AyieS52ILww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mSiekGOa4+BOUjD1OYwT178EKn7gmUtF4X7+Df/DsvAkbJPY3j/CGiFjqm79fH98E
         MDTmiRZIrM/B4AqRrQY3o6dcWjlUaMAmDQGwY8XStX8Fa4Vw5zgJqtvSMq72XUDxFl
         BDLeC5tQ7Ps3KAvy9hadsn29s43RfJ/eUvE9pPDA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Norris <briannorris@chromium.org>,
        Chen-Yu Tsai <wenst@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 5.10 072/105] arm64: dts: rockchip: Switch RK3399-Gru DP to SPDIF output
Date:   Mon,  7 Mar 2022 10:19:15 +0100
Message-Id: <20220307091646.203607863@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091644.179885033@linuxfoundation.org>
References: <20220307091644.179885033@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Norris <briannorris@chromium.org>

commit b5fbaf7d779f5f02b7f75b080e7707222573be2a upstream.

Commit b18c6c3c7768 ("ASoC: rockchip: cdn-dp sound output use spdif")
switched the platform to SPDIF, but we didn't fix up the device tree.

Drop the pinctrl settings, because the 'spdif_bus' pins are either:
 * unused (on kevin, bob), so the settings is ~harmless
 * used by a different function (on scarlet), which causes probe
   failures (!!)

Fixes: b18c6c3c7768 ("ASoC: rockchip: cdn-dp sound output use spdif")
Signed-off-by: Brian Norris <briannorris@chromium.org>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://lore.kernel.org/r/20220114150129.v2.1.I46f64b00508d9dff34abe1c3e8d2defdab4ea1e5@changeid
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi
@@ -281,7 +281,7 @@
 
 	sound: sound {
 		compatible = "rockchip,rk3399-gru-sound";
-		rockchip,cpu = <&i2s0 &i2s2>;
+		rockchip,cpu = <&i2s0 &spdif>;
 	};
 };
 
@@ -432,10 +432,6 @@ ap_i2c_audio: &i2c8 {
 	status = "okay";
 };
 
-&i2s2 {
-	status = "okay";
-};
-
 &io_domains {
 	status = "okay";
 
@@ -532,6 +528,17 @@ ap_i2c_audio: &i2c8 {
 	vqmmc-supply = <&ppvar_sd_card_io>;
 };
 
+&spdif {
+	status = "okay";
+
+	/*
+	 * SPDIF is routed internally to DP; we either don't use these pins, or
+	 * mux them to something else.
+	 */
+	/delete-property/ pinctrl-0;
+	/delete-property/ pinctrl-names;
+};
+
 &spi1 {
 	status = "okay";
 


