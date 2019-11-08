Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ACD1F4924
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:01:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390519AbfKHMBU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:01:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:58282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390524AbfKHLnm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:43:42 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 743D7222CF;
        Fri,  8 Nov 2019 11:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213421;
        bh=gQc1TgP91Eg1fBE2eP6CQ+0ionmH6FlDG3R33s8qABo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2vqv3XfjzpWPnAU8rOfqqPJ8WJkTif43HLsuq0BJBsSvH9LqWoUW1pHTFsxUhOXD5
         IB9ktmSkLK2EvDAaH2ZLG48nsKecHqpsTY5wFSPwLdAxuBK8CR7mikbVtzUeqsTTM3
         1ZdP0LMBtZkLdDUN0omZS+c3i4WEL5S1+ag4UuxY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 023/103] ARM: dts: exynos: Fix regulators configuration on Peach Pi/Pit Chromebooks
Date:   Fri,  8 Nov 2019 06:41:48 -0500
Message-Id: <20191108114310.14363-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114310.14363-1-sashal@kernel.org>
References: <20191108114310.14363-1-sashal@kernel.org>
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
index 7ccee2cfe4812..442161d2acd57 100644
--- a/arch/arm/boot/dts/exynos5420-peach-pit.dts
+++ b/arch/arm/boot/dts/exynos5420-peach-pit.dts
@@ -301,6 +301,7 @@
 				regulator-name = "vdd_1v35";
 				regulator-min-microvolt = <1350000>;
 				regulator-max-microvolt = <1350000>;
+				regulator-always-on;
 				regulator-boot-on;
 				regulator-state-mem {
 					regulator-on-in-suspend;
@@ -322,6 +323,7 @@
 				regulator-name = "vdd_2v";
 				regulator-min-microvolt = <2000000>;
 				regulator-max-microvolt = <2000000>;
+				regulator-always-on;
 				regulator-boot-on;
 				regulator-state-mem {
 					regulator-on-in-suspend;
@@ -332,6 +334,7 @@
 				regulator-name = "vdd_1v8";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
 				regulator-boot-on;
 				regulator-state-mem {
 					regulator-on-in-suspend;
diff --git a/arch/arm/boot/dts/exynos5800-peach-pi.dts b/arch/arm/boot/dts/exynos5800-peach-pi.dts
index 0900b38f60b4f..58af2254e5212 100644
--- a/arch/arm/boot/dts/exynos5800-peach-pi.dts
+++ b/arch/arm/boot/dts/exynos5800-peach-pi.dts
@@ -301,6 +301,7 @@
 				regulator-name = "vdd_1v35";
 				regulator-min-microvolt = <1350000>;
 				regulator-max-microvolt = <1350000>;
+				regulator-always-on;
 				regulator-boot-on;
 				regulator-state-mem {
 					regulator-on-in-suspend;
@@ -322,6 +323,7 @@
 				regulator-name = "vdd_2v";
 				regulator-min-microvolt = <2000000>;
 				regulator-max-microvolt = <2000000>;
+				regulator-always-on;
 				regulator-boot-on;
 				regulator-state-mem {
 					regulator-on-in-suspend;
@@ -332,6 +334,7 @@
 				regulator-name = "vdd_1v8";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
 				regulator-boot-on;
 				regulator-state-mem {
 					regulator-on-in-suspend;
-- 
2.20.1

