Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94448498F27
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357606AbiAXTvD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:51:03 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39434 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355810AbiAXToB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:44:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EAB961551;
        Mon, 24 Jan 2022 19:44:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B611C340E5;
        Mon, 24 Jan 2022 19:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053439;
        bh=6QMkhBO2A5xRflXt1DL3EZsmSg63ySjvEOpDd53WQDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=00//uaMMfHT9pOlNg+UzgBTfkhWXJkjkG/NTcFR0piyPQCBZcmjq6BhJaytBRkzgp
         QfmTbegaLXEZigDycrYOg17cPKfMIULqhksedhbDYUzfW+NKCvhG0ZJqBZDnnvKIkn
         CnIufwUDDFqN3w34wbfZoeTyIHlefjP9WNvqgOrE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dillon Min <dillon.minfei@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 064/563] media: videobuf2: Fix the size printk format
Date:   Mon, 24 Jan 2022 19:37:09 +0100
Message-Id: <20220124184026.623024397@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
index 2f3a5996d3fc9..fe626109ef4db 100644
--- a/drivers/media/common/videobuf2/videobuf2-dma-contig.c
+++ b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
@@ -150,7 +150,7 @@ static void *vb2_dc_alloc(struct device *dev, unsigned long attrs,
 	buf->cookie = dma_alloc_attrs(dev, size, &buf->dma_addr,
 					GFP_KERNEL | gfp_flags, buf->attrs);
 	if (!buf->cookie) {
-		dev_err(dev, "dma_alloc_coherent of size %ld failed\n", size);
+		dev_err(dev, "dma_alloc_coherent of size %lu failed\n", size);
 		kfree(buf);
 		return ERR_PTR(-ENOMEM);
 	}
@@ -196,9 +196,9 @@ static int vb2_dc_mmap(void *buf_priv, struct vm_area_struct *vma)
 
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



