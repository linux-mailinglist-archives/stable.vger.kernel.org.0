Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB1D328BE6
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232849AbhCASmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:42:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:47664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240103AbhCASgI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:36:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7AE43614A7;
        Mon,  1 Mar 2021 17:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619086;
        bh=6jIQRV+WkNsAghoEihlNIcK00XqPFCaCirdF3CdE7QE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wfY0r8eQNI7y9Ve8uibzlgj+WPZMcJUM8VI5bNa0yyBNaXzoP6ewmcAgPXCTGzw7s
         L2jADYm7aRO22gPOFu5yRLHMO0jR3zVU4wBfqi2KqhvHdXU0+7oIFuiFLMMgK21LY0
         4dy7jpa9JThHAphVFtu8KdlclTvP5swFuvtg1/rU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinijia Kambham <srinija.kambham@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 296/663] dmaengine: idxd: set DMA channel to be private
Date:   Mon,  1 Mar 2021 17:09:04 +0100
Message-Id: <20210301161156.478538634@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit c06e424be5f5184468c5f761c0d2cf1ed0a4e0fc ]

Add DMA_PRIVATE attribute flag to idxd DMA channels. The dedicated WQs are
expected to be used by a single client and not shared. While doing NTB
testing this mistake was discovered, which prevented ntb_transport from
requesting DSA wqs as DMA channels via dma_request_channel().

Reported-by: Srinijia Kambham <srinija.kambham@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Tested-by: Srinijia Kambham <srinija.kambham@intel.com>
Fixes: 8f47d1a5e545 ("dmaengine: idxd: connect idxd to dmaengine subsystem")
Link: https://lore.kernel.org/r/161074758743.2184057.3388557138816350980.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/dma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/idxd/dma.c b/drivers/dma/idxd/dma.c
index 8b14ba0bae1cd..ec177a535d6dd 100644
--- a/drivers/dma/idxd/dma.c
+++ b/drivers/dma/idxd/dma.c
@@ -174,6 +174,7 @@ int idxd_register_dma_device(struct idxd_device *idxd)
 	INIT_LIST_HEAD(&dma->channels);
 	dma->dev = &idxd->pdev->dev;
 
+	dma_cap_set(DMA_PRIVATE, dma->cap_mask);
 	dma_cap_set(DMA_COMPLETION_NO_ORDER, dma->cap_mask);
 	dma->device_release = idxd_dma_release;
 
-- 
2.27.0



