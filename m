Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9E936AD96
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232233AbhDZHh0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:37:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:46520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232915AbhDZHgj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:36:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FE8D613BC;
        Mon, 26 Apr 2021 07:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422469;
        bh=mQjJ6x20xtSCymemq+yGIgamS3EJ0KEd6zbDPnV6+DU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NcoUXyFGbIAtN2t3uSX7HnUp94vlgozOVZX8LnicNIRwVyU81oXPbqUu8ZDTt96EX
         Blrbm/o+V1VAVpqe0bqPyGT3GMX3pscNXvKnd5IPNeTYRxJpC2JBbGD518E7hfRxwN
         15A/vIQjiaaUgfghyBBUfjUfNoViqAGWEhFVFEbI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 03/49] dmaengine: dw: Make it dependent to HAS_IOMEM
Date:   Mon, 26 Apr 2021 09:28:59 +0200
Message-Id: <20210426072819.834240343@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072819.721586742@linuxfoundation.org>
References: <20210426072819.721586742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 88cd1d6191b13689094310c2405394e4ce36d061 ]

Some architectures do not provide devm_*() APIs. Hence make the driver
dependent on HAVE_IOMEM.

Fixes: dbde5c2934d1 ("dw_dmac: use devm_* functions to simplify code")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Link: https://lore.kernel.org/r/20210324141757.24710-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/dma/dw/Kconfig b/drivers/dma/dw/Kconfig
index 04b9728c1d26..070860ec0ef1 100644
--- a/drivers/dma/dw/Kconfig
+++ b/drivers/dma/dw/Kconfig
@@ -8,6 +8,7 @@ config DW_DMAC_CORE
 
 config DW_DMAC
 	tristate "Synopsys DesignWare AHB DMA platform driver"
+	depends on HAS_IOMEM
 	select DW_DMAC_CORE
 	help
 	  Support the Synopsys DesignWare AHB DMA controller. This
@@ -16,6 +17,7 @@ config DW_DMAC
 config DW_DMAC_PCI
 	tristate "Synopsys DesignWare AHB DMA PCI driver"
 	depends on PCI
+	depends on HAS_IOMEM
 	select DW_DMAC_CORE
 	help
 	  Support the Synopsys DesignWare AHB DMA controller on the
-- 
2.30.2



