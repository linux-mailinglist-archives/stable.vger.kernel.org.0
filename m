Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 813D26AF0EA
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbjCGShL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:37:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233277AbjCGSfm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:35:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37C8BBB2C
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:27:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FC5D61561
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:27:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57161C433EF;
        Tue,  7 Mar 2023 18:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213632;
        bh=O1XHO5T+yu4Ud78uT35oRH9/xl5tvq39z3B9IF56nE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jcEZ9RwNBuvreMJprzj1qglIE0iFGJDzIxTQ23Mk+R2ZjXmN4PKB3HZjEecABTwD+
         jTVJNQS17dwmLLdjcgXeCYKTwf5V41owORqwx6P+Dcsnc5GmRXoyMiewalrXJJjqqE
         Ro4tIYA0QSHv31sewTuQajLal6PABil9K2cSLVxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Michal Simek <michal.simek@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 539/885] arm64: zynqmp: Enable hs termination flag for USB dwc3 controller
Date:   Tue,  7 Mar 2023 17:57:53 +0100
Message-Id: <20230307170025.914840588@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

[ Upstream commit 32405e532d358a2f9d4befae928b9883c8597616 ]

Since we need to support legacy phys with the dwc3 controller,
we enable this quirk on the zynqmp platforms.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Link: https://lore.kernel.org/r/20221023215649.221726-1-m.grzeschik@pengutronix.de
Signed-off-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/xilinx/zynqmp.dtsi b/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
index a549265e55f6e..7c1af75f33a05 100644
--- a/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
+++ b/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
@@ -825,6 +825,7 @@ dwc3_0: usb@fe200000 {
 				clock-names = "bus_early", "ref";
 				iommus = <&smmu 0x860>;
 				snps,quirk-frame-length-adjustment = <0x20>;
+				snps,resume-hs-terminations;
 				/* dma-coherent; */
 			};
 		};
@@ -851,6 +852,7 @@ dwc3_1: usb@fe300000 {
 				clock-names = "bus_early", "ref";
 				iommus = <&smmu 0x861>;
 				snps,quirk-frame-length-adjustment = <0x20>;
+				snps,resume-hs-terminations;
 				/* dma-coherent; */
 			};
 		};
-- 
2.39.2



