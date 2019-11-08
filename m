Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63259F546F
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 19:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732246AbfKHS7m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 13:59:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:56498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732061AbfKHS7l (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 13:59:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B70422501;
        Fri,  8 Nov 2019 18:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239580;
        bh=HrRc/uzkTfFPv0L8nCGXB774/xM81RQM7rhRnnprTsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zt+GUX+9fMvkLyHzpjOZ4MTY8ZwD/T3acVAX+qMPCvUvqTC+3PDC1Jc1c9hH63USM
         5d4wtlyybmF5KSlF2muJ7J/oi3cvnGCWZJc2qSO+UHbBiWm9xQprODK/faQ8J7L2NJ
         zkSdKPqS99CNp28nyKZVKop4YBTPpMovPi7BE/Mo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 10/62] scsi: sni_53c710: fix compilation error
Date:   Fri,  8 Nov 2019 19:49:58 +0100
Message-Id: <20191108174729.177376455@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174719.228826381@linuxfoundation.org>
References: <20191108174719.228826381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 1f9a087daf69f..3102a75984d3b 100644
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



