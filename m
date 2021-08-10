Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6BD03E8108
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233427AbhHJRzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:55:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:43222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235031AbhHJRwX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:52:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7AEAA6120F;
        Tue, 10 Aug 2021 17:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617404;
        bh=UAwRYL7AItP8ekZw+OqmT25AAyAFcsLrphfL+XTWv+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UtXhad5FY2OMWfP+N1QGO2T2F1y/waZj4YdUA8Oa9nbwHTHQRe4Fg2OlXEYMHIiZb
         KBUd00UXicTj8kNCPftgTD7Gmf/avKzSYiVh6p4QGh+58qceqlyFtCKb/4N/oIdUzE
         vDocju2HKGuVM70ebgGNnnV/vvZDDpL12HaH7E1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "H. Nikolaus Schaller" <hns@goldelico.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 026/175] omap5-board-common: remove not physically existing vdds_1v8_main fixed-regulator
Date:   Tue, 10 Aug 2021 19:28:54 +0200
Message-Id: <20210810173001.821799502@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
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
index d8f13626cfd1..3a8f10231475 100644
--- a/arch/arm/boot/dts/omap5-board-common.dtsi
+++ b/arch/arm/boot/dts/omap5-board-common.dtsi
@@ -30,14 +30,6 @@
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
@@ -487,6 +479,7 @@
 					regulator-boot-on;
 				};
 
+				vdds_1v8_main:
 				smps7_reg: smps7 {
 					/* VDDS_1v8_OMAP over VDDS_1v8_MAIN */
 					regulator-name = "smps7";
-- 
2.30.2



