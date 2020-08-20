Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4E2324B7EE
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 13:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728625AbgHTLGh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 07:06:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:51816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730776AbgHTKLu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:11:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B13820724;
        Thu, 20 Aug 2020 10:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918310;
        bh=8ZGoBqju/lye+2LTT4VSSUJ0uHKgnw6J0Qizfb+cNtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S65LAiFPiJqpky9XwA9ZWIvx1dOcQT3u6BqvZwL1WrckGM+dn4eTyVtZ/8y5OyLfW
         gBh7u38Na0yQxqEAd+ChW5PYwYG6fLdUNcM04duzg6VM9fjAUkJWJPIJZd5717l/bD
         szJq0uvbTdyZkKjRnXjGnNDoCyQWrduyIZLj02AU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 094/228] scsi: powertec: Fix different dev_id between request_irq() and free_irq()
Date:   Thu, 20 Aug 2020 11:21:09 +0200
Message-Id: <20200820091612.323036488@linuxfoundation.org>
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
index 79aa88911b7f3..b5e4a25ea1ef3 100644
--- a/drivers/scsi/arm/powertec.c
+++ b/drivers/scsi/arm/powertec.c
@@ -382,7 +382,7 @@ static int powertecscsi_probe(struct expansion_card *ec,
 
 	if (info->info.scsi.dma != NO_DMA)
 		free_dma(info->info.scsi.dma);
-	free_irq(ec->irq, host);
+	free_irq(ec->irq, info);
 
  out_release:
 	fas216_release(host);
-- 
2.25.1



