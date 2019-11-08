Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31497F482B
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 12:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390137AbfKHLzI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:55:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:33650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387856AbfKHLqG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:46:06 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5035F222C2;
        Fri,  8 Nov 2019 11:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213565;
        bh=BPCOPpeQbZWj52xinWEfuf+g4VQnSwbdAi1/ET2hRTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lN8zU55c+R3rQYIYzj7hUglWdvSdIJhms82WagUI+w3HcxRbrAPScO+v9lLV2unpR
         gUQLdUOiSJzJSAk8g1fW6ocky4omFNocYPM+iTuxMXfjJF9gVeihATSLIhFLCAnzeR
         YlU5JH8Rq5vLM2jvdzfbcrBYG+ZKaJg0TxRzNNdg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 13/64] ARM: dts: exynos: Fix regulators configuration on Peach Pi/Pit Chromebooks
Date:   Fri,  8 Nov 2019 06:44:54 -0500
Message-Id: <20191108114545.15351-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114545.15351-1-sashal@kernel.org>
References: <20191108114545.15351-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit f8f3b7fc21b1cb59385b780acd9b9a26d04cb7b2 ]

Regulators, which are marked as 'on-in-suspend' seems to be critical for
board operation, thus they must not be disabled anytime. This can be
only assured by marking them as 'always-on', because otherwise some
actions of their clients might result in turning them off. This patch
restores suspend/resume operation on Peach-Pit Chromebook board. It
partially reverts 'always-on' property removal done by the commit
mentioned in the Fixes tag.

Fixes: 665c441eea3d ("ARM: dts: exynos: Remove unneded always-on for regulators on Peach boards")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Tomasz Figa <tfiga@chromium.org>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos5420-peach-pit.dts | 3 +++
 arch/arm/boot/dts/exynos5800-peach-pi.dts  | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5420-peach-pit.dts b/arch/arm/boot/dts/exynos5420-peach-pit.dts
index 8b754ae8c8f7d..c9d379b1a1669 100644
--- a/arch/arm/boot/dts/exynos5420-peach-pit.dts
+++ b/arch/arm/boot/dts/exynos5420-peach-pit.dts
@@ -302,6 +302,7 @@
 				regulator-name = "vdd_1v35";
 				regulator-min-microvolt = <1350000>;
 				regulator-max-microvolt = <1350000>;
+				regulator-always-on;
 				regulator-boot-on;
 				regulator-state-mem {
 					regulator-on-in-suspend;
@@ -323,6 +324,7 @@
 				regulator-name = "vdd_2v";
 				regulator-min-microvolt = <2000000>;
 				regulator-max-microvolt = <2000000>;
+				regulator-always-on;
 				regulator-boot-on;
 				regulator-state-mem {
 					regulator-on-in-suspend;
@@ -333,6 +335,7 @@
 				regulator-name = "vdd_1v8";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
 				regulator-boot-on;
 				regulator-state-mem {
 					regulator-on-in-suspend;
diff --git a/arch/arm/boot/dts/exynos5800-peach-pi.dts b/arch/arm/boot/dts/exynos5800-peach-pi.dts
index 1f90df2d7ecd8..ae58b8d6f6144 100644
--- a/arch/arm/boot/dts/exynos5800-peach-pi.dts
+++ b/arch/arm/boot/dts/exynos5800-peach-pi.dts
@@ -302,6 +302,7 @@
 				regulator-name = "vdd_1v35";
 				regulator-min-microvolt = <1350000>;
 				regulator-max-microvolt = <1350000>;
+				regulator-always-on;
 				regulator-boot-on;
 				regulator-state-mem {
 					regulator-on-in-suspend;
@@ -323,6 +324,7 @@
 				regulator-name = "vdd_2v";
 				regulator-min-microvolt = <2000000>;
 				regulator-max-microvolt = <2000000>;
+				regulator-always-on;
 				regulator-boot-on;
 				regulator-state-mem {
 					regulator-on-in-suspend;
@@ -333,6 +335,7 @@
 				regulator-name = "vdd_1v8";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
 				regulator-boot-on;
 				regulator-state-mem {
 					regulator-on-in-suspend;
-- 
2.20.1

