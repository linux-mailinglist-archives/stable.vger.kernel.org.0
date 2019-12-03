Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7222111F3E
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728924AbfLCWqS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:46:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:35744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728979AbfLCWqS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:46:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2826520803;
        Tue,  3 Dec 2019 22:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413177;
        bh=v4pJDpuQCdRigiPbfE1gK/XbbYX/s8SxGZqFRVeCkUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FjlwmiPRnOD8Jg57WxkSjr01WZRAeoK4OARxVSTpdc8YK9yRpwjRDCsFc6PbO9iYW
         ymu7KLeZxDLPiA8yO2uccUmyhtvvjN/DIPkkgmOyauR00ud0SCBkLQ7Hi4M6d4LsVC
         KklT20mkGShfdtFE1OeHGFzTK7G963/wAemNuZwI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 028/321] can: rx-offload: can_rx_offload_queue_tail(): fix error handling, avoid skb mem leak
Date:   Tue,  3 Dec 2019 23:31:34 +0100
Message-Id: <20191203223428.582102977@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 6caf8a6d6586d44fd72f4aa1021d14aa82affafb ]

If the rx-offload skb_queue is full can_rx_offload_queue_tail() will not
queue the skb and return with an error.

This patch frees the skb in case of a full queue, which brings
can_rx_offload_queue_tail() in line with the
can_rx_offload_queue_sorted() function, which has been adjusted in the
previous patch.

The return value is adjusted to -ENOBUFS to better reflect the actual
problem.

The device stats handling is left to the caller.

Fixes: d254586c3453 ("can: rx-offload: Add support for HW fifo based irq offloading")
Reported-by: Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/rx-offload.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/rx-offload.c b/drivers/net/can/rx-offload.c
index 6cf0d0bc1e8d6..a90005eac8b17 100644
--- a/drivers/net/can/rx-offload.c
+++ b/drivers/net/can/rx-offload.c
@@ -261,8 +261,10 @@ int can_rx_offload_queue_tail(struct can_rx_offload *offload,
 			      struct sk_buff *skb)
 {
 	if (skb_queue_len(&offload->skb_queue) >
-	    offload->skb_queue_len_max)
-		return -ENOMEM;
+	    offload->skb_queue_len_max) {
+		kfree_skb(skb);
+		return -ENOBUFS;
+	}
 
 	skb_queue_tail(&offload->skb_queue, skb);
 	can_rx_offload_schedule(offload);
-- 
2.20.1



