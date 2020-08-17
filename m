Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C09882473A0
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730870AbgHQPtA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:49:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:32990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387648AbgHQPs5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:48:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5A2F20885;
        Mon, 17 Aug 2020 15:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679337;
        bh=NIfl73RREMDELHyMtwbSZUzs++FkBZ0sfKTVdjnFj1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G8b9cg4YCr+zVH0mN7r+uB+rSqPhy2MI34DhssbU7Q1/7urxgUFZNvtAr2iUVsB/s
         uTN/AkIeMjmBK0pkB3TzOhQHe1vaEjuTKolgFAvIrB1nbI1keYWq/a9CAjArFiBzrZ
         2LUd4S4kkW9OeZEGvWtlc53rs4BophdbUjD1bOF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 176/393] scsi: powertec: Fix different dev_id between request_irq() and free_irq()
Date:   Mon, 17 Aug 2020 17:13:46 +0200
Message-Id: <20200817143828.153196397@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit d179f7c763241c1dc5077fca88ddc3c47d21b763 ]

The dev_id used in request_irq() and free_irq() should match. Use 'info' in
both cases.

Link: https://lore.kernel.org/r/20200626035948.944148-1-christophe.jaillet@wanadoo.fr
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/arm/powertec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/arm/powertec.c b/drivers/scsi/arm/powertec.c
index c795537a671cb..2dc0df005cb3b 100644
--- a/drivers/scsi/arm/powertec.c
+++ b/drivers/scsi/arm/powertec.c
@@ -378,7 +378,7 @@ static int powertecscsi_probe(struct expansion_card *ec,
 
 	if (info->info.scsi.dma != NO_DMA)
 		free_dma(info->info.scsi.dma);
-	free_irq(ec->irq, host);
+	free_irq(ec->irq, info);
 
  out_release:
 	fas216_release(host);
-- 
2.25.1



