Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96A602E6844
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730060AbgL1NCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:02:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:58244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730056AbgL1NCU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:02:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29935208B6;
        Mon, 28 Dec 2020 13:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160524;
        bh=qhDfQ2L5gkXut6BkNW3v3ZYyBtI5jQZJYTNpSA/GefY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lm1f36ACYe1An6wTYiPkxHhrJdHdravCfeZJENgjx+xZ0U2L9TwSPVA5pV+R9kv4S
         lXX8IIcuCOmTze26gb21M5JWNSyvzPd08M4/zwEDqT5IzzdK8YeSPjaESZLwykt4cW
         ViY5onWg4XXgSGi+SUAZzdutW/7K/Bhu+71cjmzk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 080/175] orinoco: Move context allocation after processing the skb
Date:   Mon, 28 Dec 2020 13:48:53 +0100
Message-Id: <20201228124857.110446927@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit a31eb615646a63370aa1da1053c45439c7653d83 ]

ezusb_xmit() allocates a context which is leaked if
orinoco_process_xmit_skb() returns an error.

Move ezusb_alloc_ctx() after the invocation of
orinoco_process_xmit_skb() because the context is not needed so early.
ezusb_access_ltv() will cleanup the context in case of an error.

Fixes: bac6fafd4d6a0 ("orinoco: refactor xmit path")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20201113212252.2243570-2-bigeasy@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intersil/orinoco/orinoco_usb.c    | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c b/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
index 4e91c74fcfad9..de928938c7a1c 100644
--- a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
@@ -1224,13 +1224,6 @@ static netdev_tx_t ezusb_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (skb->len < ETH_HLEN)
 		goto drop;
 
-	ctx = ezusb_alloc_ctx(upriv, EZUSB_RID_TX, 0);
-	if (!ctx)
-		goto busy;
-
-	memset(ctx->buf, 0, BULK_BUF_SIZE);
-	buf = ctx->buf->data;
-
 	tx_control = 0;
 
 	err = orinoco_process_xmit_skb(skb, dev, priv, &tx_control,
@@ -1238,6 +1231,13 @@ static netdev_tx_t ezusb_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (err)
 		goto drop;
 
+	ctx = ezusb_alloc_ctx(upriv, EZUSB_RID_TX, 0);
+	if (!ctx)
+		goto drop;
+
+	memset(ctx->buf, 0, BULK_BUF_SIZE);
+	buf = ctx->buf->data;
+
 	{
 		__le16 *tx_cntl = (__le16 *)buf;
 		*tx_cntl = cpu_to_le16(tx_control);
-- 
2.27.0



