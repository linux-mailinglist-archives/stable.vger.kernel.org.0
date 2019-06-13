Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD7243F6B
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 17:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390044AbfFMP5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:57:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:38328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731511AbfFMIut (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:50:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7125D206BA;
        Thu, 13 Jun 2019 08:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415848;
        bh=iPQyzFyu/DJUnD58qCjst1RdZFHsY0k4sa2RQWZzIdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WW/cxuPQBm4KfRb4+Yhcz4UV6+q+DoX8zKngqU1QpXqCcqeqYHNaqoLVZApD8INur
         yf5SNa+bxaecLg+3DNlHr8AUgFH9iwwLV37rbFuasQZ2XsDVDJ9KnWBG81USq2BVWT
         P00H3i/UnuacBVbhSp842KqphKeccB0ttXJSWlxc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 144/155] ARM: dts: exynos: Always enable necessary APIO_1V8 and ABB_1V8 regulators on Arndale Octa
Date:   Thu, 13 Jun 2019 10:34:16 +0200
Message-Id: <20190613075701.051910091@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5ab99cf7d5e96e3b727c30e7a8524c976bd3723d ]

The PVDD_APIO_1V8 (LDO2) and PVDD_ABB_1V8 (LDO8) regulators were turned
off by Linux kernel as unused.  However they supply critical parts of
SoC so they should be always on:

1. PVDD_APIO_1V8 supplies SYS pins (gpx[0-3], PSHOLD), HDMI level shift,
   RTC, VDD1_12 (DRAM internal 1.8 V logic), pull-up for PMIC interrupt
   lines, TTL/UARTR level shift, reset pins and SW-TACT1 button.
   It also supplies unused blocks like VDDQ_SRAM (for SROM controller) and
   VDDQ_GPIO (gpm7, gpy7).
   The LDO2 cannot be turned off (S2MPS11 keeps it on anyway) so
   marking it "always-on" only reflects its real status.

2. PVDD_ABB_1V8 supplies Adaptive Body Bias Generator for ARM cores,
   memory and Mali (G3D).

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos5420-arndale-octa.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5420-arndale-octa.dts b/arch/arm/boot/dts/exynos5420-arndale-octa.dts
index 3447160e1fbf..a0e27e1c0feb 100644
--- a/arch/arm/boot/dts/exynos5420-arndale-octa.dts
+++ b/arch/arm/boot/dts/exynos5420-arndale-octa.dts
@@ -107,6 +107,7 @@
 				regulator-name = "PVDD_APIO_1V8";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
 			};
 
 			ldo3_reg: LDO3 {
@@ -145,6 +146,7 @@
 				regulator-name = "PVDD_ABB_1V8";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
 			};
 
 			ldo9_reg: LDO9 {
-- 
2.20.1



