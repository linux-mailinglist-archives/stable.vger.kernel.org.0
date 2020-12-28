Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21BF32E40DC
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389882AbgL1O6q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:58:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:49580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440484AbgL1OOq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:14:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 484872063A;
        Mon, 28 Dec 2020 14:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164845;
        bh=pQKWXOZ5V9CeMrt1ZTHykB/khVq3Jm9H8wkFfRqg76o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mAWr6iGAPb4cA20Qa38fwgh/2G3rpXaB3ou62qY919PB5ETuWs5TxEg1vS8ZcKC0a
         WLxiwJj2h0H++a0alKkdE5iacDhlzZZarD7gA+b0vtjoPh9vHtbq5j995HX9+y9M2s
         FdYaML8YvNPtN+RncooSn0GFAGZA0tqsYycmRskU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 320/717] drm/msm: add IOMMU_SUPPORT dependency
Date:   Mon, 28 Dec 2020 13:45:18 +0100
Message-Id: <20201228125036.367073525@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit e319a1b956f785f618611857cd946dca2bb68542 ]

The iommu pgtable support is only available when IOMMU support
is built into the kernel:

WARNING: unmet direct dependencies detected for IOMMU_IO_PGTABLE
  Depends on [n]: IOMMU_SUPPORT [=n]
  Selected by [y]:
  - DRM_MSM [=y] && HAS_IOMEM [=y] && DRM [=y] && (ARCH_QCOM [=y] || SOC_IMX5 || ARM && COMPILE_TEST [=y]) && OF [=y] && COMMON_CLK [=y] && MMU [=y] && (QCOM_OCMEM [=y] || QCOM_OCMEM [=y]=n)

Fix the dependency accordingly. There is no need for depending on
CONFIG_MMU any more, as that is implied by the iommu support.

Fixes: b145c6e65eb0 ("drm/msm: Add support to create a local pagetable")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/Kconfig b/drivers/gpu/drm/msm/Kconfig
index e5816b4984942..dabb4a1ccdcf7 100644
--- a/drivers/gpu/drm/msm/Kconfig
+++ b/drivers/gpu/drm/msm/Kconfig
@@ -4,8 +4,8 @@ config DRM_MSM
 	tristate "MSM DRM"
 	depends on DRM
 	depends on ARCH_QCOM || SOC_IMX5 || (ARM && COMPILE_TEST)
+	depends on IOMMU_SUPPORT
 	depends on OF && COMMON_CLK
-	depends on MMU
 	depends on QCOM_OCMEM || QCOM_OCMEM=n
 	select IOMMU_IO_PGTABLE
 	select QCOM_MDT_LOADER if ARCH_QCOM
-- 
2.27.0



