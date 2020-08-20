Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C678B24B437
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729922AbgHTJ7u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:59:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:46160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727794AbgHTJ7t (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:59:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 539372067C;
        Thu, 20 Aug 2020 09:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917588;
        bh=y9ShighU1IxoGurbS7G9NRZYkUnFsrUe92tmo3VmKjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KN1JNKYgYezvCCwNvElB8Ae8YVOix5srGiJgI7sTRD9x1faY8Yg65bilZ+6KNQjza
         60aQrwt2CwtUr5dxI+CjVny128+Gweb3KAaHIatGdwJIyAN4L+9zLE2xYH5sMLZ8EX
         PTZR2QTuBWdo+FuYbJQgXxolxh/BECcjA/FUll88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 084/212] arm64: dts: exynos: Fix silent hang after boot on Espresso
Date:   Thu, 20 Aug 2020 11:20:57 +0200
Message-Id: <20200820091606.601139326@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



