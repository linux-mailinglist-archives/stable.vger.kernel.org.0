Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 032B53C8C86
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234690AbhGNTmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:42:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:36534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234343AbhGNTl5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:41:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2C62613DA;
        Wed, 14 Jul 2021 19:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291545;
        bh=Q9EHnnOZZqRiMJ5Is/OpXOkoNAoq5rDKZRtPLZozFYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eS7Asl8nnUNvE9tQTKzHX957gXvT1FaqePkrEi1EeYC4wa+vYzdTGheCx2nt2UI3b
         RCUTAsEhNA8kP+GKT3YXMVmjiE/3evavk0Ugp9MAgr53LqwFtQpUFYXJgxQyfOchz/
         Qugw130isiY3kr5MJ9DnJB3z0i3YJHK1l0mqS9ur7c+DgWGm5RLf1wdY61zqUY+c1L
         oQ/g7Bu6Uwk3TihjfjyWvS9hk5Drj+9/N1Hhl8g2EoWKm3hLJEwUVa4N3PGesLDu2j
         zF6ZxQb2Tvv8XRBvkaaU4Fu48QX6roNtDLAN8WHrxbgEvS9RlIMMLRcRt0fCH3dDMF
         DZU5+FEHvrMyw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 045/108] ARM: dts: am57xx-cl-som-am57x: fix ti,no-reset-on-init flag for gpios
Date:   Wed, 14 Jul 2021 15:36:57 -0400
Message-Id: <20210714193800.52097-45-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714193800.52097-1-sashal@kernel.org>
References: <20210714193800.52097-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

[ Upstream commit b644c5e01c870056e13a096e14b9a92075c8f682 ]

The ti,no-reset-on-init flag need to be at the interconnect target module
level for the modules that have it defined.
The ti-sysc driver handles this case, but produces warning, not a critical
issue.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/am57xx-cl-som-am57x.dts | 5 ++---
 arch/arm/boot/dts/dra7-l4.dtsi            | 4 ++--
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/am57xx-cl-som-am57x.dts b/arch/arm/boot/dts/am57xx-cl-som-am57x.dts
index 0d5fe2bfb683..39eba2bc36dd 100644
--- a/arch/arm/boot/dts/am57xx-cl-som-am57x.dts
+++ b/arch/arm/boot/dts/am57xx-cl-som-am57x.dts
@@ -610,12 +610,11 @@ &mcasp3 {
 	>;
 };
 
-&gpio3 {
-	status = "okay";
+&gpio3_target {
 	ti,no-reset-on-init;
 };
 
-&gpio2 {
+&gpio2_target {
 	status = "okay";
 	ti,no-reset-on-init;
 };
diff --git a/arch/arm/boot/dts/dra7-l4.dtsi b/arch/arm/boot/dts/dra7-l4.dtsi
index 149144cdff35..6e33c0bf32a9 100644
--- a/arch/arm/boot/dts/dra7-l4.dtsi
+++ b/arch/arm/boot/dts/dra7-l4.dtsi
@@ -1343,7 +1343,7 @@ gpio8: gpio@0 {
 			};
 		};
 
-		target-module@55000 {			/* 0x48055000, ap 13 0e.0 */
+		gpio2_target: target-module@55000 {		/* 0x48055000, ap 13 0e.0 */
 			compatible = "ti,sysc-omap2", "ti,sysc";
 			reg = <0x55000 0x4>,
 			      <0x55010 0x4>,
@@ -1376,7 +1376,7 @@ gpio2: gpio@0 {
 			};
 		};
 
-		target-module@57000 {			/* 0x48057000, ap 15 06.0 */
+		gpio3_target: target-module@57000 {		/* 0x48057000, ap 15 06.0 */
 			compatible = "ti,sysc-omap2", "ti,sysc";
 			reg = <0x57000 0x4>,
 			      <0x57010 0x4>,
-- 
2.30.2

