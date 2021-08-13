Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A42E3EB83D
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242010AbhHMPMH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:12:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:55156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241764AbhHMPLY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:11:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A42A604D7;
        Fri, 13 Aug 2021 15:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867457;
        bh=kfBr7CzuQBK0NYBjOvzi12C7XlKSmKvi1XBhyneaP0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pWcuQW7Q8PzDOSvzNq6Y6fb/2+x91+KLIaAprX8+Z6Gz9fBWqgWbUJ5d6t7kbBw8F
         yjm7ndfV107Jv0MIn6tpvAtqoroG25ilaevycHt4cMEKnnJhjuuFBbKqF9PskrYjss
         QXnm3AxfKT5gggJqnUVFniCKS97bUWh4ZJJA2pIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "H. Nikolaus Schaller" <hns@goldelico.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 04/42] omap5-board-common: remove not physically existing vdds_1v8_main fixed-regulator
Date:   Fri, 13 Aug 2021 17:06:30 +0200
Message-Id: <20210813150525.254390349@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150525.098817398@linuxfoundation.org>
References: <20210813150525.098817398@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: H. Nikolaus Schaller <hns@goldelico.com>

[ Upstream commit c68ef4ad180e09805fa46965d15e1dfadf09ffa5 ]

This device tree include file describes a fixed-regulator
connecting smps7_reg output (1.8V) to some 1.8V rail and
consumers (vdds_1v8_main).

This regulator does not physically exist.

I assume it was introduced as a wrapper around smps7_reg
to provide a speaking signal name "vdds_1v8_main" as label.

This fixed-regulator without real function was not an issue
in driver code until

  Commit 98e48cd9283d ("regulator: core: resolve supply for boot-on/always-on regulators")

introduced a new check for regulator initialization which
makes Palmas regulator registration fail:

[    5.407712] ldo1: supplied by vsys_cobra
[    5.412748] ldo2: supplied by vsys_cobra
[    5.417603] palmas-pmic 48070000.i2c:palmas@48:palmas_pmic: failed to register 48070000.i2c:palmas@48:palmas_pmic regulator

The reason is that the supply-chain of regulators is too
long and goes from ldo3 through the virtual vdds_1v8_main
regulator and then back to smps7. This adds a cross-dependency
of probing Palmas regulators and the fixed-regulator which
leads to probe deferral by the new check and is no longer
resolved.

Since we do not control what device tree files including this
one reference (either &vdds_1v8_main or &smps7_reg or both)
we keep both labels for smps7 for compatibility.

Fixes: 98e48cd9283d ("regulator: core: resolve supply for boot-on/always-on regulators")
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/omap5-board-common.dtsi | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/arch/arm/boot/dts/omap5-board-common.dtsi b/arch/arm/boot/dts/omap5-board-common.dtsi
index c58f14de0145..7d1877c9c361 100644
--- a/arch/arm/boot/dts/omap5-board-common.dtsi
+++ b/arch/arm/boot/dts/omap5-board-common.dtsi
@@ -29,14 +29,6 @@
 		regulator-max-microvolt = <5000000>;
 	};
 
-	vdds_1v8_main: fixedregulator-vdds_1v8_main {
-		compatible = "regulator-fixed";
-		regulator-name = "vdds_1v8_main";
-		vin-supply = <&smps7_reg>;
-		regulator-min-microvolt = <1800000>;
-		regulator-max-microvolt = <1800000>;
-	};
-
 	vmmcsd_fixed: fixedregulator-mmcsd {
 		compatible = "regulator-fixed";
 		regulator-name = "vmmcsd_fixed";
@@ -482,6 +474,7 @@
 					regulator-boot-on;
 				};
 
+				vdds_1v8_main:
 				smps7_reg: smps7 {
 					/* VDDS_1v8_OMAP over VDDS_1v8_MAIN */
 					regulator-name = "smps7";
-- 
2.30.2



