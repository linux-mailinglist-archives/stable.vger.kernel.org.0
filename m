Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 770C724B4AE
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730896AbgHTKKW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:10:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:46742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730906AbgHTKKV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:10:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9628206DA;
        Thu, 20 Aug 2020 10:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918221;
        bh=ivOMTOdFsLN/sz1ORCYQGPOcLijlJUddQvL8fkZTMnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L65l6X9UM57SDqByzZ1YDHdFJ6fVFkhmbI3kcu2jVlQtYoUlYx6xHji/a/AiUHkw9
         p5rWgsld7YF2X8+W21qVMj8LsfqakTU4JsLzEWDSjvyTCccvvKeH/+7xaWkCunlnmF
         BvYY9wDV92gb6UYnhMg7Aimt5KHhKO9KE2tmHmsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 095/228] scsi: eesox: Fix different dev_id between request_irq() and free_irq()
Date:   Thu, 20 Aug 2020 11:21:10 +0200
Message-Id: <20200820091612.373029757@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 86f2da1112ccf744ad9068b1d5d9843faf8ddee6 ]

The dev_id used in request_irq() and free_irq() should match. Use 'info' in
both cases.

Link: https://lore.kernel.org/r/20200626040553.944352-1-christophe.jaillet@wanadoo.fr
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/arm/eesox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/arm/eesox.c b/drivers/scsi/arm/eesox.c
index e93e047f43165..65bb34ce93b94 100644
--- a/drivers/scsi/arm/eesox.c
+++ b/drivers/scsi/arm/eesox.c
@@ -575,7 +575,7 @@ static int eesoxscsi_probe(struct expansion_card *ec, const struct ecard_id *id)
 
 	if (info->info.scsi.dma != NO_DMA)
 		free_dma(info->info.scsi.dma);
-	free_irq(ec->irq, host);
+	free_irq(ec->irq, info);
 
  out_remove:
 	fas216_remove(host);
-- 
2.25.1



