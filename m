Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A17C1121243
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 18:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbfLPRvO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:51:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:41076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726754AbfLPRvN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:51:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C337220700;
        Mon, 16 Dec 2019 17:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518673;
        bh=f5qrXQvyIwR4tEuDd6rOA7k/6DwzakBGHuSrshJIwFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AePD9H9OIAVX0z3wJdIc4ZJKFm5X3P0s3P+9QIjgx3/9uMttkOtT8IWvw7ohxsjm5
         5bcosaxEOWXAblh8ASc62sNPgEwMtiirPNzBzhYQ7m72LaTa/XPWtD4jHPNxHEmYic
         fIqAmqamxyzpO2pVNxeGTqM340qhHbkVWQ6zFoic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Fan <peng.fan@nxp.com>
Subject: [PATCH 4.14 004/267] tty: serial: fsl_lpuart: use the sg count from dma_map_sg
Date:   Mon, 16 Dec 2019 18:45:30 +0100
Message-Id: <20191216174849.239749492@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

commit 487ee861de176090b055eba5b252b56a3b9973d6 upstream.

The dmaengine_prep_slave_sg needs to use sg count returned
by dma_map_sg, not use sport->dma_tx_nents, because the return
value of dma_map_sg is not always same with "nents".

When enabling iommu for lpuart + edma, iommu framework may concatenate
two sgs into one.

Fixes: 6250cc30c4c4e ("tty: serial: fsl_lpuart: Use scatter/gather DMA for Tx")
Cc: <stable@vger.kernel.org>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Link: https://lore.kernel.org/r/1572932977-17866-1-git-send-email-peng.fan@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/fsl_lpuart.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -380,8 +380,8 @@ static void lpuart_dma_tx(struct lpuart_
 	}
 
 	sport->dma_tx_desc = dmaengine_prep_slave_sg(sport->dma_tx_chan, sgl,
-					sport->dma_tx_nents,
-					DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT);
+					ret, DMA_MEM_TO_DEV,
+					DMA_PREP_INTERRUPT);
 	if (!sport->dma_tx_desc) {
 		dma_unmap_sg(dev, sgl, sport->dma_tx_nents, DMA_TO_DEVICE);
 		dev_err(dev, "Cannot prepare TX slave DMA!\n");


