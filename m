Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7DE46B07
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 22:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727650AbfFNUjW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 16:39:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:50414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726388AbfFNU2v (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 16:28:51 -0400
Received: from sasha-vm.mshome.net (unknown [131.107.159.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6504B2184E;
        Fri, 14 Jun 2019 20:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560544130;
        bh=h6DRz8peL2BXbXkkK36S6N4w4/4bEu/ErJcl08BVaZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ap1n6SCxQ2U3mZpEkAByx96CMXSWZ6yOf44mop0kVWk+gx7VdfaBwVXEebGSMhCkE
         +wujxfMkATrIVztvWYPWOoG0NsrbIcgiBNks8arqEOXlza3LK0mYAv0eY7pcoAFV1X
         xLjHt2cmySB9zeSeokq9Inv6aIs6+b06cv2Hvq5c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Baolin Wang <baolin.wang@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 06/59] dmaengine: sprd: Fix the possible crash when getting descriptor status
Date:   Fri, 14 Jun 2019 16:27:50 -0400
Message-Id: <20190614202843.26941-6-sashal@kernel.org>
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

From: Baolin Wang <baolin.wang@linaro.org>

[ Upstream commit 16d0f85e45b99411ac10cb12cdd9279204a72381 ]

We will get a NULL virtual descriptor by vchan_find_desc() when the descriptor
has been submitted, that will crash the kernel when getting the descriptor
status.

In this case, since the descriptor has been submitted to process, but it
is not completed now, which means the descriptor is listed into the
'vc->desc_submitted' list now. So we can not get current processing descriptor
by vchan_find_desc(), but the pointer 'schan->cur_desc' will point to the
current processing descriptor, then we can use 'schan->cur_desc' to get
current processing descriptor's status to avoid this issue.

Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/sprd-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/sprd-dma.c b/drivers/dma/sprd-dma.c
index 48431e2da987..e29342ab85f6 100644
--- a/drivers/dma/sprd-dma.c
+++ b/drivers/dma/sprd-dma.c
@@ -625,7 +625,7 @@ static enum dma_status sprd_dma_tx_status(struct dma_chan *chan,
 		else
 			pos = 0;
 	} else if (schan->cur_desc && schan->cur_desc->vd.tx.cookie == cookie) {
-		struct sprd_dma_desc *sdesc = to_sprd_dma_desc(vd);
+		struct sprd_dma_desc *sdesc = schan->cur_desc;
 
 		if (sdesc->dir == DMA_DEV_TO_MEM)
 			pos = sprd_dma_get_dst_addr(schan);
-- 
2.20.1

