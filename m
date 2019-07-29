Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3943E795BA
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389919AbfG2TpW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:45:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:34262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389292AbfG2TpV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:45:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54FDA2171F;
        Mon, 29 Jul 2019 19:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429520;
        bh=f7tBDxzUivvdbQFNLAvWicQS27YxUC57cCcTbYDlg+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lrUCE8p76KDszrfRbWrsEGMIc7SHPbkmJLJ8PHUtTzy+zpdDrm1yqleAOXSjvVvyK
         ga5WRraf4weCUiy2FY7Uh+Fr/2qG5DT9BrSU0+bnH5aqFQN8GuRDHthhsWQuQgJDQE
         53CmGOblAQ8OyPaKe7mX/HD6p5JuYrCkzNg0ExBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Quentin Deslandes <quentin.deslandes@itdev.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 011/215] staging: vt6656: use meaningful error code during buffer allocation
Date:   Mon, 29 Jul 2019 21:20:07 +0200
Message-Id: <20190729190741.507584655@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d8c2869300ab5f7a19bf6f5a04fe473c5c9887e3 ]

Check on called function's returned value for error and return 0 on
success or a negative errno value on error instead of a boolean value.

Signed-off-by: Quentin Deslandes <quentin.deslandes@itdev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/vt6656/main_usb.c | 42 ++++++++++++++++++++-----------
 1 file changed, 28 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index ccafcc2c87ac..70433f756d8e 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -402,16 +402,19 @@ static void vnt_free_int_bufs(struct vnt_private *priv)
 	kfree(priv->int_buf.data_buf);
 }
 
-static bool vnt_alloc_bufs(struct vnt_private *priv)
+static int vnt_alloc_bufs(struct vnt_private *priv)
 {
+	int ret = 0;
 	struct vnt_usb_send_context *tx_context;
 	struct vnt_rcb *rcb;
 	int ii;
 
 	for (ii = 0; ii < priv->num_tx_context; ii++) {
 		tx_context = kmalloc(sizeof(*tx_context), GFP_KERNEL);
-		if (!tx_context)
+		if (!tx_context) {
+			ret = -ENOMEM;
 			goto free_tx;
+		}
 
 		priv->tx_context[ii] = tx_context;
 		tx_context->priv = priv;
@@ -419,16 +422,20 @@ static bool vnt_alloc_bufs(struct vnt_private *priv)
 
 		/* allocate URBs */
 		tx_context->urb = usb_alloc_urb(0, GFP_KERNEL);
-		if (!tx_context->urb)
+		if (!tx_context->urb) {
+			ret = -ENOMEM;
 			goto free_tx;
+		}
 
 		tx_context->in_use = false;
 	}
 
 	for (ii = 0; ii < priv->num_rcb; ii++) {
 		priv->rcb[ii] = kzalloc(sizeof(*priv->rcb[ii]), GFP_KERNEL);
-		if (!priv->rcb[ii])
+		if (!priv->rcb[ii]) {
+			ret = -ENOMEM;
 			goto free_rx_tx;
+		}
 
 		rcb = priv->rcb[ii];
 
@@ -436,39 +443,46 @@ static bool vnt_alloc_bufs(struct vnt_private *priv)
 
 		/* allocate URBs */
 		rcb->urb = usb_alloc_urb(0, GFP_KERNEL);
-		if (!rcb->urb)
+		if (!rcb->urb) {
+			ret = -ENOMEM;
 			goto free_rx_tx;
+		}
 
 		rcb->skb = dev_alloc_skb(priv->rx_buf_sz);
-		if (!rcb->skb)
+		if (!rcb->skb) {
+			ret = -ENOMEM;
 			goto free_rx_tx;
+		}
 
 		rcb->in_use = false;
 
 		/* submit rx urb */
-		if (vnt_submit_rx_urb(priv, rcb))
+		ret = vnt_submit_rx_urb(priv, rcb);
+		if (ret)
 			goto free_rx_tx;
 	}
 
 	priv->interrupt_urb = usb_alloc_urb(0, GFP_KERNEL);
-	if (!priv->interrupt_urb)
+	if (!priv->interrupt_urb) {
+		ret = -ENOMEM;
 		goto free_rx_tx;
+	}
 
 	priv->int_buf.data_buf = kmalloc(MAX_INTERRUPT_SIZE, GFP_KERNEL);
 	if (!priv->int_buf.data_buf) {
-		usb_free_urb(priv->interrupt_urb);
-		goto free_rx_tx;
+		ret = -ENOMEM;
+		goto free_rx_tx_urb;
 	}
 
-	return true;
+	return 0;
 
+free_rx_tx_urb:
+	usb_free_urb(priv->interrupt_urb);
 free_rx_tx:
 	vnt_free_rx_bufs(priv);
-
 free_tx:
 	vnt_free_tx_bufs(priv);
-
-	return false;
+	return ret;
 }
 
 static void vnt_tx_80211(struct ieee80211_hw *hw,
-- 
2.20.1



