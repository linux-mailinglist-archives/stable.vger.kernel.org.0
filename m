Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB137321770
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbhBVMse (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:48:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:56552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231650AbhBVMoj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:44:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2189464F51;
        Mon, 22 Feb 2021 12:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997685;
        bh=4HrBhgJIRgRPr9JuQrDIoTRdOmW5eiU2KLqhXKWskYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tl8XckAYdtIdwDBwncsHrxppnaUnl90JwKJSkGP1ZEk7AplazOVvhKCHEQiePZXX6
         wooF0JG5kSeqrnh7qu7AUD5f3zgQr7yjl63RSswDNRJ3A+mcGPeDIeL2+vzQjADWdQ
         p57P2X8kTf6/YXsf+HMYbXT74uegIhUcEnzaU4Ic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Igor Druzhinin <igor.druzhinin@citrix.com>,
        Juergen Gross <jgross@suse.com>, Wei Liu <wl@xen.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 26/49] xen/netback: avoid race in xenvif_rx_ring_slots_available()
Date:   Mon, 22 Feb 2021 13:36:24 +0100
Message-Id: <20210222121026.881460743@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121022.546148341@linuxfoundation.org>
References: <20210222121022.546148341@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

[ Upstream commit ec7d8e7dd3a59528e305a18e93f1cb98f7faf83b ]

Since commit 23025393dbeb3b8b3 ("xen/netback: use lateeoi irq binding")
xenvif_rx_ring_slots_available() is no longer called only from the rx
queue kernel thread, so it needs to access the rx queue with the
associated queue held.

Reported-by: Igor Druzhinin <igor.druzhinin@citrix.com>
Fixes: 23025393dbeb3b8b3 ("xen/netback: use lateeoi irq binding")
Signed-off-by: Juergen Gross <jgross@suse.com>
Acked-by: Wei Liu <wl@xen.org>
Link: https://lore.kernel.org/r/20210202070938.7863-1-jgross@suse.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/xen-netback/rx.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/xen-netback/rx.c b/drivers/net/xen-netback/rx.c
index f152246c7dfb7..ddfb1cfa2dd94 100644
--- a/drivers/net/xen-netback/rx.c
+++ b/drivers/net/xen-netback/rx.c
@@ -38,10 +38,15 @@ static bool xenvif_rx_ring_slots_available(struct xenvif_queue *queue)
 	RING_IDX prod, cons;
 	struct sk_buff *skb;
 	int needed;
+	unsigned long flags;
+
+	spin_lock_irqsave(&queue->rx_queue.lock, flags);
 
 	skb = skb_peek(&queue->rx_queue);
-	if (!skb)
+	if (!skb) {
+		spin_unlock_irqrestore(&queue->rx_queue.lock, flags);
 		return false;
+	}
 
 	needed = DIV_ROUND_UP(skb->len, XEN_PAGE_SIZE);
 	if (skb_is_gso(skb))
@@ -49,6 +54,8 @@ static bool xenvif_rx_ring_slots_available(struct xenvif_queue *queue)
 	if (skb->sw_hash)
 		needed++;
 
+	spin_unlock_irqrestore(&queue->rx_queue.lock, flags);
+
 	do {
 		prod = queue->rx.sring->req_prod;
 		cons = queue->rx.req_cons;
-- 
2.27.0



