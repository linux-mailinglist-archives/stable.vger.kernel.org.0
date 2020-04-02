Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36BB119C97D
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389228AbgDBTLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:11:39 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39115 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731892AbgDBTLj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:11:39 -0400
Received: by mail-wm1-f67.google.com with SMTP id e9so4932248wme.4
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=KIUT4HYy0VYSBkUgZ0BGRDLGJkL+uEuLOcNGteqvCdo=;
        b=eokabPnrDZhHr9kkLLdrYCZTKLYfkPdzTlluebCf8VJnqvy6jseSeAKT9UtExU8Eqo
         PVyq+fPQuvJJWCKJ8Vcos71lCK2RPxCMt2pm5jUIJoP5djOnrwwcFsWjX2PLizI8b+ev
         0ox1gfYEmCwie5pH5Bi8dFKCqZYke+Jkq1wR/DMjy16CH2HUQYZ2WkFAlJCG1sl4nTgo
         +j7nWV9o6vidZhXBx1JrQf9rzRRN+41i/FZti3IbnJRBT95b/UNA2Dcbq/8pIFktuh0g
         r6WIZnSk8uxTtqh/sXfRT4EpfxUd62YLaRNEz4jO+Blbt4vUr9ntZon5zLEE3ktxT1sc
         K4MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KIUT4HYy0VYSBkUgZ0BGRDLGJkL+uEuLOcNGteqvCdo=;
        b=Hela+uDME2t9hohBPtPi70yPv4qDKtJXXBQyR55aaqcs5Ii4Zo5+EopCiFEKzXPerR
         4d4nY2XPD5sNbrR7QWHnPC8asr/K/DDhjsgeMDkx4hDRdJ/SpyZago32F3Nl/DekWUSI
         zxCvufKr2I9N7UeYcURf3zRt3ClpypMO4B26dg8XasS89Eore80a+yTop+NHjRta6odA
         0PVbYFNONBXpHkz/U5AzgzVjQvLa/1nMA8OtzfgsAPkjmOkIX/320M0lTLM/YwW4BuYE
         PIra98IclzH+2xheOqxdriaOK/D3wB4SNJRQkMa8uYxhFuXKA9TGqF1r7Ctx5GAsD3Dp
         PXdQ==
X-Gm-Message-State: AGi0PuYmekcZrdp28NU2BhGxuqiMsAmfMTOrC42p6VzyLlLHmnA36yFX
        wns9IGHqgyqe99RRkHi7PWQjq73ZYu3shA==
X-Google-Smtp-Source: APiQypJBckTpf1jkXwQJv+U7ezPLwJfF0wQHEbu0PWf2UfEa4aQbbgJflePLiSIHywLK89xVRTjEJw==
X-Received: by 2002:a1c:23d6:: with SMTP id j205mr4755360wmj.22.1585854695427;
        Thu, 02 Apr 2020 12:11:35 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id s15sm8442164wrt.16.2020.04.02.12.11.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:11:34 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.19 08/14] wil6210: make sure Rx ring sizes are correlated
Date:   Thu,  2 Apr 2020 20:12:14 +0100
Message-Id: <20200402191220.787381-8-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191220.787381-1-lee.jones@linaro.org>
References: <20200402191220.787381-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dedy Lansky <dlansky@codeaurora.org>

[ Upstream commit 61e5ec044748486f06dec760a19dce78247b3ad8 ]

When enlarging rx_ring_order module param, wil6210 fails to load
because there are not enough Rx buffers.
Fix this by enlarging number of Rx buffers at startup, if needed based
on rx_ring_order.

Signed-off-by: Dedy Lansky <dlansky@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/ath/wil6210/main.c      |  2 +-
 drivers/net/wireless/ath/wil6210/txrx.c      |  4 ++--
 drivers/net/wireless/ath/wil6210/txrx_edma.c | 11 ++++++++---
 drivers/net/wireless/ath/wil6210/wil6210.h   |  2 +-
 4 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 28d2bfd0fde79..fe91db3478dc8 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -1687,7 +1687,7 @@ int __wil_up(struct wil6210_priv *wil)
 		return rc;
 
 	/* Rx RING. After MAC and beacon */
-	rc = wil->txrx_ops.rx_init(wil, 1 << rx_ring_order);
+	rc = wil->txrx_ops.rx_init(wil, rx_ring_order);
 	if (rc)
 		return rc;
 
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 73cdf54521f9b..236dcb6f5e84d 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -881,7 +881,7 @@ static void wil_rx_buf_len_init(struct wil6210_priv *wil)
 	}
 }
 
-static int wil_rx_init(struct wil6210_priv *wil, u16 size)
+static int wil_rx_init(struct wil6210_priv *wil, uint order)
 {
 	struct wil_ring *vring = &wil->ring_rx;
 	int rc;
@@ -895,7 +895,7 @@ static int wil_rx_init(struct wil6210_priv *wil, u16 size)
 
 	wil_rx_buf_len_init(wil);
 
-	vring->size = size;
+	vring->size = 1 << order;
 	vring->is_rx = true;
 	rc = wil_vring_alloc(wil, vring);
 	if (rc)
diff --git a/drivers/net/wireless/ath/wil6210/txrx_edma.c b/drivers/net/wireless/ath/wil6210/txrx_edma.c
index 03d0e6c550b98..fe666a3583c10 100644
--- a/drivers/net/wireless/ath/wil6210/txrx_edma.c
+++ b/drivers/net/wireless/ath/wil6210/txrx_edma.c
@@ -593,9 +593,9 @@ static void wil_rx_buf_len_init_edma(struct wil6210_priv *wil)
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
@@ -610,7 +610,12 @@ static int wil_rx_init_edma(struct wil6210_priv *wil, u16 desc_ring_size)
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
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 6a05f59ee58e9..bc89044d0b66e 100644
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
-- 
2.25.1

