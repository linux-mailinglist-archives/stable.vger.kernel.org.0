Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 793C9676E0B
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbjAVPGe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:06:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbjAVPGb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:06:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B93126C7
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:06:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61E95B80B17
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:06:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3AE6C433D2;
        Sun, 22 Jan 2023 15:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674399988;
        bh=9gF9vq5/yBodzUloZfD0SmyxzquXjwoBuye0A2kDwyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w4CR3z/QOAXYrE0ZJM1NsFIHIOK59nBekkrmESH/gMtt0UT642m9y0S1OzPDHRFvS
         cV8kBlyXdSWD0KVfNRO8J3cE2jYb6BPgq9hy3UeKg4pE1nJyY+I8PwxxZRlYclWDee
         pt+v+qNKwo4vqkxVLTtJnfZoQ/x4C/M0Y4xgqN4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 4.14 22/25] serial: pch_uart: Pass correct sg to dma_unmap_sg()
Date:   Sun, 22 Jan 2023 16:04:22 +0100
Message-Id: <20230122150218.724993878@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150217.788215473@linuxfoundation.org>
References: <20230122150217.788215473@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

commit e8914b52e5b024e4af3d810a935fe0805eee8a36 upstream.

A local variable sg is used to store scatterlist pointer in
pch_dma_tx_complete(). The for loop doing Tx byte accounting before
dma_unmap_sg() alters sg in its increment statement. Therefore, the
pointer passed into dma_unmap_sg() won't match to the one given to
dma_map_sg().

To fix the problem, use priv->sg_tx_p directly in dma_unmap_sg()
instead of the local variable.

Fixes: da3564ee027e ("pch_uart: add multi-scatter processing")
Cc: stable@vger.kernel.org
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20230103093435.4396-1-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/pch_uart.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -806,7 +806,7 @@ static void pch_dma_tx_complete(void *ar
 	}
 	xmit->tail &= UART_XMIT_SIZE - 1;
 	async_tx_ack(priv->desc_tx);
-	dma_unmap_sg(port->dev, sg, priv->orig_nent, DMA_TO_DEVICE);
+	dma_unmap_sg(port->dev, priv->sg_tx_p, priv->orig_nent, DMA_TO_DEVICE);
 	priv->tx_dma_use = 0;
 	priv->nent = 0;
 	priv->orig_nent = 0;


