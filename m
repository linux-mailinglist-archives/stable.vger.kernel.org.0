Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 364271FE449
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729880AbgFRBUE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:20:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:52138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730235AbgFRBUC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:20:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2545221F9;
        Thu, 18 Jun 2020 01:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443201;
        bh=qtyltuemiJrZa14Mx2YGmVNcLZew22FaS3WdPlAAHf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wU2SbNsVQ1nx/GNM0tcQpbk3WBR2lAlLxD3ZU7IJR8m3sUlJ2kZHyeSptB2hKI3ml
         GY3voLEjQIAuJWR+Tevaxa0sQwEgdSxpbsl2/dfquSQkevDhWDnWSA2x4zpkEAUwJW
         d7/GTrg3NtZz5WBmJmS9lJ2NXEnLMFvvg7gUo41s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Souptick Joarder <jrdr.linux@gmail.com>, Wu Hao <hao.wu@intel.com>,
        Xu Yilun <yilun.xu@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-fpga@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 160/266] fpga: dfl: afu: Corrected error handling levels
Date:   Wed, 17 Jun 2020 21:14:45 -0400
Message-Id: <20200618011631.604574-160-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Souptick Joarder <jrdr.linux@gmail.com>

[ Upstream commit c9d7e3da1f3c4cf5dddfc5d7ce4d76d013aba1cc ]

Corrected error handling goto sequnece. Level put_pages should
be called when pinned pages >= 0 && pinned != npages. Level
free_pages should be called when pinned pages < 0.

Fixes: fa8dda1edef9 ("fpga: dfl: afu: add DFL_FPGA_PORT_DMA_MAP/UNMAP ioctls support")
Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
Acked-by: Wu Hao <hao.wu@intel.com>
Reviewed-by: Xu Yilun <yilun.xu@intel.com>
Link: https://lore.kernel.org/r/1589825991-3545-1-git-send-email-jrdr.linux@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fpga/dfl-afu-dma-region.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/fpga/dfl-afu-dma-region.c b/drivers/fpga/dfl-afu-dma-region.c
index 62f924489db5..5942343a5d6e 100644
--- a/drivers/fpga/dfl-afu-dma-region.c
+++ b/drivers/fpga/dfl-afu-dma-region.c
@@ -61,10 +61,10 @@ static int afu_dma_pin_pages(struct dfl_feature_platform_data *pdata,
 				     region->pages);
 	if (pinned < 0) {
 		ret = pinned;
-		goto put_pages;
+		goto free_pages;
 	} else if (pinned != npages) {
 		ret = -EFAULT;
-		goto free_pages;
+		goto put_pages;
 	}
 
 	dev_dbg(dev, "%d pages pinned\n", pinned);
-- 
2.25.1

