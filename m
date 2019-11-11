Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E38FF7E0D
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbfKKSvX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:51:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:45520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727543AbfKKSvV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:51:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B367204FD;
        Mon, 11 Nov 2019 18:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498280;
        bh=ZX6R4GWSqAZPNA1XwDrGuydIQia0Bwzb5xuyTh9Pim4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GdyocKtUnwTKG0I2Bd7TR5uWywdA8NcN2Gv//9EDMY4KiHv905tZMxWs0FYv4Q29K
         rUi7fbNWuZVr+6gZMOG9hVZsMgJClOXTKKDWkPp1go78QTbmBZeJ8WLsiPaBkbGf28
         BKYg4VUBWalMWIJbnh6lfkMUpGn6d31IHiR3jpdI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Martin=20Hundeb=C3=B8ll?= <martin@geanix.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.3 076/193] can: rx-offload: can_rx_offload_queue_sorted(): fix error handling, avoid skb mem leak
Date:   Mon, 11 Nov 2019 19:27:38 +0100
Message-Id: <20191111181506.732874177@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit ca913f1ac024559ebc17f0b599af262f0ad997c9 upstream.

If the rx-offload skb_queue is full can_rx_offload_queue_sorted() will
not queue the skb and return with an error.

None of the callers of this function, issue a kfree_skb() to free the
not queued skb. This results in a memory leak.

This patch fixes the problem by freeing the skb in case of a full queue.
The return value is adjusted to -ENOBUFS to better reflect the actual
problem.

The device stats handling is left to the callers, as this function might
be used in both the rx and tx path.

Fixes: 55059f2b7f86 ("can: rx-offload: introduce can_rx_offload_get_echo_skb() and can_rx_offload_queue_sorted() functions")
Cc: linux-stable <stable@vger.kernel.org>
Cc: Martin Hundebøll <martin@geanix.com>
Reported-by: Martin Hundebøll <martin@geanix.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/rx-offload.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/can/rx-offload.c
+++ b/drivers/net/can/rx-offload.c
@@ -207,8 +207,10 @@ int can_rx_offload_queue_sorted(struct c
 	unsigned long flags;
 
 	if (skb_queue_len(&offload->skb_queue) >
-	    offload->skb_queue_len_max)
-		return -ENOMEM;
+	    offload->skb_queue_len_max) {
+		kfree_skb(skb);
+		return -ENOBUFS;
+	}
 
 	cb = can_rx_offload_get_cb(skb);
 	cb->timestamp = timestamp;


