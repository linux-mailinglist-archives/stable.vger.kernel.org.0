Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 160C4FEF8C
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 16:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729107AbfKPP7m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:59:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:35220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731333AbfKPPxy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:53:54 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76E902184B;
        Sat, 16 Nov 2019 15:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919633;
        bh=g8qwpXtgl8IM5Jzu0ga/wmRPoMvRpo/KhSdJYLHxgnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MiISpFT/2UsTGfXDndiy2fp78fMbNlt7GpTOUBFtyjW9hmNqPxCwXEFm2XCwUxDS0
         hTY9H+pgMTys2OgG/DeRee71iNVwUFbGS3Sk3j77agR5tBE8NMGpjPVUgvk8Ooc619
         8Q2mm/QA7b3naG/1RE48/p0UCF5xr/mLjkP1SBho=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wenwen Wang <wang6495@umn.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 12/77] misc: mic: fix a DMA pool free failure
Date:   Sat, 16 Nov 2019 10:52:34 -0500
Message-Id: <20191116155339.11909-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116155339.11909-1-sashal@kernel.org>
References: <20191116155339.11909-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 7f2c96f570667..6821d9d415854 100644
--- a/drivers/misc/mic/scif/scif_fence.c
+++ b/drivers/misc/mic/scif/scif_fence.c
@@ -271,7 +271,7 @@ static int _scif_prog_signal(scif_epd_t epd, dma_addr_t dst, u64 val)
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

