Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00FAA469E1
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 22:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727432AbfFNUf4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 16:35:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:52128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726082AbfFNU3u (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 16:29:50 -0400
Received: from sasha-vm.mshome.net (unknown [131.107.159.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6D2E21872;
        Fri, 14 Jun 2019 20:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560544190;
        bh=8R9UtRUVNBE2uIU81fb/ltKXzKjxnCFxSjBtWSZH3o0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uyjacr4+JNUkqvxRjsRnDFq+zWmoCxKlTuBEvXw+canJyDJYfIf1oGxGIWepKjYX8
         Vq6G0KX3Q1T7FZ+9kthOiEgoBFZl8wFSKsphnEIDymIRT7wT4pYRTohBlJ3JR0yxJ8
         vmwc4SlFcQ9GhGdptvW60E01eCTmckfBCm2uNnjg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Scott Wood <swood@redhat.com>, Wu Hao <hao.wu@intel.com>,
        Moritz Fischer <mdf@kernel.org>, Alan Tull <atull@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-fpga@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 06/39] fpga: dfl: afu: Pass the correct device to dma_mapping_error()
Date:   Fri, 14 Jun 2019 16:29:11 -0400
Message-Id: <20190614202946.27385-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190614202946.27385-1-sashal@kernel.org>
References: <20190614202946.27385-1-sashal@kernel.org>
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
index 0e81d33af856..c9a613dc9eb7 100644
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

