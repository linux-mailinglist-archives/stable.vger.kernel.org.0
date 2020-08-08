Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3580E23FA33
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 01:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728881AbgHHXkn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 19:40:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:56324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728100AbgHHXkm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Aug 2020 19:40:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96DC72053B;
        Sat,  8 Aug 2020 23:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596930041;
        bh=y9ShighU1IxoGurbS7G9NRZYkUnFsrUe92tmo3VmKjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GwE93T0oCYDfK3B0jCBFLfEWLZj0/Wuj0qKD1OMqpGgxPWLSdBHv9syKuunf2YI7g
         Vdv+qDe3UAw0A1zR22DvS1FzBvGVErO8JWmygIJI85nypXBWvBvGl6xmc67Mdmy+4q
         IMVTFmxJxOkyg+5qME2v30LeSrk/8ShMokKfN0GI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 3/9] arm64: dts: exynos: Fix silent hang after boot on Espresso
Date:   Sat,  8 Aug 2020 19:40:30 -0400
Message-Id: <20200808234037.3619732-3-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200808234037.3619732-1-sashal@kernel.org>
References: <20200808234037.3619732-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alim Akhtar <alim.akhtar@samsung.com>

[ Upstream commit b072714bfc0e42c984b8fd6e069f3ca17de8137a ]

Once regulators are disabled after kernel boot, on Espresso board silent
hang observed because of LDO7 being disabled.  LDO7 actually provide
power to CPU cores and non-cpu blocks circuitries.  Keep this regulator
always-on to fix this hang.

Fixes: 9589f7721e16 ("arm64: dts: Add S2MPS15 PMIC node on exynos7-espresso")
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/exynos/exynos7-espresso.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/exynos/exynos7-espresso.dts b/arch/arm64/boot/dts/exynos/exynos7-espresso.dts
index c528dd52ba2d3..2f7d144d556da 100644
--- a/arch/arm64/boot/dts/exynos/exynos7-espresso.dts
+++ b/arch/arm64/boot/dts/exynos/exynos7-espresso.dts
@@ -131,6 +131,7 @@ ldo7_reg: LDO7 {
 				regulator-min-microvolt = <700000>;
 				regulator-max-microvolt = <1150000>;
 				regulator-enable-ramp-delay = <125>;
+				regulator-always-on;
 			};
 
 			ldo8_reg: LDO8 {
-- 
2.25.1

