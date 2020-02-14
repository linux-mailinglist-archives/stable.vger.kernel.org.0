Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5DB115F383
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393082AbgBNSMX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 13:12:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:60542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731163AbgBNPxL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:53:11 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 805D324649;
        Fri, 14 Feb 2020 15:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695590;
        bh=kXw+U02kMo5+dBWgsIEkSY6dFpeagC5XzqBhgIO2FW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ufjCryc395phdeWJW7b7cBbBGGoeq6hJ+l67iuqMhLvpx4sT9i/2D0VW4fMRRKvPq
         SyRZiP2+VDFOzLoQE7/DXUSJG/2vMKGzI8EGjxwZALkmGdBs0QlIvmQ+OLn1PCKfNm
         Rd5VlfXJ7P2l9gegiF23n5cNwqHSLrvoiLDCSyIs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 197/542] ARM: exynos_defconfig: Bring back explicitly wanted options
Date:   Fri, 14 Feb 2020 10:43:09 -0500
Message-Id: <20200214154854.6746-197-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 9f9e2df2e64df197ff6548ef494f76be5b35d08a ]

Few options KALLSYMS_ALL, SCSI, PM_DEVFREQ and mutex/spinlock debugging
were removed with savedefconfig because they were selected by other
options.  However these are user-visible options and they might not be
selected in the future.  Exactly this happened with commit 0e4a459f56c3
("tracing: Remove unnecessary DEBUG_FS dependency") removing the
dependency between DEBUG_FS and TRACING.

To avoid losing these options in the future, explicitly mention them in
defconfig.

Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/configs/exynos_defconfig | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/configs/exynos_defconfig b/arch/arm/configs/exynos_defconfig
index fde84f123fbb5..ead8348ec999f 100644
--- a/arch/arm/configs/exynos_defconfig
+++ b/arch/arm/configs/exynos_defconfig
@@ -38,6 +38,7 @@ CONFIG_CRYPTO_SHA256_ARM=m
 CONFIG_CRYPTO_SHA512_ARM=m
 CONFIG_CRYPTO_AES_ARM_BS=m
 CONFIG_CRYPTO_CHACHA20_NEON=m
+CONFIG_KALLSYMS_ALL=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 CONFIG_PARTITION_ADVANCED=y
@@ -92,6 +93,7 @@ CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_CRYPTOLOOP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=8192
+CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_ATA=y
@@ -291,6 +293,7 @@ CONFIG_CROS_EC_SPI=y
 CONFIG_COMMON_CLK_MAX77686=y
 CONFIG_COMMON_CLK_S2MPS11=y
 CONFIG_EXYNOS_IOMMU=y
+CONFIG_PM_DEVFREQ=y
 CONFIG_DEVFREQ_GOV_PERFORMANCE=y
 CONFIG_DEVFREQ_GOV_POWERSAVE=y
 CONFIG_DEVFREQ_GOV_USERSPACE=y
@@ -356,4 +359,7 @@ CONFIG_SOFTLOCKUP_DETECTOR=y
 # CONFIG_DETECT_HUNG_TASK is not set
 CONFIG_PROVE_LOCKING=y
 CONFIG_DEBUG_ATOMIC_SLEEP=y
+CONFIG_DEBUG_RT_MUTEXES=y
+CONFIG_DEBUG_SPINLOCK=y
+CONFIG_DEBUG_MUTEXES=y
 CONFIG_DEBUG_USER=y
-- 
2.20.1

