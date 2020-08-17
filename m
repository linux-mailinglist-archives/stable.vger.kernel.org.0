Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3146B247118
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390663AbgHQSUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:20:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387981AbgHQQEW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:04:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EF87208B3;
        Mon, 17 Aug 2020 16:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680255;
        bh=87Fl949AzeQxELVjL2JDgPA6BXffnHKt0pB+nQTHT88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GgbpB2N+/gh1meo3oFt7taLBUcUC2Jyuii9DbdhzpsSXVKImXFlJrOdGvyXHuoR/j
         IJaPELIsmnbllSvm0Ca2yQb+PHTN7MmRs1sd139125ckgJ2pBXjvYkx/YbvRUu8ep4
         /OAM5dOZO9f3ztGCNCcSsHfn9YgCWr9bnrQsYbpA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 113/270] scsi: cumana_2: Fix different dev_id between request_irq() and free_irq()
Date:   Mon, 17 Aug 2020 17:15:14 +0200
Message-Id: <20200817143801.402891222@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 040ab9c4fd0070cd5fa71ba3a7b95b8470db9b4d ]

The dev_id used in request_irq() and free_irq() should match.  Use 'info'
in both cases.

Link: https://lore.kernel.org/r/20200625204730.943520-1-christophe.jaillet@wanadoo.fr
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Acked-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/arm/cumana_2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/arm/cumana_2.c b/drivers/scsi/arm/cumana_2.c
index a1f3e9ee4e639..14e1d001253c4 100644
--- a/drivers/scsi/arm/cumana_2.c
+++ b/drivers/scsi/arm/cumana_2.c
@@ -450,7 +450,7 @@ static int cumanascsi2_probe(struct expansion_card *ec,
 
 	if (info->info.scsi.dma != NO_DMA)
 		free_dma(info->info.scsi.dma);
-	free_irq(ec->irq, host);
+	free_irq(ec->irq, info);
 
  out_release:
 	fas216_release(host);
-- 
2.25.1



