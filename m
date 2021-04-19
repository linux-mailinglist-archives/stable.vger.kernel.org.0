Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1CE536440F
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhDSNZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:25:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:56846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239801AbhDSNW5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:22:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21BC4613BC;
        Mon, 19 Apr 2021 13:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838302;
        bh=DeVjNfLZq/iz/XEz4j6tUWsqTE14MLD9ZjyI2n5Dy3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AZaL36miBDnAuEwiBr/BfMkP++4kbnQ/8Wx8Ip4JIphpGP6yubVafFOQUPhzFCdjW
         tF8myIBrb8zPvxIN0RzDM+bDfeyqOvxqxa8Rku/CpBLj2l2ksO2JA/klCEHHsdLvJH
         xRHiNXztj8w9+CooE/6ORV9L/O8pZNOxPUtfj2Aw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 12/73] dmaengine: dw: Make it dependent to HAS_IOMEM
Date:   Mon, 19 Apr 2021 15:06:03 +0200
Message-Id: <20210419130524.214997444@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130523.802169214@linuxfoundation.org>
References: <20210419130523.802169214@linuxfoundation.org>
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
index e5162690de8f..db25f9b7778c 100644
--- a/drivers/dma/dw/Kconfig
+++ b/drivers/dma/dw/Kconfig
@@ -10,6 +10,7 @@ config DW_DMAC_CORE
 
 config DW_DMAC
 	tristate "Synopsys DesignWare AHB DMA platform driver"
+	depends on HAS_IOMEM
 	select DW_DMAC_CORE
 	help
 	  Support the Synopsys DesignWare AHB DMA controller. This
@@ -18,6 +19,7 @@ config DW_DMAC
 config DW_DMAC_PCI
 	tristate "Synopsys DesignWare AHB DMA PCI driver"
 	depends on PCI
+	depends on HAS_IOMEM
 	select DW_DMAC_CORE
 	help
 	  Support the Synopsys DesignWare AHB DMA controller on the
-- 
2.30.2



