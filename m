Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6221680FA4
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 14:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbjA3Nzb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 08:55:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236448AbjA3Nza (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 08:55:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00B939B88
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 05:55:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A656B81158
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:55:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A26C433D2;
        Mon, 30 Jan 2023 13:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675086925;
        bh=LvMSBPai/U8bmO1UpRwsvsA3+jxjAdM6uJT5h9PaInU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hN1lJDHG51RdPoWkUCU3PC4BXvQqyEkJ93jPoIdfZhnFMmAHRORHingegtwFmiBNn
         21lDXOCV30EO5lstnxPhuQeNyZCWL28AUxLXpjKQlBsfiAfdIWViH6qOnMii4pKiYy
         2/cdEqMPNuw3nga57N4zB//jEF++jRhgVx910bT0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Emanuele Ghidoli <emanuele.ghidoli@toradex.com>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 012/313] arm64: dts: verdin-imx8mm: fix dahlia audio playback
Date:   Mon, 30 Jan 2023 14:47:27 +0100
Message-Id: <20230130134337.236151157@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Emanuele Ghidoli <emanuele.ghidoli@toradex.com>

[ Upstream commit 0d1d030f00f3f3eea04017cbd50ffe44a2842ebc ]

Set optional `simple-audio-card,mclk-fs` parameter to ensure a proper
clock to the wm8904 audio codec. Without this change with an audio
stream rate of 44.1 kHz the playback is completely distorted.

Fixes: 6a57f224f734 ("arm64: dts: freescale: add initial support for verdin imx8m mini")
Signed-off-by: Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-verdin-dahlia.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-verdin-dahlia.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-verdin-dahlia.dtsi
index c2a5c2f7b204..7c3f5c54f040 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-verdin-dahlia.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-verdin-dahlia.dtsi
@@ -9,6 +9,7 @@ sound_card: sound-card {
 		simple-audio-card,bitclock-master = <&dailink_master>;
 		simple-audio-card,format = "i2s";
 		simple-audio-card,frame-master = <&dailink_master>;
+		simple-audio-card,mclk-fs = <256>;
 		simple-audio-card,name = "imx8mm-wm8904";
 		simple-audio-card,routing =
 			"Headphone Jack", "HPOUTL",
-- 
2.39.0



