Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 207662268CF
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732438AbgGTQU7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:20:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:46900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732328AbgGTQJI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:09:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88D9320672;
        Mon, 20 Jul 2020 16:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261348;
        bh=Wx7PdpUCk4pt6D9wXcsrxs6ytZVrxI8u6eKHPIONvs0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IQzCPyBJt/5xO4eeeHamzq2MJOsEavSXDynzpfgIvqjSuLWATx6jOx9mFvlKViMgJ
         fF8fikgWL4qYIbhHaPtyj7mxbeuleXo7Q9lNA2qa6s5n/oZRBDLAIn+GeVFUvqfAzt
         fNe5/IgK3JGaQMq0K5hojr6Mp9b4oGK/c4cFFack=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hien Dang <hien.dang.eb@renesas.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 084/244] dmaengine: sh: usb-dmac: set tx_result parameters
Date:   Mon, 20 Jul 2020 17:35:55 +0200
Message-Id: <20200720152829.834537279@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit 466257d9968ac79575831250b039dc07566c7b13 ]

A client driver (renesas_usbhs) assumed that
dmaengine_tx_status() could return the residue even if
the transfer was completed. However, this was not correct
usage [1] and this caused to break getting the residue after
the commit 24461d9792c2 ("dmaengine: virt-dma: Fix access after
free in vchan_complete()") actually. So, this is possible to get
wrong received size if the usb controller gets a short packet.
For example, g_zero driver causes "bad OUT byte" errors.

To use the tx_result from the renesas_usbhs driver when
the transfer is completed, set the tx_result parameters.

Notes that the renesas_usbhs driver needs to update for it.

[1]
https://lore.kernel.org/dmaengine/20200616165550.GP2324254@vkoul-mobl/

Reported-by: Hien Dang <hien.dang.eb@renesas.com>
Fixes: 24461d9792c2 ("dmaengine: virt-dma: Fix access after free in vchan_complete()")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/1592482053-19433-1-git-send-email-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/sh/usb-dmac.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/dma/sh/usb-dmac.c b/drivers/dma/sh/usb-dmac.c
index b218a013c2600..8f7ceb698226c 100644
--- a/drivers/dma/sh/usb-dmac.c
+++ b/drivers/dma/sh/usb-dmac.c
@@ -586,6 +586,8 @@ static void usb_dmac_isr_transfer_end(struct usb_dmac_chan *chan)
 		desc->residue = usb_dmac_get_current_residue(chan, desc,
 							desc->sg_index - 1);
 		desc->done_cookie = desc->vd.tx.cookie;
+		desc->vd.tx_result.result = DMA_TRANS_NOERROR;
+		desc->vd.tx_result.residue = desc->residue;
 		vchan_cookie_complete(&desc->vd);
 
 		/* Restart the next transfer if this driver has a next desc */
-- 
2.25.1



