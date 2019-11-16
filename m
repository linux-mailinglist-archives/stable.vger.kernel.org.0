Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D64B1FEDFF
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 16:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729992AbfKPPsS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:48:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:55192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729971AbfKPPsN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:48:13 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B4CF20891;
        Sat, 16 Nov 2019 15:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919293;
        bh=+MSac9lGQ3g4tukeHIJJKFOOP18cM1X5Kz249xwJKOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kCKfKUvK/zTfxANLue9tFMR2mZTJsZdaIKIuIcVPucXup+/ef7ieIJDcJ7cPe8jKf
         fayyKjwOjqhaML/9LXuBdWc5EmtvTPPrIzJnwaJkDbGqpqhGYWWN2eeVJXSea/yDKL
         KQeEh3BaR8OUm8MC+fTacBYqXyQiy0Ek9MZFTvfw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, dc395x@twibble.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 040/150] scsi: dc395x: fix DMA API usage in sg_update_list
Date:   Sat, 16 Nov 2019 10:45:38 -0500
Message-Id: <20191116154729.9573-40-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154729.9573-1-sashal@kernel.org>
References: <20191116154729.9573-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 6c404a68bf83b4135a8a9aa1c388ebdf98e8ba7f ]

We need to transfer device ownership to the CPU before we can manipulate
the mapped data.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/dc395x.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 9da0ac360848f..830b2d2dcf206 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -1972,6 +1972,11 @@ static void sg_update_list(struct ScsiReqBlk *srb, u32 left)
 			xferred -= psge->length;
 		} else {
 			/* Partial SG entry done */
+			pci_dma_sync_single_for_cpu(srb->dcb->
+					    acb->dev,
+					    srb->sg_bus_addr,
+					    SEGMENTX_LEN,
+					    PCI_DMA_TODEVICE);
 			psge->length -= xferred;
 			psge->address += xferred;
 			srb->sg_index = idx;
-- 
2.20.1

