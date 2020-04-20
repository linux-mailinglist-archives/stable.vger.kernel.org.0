Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BCCF1B0A9B
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729413AbgDTMt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:49:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:46394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729408AbgDTMtZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:49:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89B0B20747;
        Mon, 20 Apr 2020 12:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386965;
        bh=/HMAkxBxAQK6IIwIZeRelXxPWeQnz/Ftvn3qidsy1wM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=htd3xyFi2jIycGtJFeiEIyLv6N2ZEvPJ1o1vjr7GyUHiqcw1vFgDUTevH5zpqrIjW
         OixYHkAAetO5eocMhV78yZFVOpZBlhieC8YZDy161SkOduTHi5Tk4FDppbenSQS4f/
         Jxg1vFjIxloYj66nn45FfKq4IYutaDweVDrPMcAw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dedy Lansky <dlansky@codeaurora.org>,
        Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.19 38/40] wil6210: make sure Rx ring sizes are correlated
Date:   Mon, 20 Apr 2020 14:39:48 +0200
Message-Id: <20200420121507.310546012@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121444.178150063@linuxfoundation.org>
References: <20200420121444.178150063@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dedy Lansky <dlansky@codeaurora.org>

commit 61e5ec044748486f06dec760a19dce78247b3ad8 upstream.

When enlarging rx_ring_order module param, wil6210 fails to load
because there are not enough Rx buffers.
Fix this by enlarging number of Rx buffers at startup, if needed based
on rx_ring_order.

Signed-off-by: Dedy Lansky <dlansky@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/wil6210/main.c      |    2 +-
 drivers/net/wireless/ath/wil6210/txrx.c      |    4 ++--
 drivers/net/wireless/ath/wil6210/txrx_edma.c |   11 ++++++++---
 drivers/net/wireless/ath/wil6210/wil6210.h   |    2 +-
 4 files changed, 12 insertions(+), 7 deletions(-)

--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -1687,7 +1687,7 @@ int __wil_up(struct wil6210_priv *wil)
 		return rc;
 
 	/* Rx RING. After MAC and beacon */
-	rc = wil->txrx_ops.rx_init(wil, 1 << rx_ring_order);
+	rc = wil->txrx_ops.rx_init(wil, rx_ring_order);
 	if (rc)
 		return rc;
 
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -881,7 +881,7 @@ static void wil_rx_buf_len_init(struct w
 	}
 }
 
-static int wil_rx_init(struct wil6210_priv *wil, u16 size)
+static int wil_rx_init(struct wil6210_priv *wil, uint order)
 {
 	struct wil_ring *vring = &wil->ring_rx;
 	int rc;
@@ -895,7 +895,7 @@ static int wil_rx_init(struct wil6210_pr
 
 	wil_rx_buf_len_init(wil);
 
-	vring->size = size;
+	vring->size = 1 << order;
 	vring->is_rx = true;
 	rc = wil_vring_alloc(wil, vring);
 	if (rc)
--- a/drivers/net/wireless/ath/wil6210/txrx_edma.c
+++ b/drivers/net/wireless/ath/wil6210/txrx_edma.c
@@ -593,9 +593,9 @@ static void wil_rx_buf_len_init_edma(str
 		WIL_MAX_ETH_MTU : WIL_EDMA_RX_BUF_LEN_DEFAULT;
 }
 
-static int wil_rx_init_edma(struct wil6210_priv *wil, u16 desc_ring_size)
+static int wil_rx_init_edma(struct wil6210_priv *wil, uint desc_ring_order)
 {
-	u16 status_ring_size;
+	u16 status_ring_size, desc_ring_size = 1 << desc_ring_order;
 	struct wil_ring *ring = &wil->ring_rx;
 	int rc;
 	size_t elem_size = wil->use_compressed_rx_status ?
@@ -610,7 +610,12 @@ static int wil_rx_init_edma(struct wil62
 			"compressed RX status cannot be used with SW reorder\n");
 		return -EINVAL;
 	}
-
+	if (wil->rx_status_ring_order <= desc_ring_order)
+		/* make sure sring is larger than desc ring */
+		wil->rx_status_ring_order = desc_ring_order + 1;
+	if (wil->rx_buff_id_count <= desc_ring_size)
+		/* make sure we will not run out of buff_ids */
+		wil->rx_buff_id_count = desc_ring_size + 512;
 	if (wil->rx_status_ring_order < WIL_SRING_SIZE_ORDER_MIN ||
 	    wil->rx_status_ring_order > WIL_SRING_SIZE_ORDER_MAX)
 		wil->rx_status_ring_order = WIL_RX_SRING_SIZE_ORDER_DEFAULT;
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -602,7 +602,7 @@ struct wil_txrx_ops {
 			   struct wil_ring *ring, struct sk_buff *skb);
 	irqreturn_t (*irq_tx)(int irq, void *cookie);
 	/* RX ops */
-	int (*rx_init)(struct wil6210_priv *wil, u16 ring_size);
+	int (*rx_init)(struct wil6210_priv *wil, uint ring_order);
 	void (*rx_fini)(struct wil6210_priv *wil);
 	int (*wmi_addba_rx_resp)(struct wil6210_priv *wil, u8 mid, u8 cid,
 				 u8 tid, u8 token, u16 status, bool amsdu,


