Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6385EA321
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237677AbiIZLTp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237842AbiIZLTI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:19:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B05D252E45;
        Mon, 26 Sep 2022 03:38:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 878D2B802C7;
        Mon, 26 Sep 2022 10:36:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9FDFC433D6;
        Mon, 26 Sep 2022 10:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188605;
        bh=6tasvJ3bw1ZpODK/m7Ahrqs+W9D5eONd94fDDdQIjt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N31Bkqb8nQkyylve3xCz+Ghzuk+Jpj/1dhT9qn4Gma8kqqXCDG+B4Mw0t6soQfI1R
         n+TDd0iCYHki59eG8z9NJOggkfi27uaAkv45CGr6qWtS2i6rD5xvJGA8VETwCJRoKq
         itAACaqadtdU4OF96sMO7qcR7+Vu8zHnqC3GEOoA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        zain wang <wzz@rock-chips.com>,
        Brian Norris <briannorris@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 063/148] arm64: dts: rockchip: Set RK3399-Gru PCLK_EDP to 24 MHz
Date:   Mon, 26 Sep 2022 12:11:37 +0200
Message-Id: <20220926100758.399210028@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zain wang <wzz@rock-chips.com>

[ Upstream commit 8123437cf46ea5a0f6ca5cb3c528d8b6db97b9c2 ]

We've found the AUX channel to be less reliable with PCLK_EDP at a
higher rate (typically 25 MHz). This is especially important on systems
with PSR-enabled panels (like Gru-Kevin), since we make heavy, constant
use of AUX.

According to Rockchip, using any rate other than 24 MHz can cause
"problems between syncing the PHY an PCLK", which leads to all sorts of
unreliabilities around register operations.

Fixes: d67a38c5a623 ("arm64: dts: rockchip: move core edp from rk3399-kevin to shared chromebook")
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: zain wang <wzz@rock-chips.com>
Signed-off-by: Brian Norris <briannorris@chromium.org>
Link: https://lore.kernel.org/r/20220830131212.v2.1.I98d30623f13b785ca77094d0c0fd4339550553b6@changeid
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-gru-chromebook.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-gru-chromebook.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-gru-chromebook.dtsi
index 0d8458d55626..739937f70f8d 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-gru-chromebook.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-gru-chromebook.dtsi
@@ -237,6 +237,14 @@ &cdn_dp {
 &edp {
 	status = "okay";
 
+	/*
+	 * eDP PHY/clk don't sync reliably at anything other than 24 MHz. Only
+	 * set this here, because rk3399-gru.dtsi ensures we can generate this
+	 * off GPLL=600MHz, whereas some other RK3399 boards may not.
+	 */
+	assigned-clocks = <&cru PCLK_EDP>;
+	assigned-clock-rates = <24000000>;
+
 	ports {
 		edp_out: port@1 {
 			reg = <1>;
-- 
2.35.1



