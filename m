Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D66068D79C
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbjBGNBa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:01:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231997AbjBGNB0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:01:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B36223A5A8
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:00:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFF33613EA
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:00:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C74C433EF;
        Tue,  7 Feb 2023 13:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675774845;
        bh=fHYELPJogo3NvPFkv0KZ+PV3JCsSgJ9vtOMQBEJB8rE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r1X7HBS/EFXem1ik0rl2dJ8LWlGXGJQHQLe0F9EP9cPa6H04+VUV/FvzTVClX6XM/
         kcKZndbCzU54vzCt5qaJCEHoQna4uvZnvrm3cZxkMLRtL7oXOuog3nacDmydl/HV4S
         j5Ixh7xJwtk4/UW3IJ3tMCyK1olZ76eCOtEKQTcY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 023/208] arm64: dts: imx8mm-verdin: Do not power down eth-phy
Date:   Tue,  7 Feb 2023 13:54:37 +0100
Message-Id: <20230207125635.352519243@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
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

From: Philippe Schenker <philippe.schenker@toradex.com>

[ Upstream commit 39c95d0c357d7ef76aea958c1bece6b24f9b2e7e ]

Currently if suspending using either freeze or memory state, the fec
driver tries to power down the phy which leads to crash of the kernel
and non-responsible kernel with the following call trace:

[   24.839889 ] Call trace:
[   24.839892 ]  phy_error+0x18/0x60
[   24.839898 ]  kszphy_handle_interrupt+0x6c/0x80
[   24.839903 ]  phy_interrupt+0x20/0x2c
[   24.839909 ]  irq_thread_fn+0x30/0xa0
[   24.839919 ]  irq_thread+0x178/0x2c0
[   24.839925 ]  kthread+0x154/0x160
[   24.839932 ]  ret_from_fork+0x10/0x20

Since there is currently no functionality in the phy subsystem to power
down phys let's just disable the feature of powering-down the ethernet
phy.

Fixes: 6a57f224f734 ("arm64: dts: freescale: add initial support for verdin imx8m mini")
Signed-off-by: Philippe Schenker <philippe.schenker@toradex.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
index bcab830c6e95..59445f916d7f 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
@@ -98,6 +98,7 @@
 		off-on-delay = <500000>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_reg_eth>;
+		regulator-always-on;
 		regulator-boot-on;
 		regulator-max-microvolt = <3300000>;
 		regulator-min-microvolt = <3300000>;
-- 
2.39.0



