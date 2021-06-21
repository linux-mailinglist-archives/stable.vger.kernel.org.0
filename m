Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3D243AEE22
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbhFUQZx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:25:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:42736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230304AbhFUQYT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:24:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 888B8611BD;
        Mon, 21 Jun 2021 16:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292472;
        bh=drezTIm5NXAag9VITwUk03/tBNhHUWrIQdZSgd+d5GY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GOBoWDRwHXJuwObwdc7V/nYiglocqNZUTdfHQFEHP8osxhwL3qraC0ak6nJ5qXI2N
         HYWbt1LwojUJ1hkhVgmybwF+RN0g2Y6yYkJErRYNghi9cQH6ZyoxRNKf/JzewHaZAa
         CSsfCjVZ0xcdq0XaV7vpfy81EHXdlbeRArxYZhp8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Sinan Kaya <okaya@codeaurora.org>,
        Vinod Koul <vkoul@kernel.org>, dmaengine@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 005/146] dmaengine: QCOM_HIDMA_MGMT depends on HAS_IOMEM
Date:   Mon, 21 Jun 2021 18:13:55 +0200
Message-Id: <20210621154911.434083731@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
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
index 3bcb689162c6..ef038f3c5e32 100644
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



