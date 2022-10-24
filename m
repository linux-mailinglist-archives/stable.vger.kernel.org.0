Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E26A60A7DC
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232332AbiJXNAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232122AbiJXM63 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:58:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4296981CF;
        Mon, 24 Oct 2022 05:17:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDDB761286;
        Mon, 24 Oct 2022 11:50:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB4BC433D6;
        Mon, 24 Oct 2022 11:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612205;
        bh=BBEZSL/kEaLKT0nn3CDJDaoaCe8MaFX+1kU7JZ+z9Ck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QotdaSOMakNZsKCppLdr+ert4ConasfJd2QUp599h1aygca2noXAgy9bgvhvYkTyB
         vn6NxbQL5t7m3AMrF5IXufw7TVs9k2BgIkzITXIUS1WJg+vf/r7TtuvhcwqNKZmUPv
         k7Bqc2PneutNz67IhDTlqp3ATM/a4rE2P2CHzmgQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 110/210] ARM: dts: kirkwood: lsxl: fix serial line
Date:   Mon, 24 Oct 2022 13:30:27 +0200
Message-Id: <20221024113000.576191265@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

[ Upstream commit 04eabc6ac10fda9424606d9a7ab6ab9a5d95350a ]

Commit 327e15428977 ("ARM: dts: kirkwood: consolidate common pinctrl
settings") unknowingly broke the serial output on this board. Before
this commit, the pinmux was still configured by the bootloader and the
kernel didn't reconfigured it again. This was an oversight by the
initial board support where the pinmux for the serial line was never
configured by the kernel. But with this commit, the serial line will be
reconfigured to the wrong pins. This is especially confusing, because
the output still works, but the input doesn't. Presumingly, the input is
reconfigured to MPP10, but the output is connected to both MPP11 and
MPP5.

Override the pinmux in the board device tree.

Fixes: 327e15428977 ("ARM: dts: kirkwood: consolidate common pinctrl settings")
Signed-off-by: Michael Walle <michael@walle.cc>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/kirkwood-lsxl.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/kirkwood-lsxl.dtsi b/arch/arm/boot/dts/kirkwood-lsxl.dtsi
index 7b151acb9984..321a40a98ed2 100644
--- a/arch/arm/boot/dts/kirkwood-lsxl.dtsi
+++ b/arch/arm/boot/dts/kirkwood-lsxl.dtsi
@@ -10,6 +10,11 @@
 
 	ocp@f1000000 {
 		pinctrl: pin-controller@10000 {
+			/* Non-default UART pins */
+			pmx_uart0: pmx-uart0 {
+				marvell,pins = "mpp4", "mpp5";
+			};
+
 			pmx_power_hdd: pmx-power-hdd {
 				marvell,pins = "mpp10";
 				marvell,function = "gpo";
-- 
2.35.1



