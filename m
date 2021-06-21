Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D380A3AED6E
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbhFUQUI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:20:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231246AbhFUQTl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:19:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AE9C611CE;
        Mon, 21 Jun 2021 16:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292246;
        bh=E8JORQseppBmhQ9GAMEjDRjxh+lsXaikuKwER4tJwKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SeoHLgu7IH/xeIlHBRXcyC11Az3pQbx99kaoLtj6AlffwVT1vCzT9xmQMyvjNxreT
         j7Q8pyPHLzdm/Kgns+2rj5L3uT+0FQ1Q3ceu/ssDOAnB+JQwMe+V7eRKI13dyX1BNR
         Damhd5YpMcsQJFdr0Eii/m5HGvj+5pdFyvmBMxq0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Sinan Kaya <okaya@codeaurora.org>,
        Vinod Koul <vkoul@kernel.org>, dmaengine@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 02/90] dmaengine: QCOM_HIDMA_MGMT depends on HAS_IOMEM
Date:   Mon, 21 Jun 2021 18:14:37 +0200
Message-Id: <20210621154904.247200835@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154904.159672728@linuxfoundation.org>
References: <20210621154904.159672728@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 1d189438aeb0..bef309ef6a71 100644
--- a/drivers/dma/qcom/Kconfig
+++ b/drivers/dma/qcom/Kconfig
@@ -10,6 +10,7 @@ config QCOM_BAM_DMA
 
 config QCOM_HIDMA_MGMT
 	tristate "Qualcomm Technologies HIDMA Management support"
+	depends on HAS_IOMEM
 	select DMA_ENGINE
 	help
 	  Enable support for the Qualcomm Technologies HIDMA Management.
-- 
2.30.2



