Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9E03D2844
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbhGVP4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:56:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:60382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232752AbhGVP4P (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:56:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E9C26135B;
        Thu, 22 Jul 2021 16:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971808;
        bh=4J970V/Gra9tWG27qRm9+lAVShP0DPF7mPi8lphDFpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xYOCxX7Qil+wm0qTIXnrhYVNrZl9yHjCPViY152o0QSYXDHFdx6xAX4fxngEUGAQg
         43IV0PqLNccHOCb6m0YuaX2jDyZDpwWC37bjwlLI9+vq+ONRN/Bg35U4CY/WCLCZFE
         ZaQxqUOgSOKTbxhZ3LFHiXv8tE7nL/cQdcGOVcbI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 033/125] ARM: dts: am335x: fix ti,no-reset-on-init flag for gpios
Date:   Thu, 22 Jul 2021 18:30:24 +0200
Message-Id: <20210722155625.790410458@linuxfoundation.org>
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

From: Grygorii Strashko <grygorii.strashko@ti.com>

[ Upstream commit d7d30b8fcd111e9feb171023c0e0c8d855582dcb ]

The ti,no-reset-on-init flag need to be at the interconnect target module
level for the modules that have it defined.
The ti-sysc driver handles this case, but produces warning, not a critical
issue.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/am335x-baltos.dtsi              | 4 ++--
 arch/arm/boot/dts/am335x-evmsk.dts                | 2 +-
 arch/arm/boot/dts/am335x-moxa-uc-2100-common.dtsi | 2 +-
 arch/arm/boot/dts/am335x-moxa-uc-8100-common.dtsi | 2 +-
 arch/arm/boot/dts/am33xx-l4.dtsi                  | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/am335x-baltos.dtsi b/arch/arm/boot/dts/am335x-baltos.dtsi
index b7f64c7ba83d..77e23e736854 100644
--- a/arch/arm/boot/dts/am335x-baltos.dtsi
+++ b/arch/arm/boot/dts/am335x-baltos.dtsi
@@ -393,10 +393,10 @@
 	status = "okay";
 };
 
-&gpio0 {
+&gpio0_target {
 	ti,no-reset-on-init;
 };
 
-&gpio3 {
+&gpio3_target {
 	ti,no-reset-on-init;
 };
diff --git a/arch/arm/boot/dts/am335x-evmsk.dts b/arch/arm/boot/dts/am335x-evmsk.dts
index b43b94122d3c..bf05b68274c2 100644
--- a/arch/arm/boot/dts/am335x-evmsk.dts
+++ b/arch/arm/boot/dts/am335x-evmsk.dts
@@ -648,7 +648,7 @@
 	status = "okay";
 };
 
-&gpio0 {
+&gpio0_target {
 	ti,no-reset-on-init;
 };
 
diff --git a/arch/arm/boot/dts/am335x-moxa-uc-2100-common.dtsi b/arch/arm/boot/dts/am335x-moxa-uc-2100-common.dtsi
index 4e90f9c23d2e..8121a199607c 100644
--- a/arch/arm/boot/dts/am335x-moxa-uc-2100-common.dtsi
+++ b/arch/arm/boot/dts/am335x-moxa-uc-2100-common.dtsi
@@ -150,7 +150,7 @@
 	status = "okay";
 };
 
-&gpio0 {
+&gpio0_target {
 	ti,no-reset-on-init;
 };
 
diff --git a/arch/arm/boot/dts/am335x-moxa-uc-8100-common.dtsi b/arch/arm/boot/dts/am335x-moxa-uc-8100-common.dtsi
index 98d8ed4ad967..39e5d2ce600a 100644
--- a/arch/arm/boot/dts/am335x-moxa-uc-8100-common.dtsi
+++ b/arch/arm/boot/dts/am335x-moxa-uc-8100-common.dtsi
@@ -353,7 +353,7 @@
 	status = "okay";
 };
 
-&gpio0 {
+&gpio0_target {
 	ti,no-reset-on-init;
 };
 
diff --git a/arch/arm/boot/dts/am33xx-l4.dtsi b/arch/arm/boot/dts/am33xx-l4.dtsi
index ea20e4bdf040..29fafb67cfaa 100644
--- a/arch/arm/boot/dts/am33xx-l4.dtsi
+++ b/arch/arm/boot/dts/am33xx-l4.dtsi
@@ -1723,7 +1723,7 @@
 			};
 		};
 
-		target-module@ae000 {			/* 0x481ae000, ap 56 3a.0 */
+		gpio3_target: target-module@ae000 {		/* 0x481ae000, ap 56 3a.0 */
 			compatible = "ti,sysc-omap2", "ti,sysc";
 			reg = <0xae000 0x4>,
 			      <0xae010 0x4>,
-- 
2.30.2



