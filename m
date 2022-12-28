Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18F44658099
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234583AbiL1QS3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:18:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234580AbiL1QSB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:18:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66B41165B4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:16:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E58B7B81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:16:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56373C433D2;
        Wed, 28 Dec 2022 16:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244205;
        bh=K0YOuC+M8aF8XcBEKcJIg0z82Uzjl1kl0ANjhO5Ouyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DrkKB9h8gFNDokL4p+6PfQpycraW4JQB5kivezDp55Yd2oNoFXqsWwypwEs2MKQT7
         zuQzf0gBwl/NFeW0YQKW9a4zCqLDa0Xs9RZMI0wBiOfrlyIFqAheyO1/29J/VJfznK
         N76VO9rXyBm76E2PXxAh1OP75A2ADlNeEVAlPtRA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0629/1146] dt-bindings: visconti-pcie: Fix interrupts array max constraints
Date:   Wed, 28 Dec 2022 15:36:08 +0100
Message-Id: <20221228144347.253845277@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

[ Upstream commit 4cf4b9b70ab2785461190c08a3542d2d74c28b46 ]

In accordance with the way the device DT-node is actually defined in
arch/arm64/boot/dts/toshiba/tmpv7708.dtsi and the way the device is probed
by the DW PCIe driver there are two IRQs it actually has. It's MSI IRQ the
DT-bindings lack. Let's extend the interrupts property constraints then
and fix the schema example so one would be acceptable by the actual device
DT-bindings.

Link: https://lore.kernel.org/r/20221113191301.5526-3-Sergey.Semin@baikalelectronics.ru
Fixes: 17c1b16340f0 ("dt-bindings: pci: Add DT binding for Toshiba Visconti PCIe controller")
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Acked-by: Rob Herring <robh@kernel.org>
Acked-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/pci/toshiba,visconti-pcie.yaml     | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/pci/toshiba,visconti-pcie.yaml b/Documentation/devicetree/bindings/pci/toshiba,visconti-pcie.yaml
index 48ed227fc5b9..53da2edd7c9a 100644
--- a/Documentation/devicetree/bindings/pci/toshiba,visconti-pcie.yaml
+++ b/Documentation/devicetree/bindings/pci/toshiba,visconti-pcie.yaml
@@ -36,7 +36,7 @@ properties:
       - const: mpu
 
   interrupts:
-    maxItems: 1
+    maxItems: 2
 
   clocks:
     items:
@@ -94,8 +94,9 @@ examples:
             #interrupt-cells = <1>;
             ranges = <0x81000000 0 0x40000000 0 0x40000000 0 0x00010000>,
                      <0x82000000 0 0x50000000 0 0x50000000 0 0x20000000>;
-            interrupts = <GIC_SPI 215 IRQ_TYPE_LEVEL_HIGH>;
-            interrupt-names = "intr";
+            interrupts = <GIC_SPI 211 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 215 IRQ_TYPE_LEVEL_HIGH>;
+            interrupt-names = "msi", "intr";
             interrupt-map-mask = <0 0 0 7>;
             interrupt-map =
                 <0 0 0 1 &gic GIC_SPI 215 IRQ_TYPE_LEVEL_HIGH
-- 
2.35.1



