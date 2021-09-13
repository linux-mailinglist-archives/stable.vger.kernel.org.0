Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3737C408FB0
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243281AbhIMNpp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:45:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:46598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241272AbhIMNoE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:44:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 020F061425;
        Mon, 13 Sep 2021 13:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539849;
        bh=EgO6sYQfPjUJniOvDyLLumb8s3xF/Xj+KqRk5GXmljY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PAu98zaQoNOmTfoor4t6Emfl9sG9OuWDjwiIUL3xos0h0tkLSedayrAXS00IL4RA0
         Wj6bjDUZVyfRoKD7Vy3PYjPjuYkT4l/AgsNZARi178zstgwZPYMn03JirGQlPsFBGx
         oOypm9Cg0/7w3oBGJZlmaJh4+gKEPKDQGpJYS6Bc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Chunyan Zhang <zhang.chunyan@linaro.org>,
        Faiz Abbas <faiz_abbas@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Vinod Koul <vkoul@kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 186/236] mmc: sdhci: Fix issue with uninitialized dma_slave_config
Date:   Mon, 13 Sep 2021 15:14:51 +0200
Message-Id: <20210913131106.705012633@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 522654d534d315d540710124c57b49ca22ac5f72 ]

Depending on the DMA driver being used, the struct dma_slave_config may
need to be initialized to zero for the unused data.

For example, we have three DMA drivers using src_port_window_size and
dst_port_window_size. If these are left uninitialized, it can cause DMA
failures at least if external TI SDMA is ever configured for sdhci.

For other external DMA cases, this is probably not currently an issue but
is still good to fix though.

Fixes: 18e762e3b7a7 ("mmc: sdhci: add support for using external DMA devices")
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Chunyan Zhang <zhang.chunyan@linaro.org>
Cc: Faiz Abbas <faiz_abbas@ti.com>
Cc: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Cc: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Link: https://lore.kernel.org/r/20210810081644.19353-1-tony@atomide.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 6cdadbb3accd..b1e1d327cb8e 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1223,6 +1223,7 @@ static int sdhci_external_dma_setup(struct sdhci_host *host,
 	if (!host->mapbase)
 		return -EINVAL;
 
+	memset(&cfg, 0, sizeof(cfg));
 	cfg.src_addr = host->mapbase + SDHCI_BUFFER;
 	cfg.dst_addr = host->mapbase + SDHCI_BUFFER;
 	cfg.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
-- 
2.30.2



