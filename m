Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8940048786A
	for <lists+stable@lfdr.de>; Fri,  7 Jan 2022 14:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238947AbiAGNo4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jan 2022 08:44:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238931AbiAGNo4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jan 2022 08:44:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E3FC061574
        for <stable@vger.kernel.org>; Fri,  7 Jan 2022 05:44:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F36C60F00
        for <stable@vger.kernel.org>; Fri,  7 Jan 2022 13:44:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5102C36AE5;
        Fri,  7 Jan 2022 13:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641563095;
        bh=jOMKo0694GCX7s7C9Ml/ouCcIf4QqhADKi2EOjaRQ2E=;
        h=Subject:To:Cc:From:Date:From;
        b=thEFjMtCA5SqSGRGQzJFzVYvBO18qvAKxTNQwxM0qEekhikyaPTo9OxxSfBw/DfPL
         H3AZnqNB9wxoWUzV6ejNVqdi7+GbODuhb2/6ZIni562CVcOQS0iQ184DBFN4IJMuAO
         nysL8hce5uDyWRET4R46phJmdzbYHygWK1QjxT9E=
Subject: FAILED: patch "[PATCH] sfc: The RX page_ring is optional" failed to apply to 4.19-stable tree
To:     habetsm.xilinx@gmail.com, jiasheng@iscas.ac.cn, kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 07 Jan 2022 14:44:44 +0100
Message-ID: <1641563084142169@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1d5a474240407c38ca8c7484a656ee39f585399c Mon Sep 17 00:00:00 2001
From: Martin Habets <habetsm.xilinx@gmail.com>
Date: Sun, 2 Jan 2022 08:41:22 +0000
Subject: [PATCH] sfc: The RX page_ring is optional

The RX page_ring is an optional feature that improves
performance. When allocation fails the driver can still
function, but possibly with a lower bandwidth.
Guard against dereferencing a NULL page_ring.

Fixes: 2768935a4660 ("sfc: reuse pages to avoid DMA mapping/unmapping costs")
Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
Reported-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Link: https://lore.kernel.org/r/164111288276.5798.10330502993729113868.stgit@palantir17.mph.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/drivers/net/ethernet/sfc/falcon/rx.c b/drivers/net/ethernet/sfc/falcon/rx.c
index 11a6aee852e9..0c6cc2191369 100644
--- a/drivers/net/ethernet/sfc/falcon/rx.c
+++ b/drivers/net/ethernet/sfc/falcon/rx.c
@@ -110,6 +110,8 @@ static struct page *ef4_reuse_page(struct ef4_rx_queue *rx_queue)
 	struct ef4_rx_page_state *state;
 	unsigned index;
 
+	if (unlikely(!rx_queue->page_ring))
+		return NULL;
 	index = rx_queue->page_remove & rx_queue->page_ptr_mask;
 	page = rx_queue->page_ring[index];
 	if (page == NULL)
@@ -293,6 +295,9 @@ static void ef4_recycle_rx_pages(struct ef4_channel *channel,
 {
 	struct ef4_rx_queue *rx_queue = ef4_channel_get_rx_queue(channel);
 
+	if (unlikely(!rx_queue->page_ring))
+		return;
+
 	do {
 		ef4_recycle_rx_page(channel, rx_buf);
 		rx_buf = ef4_rx_buf_next(rx_queue, rx_buf);
diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/rx_common.c
index 0983abc0cc5f..633ca77a26fd 100644
--- a/drivers/net/ethernet/sfc/rx_common.c
+++ b/drivers/net/ethernet/sfc/rx_common.c
@@ -45,6 +45,8 @@ static struct page *efx_reuse_page(struct efx_rx_queue *rx_queue)
 	unsigned int index;
 	struct page *page;
 
+	if (unlikely(!rx_queue->page_ring))
+		return NULL;
 	index = rx_queue->page_remove & rx_queue->page_ptr_mask;
 	page = rx_queue->page_ring[index];
 	if (page == NULL)
@@ -114,6 +116,9 @@ void efx_recycle_rx_pages(struct efx_channel *channel,
 {
 	struct efx_rx_queue *rx_queue = efx_channel_get_rx_queue(channel);
 
+	if (unlikely(!rx_queue->page_ring))
+		return;
+
 	do {
 		efx_recycle_rx_page(channel, rx_buf);
 		rx_buf = efx_rx_buf_next(rx_queue, rx_buf);

