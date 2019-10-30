Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20DBCEA112
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 17:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729049AbfJ3P52 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:57:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:59066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729039AbfJ3P5Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:57:25 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F4D421734;
        Wed, 30 Oct 2019 15:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572451045;
        bh=KOUMRaIXAGCb/5lzwRYuWypD1T7l7uduhC7ayCsSL/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M/3bTFFMXmSDL5Hsg80wVV+OHePWY4uWhM2vVaRWCliJ1aq73VWzhF6ovsoYWUG5i
         j0mdqgfOHOae71SlA7gZlGx+YbruWmJzqkhj1Z9eG4sBJodFQPbuJa2Kn9hFRKnWvo
         Codls4n/AuZI2Qz8mlYPb0dZvW7NCu6UNf9pgORE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 09/18] scsi: sni_53c710: fix compilation error
Date:   Wed, 30 Oct 2019 11:56:51 -0400
Message-Id: <20191030155700.10748-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030155700.10748-1-sashal@kernel.org>
References: <20191030155700.10748-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Bogendoerfer <tbogendoerfer@suse.de>

[ Upstream commit 0ee6211408a8e939428f662833c7301394125b80 ]

Drop out memory dev_printk() with wrong device pointer argument.

[mkp: typo]

Link: https://lore.kernel.org/r/20191009151118.32350-1-tbogendoerfer@suse.de
Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sni_53c710.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/sni_53c710.c b/drivers/scsi/sni_53c710.c
index 76278072147e2..b0f5220ae23a8 100644
--- a/drivers/scsi/sni_53c710.c
+++ b/drivers/scsi/sni_53c710.c
@@ -78,10 +78,8 @@ static int snirm710_probe(struct platform_device *dev)
 
 	base = res->start;
 	hostdata = kzalloc(sizeof(*hostdata), GFP_KERNEL);
-	if (!hostdata) {
-		dev_printk(KERN_ERR, dev, "Failed to allocate host data\n");
+	if (!hostdata)
 		return -ENOMEM;
-	}
 
 	hostdata->dev = &dev->dev;
 	dma_set_mask(&dev->dev, DMA_BIT_MASK(32));
-- 
2.20.1

