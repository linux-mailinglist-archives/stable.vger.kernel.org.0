Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A35329BCC3
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1811067AbgJ0QhE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:37:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:45464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1763869AbgJ0Prj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:47:39 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 520C72072C;
        Tue, 27 Oct 2020 15:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813655;
        bh=r3qMM+7kEx7oV8BxE5af5OJtnD9l4vZHU2aGFsJw2z0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pqZLglXwAhO3ywDZ+JWJ/rxh8u8qSVqLjiqouFeS9d15hPoGvwwu/uzCBqE86Mxn5
         7z3ZnR8XRdz7Bcii5lMOzEc72cwMdxtc6K2sX5i1yfCCo5q1AkhitmbORxxM5nMmFQ
         VZz/L5ajuAnXv0ehmPTyI82Wek/fDwAfxyp0//Ak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Simek <michal.simek@xilinx.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 626/757] arm64: dts: zynqmp: Remove additional compatible string for i2c IPs
Date:   Tue, 27 Oct 2020 14:54:36 +0100
Message-Id: <20201027135519.913021172@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
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
index 3ec99f13c259e..a6d869727a92e 100644
--- a/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
+++ b/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
@@ -501,7 +501,7 @@ gpio: gpio@ff0a0000 {
 		};
 
 		i2c0: i2c@ff020000 {
-			compatible = "cdns,i2c-r1p14", "cdns,i2c-r1p10";
+			compatible = "cdns,i2c-r1p14";
 			status = "disabled";
 			interrupt-parent = <&gic>;
 			interrupts = <0 17 4>;
@@ -512,7 +512,7 @@ i2c0: i2c@ff020000 {
 		};
 
 		i2c1: i2c@ff030000 {
-			compatible = "cdns,i2c-r1p14", "cdns,i2c-r1p10";
+			compatible = "cdns,i2c-r1p14";
 			status = "disabled";
 			interrupt-parent = <&gic>;
 			interrupts = <0 18 4>;
-- 
2.25.1



