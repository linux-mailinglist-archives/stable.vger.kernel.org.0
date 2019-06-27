Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB5E577C0
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 02:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728729AbfF0Ah5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 20:37:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:42360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727270AbfF0Ah4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 20:37:56 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E8132080C;
        Thu, 27 Jun 2019 00:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595875;
        bh=EgQM/TXve2elP/6ZXxEVjCqqSaywt9iJ96wu7+E1KNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uxw2WB5WfOpjYD6SQG3CiTDNFmwz9I1vU2dsbaU5uGAlxZXpznXnlgX9CN4zUyCGp
         cJnJ1UIY45+6LGaEas1GRn9eBv+ld9ytcon4XYL6GgQn4kra25egeB8gKBDKk+2iHi
         jyO+ZmbzHX94de+4wsF1EbxVbEB9V0V473c23bIQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Hellstrom <thellstrom@vmware.com>,
        Deepak Rawat <drawat@vmware.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 32/60] drm/vmwgfx: Honor the sg list segment size limitation
Date:   Wed, 26 Jun 2019 20:35:47 -0400
Message-Id: <20190627003616.20767-32-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003616.20767-1-sashal@kernel.org>
References: <20190627003616.20767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Hellstrom <thellstrom@vmware.com>

[ Upstream commit bde15555ba61c7f664f40fd3c6fdbdb63f784c9b ]

When building sg tables, honor the device sg list segment size limitation.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Reviewed-by: Deepak Rawat <drawat@vmware.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c b/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c
index 31786b200afc..f388ad51e72b 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c
@@ -448,11 +448,11 @@ static int vmw_ttm_map_dma(struct vmw_ttm_tt *vmw_tt)
 		if (unlikely(ret != 0))
 			return ret;
 
-		ret = sg_alloc_table_from_pages(&vmw_tt->sgt, vsgt->pages,
-						vsgt->num_pages, 0,
-						(unsigned long)
-						vsgt->num_pages << PAGE_SHIFT,
-						GFP_KERNEL);
+		ret = __sg_alloc_table_from_pages
+			(&vmw_tt->sgt, vsgt->pages, vsgt->num_pages, 0,
+			 (unsigned long) vsgt->num_pages << PAGE_SHIFT,
+			 dma_get_max_seg_size(dev_priv->dev->dev),
+			 GFP_KERNEL);
 		if (unlikely(ret != 0))
 			goto out_sg_alloc_fail;
 
-- 
2.20.1

