Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B926137CD5E
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239570AbhELQyp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:54:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:33470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243810AbhELQmG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EFB661C58;
        Wed, 12 May 2021 16:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835634;
        bh=nUrAeYc8W993WQSg5l1CaICN202pFNACmF5WtPmshZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ODPrXiScb1g3srFIpG//mSkcd90Q8JVYPiaE8wkCjgotcD1Vx6o/txF8cIj115Ps5
         Za0eYxfK3CxXWeDIyFx/PnTzxyvijlqZpBuzcx/sldheWJX0U0WtWbAuHk586hfanq
         acvxO8LH/B20pIWKOxsMUibjq9a3FH0DosgDe7bM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 424/677] nvme-pci: dont simple map sgl when sgls are disabled
Date:   Wed, 12 May 2021 16:47:50 +0200
Message-Id: <20210512144851.427491083@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

[ Upstream commit e51183be1fa96dc6d3cd11b3c25a0f595807315e ]

According to the module parameter description for sgl_threshold,
a value of 0 means that SGLs are disabled.

If SGLs are disabled, we should respect that, even for the case
where the request is made up of a single physical segment.

Fixes: 297910571f08 ("nvme-pci: optimize mapping single segment requests using SGLs")
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 7249ae74f71f..c92a15c3fbc5 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -852,7 +852,7 @@ static blk_status_t nvme_map_data(struct nvme_dev *dev, struct request *req,
 				return nvme_setup_prp_simple(dev, req,
 							     &cmnd->rw, &bv);
 
-			if (iod->nvmeq->qid &&
+			if (iod->nvmeq->qid && sgl_threshold &&
 			    dev->ctrl.sgls & ((1 << 0) | (1 << 1)))
 				return nvme_setup_sgl_simple(dev, req,
 							     &cmnd->rw, &bv);
-- 
2.30.2



