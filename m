Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99DEE31040D
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 05:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbhBEEaq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 23:30:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:43834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229729AbhBEEap (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Feb 2021 23:30:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81B5364F58;
        Fri,  5 Feb 2021 04:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612499405;
        bh=OSBK9BNewWW1mo51cnuVfoS46v1aMKG2abPpzqwLzU8=;
        h=From:To:Cc:Subject:Date:From;
        b=rxtpPLLoZ7Zoh9Z7wT6kLPQojGYkwguLo39lxrVG2I0PIgY/joAr1VU4yRpvFrh6N
         2nbuU4FTZrvZ3RGIzPTklI/LP0pDTe5DLzkop5YYJOFh4WnfkMo/bdPx1eZEvHF0I9
         ydEWnPSyaZaZL6rAHMenO0Jlw7kPfcNTCsBYQ6/kMsb1stmxYI2NOMoIXd/0xqMFgQ
         g3IbX6Eq1VrjgHL7hTe6HxsgYkS8/S92JZuS/Wv6jQIBQPwLhRZ/qhLcHgNCa42+Fb
         6EoKtvwaL18BbPEgsYh7zsZr4sac/HxIZVDCaO1ppNSLHpmervP1hz2viUwoE5uTXF
         uJteXIP/BWPBQ==
From:   Dinh Nguyen <dinguyen@kernel.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     dinguyen@kernel.org, devicetree@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] arm64: dts: agilex: fix phy interface bit shift for gmac1 and gmac2
Date:   Thu,  4 Feb 2021 22:29:53 -0600
Message-Id: <20210205042953.157527-1-dinguyen@kernel.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The shift for the phy_intf_sel bit in the system manager for gmac1 and
gmac2 should be 0.

Fixes: 2f804ba7aa9ee ("arm64: dts: agilex: Add SysMgr to Ethernet nodes")
Cc: stable@vger.kernel.org
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
---
 arch/arm64/boot/dts/intel/socfpga_agilex.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/intel/socfpga_agilex.dtsi b/arch/arm64/boot/dts/intel/socfpga_agilex.dtsi
index e1c0fcba5c20..07c099b4ed5b 100644
--- a/arch/arm64/boot/dts/intel/socfpga_agilex.dtsi
+++ b/arch/arm64/boot/dts/intel/socfpga_agilex.dtsi
@@ -166,7 +166,7 @@ gmac1: ethernet@ff802000 {
 			rx-fifo-depth = <16384>;
 			snps,multicast-filter-bins = <256>;
 			iommus = <&smmu 2>;
-			altr,sysmgr-syscon = <&sysmgr 0x48 8>;
+			altr,sysmgr-syscon = <&sysmgr 0x48 0>;
 			clocks = <&clkmgr AGILEX_EMAC1_CLK>, <&clkmgr AGILEX_EMAC_PTP_CLK>;
 			clock-names = "stmmaceth", "ptp_ref";
 			status = "disabled";
@@ -184,7 +184,7 @@ gmac2: ethernet@ff804000 {
 			rx-fifo-depth = <16384>;
 			snps,multicast-filter-bins = <256>;
 			iommus = <&smmu 3>;
-			altr,sysmgr-syscon = <&sysmgr 0x4c 16>;
+			altr,sysmgr-syscon = <&sysmgr 0x4c 0>;
 			clocks = <&clkmgr AGILEX_EMAC2_CLK>, <&clkmgr AGILEX_EMAC_PTP_CLK>;
 			clock-names = "stmmaceth", "ptp_ref";
 			status = "disabled";
-- 
2.30.0

