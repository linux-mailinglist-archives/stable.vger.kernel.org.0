Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C21C43CA8BC
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239577AbhGOTCn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:02:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:34984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240997AbhGOS6t (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:58:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2ADA613D4;
        Thu, 15 Jul 2021 18:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375343;
        bh=X0bu4H7WOFKLkbG4+PvRP5lJ23vKTpaLCOAkkv0fX30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zK2w+NLRL88ER8JupN/fp18vOgW2SZ583ZoNr8nLA75qngFiGPZ9FeRBYdG/7uMKa
         1W+9eeUlqnXzMAo9sdpBDwBwv7+U1VCH53akz1oHISLqlzwJfoAimdKDtF7JIOKnQe
         kz7mynOcJ1DlA+Fx9SOTBKHOLE3q8xuSbfY84RKU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Jason Wang <jasowang@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 046/242] virtio-net: Add validation for used length
Date:   Thu, 15 Jul 2021 20:36:48 +0200
Message-Id: <20210715182600.275545240@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie Yongji <xieyongji@bytedance.com>

[ Upstream commit ad993a95c508417acdeb15244109e009e50d8758 ]

This adds validation for used length (might come
from an untrusted device) to avoid data corruption
or loss.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Link: https://lore.kernel.org/r/20210531135852.113-1-xieyongji@bytedance.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 0824e6999e49..447582fa20a5 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -660,6 +660,12 @@ static struct sk_buff *receive_small(struct net_device *dev,
 	len -= vi->hdr_len;
 	stats->bytes += len;
 
+	if (unlikely(len > GOOD_PACKET_LEN)) {
+		pr_debug("%s: rx error: len %u exceeds max size %d\n",
+			 dev->name, len, GOOD_PACKET_LEN);
+		dev->stats.rx_length_errors++;
+		goto err_len;
+	}
 	rcu_read_lock();
 	xdp_prog = rcu_dereference(rq->xdp_prog);
 	if (xdp_prog) {
@@ -761,6 +767,7 @@ err:
 err_xdp:
 	rcu_read_unlock();
 	stats->xdp_drops++;
+err_len:
 	stats->drops++;
 	put_page(page);
 xdp_xmit:
@@ -814,6 +821,12 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 	head_skb = NULL;
 	stats->bytes += len - vi->hdr_len;
 
+	if (unlikely(len > truesize)) {
+		pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
+			 dev->name, len, (unsigned long)ctx);
+		dev->stats.rx_length_errors++;
+		goto err_skb;
+	}
 	rcu_read_lock();
 	xdp_prog = rcu_dereference(rq->xdp_prog);
 	if (xdp_prog) {
@@ -938,13 +951,6 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 	}
 	rcu_read_unlock();
 
-	if (unlikely(len > truesize)) {
-		pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
-			 dev->name, len, (unsigned long)ctx);
-		dev->stats.rx_length_errors++;
-		goto err_skb;
-	}
-
 	head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog,
 			       metasize);
 	curr_skb = head_skb;
-- 
2.30.2



