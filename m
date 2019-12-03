Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6761111CB0
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729073AbfLCWqe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:46:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:36192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728944AbfLCWqb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:46:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D55A2084B;
        Tue,  3 Dec 2019 22:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413190;
        bh=+YuJKEMJzx+aMgGrjmXZEOgaNUXK8o3GhNm3FzyZ0uY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qeeK5KCSecyCgAXC+b8yFFdyoBHxdg4CFZIVpNUeFdCHbR6i7zc8trMHjcWHLghca
         PmHOQ9PBUD37QIsKlTbbdGRKQjRr6Z8eoqiuYDCtjNBzcBZ6tSu6D3htsGK1XihgpU
         3cC2g8xqdOpSnDG4McYA9eiA83hKc7oF/RXosf1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 032/321] can: rx-offload: can_rx_offload_irq_offload_timestamp(): continue on error
Date:   Tue,  3 Dec 2019 23:31:38 +0100
Message-Id: <20191203223428.785734407@linuxfoundation.org>
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

From: Jeroen Hofstee <jhofstee@victronenergy.com>

[ Upstream commit c2a9f74c9d18acfdcabd3361adc7eac82c537a66 ]

In case of a resource shortage, i.e. the rx_offload queue will overflow
or a skb fails to be allocated (due to OOM),
can_rx_offload_offload_one() will call mailbox_read() to discard the
mailbox and return an ERR_PTR.

However can_rx_offload_irq_offload_timestamp() bails out in the error
case. In case of a resource shortage all mailboxes should be discarded,
to avoid an IRQ storm and give the system some time to recover.

Since can_rx_offload_irq_offload_timestamp() is typically called from a
while loop, all message will eventually be discarded. So let's continue
on error instead to discard them directly.

Signed-off-by: Jeroen Hofstee <jhofstee@victronenergy.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/rx-offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/rx-offload.c b/drivers/net/can/rx-offload.c
index 1b3ce70c55bc7..0dded7a1067bb 100644
--- a/drivers/net/can/rx-offload.c
+++ b/drivers/net/can/rx-offload.c
@@ -225,7 +225,7 @@ int can_rx_offload_irq_offload_timestamp(struct can_rx_offload *offload, u64 pen
 
 		skb = can_rx_offload_offload_one(offload, i);
 		if (IS_ERR_OR_NULL(skb))
-			break;
+			continue;
 
 		__skb_queue_add_sort(&skb_queue, skb, can_rx_offload_compare);
 	}
-- 
2.20.1



