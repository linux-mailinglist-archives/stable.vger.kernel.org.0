Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D810137FBE
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730768AbgAKKWp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:22:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:48454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730845AbgAKKWo (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:22:44 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63CAC2082E;
        Sat, 11 Jan 2020 10:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738164;
        bh=xYHCqeSqTyw7YMuYYvLayPiWngIzGhgLfcAOH/sluAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aaybgBR5CWYMEQisCXkQMTZam/ut5NVlp+4ddE21jj30A4N2PXGbFdABeU0IsI0Om
         mI43Q4+yeUwBtapx089ttHyjiTZvjO+JbsQyrFS5SA+SDBtfRIk1icJuBwyTfBJr7R
         tsUl5Xc8Hujww7kumLbPXRHXcbBHnGwzwojFBnq0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 041/165] ARM: exynos_defconfig: Restore debugfs support
Date:   Sat, 11 Jan 2020 10:49:20 +0100
Message-Id: <20200111094924.405951844@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit a2315d3aea5976acd919d3d3fcf82f752562c25b ]

Commit 9f532d26c75c ("ARM: exynos_defconfig: Trim and reorganize with
savedefconfig") removed explicit enable line for CONFIG_DEBUG_FS, because
that feature has been selected by other enabled options: CONFIG_TRACING,
which in turn had been selected by CONFIG_PERF_EVENTS and
CONFIG_PROVE_LOCKING.

In meantime, commit 0e4a459f56c3 ("tracing: Remove unnecessary DEBUG_FS
dependency") removed the dependency between CONFIG_DEBUG_FS and
CONFIG_TRACING, so CONFIG_DEBUG_FS is no longer enabled in default builds.

Enable it again explicitly, as debugfs support is essential for various
automated testing tools.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/configs/exynos_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/exynos_defconfig b/arch/arm/configs/exynos_defconfig
index 08db1c83eb2d..736ed7a7bcf8 100644
--- a/arch/arm/configs/exynos_defconfig
+++ b/arch/arm/configs/exynos_defconfig
@@ -348,6 +348,7 @@ CONFIG_PRINTK_TIME=y
 CONFIG_DYNAMIC_DEBUG=y
 CONFIG_DEBUG_INFO=y
 CONFIG_MAGIC_SYSRQ=y
+CONFIG_DEBUG_FS=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_SOFTLOCKUP_DETECTOR=y
 # CONFIG_DETECT_HUNG_TASK is not set
-- 
2.20.1



