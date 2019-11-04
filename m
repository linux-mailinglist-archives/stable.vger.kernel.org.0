Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB437EF022
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729976AbfKDW0H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:26:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:44382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730503AbfKDVvY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:51:24 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D4EE21850;
        Mon,  4 Nov 2019 21:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904284;
        bh=a/CrEaRPI9p2L9QvfTnm1Yau+XWCrkMuGwhTOPbUtpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UrQaLgC//uQ7xqhXEdBQYjjZHlTwCkNTtWjftk2N4yb41Fwsi5Qf/Z9RdjjxSaI5C
         6tCHU533UbL6zz5PkK5ryVPKdmokAs7P3QdEyC8HnmFutxJrz5J0oJQHf6ge/Qhv+H
         azACpNwo4JMW1IMqnPc4fQlkNhsTX4H4KOLJbmZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yegor Yefremov <yegorslists@googlemail.com>,
        Tony Lindgren <tony@atomide.com>, Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 4.9 50/62] dmaengine: cppi41: Fix cppi41_dma_prep_slave_sg() when idle
Date:   Mon,  4 Nov 2019 22:45:12 +0100
Message-Id: <20191104211953.108084720@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104211901.387893698@linuxfoundation.org>
References: <20191104211901.387893698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

commit bacdcb6675e170bb2e8d3824da220e10274f42a7 upstream.

Yegor Yefremov <yegorslists@googlemail.com> reported that musb and ftdi
uart can fail for the first open of the uart unless connected using
a hub.

This is because the first dma call done by musb_ep_program() must wait
if cppi41 is PM runtime suspended. Otherwise musb_ep_program() continues
with other non-dma packets before the DMA transfer is started causing at
least ftdi uarts to fail to receive data.

Let's fix the issue by waking up cppi41 with PM runtime calls added to
cppi41_dma_prep_slave_sg() and return NULL if still idled. This way we
have musb_ep_program() continue with PIO until cppi41 is awake.

Fixes: fdea2d09b997 ("dmaengine: cppi41: Add basic PM runtime support")
Reported-by: Yegor Yefremov <yegorslists@googlemail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Cc: stable@vger.kernel.org # v4.9+
Link: https://lore.kernel.org/r/20191023153138.23442-1-tony@atomide.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/cppi41.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

--- a/drivers/dma/cppi41.c
+++ b/drivers/dma/cppi41.c
@@ -586,9 +586,22 @@ static struct dma_async_tx_descriptor *c
 	enum dma_transfer_direction dir, unsigned long tx_flags, void *context)
 {
 	struct cppi41_channel *c = to_cpp41_chan(chan);
+	struct dma_async_tx_descriptor *txd = NULL;
+	struct cppi41_dd *cdd = c->cdd;
 	struct cppi41_desc *d;
 	struct scatterlist *sg;
 	unsigned int i;
+	int error;
+
+	error = pm_runtime_get(cdd->ddev.dev);
+	if (error < 0) {
+		pm_runtime_put_noidle(cdd->ddev.dev);
+
+		return NULL;
+	}
+
+	if (cdd->is_suspended)
+		goto err_out_not_ready;
 
 	d = c->desc;
 	for_each_sg(sgl, sg, sg_len, i) {
@@ -611,7 +624,13 @@ static struct dma_async_tx_descriptor *c
 		d++;
 	}
 
-	return &c->txd;
+	txd = &c->txd;
+
+err_out_not_ready:
+	pm_runtime_mark_last_busy(cdd->ddev.dev);
+	pm_runtime_put_autosuspend(cdd->ddev.dev);
+
+	return txd;
 }
 
 static void cppi41_compute_td_desc(struct cppi41_desc *d)


