Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD3D489163
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240609AbiAJHbh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:31:37 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37416 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240247AbiAJH3m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:29:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4506611A3;
        Mon, 10 Jan 2022 07:29:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB7FC36AE9;
        Mon, 10 Jan 2022 07:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799780;
        bh=ozMljWCXRk0xRH33Ws1uj19s4rejF6ZOu7s6mtdRefk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xp2CWE5X7KQQW7Ertyp44hXIsU1Sv/iWwUyRX73Oo9Vxk1amVep9tJXHBLtO6yoba
         mZJ9sUTqEuGwlL33CidC75ah4yioozuJGPcBKz3aqBlstWj4ikrkPegyFlLCwn4O3O
         8ra4TqxtHnz2M6W6lDX1CdOSjteyWMr9PU80Fq+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Habets <habetsm.xilinx@gmail.com>,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 12/43] sfc: The RX page_ring is optional
Date:   Mon, 10 Jan 2022 08:23:09 +0100
Message-Id: <20220110071817.765763199@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071817.337619922@linuxfoundation.org>
References: <20220110071817.337619922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Habets <habetsm.xilinx@gmail.com>

commit 1d5a474240407c38ca8c7484a656ee39f585399c upstream.

The RX page_ring is an optional feature that improves
performance. When allocation fails the driver can still
function, but possibly with a lower bandwidth.
Guard against dereferencing a NULL page_ring.

Fixes: 2768935a4660 ("sfc: reuse pages to avoid DMA mapping/unmapping costs")
Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
Reported-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Link: https://lore.kernel.org/r/164111288276.5798.10330502993729113868.stgit@palantir17.mph.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/sfc/falcon/rx.c |    5 +++++
 drivers/net/ethernet/sfc/rx_common.c |    5 +++++
 2 files changed, 10 insertions(+)

--- a/drivers/net/ethernet/sfc/falcon/rx.c
+++ b/drivers/net/ethernet/sfc/falcon/rx.c
@@ -110,6 +110,8 @@ static struct page *ef4_reuse_page(struc
 	struct ef4_rx_page_state *state;
 	unsigned index;
 
+	if (unlikely(!rx_queue->page_ring))
+		return NULL;
 	index = rx_queue->page_remove & rx_queue->page_ptr_mask;
 	page = rx_queue->page_ring[index];
 	if (page == NULL)
@@ -293,6 +295,9 @@ static void ef4_recycle_rx_pages(struct
 {
 	struct ef4_rx_queue *rx_queue = ef4_channel_get_rx_queue(channel);
 
+	if (unlikely(!rx_queue->page_ring))
+		return;
+
 	do {
 		ef4_recycle_rx_page(channel, rx_buf);
 		rx_buf = ef4_rx_buf_next(rx_queue, rx_buf);
--- a/drivers/net/ethernet/sfc/rx_common.c
+++ b/drivers/net/ethernet/sfc/rx_common.c
@@ -45,6 +45,8 @@ static struct page *efx_reuse_page(struc
 	unsigned int index;
 	struct page *page;
 
+	if (unlikely(!rx_queue->page_ring))
+		return NULL;
 	index = rx_queue->page_remove & rx_queue->page_ptr_mask;
 	page = rx_queue->page_ring[index];
 	if (page == NULL)
@@ -114,6 +116,9 @@ void efx_recycle_rx_pages(struct efx_cha
 {
 	struct efx_rx_queue *rx_queue = efx_channel_get_rx_queue(channel);
 
+	if (unlikely(!rx_queue->page_ring))
+		return;
+
 	do {
 		efx_recycle_rx_page(channel, rx_buf);
 		rx_buf = efx_rx_buf_next(rx_queue, rx_buf);


