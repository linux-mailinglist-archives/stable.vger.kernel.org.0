Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40AF129B0F0
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2901619AbgJ0OZZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:25:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:50816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2901613AbgJ0OZY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:25:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3007320773;
        Tue, 27 Oct 2020 14:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808723;
        bh=1fHMQsfwc+E4J485jdFMYQOsESavJapQ0G7HTOqP9Es=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=La8e/RgB+dETqzU1B19eUEWldsvpd3IKSSV17b1N9Ykoja3rphKV8SFuD+baPLKv4
         seaGm/jmRTKSkjhZ2gdh/BXiF7NKcQyElKUwmJML+seu1RAyRbuhY2pD4++cpHyyJE
         /wZUsk9F9Q5gQF3JBCQ7hAPUpk8MwKIUfiRaaWKM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Simek <michal.simek@xilinx.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 199/264] arm64: dts: zynqmp: Remove additional compatible string for i2c IPs
Date:   Tue, 27 Oct 2020 14:54:17 +0100
Message-Id: <20201027135440.016823650@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Simek <michal.simek@xilinx.com>

[ Upstream commit 35292518cb0a626fcdcabf739aed75060a018ab5 ]

DT binding permits only one compatible string which was decribed in past by
commit 63cab195bf49 ("i2c: removed work arounds in i2c driver for Zynq
Ultrascale+ MPSoC").
The commit aea37006e183 ("dt-bindings: i2c: cadence: Migrate i2c-cadence
documentation to YAML") has converted binding to yaml and the following
issues is reported:
...: i2c@ff030000: compatible: Additional items are not allowed
('cdns,i2c-r1p10' was unexpected)
	From schema:
.../Documentation/devicetree/bindings/i2c/cdns,i2c-r1p10.yaml fds
...: i2c@ff030000: compatible: ['cdns,i2c-r1p14', 'cdns,i2c-r1p10'] is too
long

The commit c415f9e8304a ("ARM64: zynqmp: Fix i2c node's compatible string")
has added the second compatible string but without removing origin one.
The patch is only keeping one compatible string "cdns,i2c-r1p14".

Fixes: c415f9e8304a ("ARM64: zynqmp: Fix i2c node's compatible string")
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Link: https://lore.kernel.org/r/cc294ae1a79ef845af6809ddb4049f0c0f5bb87a.1598259551.git.michal.simek@xilinx.com
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/xilinx/zynqmp.dtsi b/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
index a516c0e01429a..8a885ae647b7e 100644
--- a/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
+++ b/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
@@ -411,7 +411,7 @@ gpio: gpio@ff0a0000 {
 		};
 
 		i2c0: i2c@ff020000 {
-			compatible = "cdns,i2c-r1p14", "cdns,i2c-r1p10";
+			compatible = "cdns,i2c-r1p14";
 			status = "disabled";
 			interrupt-parent = <&gic>;
 			interrupts = <0 17 4>;
@@ -421,7 +421,7 @@ i2c0: i2c@ff020000 {
 		};
 
 		i2c1: i2c@ff030000 {
-			compatible = "cdns,i2c-r1p14", "cdns,i2c-r1p10";
+			compatible = "cdns,i2c-r1p14";
 			status = "disabled";
 			interrupt-parent = <&gic>;
 			interrupts = <0 18 4>;
-- 
2.25.1



