Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F26695EA0B5
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236265AbiIZKlA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236617AbiIZKjq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:39:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6614753D3D;
        Mon, 26 Sep 2022 03:23:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA62A60BAF;
        Mon, 26 Sep 2022 10:23:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD89CC433C1;
        Mon, 26 Sep 2022 10:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187811;
        bh=eUck7UUqhWIihyDGGH5y1+ziQsswGYPBDFAwlecVRRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SqGr+boaHl0bFTBfQxghYcLGIX9wmDFjcMVpDQq3MTJ2G64IDZ3Ddd1cajEWc6mci
         XRdMRmJ5aN11lJ/pv1/lblblJ5wOgETGBnbxH/SVt45xGQg2RZE6vcgZmZqumR0tBW
         vl3cOGwJ+0y7cZoj6WfxMnPAzt/ZterW1Vj9t+PI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Norris <briannorris@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 066/120] arm64: dts: rockchip: Pull up wlan wake# on Gru-Bob
Date:   Mon, 26 Sep 2022 12:11:39 +0200
Message-Id: <20220926100753.400977347@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100750.519221159@linuxfoundation.org>
References: <20220926100750.519221159@linuxfoundation.org>
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

From: Brian Norris <briannorris@chromium.org>

[ Upstream commit e5467359a725de90b6b8d0dd865500f6373828ca ]

The Gru-Bob board does not have a pull-up resistor on its
WLAN_HOST_WAKE# pin, but Kevin does. The production/vendor kernel
specified the pin configuration correctly as a pull-up, but this didn't
get ported correctly to upstream.

This means Bob's WLAN_HOST_WAKE# pin is floating, causing inconsistent
wakeup behavior.

Note that bt_host_wake_l has a similar dynamic, but apparently the
upstream choice was to redundantly configure both internal and external
pull-up on Kevin (see the "Kevin has an external pull up" comment in
rk3399-gru.dtsi). This doesn't cause any functional problem, although
it's perhaps wasteful.

Fixes: 8559bbeeb849 ("arm64: dts: rockchip: add Google Bob")
Signed-off-by: Brian Norris <briannorris@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20220822164453.1.I75c57b48b0873766ec993bdfb7bc1e63da5a1637@changeid
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-gru-bob.dts         | 5 +++++
 arch/arm64/boot/dts/rockchip/rk3399-gru-chromebook.dtsi | 1 +
 2 files changed, 6 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-gru-bob.dts b/arch/arm64/boot/dts/rockchip/rk3399-gru-bob.dts
index a9f4d6d7d2b7..586351340da6 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-gru-bob.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-gru-bob.dts
@@ -77,3 +77,8 @@ h1_int_od_l: h1-int-od-l {
 		};
 	};
 };
+
+&wlan_host_wake_l {
+	/* Kevin has an external pull up, but Bob does not. */
+	rockchip,pins = <0 RK_PB0 RK_FUNC_GPIO &pcfg_pull_up>;
+};
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-gru-chromebook.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-gru-chromebook.dtsi
index 7cd6d470c1cb..53185404d3c8 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-gru-chromebook.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-gru-chromebook.dtsi
@@ -397,6 +397,7 @@ wifi_perst_l: wifi-perst-l {
 	};
 
 	wlan_host_wake_l: wlan-host-wake-l {
+		/* Kevin has an external pull up, but Bob does not */
 		rockchip,pins = <0 RK_PB0 RK_FUNC_GPIO &pcfg_pull_none>;
 	};
 };
-- 
2.35.1



