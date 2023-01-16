Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 640AB66CABE
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbjAPRGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:06:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbjAPRGS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:06:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 237B642BE9
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:47:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F002661050
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:47:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1176EC433EF;
        Mon, 16 Jan 2023 16:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887647;
        bh=afFjsmY8iwvYH+Uiy5cU44WEvQ1g6z9bsZvThFFrUec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=piayyL2owGYu6RXxXlkqWi/0jxrZcYdMjjKU30cJG8g/tlIjBgpNiPpjyGXoSM2YU
         VY1KPt15Yqhei4xk8jTqF9odDbYlqF7B4X+eeIcf8+dDW9DtQfIo8ul9WXI+GLfiH+
         7+q9Uv75yvcJMSt0g8dOXrMbZgESaJQT6FVTVEyY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 227/521] serial: pch: Fix PCI device refcount leak in pch_request_dma()
Date:   Mon, 16 Jan 2023 16:48:09 +0100
Message-Id: <20230116154857.308124416@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

[ Upstream commit 8be3a7bf773700534a6e8f87f6ed2ed111254be5 ]

As comment of pci_get_slot() says, it returns a pci_device with its
refcount increased. The caller must decrement the reference count by
calling pci_dev_put().

Since 'dma_dev' is only used to filter the channel in filter(), we can
call pci_dev_put() before exiting from pch_request_dma(). Add the
missing pci_dev_put() for the normal and error path.

Fixes: 3c6a483275f4 ("Serial: EG20T: add PCH_UART driver")
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Link: https://lore.kernel.org/r/20221122114559.27692-1-wangxiongfeng2@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/pch_uart.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index e5ff30544bd0..447990006d68 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -734,6 +734,7 @@ static void pch_request_dma(struct uart_port *port)
 	if (!chan) {
 		dev_err(priv->port.dev, "%s:dma_request_channel FAILS(Tx)\n",
 			__func__);
+		pci_dev_put(dma_dev);
 		return;
 	}
 	priv->chan_tx = chan;
@@ -750,6 +751,7 @@ static void pch_request_dma(struct uart_port *port)
 			__func__);
 		dma_release_channel(priv->chan_tx);
 		priv->chan_tx = NULL;
+		pci_dev_put(dma_dev);
 		return;
 	}
 
@@ -757,6 +759,8 @@ static void pch_request_dma(struct uart_port *port)
 	priv->rx_buf_virt = dma_alloc_coherent(port->dev, port->fifosize,
 				    &priv->rx_buf_dma, GFP_KERNEL);
 	priv->chan_rx = chan;
+
+	pci_dev_put(dma_dev);
 }
 
 static void pch_dma_rx_complete(void *arg)
-- 
2.35.1



