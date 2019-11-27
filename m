Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC3910BD7E
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731173AbfK0U5W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:57:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:48356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731160AbfK0U5V (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:57:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16206217AB;
        Wed, 27 Nov 2019 20:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888240;
        bh=XP4W78k7tWdh+OxHKfg/hOgoXSYlnsAKcT0blXHT8RY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lIy09gT0Kd/hpmtGq7LOBHwevkIa0O0itfClQur5v4GBj76BtaOkt0erWoU5tVyek
         lCUpANb6P7Sz1iNIaESxLKb5Zf3ks+Hd10xsPUIiZ0+zO1zW9BLUe2WL6JC++15U+f
         jEikFba+0nmWFbXljUmN+pVGZITyR/n/KhwfDhus=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenwen Wang <wang6495@umn.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 051/306] misc: mic: fix a DMA pool free failure
Date:   Wed, 27 Nov 2019 21:28:21 +0100
Message-Id: <20191127203118.514644607@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenwen Wang <wang6495@umn.edu>

[ Upstream commit 6b995f4eec34745f6cb20d66d5277611f0b3c3fa ]

In _scif_prog_signal(), the boolean variable 'x100' is used to indicate
whether the MIC Coprocessor is X100. If 'x100' is true, the status
descriptor will be used to write the value to the destination. Otherwise, a
DMA pool will be allocated for this purpose. Specifically, if the DMA pool
is allocated successfully, two memory addresses will be returned. One is
for the CPU and the other is for the device to access the DMA pool. The
former is stored to the variable 'status' and the latter is stored to the
variable 'src'. After the allocation, the address in 'src' is saved to
'status->src_dma_addr', which is actually in the DMA pool, and 'src' is
then modified.

Later on, if an error occurs, the execution flow will transfer to the label
'dma_fail', which will check 'x100' and free up the allocated DMA pool if
'x100' is false. The point here is that 'status->src_dma_addr' is used for
freeing up the DMA pool. As mentioned before, 'status->src_dma_addr' is in
the DMA pool. And thus, the device is able to modify this data. This can
potentially cause failures when freeing up the DMA pool because of the
modified device address.

This patch avoids the above issue by using the variable 'src' (with
necessary calculation) to free up the DMA pool.

Signed-off-by: Wenwen Wang <wang6495@umn.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/mic/scif/scif_fence.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/mic/scif/scif_fence.c b/drivers/misc/mic/scif/scif_fence.c
index cac3bcc308a7e..7bb929f05d852 100644
--- a/drivers/misc/mic/scif/scif_fence.c
+++ b/drivers/misc/mic/scif/scif_fence.c
@@ -272,7 +272,7 @@ static int _scif_prog_signal(scif_epd_t epd, dma_addr_t dst, u64 val)
 dma_fail:
 	if (!x100)
 		dma_pool_free(ep->remote_dev->signal_pool, status,
-			      status->src_dma_addr);
+			      src - offsetof(struct scif_status, val));
 alloc_fail:
 	return err;
 }
-- 
2.20.1



