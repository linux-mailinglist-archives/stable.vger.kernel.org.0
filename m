Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE2B5C02A2
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbiIUPy2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231882AbiIUPxi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:53:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 559D67C321;
        Wed, 21 Sep 2022 08:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E87CB82714;
        Wed, 21 Sep 2022 15:49:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999B7C433C1;
        Wed, 21 Sep 2022 15:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775383;
        bh=3brTycJ0De2vAzvXgwladuUXsxgrLWMn0uEYin+EqgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GUvw5cBgiMdQJCAr8fQTvv/og0GKS0WX7E741Pjn+vkAfJlrz9KTQuzC+cqHocWyI
         FWB4rn1Lpa0JCSe4N3EFLF+fnpyz4Qy4Y7xHO8A+DIzjN2B53QV8H1rOAhCKlNSt+X
         bfOm4WlXoHJW4SUfV/AcSYzXF68+wEXhd0uS7hYg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jassi Brar <jaswinder.singh@linaro.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 27/45] arm64: dts: juno: Add missing MHU secure-irq
Date:   Wed, 21 Sep 2022 17:46:17 +0200
Message-Id: <20220921153647.784204824@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153646.931277075@linuxfoundation.org>
References: <20220921153646.931277075@linuxfoundation.org>
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

From: Jassi Brar <jaswinder.singh@linaro.org>

[ Upstream commit 422ab8fe15e30066d4c8e236b747c77069bfca45 ]

The MHU secure interrupt exists physically but is missing in the DT node.

Specify the interrupt in DT node to fix a warning on Arm Juno board:
   mhu@2b1f0000: interrupts: [[0, 36, 4], [0, 35, 4]] is too short

Link: https://lore.kernel.org/r/20220801141005.599258-1-jassisinghbrar@gmail.com
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/arm/juno-base.dtsi | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/arm/juno-base.dtsi b/arch/arm64/boot/dts/arm/juno-base.dtsi
index a2635b14da30..34e5549ea748 100644
--- a/arch/arm64/boot/dts/arm/juno-base.dtsi
+++ b/arch/arm64/boot/dts/arm/juno-base.dtsi
@@ -26,7 +26,8 @@
 		compatible = "arm,mhu", "arm,primecell";
 		reg = <0x0 0x2b1f0000 0x0 0x1000>;
 		interrupts = <GIC_SPI 36 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 35 IRQ_TYPE_LEVEL_HIGH>;
+			     <GIC_SPI 35 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
 		#mbox-cells = <1>;
 		clocks = <&soc_refclk100mhz>;
 		clock-names = "apb_pclk";
-- 
2.35.1



