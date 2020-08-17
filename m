Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A30247692
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729851AbgHQTjJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:39:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:35726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729277AbgHQP0l (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:26:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 029A52078D;
        Mon, 17 Aug 2020 15:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678000;
        bh=LbUYP1IQLhtmeYiSftNfPFlg4bh7sn+HM28H+KDvsSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RtKlUihoAiLrW+zfiDg/D31yNfT6LMQvum2HlL9mFYAz5ndZ5OG0EExBj/NrCDSF9
         QtnaD643SD9EBOquvrnyPaygxl7n/DHM3pQLsfi+C6bkOIW4FY5wscrHGHAwKd+PZ3
         96lS4iGxEeLQrlYWOuL3vTErGSqiykOKYWk0RP94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 183/464] scsi: cumana_2: Fix different dev_id between request_irq() and free_irq()
Date:   Mon, 17 Aug 2020 17:12:16 +0200
Message-Id: <20200817143842.586674004@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
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
index 65691c21f133d..29294f0ef8a9a 100644
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



