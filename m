Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F63163DF65
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbiK3Sqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:46:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbiK3Sqe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:46:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C87B9702C
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:46:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 194A4B81CAB
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:46:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68151C433D6;
        Wed, 30 Nov 2022 18:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833990;
        bh=g2WIqdFXdE5EjQDyff6iGvwtakaJ+ICMwIn4XY8FVrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LQiwDrAYbJVIJSRH0Efa2ZlRcDIDpRkjBz2befPxPKzHnbkbDYPxZj/O3WP96MSXK
         SpzP00E9CF+IK6Vo0PeyJW99dOgaOWvBT5GVrBFZndfNNrI76MCaeMHUQyjy2mvbZ6
         KYAfrjIjtj/bfOVbyaJ57ld/DPoQp3x1L+26QI2c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Fabio Estevam <festevam@denx.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 089/289] ARM: dts: imx6q-prti6q: Fix ref/tcxo-clock-frequency properties
Date:   Wed, 30 Nov 2022 19:21:14 +0100
Message-Id: <20221130180546.162955680@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit e68be7b39f21d8a9291a5a3019787cd3ca999dd7 ]

make dtbs_check gives the following errors:

ref-clock-frequency: size (9) error for type uint32
tcxo-clock-frequency: size (9) error for type uint32

Fix it by passing the frequencies inside < > as documented in
Documentation/devicetree/bindings/net/wireless/ti,wlcore.yaml.

Signed-off-by: Fabio Estevam <festevam@denx.de>
Fixes: 0d446a505592 ("ARM: dts: add Protonic PRTI6Q board")
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6q-prti6q.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/imx6q-prti6q.dts b/arch/arm/boot/dts/imx6q-prti6q.dts
index b4605edfd2ab..d8fa83effd63 100644
--- a/arch/arm/boot/dts/imx6q-prti6q.dts
+++ b/arch/arm/boot/dts/imx6q-prti6q.dts
@@ -364,8 +364,8 @@ wifi {
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_wifi>;
 		interrupts-extended = <&gpio1 30 IRQ_TYPE_LEVEL_HIGH>;
-		ref-clock-frequency = "38400000";
-		tcxo-clock-frequency = "19200000";
+		ref-clock-frequency = <38400000>;
+		tcxo-clock-frequency = <19200000>;
 	};
 };
 
-- 
2.35.1



