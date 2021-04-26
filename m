Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F57836AD40
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbhDZHdW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:33:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:45082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232650AbhDZHdO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:33:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4C4961041;
        Mon, 26 Apr 2021 07:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422352;
        bh=vKweCKWSIkgNbcEEo2obRL3rL/LqXkVVwAvne2xhoAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hfDiHAidk2UH9J+JN2Gn5B7aHYf6/FVaucFGx5ShVJxgN6c4dBJ+2ofTBtKz5cLNs
         jO9Mb3kFwS7IWKmFhUQ5ONFrwLK/JBCy6jnTJQ8Um/lbOz9PvgcDnpZn8nyNvk7Mmz
         4GSkyMWxSVA1jzezcCploy8qpCf0EueBrDMc0WFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 03/37] dmaengine: dw: Make it dependent to HAS_IOMEM
Date:   Mon, 26 Apr 2021 09:29:04 +0200
Message-Id: <20210426072817.369583552@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072817.245304364@linuxfoundation.org>
References: <20210426072817.245304364@linuxfoundation.org>
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
index e00c9b022964..6ea3e95c287b 100644
--- a/drivers/dma/dw/Kconfig
+++ b/drivers/dma/dw/Kconfig
@@ -11,6 +11,7 @@ config DW_DMAC_BIG_ENDIAN_IO
 
 config DW_DMAC
 	tristate "Synopsys DesignWare AHB DMA platform driver"
+	depends on HAS_IOMEM
 	select DW_DMAC_CORE
 	select DW_DMAC_BIG_ENDIAN_IO if AVR32
 	default y if CPU_AT32AP7000
@@ -21,6 +22,7 @@ config DW_DMAC
 config DW_DMAC_PCI
 	tristate "Synopsys DesignWare AHB DMA PCI driver"
 	depends on PCI
+	depends on HAS_IOMEM
 	select DW_DMAC_CORE
 	help
 	  Support the Synopsys DesignWare AHB DMA controller on the
-- 
2.30.2



