Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D135D1015A1
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730214AbfKSFps (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:45:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:41524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730982AbfKSFpp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:45:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B6E92082F;
        Tue, 19 Nov 2019 05:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142344;
        bh=gQc1TgP91Eg1fBE2eP6CQ+0ionmH6FlDG3R33s8qABo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Poaom7iuWaa9vyumom/6gTe/DRAlzjpxhw+KvvkJZC/WCk2xWOB4oAXHHuVL4ibmT
         zdFgspYoMwKc/doVtFVM305GNjfvelHluWsscj4n+j6dE3uoFF1Ejdvz4w0pVxMyY4
         hrHOoK+0QVPPZC/i/EJBgp5TL0t9JjVjlHeSrV9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 050/239] ARM: dts: exynos: Fix regulators configuration on Peach Pi/Pit Chromebooks
Date:   Tue, 19 Nov 2019 06:17:30 +0100
Message-Id: <20191119051307.357970632@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



