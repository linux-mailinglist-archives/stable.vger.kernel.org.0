Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D09F247781
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732632AbgHQTtm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:49:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:41682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729242AbgHQPUD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:20:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C2C0207D3;
        Mon, 17 Aug 2020 15:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677600;
        bh=CD3HPUADLYe44TSi72mJmigB4TKXwZYje3mQ+Tm1oJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rEgcM+IOxLhdwTu1eZSQPbNBLOJVuyny+ibp9Th6v+/IkfZV6tMtg77KTMCOrUEoZ
         KiFpJsLCt03DPCVE0qAP7+qzPkpHsG1KafxvRlXNeQh9Q1byhn/1YvFDiNE0OokHi6
         wM7J4gFiQJ81vEoSR9sDahq77jHrBU8H2O6NNvxw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Willy Wolff <willy.mh.wolff.ml@gmail.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 040/464] ARM: dts: exynos: Disable frequency scaling for FSYS bus on Odroid XU3 family
Date:   Mon, 17 Aug 2020 17:09:53 +0200
Message-Id: <20200817143835.674186075@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



