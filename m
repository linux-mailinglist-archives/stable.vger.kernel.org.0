Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 753BF6AEB76
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbjCGRon (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:44:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232111AbjCGRoX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:44:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B6CBA2263
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:40:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4307DB819B4
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE278C433EF;
        Tue,  7 Mar 2023 17:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210809;
        bh=JZQr9dYF8DiS7/ibNUSYwinpPhfpthUkbrwypnQV85U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Su4zYSANip/CHYr86BH7H7/ImVe8dWkJf0NQMEr2QZp5EZuTFmWeFIIAUuWKoGWn+
         ssUPK0HLw+laSqyg85kyBoDPae9PvXS/o7VjvTHue7oWrdon7hYoKs+TAjpyuUOz69
         bzGsV5hadDKuhMHRf8dUSG4inNzutPnZxY+VZR5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Michal Simek <michal.simek@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0630/1001] arm64: zynqmp: Enable hs termination flag for USB dwc3 controller
Date:   Tue,  7 Mar 2023 17:56:42 +0100
Message-Id: <20230307170048.911916659@linuxfoundation.org>
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
index 4325cb8526edc..f92df478f0eea 100644
--- a/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
+++ b/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
@@ -858,6 +858,7 @@ dwc3_0: usb@fe200000 {
 				clock-names = "bus_early", "ref";
 				iommus = <&smmu 0x860>;
 				snps,quirk-frame-length-adjustment = <0x20>;
+				snps,resume-hs-terminations;
 				/* dma-coherent; */
 			};
 		};
@@ -884,6 +885,7 @@ dwc3_1: usb@fe300000 {
 				clock-names = "bus_early", "ref";
 				iommus = <&smmu 0x861>;
 				snps,quirk-frame-length-adjustment = <0x20>;
+				snps,resume-hs-terminations;
 				/* dma-coherent; */
 			};
 		};
-- 
2.39.2



