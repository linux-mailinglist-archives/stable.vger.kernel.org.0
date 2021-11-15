Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36785451F13
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355483AbhKPAi0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:38:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:45402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344478AbhKOTYs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAE456367E;
        Mon, 15 Nov 2021 18:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002701;
        bh=AFsCuftF9z9go0FzPJeD93XQ71yWOe7BMJV5lhIjACU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yulr2UegdlL6LvhfCeyV2BJyZ/AbEDL+yr4jMSI4C8UCTQSJOnLhmEnwaG9FcXtc5
         lJxccrbguUF4pcDOuZjCg7YSVcllZkOIPjl2s1csF+pJx6C0Gr5/mCe4AezrKMO6TH
         Leihp5fQ67hbNn6h3VuKGoha2abM+JOQh1exoj2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Logan Gunthorpe <logang@deltatee.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 632/917] RDMA/core: Set sgtable nents when using ib_dma_virt_map_sg()
Date:   Mon, 15 Nov 2021 18:02:07 +0100
Message-Id: <20211115165450.240054013@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Logan Gunthorpe <logang@deltatee.com>

[ Upstream commit ac0fffa0859b8e1e991939663b3ebdd80bf979e6 ]

ib_dma_map_sgtable_attrs() should be mapping the sgls and setting nents
but the ib_uses_virt_dma() path falls back to ib_dma_virt_map_sg() which
will not set the nents in the sgtable.

Check the return value (per the map_sg calling convention) and set
sgt->nents appropriately on success.

Fixes: 79fbd3e1241c ("RDMA: Use the sg_table directly and remove the opencoded version from umem")
Link: https://lore.kernel.org/r/20211013165942.89806-1-logang@deltatee.com
Reported-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Tested-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/rdma/ib_verbs.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 4b50d9a3018a6..4ba642fc8a19a 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -4097,8 +4097,13 @@ static inline int ib_dma_map_sgtable_attrs(struct ib_device *dev,
 					   enum dma_data_direction direction,
 					   unsigned long dma_attrs)
 {
+	int nents;
+
 	if (ib_uses_virt_dma(dev)) {
-		ib_dma_virt_map_sg(dev, sgt->sgl, sgt->orig_nents);
+		nents = ib_dma_virt_map_sg(dev, sgt->sgl, sgt->orig_nents);
+		if (!nents)
+			return -EIO;
+		sgt->nents = nents;
 		return 0;
 	}
 	return dma_map_sgtable(dev->dma_device, sgt, direction, dma_attrs);
-- 
2.33.0



