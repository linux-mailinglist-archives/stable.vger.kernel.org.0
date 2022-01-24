Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2793C4998F4
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1453800AbiAXVa4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:30:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1450658AbiAXVVI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:21:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E526C0A1CC9;
        Mon, 24 Jan 2022 12:15:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E2A06090A;
        Mon, 24 Jan 2022 20:15:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05571C340E7;
        Mon, 24 Jan 2022 20:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055306;
        bh=EQgJcpJ3xDhR+aLU+qaa8lV9sTNGFx9W2zY4TtRUjWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZS6oPQKrejsjkXJxyLgNTyjt+OjJyZOTHHt7hUOE2U6r+j+Wo9/8G0HRSl836Pt1W
         PygzwVOH3C5VX8J5Sm0zTuRiCYgwEsQ7zv7hgPoI3oTohzgYC2GP0ahvVRAsp24cPT
         dOswTkPaeqZ73JHDvPHJJ9AlZtga8pqGT8hyf7fs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dillon Min <dillon.minfei@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 107/846] media: videobuf2: Fix the size printk format
Date:   Mon, 24 Jan 2022 19:33:44 +0100
Message-Id: <20220124184104.679014327@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dillon Min <dillon.minfei@gmail.com>

[ Upstream commit c9ee220d76775e42f35d634479c978d9350077d3 ]

Since the type of parameter size is unsigned long,
it should printk by %lu, instead of %ld, fix it.

Fixes: 7952be9b6ece ("media: drivers/media/common/videobuf2: rename from videobuf")
Signed-off-by: Dillon Min <dillon.minfei@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/common/videobuf2/videobuf2-dma-contig.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-dma-contig.c b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
index be376f3011b68..f8c65b0401054 100644
--- a/drivers/media/common/videobuf2/videobuf2-dma-contig.c
+++ b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
@@ -157,7 +157,7 @@ static void *vb2_dc_alloc(struct vb2_buffer *vb,
 				      GFP_KERNEL | vb->vb2_queue->gfp_flags,
 				      buf->attrs);
 	if (!buf->cookie) {
-		dev_err(dev, "dma_alloc_coherent of size %ld failed\n", size);
+		dev_err(dev, "dma_alloc_coherent of size %lu failed\n", size);
 		kfree(buf);
 		return ERR_PTR(-ENOMEM);
 	}
@@ -204,9 +204,9 @@ static int vb2_dc_mmap(void *buf_priv, struct vm_area_struct *vma)
 
 	vma->vm_ops->open(vma);
 
-	pr_debug("%s: mapped dma addr 0x%08lx at 0x%08lx, size %ld\n",
-		__func__, (unsigned long)buf->dma_addr, vma->vm_start,
-		buf->size);
+	pr_debug("%s: mapped dma addr 0x%08lx at 0x%08lx, size %lu\n",
+		 __func__, (unsigned long)buf->dma_addr, vma->vm_start,
+		 buf->size);
 
 	return 0;
 }
-- 
2.34.1



