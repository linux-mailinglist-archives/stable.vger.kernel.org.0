Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1C666C7E2
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233201AbjAPQf2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:35:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232290AbjAPQef (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:34:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3135226580
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:22:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C44D56104E
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:22:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBCF7C433EF;
        Mon, 16 Jan 2023 16:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886138;
        bh=YqWG/TIVfrEZQtYahCLWWUdOyyaNoWPp4hbQS9WMgL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N/xcdh4VXgXqPeedGfejaWR7ofo+TKQ11W7aRT+LZKMdfpf1CKpUPn1J8DIjibQVJ
         wToSh7y8kj5u81lfwMLyKWvhHNv6JdHPaEsxWp7kLlc4Z1kNEQEEYhwD/6M9oZ+H8e
         QR1MZqyN+Q62EiMAB2SLraabyC2oJxpVAVr4LU8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 287/658] serial: pch: Fix PCI device refcount leak in pch_request_dma()
Date:   Mon, 16 Jan 2023 16:46:15 +0100
Message-Id: <20230116154922.717465158@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index 77f18445bb98..a8b6759140dd 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -718,6 +718,7 @@ static void pch_request_dma(struct uart_port *port)
 	if (!chan) {
 		dev_err(priv->port.dev, "%s:dma_request_channel FAILS(Tx)\n",
 			__func__);
+		pci_dev_put(dma_dev);
 		return;
 	}
 	priv->chan_tx = chan;
@@ -734,6 +735,7 @@ static void pch_request_dma(struct uart_port *port)
 			__func__);
 		dma_release_channel(priv->chan_tx);
 		priv->chan_tx = NULL;
+		pci_dev_put(dma_dev);
 		return;
 	}
 
@@ -741,6 +743,8 @@ static void pch_request_dma(struct uart_port *port)
 	priv->rx_buf_virt = dma_alloc_coherent(port->dev, port->fifosize,
 				    &priv->rx_buf_dma, GFP_KERNEL);
 	priv->chan_rx = chan;
+
+	pci_dev_put(dma_dev);
 }
 
 static void pch_dma_rx_complete(void *arg)
-- 
2.35.1



