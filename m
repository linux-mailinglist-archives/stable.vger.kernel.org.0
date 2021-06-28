Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 603D43B6239
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234477AbhF1On1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:43:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:51372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234309AbhF1OlZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:41:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E68E061CCD;
        Mon, 28 Jun 2021 14:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890806;
        bh=FMYvws+kWjH2cfK0q5IZM3N/gw5nFfC7NZ3ZH7gG+kc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NK5MKeWiEJFFvntDyOm2VfC28Mg05IzogfQ9P6ECvWrRsuzAkN4avDMRHQ6Cvcuju
         gxRdA8PNm5x+UUKEJy3Ngp1ws4rNQKo2K3FgQPm5Vt7Wu05MvhgPlROTCMBe0dG3NI
         k+cepaNR3mKyrGkmTZCApMD/Wpw5trR7MTvPrONq/KiKL0umLYfHJPuD2bD7srE9EY
         lMeuhJ1MtMX4qLWK+sPcszIJqxwdEvcHucS8pyF6NuYaggZJ9vIyEU2I68O/XbJA7k
         zBRqsfxlh+3BOvbOZMbiBvJvOqNucob0fAtZKyZYvVFmfpkJcqs7lfY6cxt7nO2mGQ
         DCKquCd2V8sUg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Sinan Kaya <okaya@codeaurora.org>,
        Vinod Koul <vkoul@kernel.org>, dmaengine@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 022/109] dmaengine: QCOM_HIDMA_MGMT depends on HAS_IOMEM
Date:   Mon, 28 Jun 2021 10:31:38 -0400
Message-Id: <20210628143305.32978-23-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 0cfbb589d67f16fa55b26ae02b69c31b52e344b1 ]

When CONFIG_HAS_IOMEM is not set/enabled, certain iomap() family
functions [including ioremap(), devm_ioremap(), etc.] are not
available.
Drivers that use these functions should depend on HAS_IOMEM so that
they do not cause build errors.

Rectifies these build errors:
s390-linux-ld: drivers/dma/qcom/hidma_mgmt.o: in function `hidma_mgmt_probe':
hidma_mgmt.c:(.text+0x780): undefined reference to `devm_ioremap_resource'
s390-linux-ld: drivers/dma/qcom/hidma_mgmt.o: in function `hidma_mgmt_init':
hidma_mgmt.c:(.init.text+0x126): undefined reference to `of_address_to_resource'
s390-linux-ld: hidma_mgmt.c:(.init.text+0x16e): undefined reference to `of_address_to_resource'

Fixes: 67a2003e0607 ("dmaengine: add Qualcomm Technologies HIDMA channel driver")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Sinan Kaya <okaya@codeaurora.org>
Cc: Vinod Koul <vkoul@kernel.org>
Cc: dmaengine@vger.kernel.org
Link: https://lore.kernel.org/r/20210522021313.16405-3-rdunlap@infradead.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/qcom/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/qcom/Kconfig b/drivers/dma/qcom/Kconfig
index a7761c4025f4..a97c7123d913 100644
--- a/drivers/dma/qcom/Kconfig
+++ b/drivers/dma/qcom/Kconfig
@@ -9,6 +9,7 @@ config QCOM_BAM_DMA
 
 config QCOM_HIDMA_MGMT
 	tristate "Qualcomm Technologies HIDMA Management support"
+	depends on HAS_IOMEM
 	select DMA_ENGINE
 	help
 	  Enable support for the Qualcomm Technologies HIDMA Management.
-- 
2.30.2

