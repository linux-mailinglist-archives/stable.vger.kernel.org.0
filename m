Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 456AA4521C3
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348644AbhKPBGl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:06:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:44606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245407AbhKOTUa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B200C6326B;
        Mon, 15 Nov 2021 18:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001234;
        bh=9H8ayQZM9qCb782p3MOUzhUnBt+/ZNb1ZVGB1reZSNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cVBc+BiXmH2ILq5Ej13q62YyyocoyFF6TX+bYpEppoo73sBJkbsHZ8XgdFG4Mtx0r
         0bWkZ/MLv8eBOFTFqt78EPed3j8MQn/3CQZq0a28CsAvMMJrtdx6WjTK4Lcw4TpnZl
         noh2EOgosLalQawwtueqndiIwXNLlQOafrLv8SP4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Virag <virag.david003@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH 5.15 112/917] soc: samsung: exynos-pmu: Fix compilation when nothing selects CONFIG_MFD_CORE
Date:   Mon, 15 Nov 2021 17:53:27 +0100
Message-Id: <20211115165432.546269612@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Virag <virag.david003@gmail.com>

commit e37ef6dcdb1f4738b01cec7fb7be46af07816af9 upstream.

Commit 93618e344a5e ("soc: samsung: exynos-pmu: instantiate clkout
driver as MFD") adds a "devm_mfd_add_devices" call in the exynos-pmu
driver which depends on CONFIG_MFD_CORE. If no driver selects that
config, the build will fail if CONFIG_EXYNOS_PMU is enabled with the
following error:

  drivers/soc/samsung/exynos-pmu.c:137: undefined reference to `devm_mfd_add_devices'

Fix this by making CONFIG_EXYNOS_PMU select CONFIG_MFD_CORE.

Fixes: 93618e344a5e ("soc: samsung: exynos-pmu: instantiate clkout driver as MFD")
Cc: <stable@vger.kernel.org>
Signed-off-by: David Virag <virag.david003@gmail.com>
Link: https://lore.kernel.org/r/20210909222812.108614-1-virag.david003@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/samsung/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/soc/samsung/Kconfig
+++ b/drivers/soc/samsung/Kconfig
@@ -25,6 +25,7 @@ config EXYNOS_PMU
 	bool "Exynos PMU controller driver" if COMPILE_TEST
 	depends on ARCH_EXYNOS || ((ARM || ARM64) && COMPILE_TEST)
 	select EXYNOS_PMU_ARM_DRIVERS if ARM && ARCH_EXYNOS
+	select MFD_CORE
 
 # There is no need to enable these drivers for ARMv8
 config EXYNOS_PMU_ARM_DRIVERS


