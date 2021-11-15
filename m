Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1EE450F7D
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241999AbhKOSb4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:31:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:36924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241064AbhKOS3p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:29:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26308632CA;
        Mon, 15 Nov 2021 17:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999109;
        bh=9H8ayQZM9qCb782p3MOUzhUnBt+/ZNb1ZVGB1reZSNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=matdMh0KsjpyTpQnYsII5Aq83/wRGZTG0R6rqmXOI9SfmCCa2vBhv8a+3RZhyAdbw
         DRzfc11Qe+ebW4G3Qsaks0flKIKr3TBowUrAtvMyWp1bc7lnWZSUzYH566s3oXWTpX
         zuKuASEr5Rg1vlhbga0E5//Ojojh5IYlUBRqFSis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Virag <virag.david003@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH 5.14 146/849] soc: samsung: exynos-pmu: Fix compilation when nothing selects CONFIG_MFD_CORE
Date:   Mon, 15 Nov 2021 17:53:49 +0100
Message-Id: <20211115165425.077869346@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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


