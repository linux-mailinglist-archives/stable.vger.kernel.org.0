Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F00D3D2850
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232787AbhGVP4b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:56:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:60172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232761AbhGVP4B (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:56:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DE8561362;
        Thu, 22 Jul 2021 16:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971795;
        bh=7U3/2k0ypGrY2nce/VxayLDVWTCcWN2m8xuYEiVreMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ij0bH4Is5u1BbP3s7OnmYp6KkymBeGWKpsRuIiakb9m5/4ksu0bGZg6v1vPV+J0Ho
         IOusTcT12FfTYFlAi4gjCucecPFTXrdctB4R9Jeewy/TclcGc6VPMks85HjI2Fee4e
         797Jw6lyjYRvdmWeSK8RhN3TX7Uu0+EaGSshv8+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Ford <aford173@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 029/125] arm64: dts: renesas: beacon: Fix USB ref clock references
Date:   Thu, 22 Jul 2021 18:30:20 +0200
Message-Id: <20210722155625.652154340@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Ford <aford173@gmail.com>

[ Upstream commit ebc666f39ff67a01e748c34d670ddf05a9e45220 ]

The RZ/G2 boards expect there to be an external clock reference for
USB2 EHCI controllers.  For the Beacon boards, this reference clock
is controlled by a programmable versaclock.  Because the RZ/G2
family has a special clock driver when using an external clock,
the third clock reference in the EHCI node needs to point to this
special clock, called usb2_clksel.

Since the usb2_clksel does not keep the usb_extal clock enabled,
the 4th clock entry for the EHCI nodes needs to reference it to
keep the clock running and make USB functional.

Signed-off-by: Adam Ford <aford173@gmail.com>
Link: https://lore.kernel.org/r/20210513114617.30191-2-aford173@gmail.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi b/arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi
index 597388f87127..bc4bb5dd8bae 100644
--- a/arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi
+++ b/arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi
@@ -271,12 +271,12 @@
 &ehci0 {
 	dr_mode = "otg";
 	status = "okay";
-	clocks = <&cpg CPG_MOD 703>, <&cpg CPG_MOD 704>;
+	clocks = <&cpg CPG_MOD 703>, <&cpg CPG_MOD 704>, <&usb2_clksel>, <&versaclock5 3>;
 };
 
 &ehci1 {
 	status = "okay";
-	clocks = <&cpg CPG_MOD 703>, <&cpg CPG_MOD 704>;
+	clocks = <&cpg CPG_MOD 703>, <&cpg CPG_MOD 704>, <&usb2_clksel>, <&versaclock5 3>;
 };
 
 &hdmi0 {
-- 
2.30.2



