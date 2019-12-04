Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA4B11348A
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729204AbfLDSBo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:01:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:42644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729637AbfLDSBo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:01:44 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1F31206DF;
        Wed,  4 Dec 2019 18:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482503;
        bh=KtvtfVhh4d+XHkmCqF5Q/paFYbGma6zpuEW1PkAKSR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J7vXRiPQ+e6z38/ws3oLxLVcSDs0DF1G+/pJDl0DdlrYwW3o64gACLpg7K68bTD0l
         OiOiss/znSkQw3X03vb/QfRvKFqZf3JtEh6Oot6jeNY/sL67vZMJWPZke/iQkn8q/0
         glnwkZkF0lMrYTMzLE0ze/N5BYKlr8MEEZbBt8Sg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 022/209] can: rx-offload: can_rx_offload_irq_offload_fifo(): continue on error
Date:   Wed,  4 Dec 2019 18:53:54 +0100
Message-Id: <20191204175323.030935417@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 1f7f504dcd9d1262437bdcf4fa071e41dec1af03 ]

In case of a resource shortage, i.e. the rx_offload queue will overflow
or a skb fails to be allocated (due to OOM),
can_rx_offload_offload_one() will call mailbox_read() to discard the
mailbox and return an ERR_PTR.

If the hardware FIFO is empty can_rx_offload_offload_one() will return
NULL.

In case a CAN frame was read from the hardware,
can_rx_offload_offload_one() returns the skb containing it.

Without this patch can_rx_offload_irq_offload_fifo() bails out if no skb
returned, regardless of the reason.

Similar to can_rx_offload_irq_offload_timestamp() in case of a resource
shortage the whole FIFO should be discarded, to avoid an IRQ storm and
give the system some time to recover. However if the FIFO is empty the
loop can be left.

With this patch the loop is left in case of empty FIFO, but not on
errors.

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/rx-offload.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/rx-offload.c b/drivers/net/can/rx-offload.c
index fef6534f163b7..54ffd1e91a693 100644
--- a/drivers/net/can/rx-offload.c
+++ b/drivers/net/can/rx-offload.c
@@ -257,7 +257,9 @@ int can_rx_offload_irq_offload_fifo(struct can_rx_offload *offload)
 
 	while (1) {
 		skb = can_rx_offload_offload_one(offload, 0);
-		if (IS_ERR_OR_NULL(skb))
+		if (IS_ERR(skb))
+			continue;
+		if (!skb)
 			break;
 
 		skb_queue_tail(&offload->skb_queue, skb);
-- 
2.20.1



