Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6793866EF3
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727746AbfGLMmW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:42:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:54274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727428AbfGLMUq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:20:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F05F5208E4;
        Fri, 12 Jul 2019 12:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934045;
        bh=8/Qz2aX3souvgmyffd9xNLg5D2ae/5yYYya+OBpprt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fl8w3hEZonKQR3SM1q7tyyLu6MYw6WcKEoXqs6Hejmqi9ACMLzKu4fZQr3Phfulto
         PMRRxhNYqcm1QZHcDzxs13QD2R3kpBkMf/sBZB+BIa7QjlFMEE9WUpWww/7TIgR3Qi
         4iccRz8htoRi3YmZLVJXwAbASwazTgI/7NYxxOOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Hellstrom <thellstrom@vmware.com>,
        Deepak Rawat <drawat@vmware.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 28/91] drm/vmwgfx: Honor the sg list segment size limitation
Date:   Fri, 12 Jul 2019 14:18:31 +0200
Message-Id: <20190712121622.896948621@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121621.422224300@linuxfoundation.org>
References: <20190712121621.422224300@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



