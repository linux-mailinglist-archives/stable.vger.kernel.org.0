Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9C45111F66
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbfLCXH7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 18:07:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:35816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729172AbfLCWqU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:46:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD0E220656;
        Tue,  3 Dec 2019 22:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413180;
        bh=eaOmP9/0R+knqulXgInpzT8veyirzkDjMqIqUJlwDXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wrU7ycWW0Oq44adQdqjg9vPcYW4tYuNuQrvc8H7mZ3FvOTWfF/ur3cRyIL00oQfwf
         bFmkgf4lbzav/wEXkWfC4e3JsFkdkmnW38oVm9DYpFUUDwASwznBwHz/emNBxpOIm2
         kO03+rs9zByeYfA9yN0sCNRikptg1iqntkGt/eSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 029/321] can: rx-offload: can_rx_offload_offload_one(): do not increase the skb_queue beyond skb_queue_len_max
Date:   Tue,  3 Dec 2019 23:31:35 +0100
Message-Id: <20191203223428.633153096@linuxfoundation.org>
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

[ Upstream commit a2dc3f5e1022a5ede8af9ab89a144f1e69db8636 ]

The skb_queue is a linked list, holding the skb to be processed in the
next NAPI call.

Without this patch, the queue length in can_rx_offload_offload_one() is
limited to skb_queue_len_max + 1. As the skb_queue is a linked list, no
array or other resources are accessed out-of-bound, however this
behaviour is counterintuitive.

This patch limits the rx-offload skb_queue length to skb_queue_len_max.

Fixes: d254586c3453 ("can: rx-offload: Add support for HW fifo based irq offloading")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/rx-offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/rx-offload.c b/drivers/net/can/rx-offload.c
index a90005eac8b17..e32b65599a5f2 100644
--- a/drivers/net/can/rx-offload.c
+++ b/drivers/net/can/rx-offload.c
@@ -124,7 +124,7 @@ static struct sk_buff *can_rx_offload_offload_one(struct can_rx_offload *offload
 	int ret;
 
 	/* If queue is full or skb not available, read to discard mailbox */
-	if (likely(skb_queue_len(&offload->skb_queue) <=
+	if (likely(skb_queue_len(&offload->skb_queue) <
 		   offload->skb_queue_len_max))
 		skb = alloc_can_skb(offload->dev, &cf);
 
-- 
2.20.1



