Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0E83D29C1
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234279AbhGVQGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:06:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:42234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234688AbhGVQFB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:05:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FABF613D2;
        Thu, 22 Jul 2021 16:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972336;
        bh=7BB59h43NONr1QlZ2cm9tQUNkmVmBqnQQ9I+BQ907yU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CnGE4UyItUHZe2jMz+HFK/LCpHlwsULr2Bp35GeU+1rdGwyA9UQyMyP10tRD32YCA
         T8sCZ3mJdOJ2Z9/KXimSz6oiMhck4ITXnUdaqPx0K5CDtLKrrUyQ2nRPfGzt6qQzFU
         5THmuF0iGnZhjeE0Wit+EaKBQ+AQIy6+oWhq9n7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 039/156] ARM: dts: am437x-gp-evm: fix ti,no-reset-on-init flag for gpios
Date:   Thu, 22 Jul 2021 18:30:14 +0200
Message-Id: <20210722155629.675457658@linuxfoundation.org>
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

[ Upstream commit 2566d5b8c1670f7d7a44cc1426d254147ec5c421 ]

The ti,no-reset-on-init flag need to be at the interconnect target module
level for the modules that have it defined.
The ti-sysc driver handles this case, but produces warning, not a critical
issue.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/am437x-gp-evm.dts |    5 ++++-
 arch/arm/boot/dts/am437x-l4.dtsi    |    2 +-
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/arch/arm/boot/dts/am437x-gp-evm.dts
+++ b/arch/arm/boot/dts/am437x-gp-evm.dts
@@ -813,11 +813,14 @@
 	status = "okay";
 };
 
+&gpio5_target {
+	ti,no-reset-on-init;
+};
+
 &gpio5 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&display_mux_pins>;
 	status = "okay";
-	ti,no-reset-on-init;
 
 	p8 {
 		/*
--- a/arch/arm/boot/dts/am437x-l4.dtsi
+++ b/arch/arm/boot/dts/am437x-l4.dtsi
@@ -2070,7 +2070,7 @@
 			};
 		};
 
-		target-module@22000 {			/* 0x48322000, ap 116 64.0 */
+		gpio5_target: target-module@22000 {		/* 0x48322000, ap 116 64.0 */
 			compatible = "ti,sysc-omap2", "ti,sysc";
 			reg = <0x22000 0x4>,
 			      <0x22010 0x4>,


