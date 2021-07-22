Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E55F3D29C0
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234273AbhGVQGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:06:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:42454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234650AbhGVQFA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:05:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8416861363;
        Thu, 22 Jul 2021 16:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972334;
        bh=3EV+2RNPG505qUMPtwIehZb8H4gcz9qUxvJyYi9J5ic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hao+9qhCUmvWlcApe+hqgMp+wRMENP9GRuz47b+DSaKav8REDwaIQJ1/m7kRzhATp
         FbrlRnaUqrLseeBsLxEE+xribfi5/4SsFtECOv1M5ruArvAY+S+jPC1mwoGmArdiXs
         7mvgmzKKr2upKnJc7AVmimP8qio4tjEJSs/Xwr8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 038/156] ARM: dts: am57xx-cl-som-am57x: fix ti,no-reset-on-init flag for gpios
Date:   Thu, 22 Jul 2021 18:30:13 +0200
Message-Id: <20210722155629.644898082@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -610,12 +610,11 @@
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
index 648d23f7f748..06e26182eabf 100644
--- a/arch/arm/boot/dts/dra7-l4.dtsi
+++ b/arch/arm/boot/dts/dra7-l4.dtsi
@@ -1343,7 +1343,7 @@
 			};
 		};
 
-		target-module@55000 {			/* 0x48055000, ap 13 0e.0 */
+		gpio2_target: target-module@55000 {		/* 0x48055000, ap 13 0e.0 */
 			compatible = "ti,sysc-omap2", "ti,sysc";
 			reg = <0x55000 0x4>,
 			      <0x55010 0x4>,
@@ -1376,7 +1376,7 @@
 			};
 		};
 
-		target-module@57000 {			/* 0x48057000, ap 15 06.0 */
+		gpio3_target: target-module@57000 {		/* 0x48057000, ap 15 06.0 */
 			compatible = "ti,sysc-omap2", "ti,sysc";
 			reg = <0x57000 0x4>,
 			      <0x57010 0x4>,
-- 
2.30.2



