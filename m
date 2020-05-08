Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE3041CAF8D
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbgEHMlf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:41:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:36534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727094AbgEHMla (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:41:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5E3920731;
        Fri,  8 May 2020 12:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941690;
        bh=q+u+Ooo9X2BXKnDKEMm+z9vr/5/zeJ8JyneIAjRTENw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aBMcBpAQvem86GY7eGEZ5UG7KC9d424dJQiwHHhX0uy7v9s6bIbme/4Y8pS4zLowx
         46ruUVAhRyimysOWXrppNES2r0wh4pPXeF5GXHD+UGwhXq+MF0oovEwMhuZuWLPhc/
         KsUyAcM1KQkaZeA1rGa66X+xBADe24waHm7tohMM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Dinh Nguyen <dinguyen@opensource.altera.com>,
        Brian Norris <computersforpeace@gmail.com>
Subject: [PATCH 4.4 132/312] mtd: nand: denali: add missing nand_release() call in denali_remove()
Date:   Fri,  8 May 2020 14:32:03 +0200
Message-Id: <20200508123133.790481132@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Brezillon <boris.brezillon@free-electrons.com>

commit 320092a05dab2f44819c42f33d6b51efb6c474f2 upstream.

Unregister the NAND device from the NAND subsystem when removing a denali
NAND controller, otherwise the MTD attached to the NAND device is still
exposed by the MTD layer, and accesses to this device will likely crash
the system.

Fixes: 2a0a288ec258 ("mtd: denali: split the generic driver and PCI layer")
Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Acked-by: Dinh Nguyen <dinguyen@opensource.altera.com>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/denali.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/mtd/nand/denali.c
+++ b/drivers/mtd/nand/denali.c
@@ -1622,9 +1622,16 @@ EXPORT_SYMBOL(denali_init);
 /* driver exit point */
 void denali_remove(struct denali_nand_info *denali)
 {
+	/*
+	 * Pre-compute DMA buffer size to avoid any problems in case
+	 * nand_release() ever changes in a way that mtd->writesize and
+	 * mtd->oobsize are not reliable after this call.
+	 */
+	int bufsize = denali->mtd.writesize + denali->mtd.oobsize;
+
+	nand_release(&denali->mtd);
 	denali_irq_cleanup(denali->irq, denali);
-	dma_unmap_single(denali->dev, denali->buf.dma_buf,
-			 denali->mtd.writesize + denali->mtd.oobsize,
+	dma_unmap_single(denali->dev, denali->buf.dma_buf, bufsize,
 			 DMA_BIDIRECTIONAL);
 }
 EXPORT_SYMBOL(denali_remove);


