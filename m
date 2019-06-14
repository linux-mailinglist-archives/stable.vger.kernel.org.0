Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48EF546ADB
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 22:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727629AbfFNUi5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 16:38:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:50700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726627AbfFNU27 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 16:28:59 -0400
Received: from sasha-vm.mshome.net (unknown [131.107.159.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9FAE21841;
        Fri, 14 Jun 2019 20:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560544139;
        bh=sZsDlbJphL6qfeqNsC1sf4lQZa9MU/GVetAs3TUPfmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cKLqhieBhIS4960tan2/sFaDIBCmTLvrK2T5eZWV11bwOI9AEMXwCq4seu+AKm+lE
         J4oQkZ5lrCQmtzioCrlU1l3oK6wP4rJy6xh0B7lASlVNdq7OfoqbjTx1o18jZKRbey
         GDK9lNxqNXAegJG3VpN0idCn1XOltsAI0HZHLwxA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Scott Wood <swood@redhat.com>, Wu Hao <hao.wu@intel.com>,
        Moritz Fischer <mdf@kernel.org>, Alan Tull <atull@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-fpga@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 15/59] fpga: dfl: afu: Pass the correct device to dma_mapping_error()
Date:   Fri, 14 Jun 2019 16:27:59 -0400
Message-Id: <20190614202843.26941-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190614202843.26941-1-sashal@kernel.org>
References: <20190614202843.26941-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Scott Wood <swood@redhat.com>

[ Upstream commit 13069847a475b60069918dc9971f5adb42811ce3 ]

dma_mapping_error() was being called on a different device struct than
what was passed to map/unmap.  Besides rendering the error checking
ineffective, it caused a debug splat with CONFIG_DMA_API_DEBUG.

Signed-off-by: Scott Wood <swood@redhat.com>
Acked-by: Wu Hao <hao.wu@intel.com>
Acked-by: Moritz Fischer <mdf@kernel.org>
Acked-by: Alan Tull <atull@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fpga/dfl-afu-dma-region.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/fpga/dfl-afu-dma-region.c b/drivers/fpga/dfl-afu-dma-region.c
index e18a786fc943..cd68002ac097 100644
--- a/drivers/fpga/dfl-afu-dma-region.c
+++ b/drivers/fpga/dfl-afu-dma-region.c
@@ -399,7 +399,7 @@ int afu_dma_map_region(struct dfl_feature_platform_data *pdata,
 				    region->pages[0], 0,
 				    region->length,
 				    DMA_BIDIRECTIONAL);
-	if (dma_mapping_error(&pdata->dev->dev, region->iova)) {
+	if (dma_mapping_error(dfl_fpga_pdata_to_parent(pdata), region->iova)) {
 		dev_err(&pdata->dev->dev, "failed to map for dma\n");
 		ret = -EFAULT;
 		goto unpin_pages;
-- 
2.20.1

