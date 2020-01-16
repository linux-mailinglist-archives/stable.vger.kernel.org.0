Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA5413FE21
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403889AbgAPXcq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:32:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:42450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404193AbgAPXcp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:32:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F3BD2073A;
        Thu, 16 Jan 2020 23:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217565;
        bh=Yr/v8JCKiAzj9Xg/55tcnrpoweVvorUmgwUtXTSr1Tk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fPGVbqrs8VmKZC1kN4wDzKr4b89RP9FMDQkaY55Pz54r1h6KmmUDkvi1E+IApWMqs
         FfO2G13JguDilvkuHr4/fjqwoXvqqeDGVBYQXJLXKzTAOzJYF6HjxtdP6C5EBgYVkS
         4Ktlj/TAeLWY3CiwsuoCZ1BeoMMGV5dJNVT+dZus=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Fan <peng.fan@nxp.com>
Subject: [PATCH 4.14 50/71] tty: serial: imx: use the sg count from dma_map_sg
Date:   Fri, 17 Jan 2020 00:18:48 +0100
Message-Id: <20200116231716.579154955@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231709.377772748@linuxfoundation.org>
References: <20200116231709.377772748@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

commit 596fd8dffb745afcebc0ec6968e17fe29f02044c upstream.

The dmaengine_prep_slave_sg needs to use sg count returned
by dma_map_sg, not use sport->dma_tx_nents, because the return
value of dma_map_sg is not always same with "nents".

Fixes: b4cdc8f61beb ("serial: imx: add DMA support for imx6q")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Link: https://lore.kernel.org/r/1573108875-26530-1-git-send-email-peng.fan@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/imx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -542,7 +542,7 @@ static void imx_dma_tx(struct imx_port *
 		dev_err(dev, "DMA mapping error for TX.\n");
 		return;
 	}
-	desc = dmaengine_prep_slave_sg(chan, sgl, sport->dma_tx_nents,
+	desc = dmaengine_prep_slave_sg(chan, sgl, ret,
 					DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT);
 	if (!desc) {
 		dma_unmap_sg(dev, sgl, sport->dma_tx_nents,


