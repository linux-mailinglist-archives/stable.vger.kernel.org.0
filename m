Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48ACA3B622A
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234854AbhF1OmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:42:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:44258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235625AbhF1OkN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:40:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBB1A61C91;
        Mon, 28 Jun 2021 14:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890805;
        bh=oa7YIGmvmpWfnMERZOZgKjgMKcnRpGgwQeVF5chM97Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SQRAslQtdbEV3SOaLdQb580Xw6TjG6+J6i3BosLUxYX5tk4RrD1r5mgnXojXuGCl4
         lFWKTyxILMFLGcdbU+s9qdVwaIPehYZzaGBDWoRCZeH+EnsVqad3IDaYq6SzA/PcB3
         Ytq77JBrck4I7NWmxsz/MDw1tCl0uG3keAmumeArnvZUKgEXOqCt5gb79MznVQTxj4
         gXe/FCROhtXxWdF6Cn5vIi0NVwxmCpinbDKxtR9P7hAU6EwOvzZ2VQO8RdsjVoXlQp
         StKQ1UiSV6kfjCDwG5Xbe/AN9WR4A8F1qJxIMJMczUmWx+R6Ytx8Sue3K8BNbR0X6B
         eYx05lHcSFE0A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>, Stefan Roese <sr@denx.de>,
        Vinod Koul <vkoul@kernel.org>, dmaengine@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 021/109] dmaengine: ALTERA_MSGDMA depends on HAS_IOMEM
Date:   Mon, 28 Jun 2021 10:31:37 -0400
Message-Id: <20210628143305.32978-22-sashal@kernel.org>
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

[ Upstream commit 253697b93c2a1c237d34d3ae326e394aeb0ca7b3 ]

When CONFIG_HAS_IOMEM is not set/enabled, certain iomap() family
functions [including ioremap(), devm_ioremap(), etc.] are not
available.
Drivers that use these functions should depend on HAS_IOMEM so that
they do not cause build errors.

Repairs this build error:
s390-linux-ld: drivers/dma/altera-msgdma.o: in function `request_and_map':
altera-msgdma.c:(.text+0x14b0): undefined reference to `devm_ioremap'

Fixes: a85c6f1b2921 ("dmaengine: Add driver for Altera / Intel mSGDMA IP core")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Stefan Roese <sr@denx.de>
Cc: Vinod Koul <vkoul@kernel.org>
Cc: dmaengine@vger.kernel.org
Reviewed-by: Stefan Roese <sr@denx.de>
Phone: (+49)-8142-66989-51 Fax: (+49)-8142-66989-80 Email: sr@denx.de
Link: https://lore.kernel.org/r/20210522021313.16405-2-rdunlap@infradead.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index a4f95574eb9a..52dd4bd7c209 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -58,6 +58,7 @@ config DMA_OF
 #devices
 config ALTERA_MSGDMA
 	tristate "Altera / Intel mSGDMA Engine"
+	depends on HAS_IOMEM
 	select DMA_ENGINE
 	help
 	  Enable support for Altera / Intel mSGDMA controller.
-- 
2.30.2

