Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E994111C30
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727953AbfLCWl0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:41:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:55884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728550AbfLCWlZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:41:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D68B82084B;
        Tue,  3 Dec 2019 22:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412885;
        bh=VbReP7Qkbf3t3xJNhOIE20IUIgjrJJkVWaMD9BCNTDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MQDNCXplqanrNyczn6msiZuQdwNfI2L57OyRPSpAVD7ZJ2lDVXmmVYynf2R4Qm/Sd
         0uOwTsS+HE3nT/c6vRzfP70wPEJjEONE7d1b8sMP7dIt9V4h6xcXotw0894WTWOelX
         LMNBeqsJVOi7gH4zO40B4SHpgnxVT9tWw998MXrY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 055/135] can: rx-offload: can_rx_offload_offload_one(): increment rx_fifo_errors on queue overflow or OOM
Date:   Tue,  3 Dec 2019 23:34:55 +0100
Message-Id: <20191203213020.458989998@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 4e9016bee3bf0c24963097edace034ff205b565c ]

If the rx-offload skb_queue is full or the skb allocation fails (due to OOM),
the mailbox contents is discarded.

This patch adds the incrementing of the rx_fifo_errors statistics counter.

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/rx-offload.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/rx-offload.c b/drivers/net/can/rx-offload.c
index bdc27481b57f9..e224530a06300 100644
--- a/drivers/net/can/rx-offload.c
+++ b/drivers/net/can/rx-offload.c
@@ -125,8 +125,10 @@ static struct sk_buff *can_rx_offload_offload_one(struct can_rx_offload *offload
 
 		ret = offload->mailbox_read(offload, &cf_overflow,
 					    &timestamp, n);
-		if (ret)
+		if (ret) {
 			offload->dev->stats.rx_dropped++;
+			offload->dev->stats.rx_fifo_errors++;
+		}
 
 		return NULL;
 	}
-- 
2.20.1



