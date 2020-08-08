Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EBE823FB0E
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 01:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbgHHXiP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 19:38:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:51894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726458AbgHHXiN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Aug 2020 19:38:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FA572075D;
        Sat,  8 Aug 2020 23:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596929892;
        bh=CD3HPUADLYe44TSi72mJmigB4TKXwZYje3mQ+Tm1oJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=erAnDbao+nv0U1KfIjw0aYHeWLKVu3SUPwmGO8wajin/mB7JW66jTsIDl9RbaUzTZ
         6UyY9fuZwpyk2wYyIalhNwAmWJgESptS+iPuj3zTW+aIpDiHo61SQQdu4SzAiBXL9V
         or/E3hdQQv2ZhqNvyd1LM9Jlyu1wNxLyBm8wlWFM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Willy Wolff <willy.mh.wolff.ml@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 33/58] ARM: dts: exynos: Disable frequency scaling for FSYS bus on Odroid XU3 family
Date:   Sat,  8 Aug 2020 19:36:59 -0400
Message-Id: <20200808233724.3618168-33-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200808233724.3618168-1-sashal@kernel.org>
References: <20200808233724.3618168-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 9ff416cf45a08f28167b75045222c762a0347930 ]

Commit 1019fe2c7280 ("ARM: dts: exynos: Adjust bus related OPPs to the
values correct for Exynos5422 Odroids") changed the parameters of the
OPPs for the FSYS bus. Besides the frequency adjustments, it also removed
the 'shared-opp' property from the OPP table used for FSYS_APB and FSYS
busses.

This revealed that in fact the FSYS bus frequency scaling never worked.
When one OPP table is marked as 'opp-shared', only the first bus which
selects the OPP sets the rate of its clock. Then OPP core assumes that
the other busses have been changed to that OPP and no change to their
clock rates are needed. Thus when FSYS_APB bus, which was registered
first, set the rate for its clock, the OPP core did not change the FSYS
bus clock later.

The mentioned commit removed that behavior, what introduced a regression
on some Odroid XU3 boards. Frequency scaling of the FSYS bus causes
instability of the USB host operation, what can be observed as network
hangs. To restore old behavior, simply disable frequency scaling for the
FSYS bus.

Reported-by: Willy Wolff <willy.mh.wolff.ml@gmail.com>
Fixes: 1019fe2c7280 ("ARM: dts: exynos: Adjust bus related OPPs to the values correct for Exynos5422 Odroids")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos5422-odroid-core.dtsi | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5422-odroid-core.dtsi b/arch/arm/boot/dts/exynos5422-odroid-core.dtsi
index ab27ff8bc3dca..afe090578e8fa 100644
--- a/arch/arm/boot/dts/exynos5422-odroid-core.dtsi
+++ b/arch/arm/boot/dts/exynos5422-odroid-core.dtsi
@@ -411,12 +411,6 @@ &bus_fsys_apb {
 	status = "okay";
 };
 
-&bus_fsys {
-	operating-points-v2 = <&bus_fsys2_opp_table>;
-	devfreq = <&bus_wcore>;
-	status = "okay";
-};
-
 &bus_fsys2 {
 	operating-points-v2 = <&bus_fsys2_opp_table>;
 	devfreq = <&bus_wcore>;
-- 
2.25.1

